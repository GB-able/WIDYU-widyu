enum AppRoute {
  splash("/splash"),
  onboarding("/onboarding"),
  login("/login"),

  home("/home"),
  goal("/goal"),
  album("/album"),
  my("/my"),
  ;

  final String path;
  const AppRoute(this.path);
}
