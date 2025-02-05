class RouteInfo {
  const RouteInfo.normal({
    required this.path,
    required this.name,
  }) : isShellRoute = false;

  const RouteInfo.shell({required this.name})
      : isShellRoute = true,
        path = '/$name';

  final String path;
  final String name;
  final bool isShellRoute;
}
