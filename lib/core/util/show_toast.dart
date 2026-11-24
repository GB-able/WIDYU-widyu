import 'package:fluttertoast/fluttertoast.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/gen/assets.gen.dart';

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: MyColor.grey600,
    textColor: MyColor.white,
    fontSize: 16.0,
    fontAsset: Assets.fonts.pretendardMedium,
  );
}
