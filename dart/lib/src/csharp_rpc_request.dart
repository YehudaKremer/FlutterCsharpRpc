import 'dart:async';

/// Represent RPC-request as a Future via Completer instance
class CsharpRpcRequest<TResult> {
  final String _requestId;
  String get requestId => this._requestId;

  final Completer<TResult> _completer = Completer();

  /// this Completer will resolve after response came back from RPC
  Completer<TResult> get completer => this._completer;

  CsharpRpcRequest(this._requestId);
}
