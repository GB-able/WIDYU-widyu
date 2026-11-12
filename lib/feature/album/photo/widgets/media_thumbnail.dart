part of '../photo_tab_view.dart';

class _MediaThumbnail extends StatelessWidget {
  const _MediaThumbnail({
    required this.media,
    required this.isLocked,
    required this.onRequestUnlock,
  });

  final Media media;
  final bool isLocked;
  final Future<bool> Function() onRequestUnlock;

  @override
  Widget build(BuildContext context) {
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
              // 뒤를 흐리는 BackdropFilter는 칸마다 매 프레임 화면 전체를 복사해야 해서
              // 스크롤 중 비용이 크다. 블러 없이 반투명 원만 둔다.
              // 아이콘이 원 안쪽에 있어 ClipOval도 필요 없다(둥근 clip은 칸마다 stencil draw가 든다).
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
    if (await onRequestUnlock() && context.mounted) {
      unawaited(context.push(AppRoute.postOf(media.postId)));
    }
  }

  Widget get _thumbnail {
    final url = media.thumbnailUrl;
    if (url == null) return Container(color: MyColor.grey100);

    return CustomNetworkImage(
      url: url,
      decodeWidth: isLocked ? lockedImageDecodeWidth : null,
    );
  }
}
