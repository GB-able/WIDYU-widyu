enum AppRoute {
  splash("/splash"),
  permission("/permission"),
  onboarding("/onboarding"),
  login("/login"),
  locationSetup('/location-setup'),

  home("/home"),
  goal("/goal"),
  album("/album"),
  my("/my"),

  profile("/my/profile"),
  point("/my/point"),
  contact("/my/contact"),
  management("/my/management"),
  notification("/my/notification"),
  ;

  final String path;
  const AppRoute(this.path);
}
