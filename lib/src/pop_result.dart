import 'dart:async';

class PopResult<T> {
  final Completer<T> _completer = Completer<T>();

  Future<T> getFuture() {
    return _completer.future;
  }

  void setValue(T result) {
    _completer.complete(result);
  }
}