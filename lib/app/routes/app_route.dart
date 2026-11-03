import 'package:go_router/go_router.dart';

enum AppRoute {
  splash('/splash'),
  permission('/permission'),
  onboarding('/onboarding'),
  login('/login'),

  home('/home'),
  goal('/goal'),
  album('/album'),
  my('/my'),

  post('/album/post'),
  selectPhoto('/album/select-photo'),
  photoPreview('/album/select-photo/preview'),
  managePost('/album/manage-post'),

  profile('/my/profile'),
  point('/my/point'),
  contact('/my/contact'),
  management('/my/management'),
  notificationSetting('/my/notification'),
  notification('/notification'),
  medicationCamera('/medication/camera'),
  safetyCheck('/safety-check'),
  ;

  final String path;
  const AppRoute(this.path);

  static String postOf(int postId) => '${post.path}?postId=$postId';
}

extension DeepLinkRouter on GoRouter {
  void openDeepLink(String path) {
    final uri = Uri.tryParse(path);
    if (path.isEmpty || uri == null) return;
    if (configuration.findMatch(uri).isEmpty) return;
    const tabs = [AppRoute.home, AppRoute.goal, AppRoute.album, AppRoute.my];
    if (tabs.any((tab) => tab.path == uri.path)) {
      go(path);
    } else {
      push(path);
    }
  }
}
