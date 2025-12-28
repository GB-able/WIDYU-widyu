import 'package:widyu/core/theme/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: MyColor.grey600,
    textColor: MyColor.white,
    fontSize: 16.0,
    fontAsset: "assets/fonts/Pretendard-Medium.otf",
  );
}
