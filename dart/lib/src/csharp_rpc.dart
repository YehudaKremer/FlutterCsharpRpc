import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'csharp_rpc_request.dart';

/// Manage the communication between dart and C# RPC-server
class CsharpRpc {
  Process? csharpProcess;
  final String _executablePath;
  final Uuid _uuid = const Uuid();
  final List<CsharpRpcRequest> _requests = [];
  late RegExp _jsonsInRpcMessageExp;

  CsharpRpc(this._executablePath) {
    _jsonsInRpcMessageExp = _getJsonsInRpcMessageExp(10);
  }

  /// Start C#-RPC child process.
  Future<CsharpRpc> start() async {
    csharpProcess = await Process.start(_executablePath, []);
    csharpProcess?.stdout.listen(_onDataReceived);
    csharpProcess?.stderr.listen(_onLogReceived);
    return this;
  }

  /// Dispose the C#-RPC child process
  void dispose() {
    csharpProcess?.kill();
    _requests.clear();
  }

  /// Invoke C#-RPC method by name with (optional) param(s)
  Future<TResult> invoke<TResult>(
      {required String method, List<dynamic>? params, Object? param}) {
    /// create a unique id for the RPC request
    var id = _uuid.v4();

    /// encode json request in RPC format.
    /// jsonrpc version and 'Content-Length' header
    var jsonEncodedBody = jsonEncode({
      "jsonrpc": "2.0",
      "method": method,
      if (params != null || param != null) "params": params ?? [param],
      "id": id
    });
    var contentLengthHeader = 'Content-Length: ${jsonEncodedBody.length}';
    var messagePayload = '$contentLengthHeader\r\n\r\n$jsonEncodedBody';

    /// write ('send') the request to the STDIN stream
    csharpProcess?.stdin.write(messagePayload);

    /// create a CsharpRpcRequest instance for this request
    var csharpRpcRequest = CsharpRpcRequest<TResult>(id);
    _requests.add(csharpRpcRequest);

    return csharpRpcRequest.completer.future;
  }

  /// Build a RegExp that identifies the JSON code inside the RPC response
  RegExp _getJsonsInRpcMessageExp(int nestedJsonLevels) {
    /// base RegExp
    String jsonInRpcMessage = "{(?:[^{}]*|())*}";

    /// variable for building a recursive RegExp
    String jsonsInRpcMessage = jsonInRpcMessage;

    /// Duplicate (recursive) the RegExp value to support nested json objects
    for (var i = 0; i < nestedJsonLevels; i++) {
      jsonsInRpcMessage =
          jsonsInRpcMessage.replaceFirst('()', jsonInRpcMessage);
    }

    return RegExp(jsonsInRpcMessage);
  }

  /// get RPC response from the STDOUT stream and decode it to utf8-json format
  dynamic _onDataReceived(event) {
    var strMessage = utf8.decode(event);

    /// find the json-objects in the RPC response using RegExp
    var strJsons =
        _jsonsInRpcMessageExp.allMatches(strMessage).map((m) => m.group(0)!);

    /// for every json-string
    for (var strJson in strJsons) {
      /// first decode to json
      dynamic response = jsonDecode(strJson);

      /// then find by-ID the CsharpRpcRequest instance in the _requests list,
      /// to complete ('resolve') its CsharpRpcRequest.completer instance
      var request = _requests
          .firstWhere((request) => request.requestId == response['id']);

      /// if error found in the RPC response content
      var error = response['error'];
      if (error != null) {
        throw Exception(error);
      }

      request.completer.complete(response['result']);
      _requests.remove(request);
    }
  }

  /// write logs from the STDERR stream
  dynamic _onLogReceived(event) {
    // use 'assert' to print logs only if debug mode
    // this is workaround because dart don't have the kDebugMode constant
    assert(() {
      // ignore: avoid_print
      print(utf8.decode(event));
      return true;
    }());
  }
}
