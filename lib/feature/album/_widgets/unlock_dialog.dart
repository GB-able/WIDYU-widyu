import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/core/data/provider/album_provider.dart';
import 'package:widyu/core/data/provider/point_provider.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/widu_icon.dart';
import 'package:widyu/core/ui/widgets/widyu_text_button.dart';
import 'package:widyu/gen/assets.gen.dart';

Future<bool> showUnlockDialog(BuildContext context, int albumId) async {
  final albumProvider = context.read<AlbumProvider>();
  if (albumProvider.isUnlocking(albumId)) return false;
  final price = albumProvider.postOf(albumId)?.price;
  if (price == null) return false;
  final point = context.read<PointProvider>().point;

  if (point != null && point < price) {
    await showDialog<void>(
      context: context,
      builder: (_) => UnlockDialog.notEnough(
        price: price,
        point: point,
        onTap: () => context.go(AppRoute.goal.path),
      ),
    );
    return false;
  }

  final success = await showDialog<bool>(
    context: context,
    builder: (_) => UnlockDialog.purchase(
      price: price,
      point: point,
      onPurchase: () => albumProvider.unlock(albumId),
    ),
  );
  return success == true && !albumProvider.isDisposed;
}

class UnlockDialog extends StatefulWidget {
  const UnlockDialog({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.point,
    required this.buttonText,
    required this.onTap,
  }) : onPurchase = null;

  UnlockDialog.purchase({
    super.key,
    required this.price,
    required this.point,
    required this.onPurchase,
  })  : onTap = null,
        image = Assets.images.img112Unlock,
        title = '새로운 소식을 구매할까요?',
        buttonText = '구매하기';

  UnlockDialog.notEnough({
    super.key,
    required this.price,
    required this.point,
    required this.onTap,
  })  : onPurchase = null,
        image = Assets.images.img112Warning,
        title = '포인트가 부족해요',
        buttonText = '포인트 모으러 가기';

  final AssetGenImage image;
  final String title;
  final int price;
  final int? point;
  final String buttonText;
  final VoidCallback? onTap;
  final Future<bool> Function()? onPurchase;

  @override
  State<UnlockDialog> createState() => _UnlockDialogState();
}

class _UnlockDialogState extends State<UnlockDialog> {
  bool _loading = false;
  bool _failed = false;

  Future<void> _submit() async {
    if (_loading) return;
    final purchase = widget.onPurchase;
    if (purchase == null) {
      Navigator.pop(context);
      widget.onTap?.call();
      return;
    }

    setState(() {
      _loading = true;
      _failed = false;
    });
    var success = false;
    try {
      success = await purchase();
    } catch (error, stack) {
      WiduLog.ui.w('앨범 잠금 해제 실패', error: error, stackTrace: stack);
    }
    if (!mounted) return;
    if (success) {
      Navigator.pop(context, true);
    } else {
      setState(() {
        _loading = false;
        _failed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_loading,
      child: Dialog(
        backgroundColor: MyColor.white,
        surfaceTintColor: MyColor.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.antiAlias,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        child: IntrinsicHeight(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: _loading ? null : () => Navigator.pop(context),
                          behavior: HitTestBehavior.translucent,
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: WiduIcon(
                              icon: Assets.icons.ic16Close,
                              width: 16,
                              color: MyColor.grey700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    widget.image.image(width: 112, height: 112),
                    const SizedBox(height: 16),
                    Text(
                      widget.title,
                      style: MyTypo.title2.copyWith(color: MyColor.black),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.price}P',
                      style: MyTypo.title1.copyWith(color: MyColor.primary),
                    ),
                    const SizedBox(height: 20),
                    _PointBalance(point: widget.point),
                    const SizedBox(height: 24),
                    if (_failed) ...[
                      const Text('소식을 여는 데 실패했습니다. 다시 시도해주세요.'),
                      const SizedBox(height: 12),
                    ],
                    WidyuTextButton(
                      onTap: _submit,
                      text: widget.buttonText,
                      isLoading: _loading,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PointBalance extends StatelessWidget {
  const _PointBalance({required this.point});

  final int? point;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: MyColor.grey100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '잔여 포인트',
            style: MyTypo.subTitle2.copyWith(color: MyColor.grey500),
          ),
          Text(
            point == null ? '-' : '${point}P',
            style: MyTypo.title2.copyWith(color: MyColor.grey600),
          ),
        ],
      ),
    );
  }
}
