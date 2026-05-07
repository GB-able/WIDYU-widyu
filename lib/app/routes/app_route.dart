enum AppRoute {
  splash("/splash"),
  onboarding("/onboarding"),
  login("/login"),

  home("/home"),
  goal("/goal"),
  album("/album"),
  my("/my"),

  profile("/my/profile"),
  point("/my/point"),
  ;

  final String path;
  const AppRoute(this.path);
}
