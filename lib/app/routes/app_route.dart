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
  contact("/my/contact"),
  management("/my/management"),
  notification("/my/notification"),
  medicationVerify("/medication/verify"),
  ;

  final String path;
  const AppRoute(this.path);
}
