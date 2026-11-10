part of '../select_photo_screen.dart';

class _PhotoItem extends StatelessWidget {
  const _PhotoItem({
    required this.asset,
    required this.index,
    required this.order,
    required this.onToggle,
  });

  final AssetEntity asset;
  final int index;
  final int? order;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final order = this.order;
    final isSelected = order != null;

    return GestureDetector(
      onTap: () => context.push(
        AppRoute.photoPreview.path,
        extra: index,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          AssetEntityImage(
            asset,
            isOriginal: false,
            thumbnailSize: const ThumbnailSize.square(300),
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 2,
            right: 2,
            child: GestureDetector(
              onTap: onToggle,
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color:
                        isSelected ? MyColor.primary : const Color(0x8C16161D),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: MyColor.white,
                      width: 1.5,
                    ),
                  ),
                  child: isSelected
                      ? Text(
                          order.toString(),
                          style: MyTypo.subTitle1.copyWith(
                            color: MyColor.white,
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ),
          if (asset.type == AssetType.video)
            Positioned(
              right: 4,
              bottom: 4,
              child: Text(
                asset.duration.toDuration,
                style: MyTypo.helper3.copyWith(color: MyColor.white),
              ),
            ),
        ],
      ),
    );
  }
}
