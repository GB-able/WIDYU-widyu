part of '../manage_post_screen.dart';

class _MediaCarousel extends StatelessWidget {
  const _MediaCarousel({
    required this.type,
    required this.currIdx,
    required this.onPageChanged,
    this.photos,
    this.photoUrls,
  });

  final ManageMode type;
  final List<AssetEntity>? photos;
  final List<String>? photoUrls;
  final int currIdx;
  final ValueChanged<int> onPageChanged;

  static const double _itemWidth = 256;
  static const double _itemHeight = _itemWidth * 5 / 4;
  static const double _itemGap = 16;

  int get _itemCount => photos?.length ?? photoUrls!.length;

  @override
  Widget build(BuildContext context) {
    final isSingle = _itemCount == 1;
    final maxWidth = MediaQuery.sizeOf(context).width;
    final viewportFraction = ((_itemWidth + _itemGap) / maxWidth).clamp(
      0.1,
      1.0,
    );

    return Column(
      children: [
        if (isSingle)
          SizedBox(
            height: _itemHeight,
            child: Center(child: _buildItem(0)),
          )
        else
          NotificationListener<ScrollUpdateNotification>(
            onNotification: (notification) {
              final metrics = notification.metrics;
              if (notification.depth != 0 || !metrics.hasContentDimensions) {
                return false;
              }
              final index = metrics.pixels >= metrics.maxScrollExtent - 1
                  ? _itemCount - 1
                  : (metrics.pixels /
                          (metrics.viewportDimension * viewportFraction))
                      .round();
              if (index != currIdx) onPageChanged(index);
              return false;
            },
            child: CarouselSlider(
              items: List.generate(
                _itemCount,
                (index) => Padding(
                  padding: EdgeInsets.only(
                    left: _itemGap,
                    right: index == _itemCount - 1 ? _itemGap : 0,
                  ),
                  child: _buildItem(index),
                ),
              ),
              options: CarouselOptions(
                height: _itemHeight,
                aspectRatio: 4 / 5,
                viewportFraction: viewportFraction,
                padEnds: false,
                enableInfiniteScroll: false,
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 20),
          child: isSingle
              ? const SizedBox(height: 6)
              : Row(
                  spacing: 4,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _itemCount,
                    (index) => Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: currIdx == index
                            ? MyColor.primary
                            : MyColor.grey200,
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildItem(int index) {
    switch (type) {
      case ManageMode.add:
        final photo = photos![index];
        return photo.type == AssetType.video
            ? _AssetVideoPreview(
                asset: photo,
                isActive: index == currIdx,
                width: _itemWidth,
                height: _itemHeight,
              )
            : AssetEntityImage(
                photo,
                width: _itemWidth,
                height: _itemHeight,
                fit: BoxFit.cover,
              );
      case ManageMode.edit:
        return CustomNetworkImage(
          url: photoUrls![index],
          width: _itemWidth,
          height: _itemHeight,
        );
    }
  }
}
