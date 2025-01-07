class RouteNotFoundException implements Exception{
  final String routePath;

  RouteNotFoundException(this.routePath);

  @override
  String toString() {
    return "RouteNotFoundException: Could not find path : $routePath\n${StackTrace.current}";
  }
}