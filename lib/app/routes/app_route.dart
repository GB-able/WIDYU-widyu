enum AppRoute {
  onboarding("/onboarding"),
  login("/login");

  final String path;
  const AppRoute(this.path);
}
