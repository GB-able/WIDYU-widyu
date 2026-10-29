part of '../photo_tab_view.dart';

class _MediaThumbnail extends StatelessWidget {
  const _MediaThumbnail({required this.media});

  final Media media;

  @override
  Widget build(BuildContext context) {
    final isLocked = context.select(
      (AlbumProvider p) => !p.isUnlocked(media.postId),
    );

    return GestureDetector(
      onTap: () {
        if (isLocked) {
          _confirmUnlock(context);
          return;
        }
        unawaited(context.push(AppRoute.postOf(media.postId)));
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (isLocked) MediaLockOverlay(child: _thumbnail) else _thumbnail,
          if (!isLocked && media.type == MediaType.video) ...[
            Center(
              child: ClipOval(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: MyColor.white.withValues(alpha: 0.24),
                    ),
                    child: WiduIcon(icon: Assets.icons.ic18Play, width: 18),
                  ),
                ),
              ),
            ),
            if (media.duration != null)
              Positioned(
                right: 8,
                bottom: 5,
                child: Text(
                  media.duration!.toDuration,
                  style: MyTypo.helper3.copyWith(color: MyColor.white),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Future<void> _confirmUnlock(BuildContext context) async {
    final albumProvider = context.read<AlbumProvider>();

    if (albumProvider.isUnlocking(media.postId)) return;

    final price = media.price;
    final point = context.read<PointProvider>().point;

    if (point != null && point < price) {
      unawaited(showDialog<void>(
        context: context,
        builder: (_) => UnlockDialog.notEnough(
          price: price,
          point: point,
          onTap: () => context.go(AppRoute.goal.path),
        ),
      ));
      return;
    }

    final success = await showDialog<bool>(
      context: context,
      builder: (_) => UnlockDialog.purchase(
        price: price,
        point: point,
        onPurchase: () => albumProvider.unlock(media.postId),
      ),
    );
    if (success == true && context.mounted && !albumProvider.isDisposed) {
      unawaited(context.push(AppRoute.postOf(media.postId)));
    }
  }

  Widget get _thumbnail {
    final url = media.thumbnailUrl;
    if (url == null) return Container(color: MyColor.grey100);

    return CustomNetworkImage(url: url);
  }
}
