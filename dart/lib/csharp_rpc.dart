library csharp_rpc;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:uuid/uuid.dart';

class CsharpRpc {
  Process? csharpProcess;
  final String _executablePath;
  final Uuid _uuid = const Uuid();
  final List<_CsharpRpcRequest> _requests = [];
  late RegExp _jsonsInRpcMessageExp;

  CsharpRpc(this._executablePath) {
    _jsonsInRpcMessageExp = _getJsonsInRpcMessageExp(10);
  }

  /// Start C#-RPC child process
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
    var id = _uuid.v4();
    var jsonEncodedBody = jsonEncode({
      "jsonrpc": "2.0",
      "method": method,
      if (params != null || param != null) "params": params ?? [param],
      "id": id
    });
    var contentLengthHeader = 'Content-Length: ${jsonEncodedBody.length}';
    var messagePayload = '$contentLengthHeader\r\n\r\n$jsonEncodedBody';
    csharpProcess?.stdin.write(messagePayload);
    var csharpRpcRequest = _CsharpRpcRequest<TResult>(id);
    _requests.add(csharpRpcRequest);
    return csharpRpcRequest.completer.future;
  }

  RegExp _getJsonsInRpcMessageExp(int nestedJsonLevels) {
    String jsonInRpcMessage = "{(?:[^{}]*|())*}";
    String jsonsInRpcMessage = jsonInRpcMessage;
    for (var i = 0; i < nestedJsonLevels; i++) {
      jsonsInRpcMessage =
          jsonsInRpcMessage.replaceFirst('()', jsonInRpcMessage);
    }
    return RegExp(jsonsInRpcMessage);
  }

  dynamic _onDataReceived(event) {
    var strMessage = utf8.decode(event);
    var strJsons =
        _jsonsInRpcMessageExp.allMatches(strMessage).map((m) => m.group(0)!);

    for (var strJson in strJsons) {
      dynamic response = jsonDecode(strJson);
      var request = _requests
          .firstWhere((request) => request.requestId == response['id']);

      var error = response['error'];
      if (error != null) {
        throw Exception(error);
      }

      request.completer.complete(response['result']);
      _requests.remove(request);
    }
  }

  dynamic _onLogReceived(event) {
    // run only if debug mode
    assert(() {
      // ignore: avoid_print
      print(utf8.decode(event));
      return true;
    }());
  }
}

class _CsharpRpcRequest<TResult> {
  String requestId;
  final Completer<TResult> completer = Completer();

  _CsharpRpcRequest(this.requestId);
}
