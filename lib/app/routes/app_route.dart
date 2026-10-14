enum AppRoute {
  splash("/splash"),
  onboarding("/onboarding"),
  login("/login"),

  home("/home"),
  goal("/goal"),
  album("/album"),
  my("/my"),

  post("/album/post"),
  selectPhoto("/album/select-photo"),
  photoPreview("/album/select-photo/preview"),
  managePost("/album/manage-post"),

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
