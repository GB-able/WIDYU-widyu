enum AppRoute {
  splash("/splash"),
  permission("/permission"),
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
  notificationSetting("/my/notification"),
  notification("/notification"),
  medicationCamera("/medication/camera"),
  emergencyConfirm("/emergency/confirm"),
  ;

  final String path;
  const AppRoute(this.path);
}
