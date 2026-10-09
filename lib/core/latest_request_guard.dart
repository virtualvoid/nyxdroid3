// author: juraj.suchan@gmail.com

mixin LatestRequestGuard {
  int _requestId = 0;

  int beginRequest() => ++_requestId;

  bool isStale(int id) => id != _requestId;
}
