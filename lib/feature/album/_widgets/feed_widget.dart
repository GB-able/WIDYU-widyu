import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/app/routes/extra/edit_post_extra.dart';
import 'package:widyu/core/data/provider/album_provider.dart';
import 'package:widyu/core/data/provider/point_provider.dart';
import 'package:widyu/core/model/album/album_post.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/custom_dialog.dart';
import 'package:widyu/core/ui/widgets/custom_network_image.dart';
import 'package:widyu/core/ui/widgets/expandable_text.dart';
import 'package:widyu/core/ui/widgets/icon_widget.dart';
import 'package:widyu/core/ui/widgets/profile_widget.dart';
import 'package:widyu/core/utils/extensions/date_extension.dart';
import 'package:widyu/core/utils/show_toast.dart';
import 'package:widyu/feature/album/_widgets/feed_menu_sheet.dart';
import 'package:widyu/feature/album/_widgets/feed_video_widget.dart';
import 'package:widyu/feature/album/_widgets/lock_overlay.dart';
import 'package:widyu/feature/album/_widgets/unlock_dialog.dart';
import 'package:widyu/feature/album/_widgets/viewers_row.dart';

class FeedWidget extends StatefulWidget {
  const FeedWidget({
    super.key,
    required this.albumId,
    this.isDetail = false,
    this.isContentExpanded = true,
    this.onContentExpandChanged,
    this.onDeleted,
  });

  final int albumId;
  final bool isDetail;
  final bool isContentExpanded;
  final ValueChanged<bool>? onContentExpandChanged;
  final VoidCallback? onDeleted;

  @override
  State<FeedWidget> createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  final ctrl = CarouselSliderController();
  int idx = 0;

  void setIdx(int index) {
    setState(() {
      idx = index;
    });
  }

  String? lockedPreviewUrl(AlbumPost feed) {
    if (feed.thumbnailUrls.isNotEmpty) {
      return feed.thumbnailUrls.first;
    }

    final image = feed.mediaUrls.where((url) => !_isVideoUrl(url));
    if (image.isNotEmpty) return image.first;

    return feed.mediaUrls.isEmpty ? null : feed.mediaUrls.first;
  }

  Future<void> _confirmUnlock() async {
    final albumProvider = context.read<AlbumProvider>();
    if (albumProvider.isUnlocking(widget.albumId)) return;
    final price = albumProvider.postOf(widget.albumId)?.price;
    if (price == null) return;
    final point = context.read<PointProvider>().point;

    if (point != null && point < price) {
      showDialog(
        context: context,
        builder: (_) => UnlockDialog.notEnough(
          price: price,
          point: point,
          onTap: () => context.go(AppRoute.goal.path),
        ),
      );
      return;
    }

    final success = await showDialog<bool>(
      context: context,
      builder: (_) => UnlockDialog.purchase(
        price: price,
        point: point,
        onPurchase: () => albumProvider.unlock(widget.albumId),
      ),
    );
    if (success == true && mounted && !albumProvider.isDisposed) {
      context.push(AppRoute.post.path, extra: widget.albumId);
    }
  }

  void showMenu() {
    showModalBottomSheet(
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (_) => FeedMenuSheet(onEdit: editFeed, onDelete: confirmDelete),
    );
  }

  Future<void> editFeed() async {
    final feed = context.read<AlbumProvider>().postOf(widget.albumId);
    if (feed == null) return;
    await context.push(
      AppRoute.managePost.path,
      extra: EditPostExtra(
        albumId: feed.albumId,
        content: feed.content,
        mediaUrls: feed.mediaUrls,
      ),
    );
  }

  void confirmDelete() {
    showDialog(
      context: context,
      builder: (_) => CustomDialog(
        type: CustomDialogType.two,
        title: "게시글을 삭제하시겠어요?",
        description: "삭제한 게시글은 다시 볼 수 없어요.",
        posText: "삭제",
        onPosTap: deleteFeed,
      ),
    );
  }

  Future<void> deleteFeed() async {
    final albumProvider = context.read<AlbumProvider>();
    final success = await albumProvider.deleteFeed(widget.albumId);

    if (!mounted) return;

    if (!success) {
      showToast("게시글 삭제에 실패했습니다.");
      return;
    }

    widget.onDeleted?.call();
  }

  @override
  Widget build(BuildContext context) {
    final feed = context.select((AlbumProvider p) => p.postOf(widget.albumId));
    if (feed == null) return const SizedBox.shrink();
    final thumbnailWidth = MediaQuery.of(context).size.width - 32;
    final thumbnailHeight = thumbnailWidth * 5 / 4;

    final stat = context.select((AlbumProvider p) => p.statOf(widget.albumId));

    final isLocked = context.select(
      (AlbumProvider p) => !p.isUnlocked(widget.albumId),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  spacing: 8,
                  children: [
                    ProfileWidget(profileImage: feed.authorProfileImage),
                    Expanded(
                      child: Text(
                        feed.authorName,
                        style: MyTypo.subTitle1.copyWith(color: MyColor.black),
                      ),
                    ),
                  ],
                ),
              ),
              if (feed.canEdit)
                GestureDetector(
                  onTap: showMenu,
                  behavior: HitTestBehavior.opaque,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: IconWidget(icon: "more", width: 24),
                  ),
                ),
            ],
          ),
        ),
        isLocked
            ? Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: GestureDetector(
                  onTap: _confirmUnlock,
                  child: SizedBox(
                    width: thumbnailWidth,
                    height: thumbnailHeight,
                    child: FeedLockOverlay(
                      price: feed.price,
                      child: CustomNetworkImage(
                        url: lockedPreviewUrl(feed),
                        width: thumbnailWidth,
                        height: thumbnailHeight,
                      ),
                    ),
                  ),
                ),
              )
            : Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: CarouselSlider.builder(
                      carouselController: ctrl,
                      itemCount: feed.mediaUrls.length,
                      itemBuilder: (context, index, realIndex) {
                        final url = feed.mediaUrls[index];

                        return _isVideoUrl(url)
                            ? FeedVideoWidget(
                                url: url,
                                width: thumbnailWidth,
                                height: thumbnailHeight,
                                isActive: idx == index,
                              )
                            : CustomNetworkImage(
                                url: url,
                                width: thumbnailWidth,
                                height: thumbnailHeight,
                              );
                      },
                      options: CarouselOptions(
                        aspectRatio: 4 / 5,
                        viewportFraction: 1.0,
                        enableInfiniteScroll: false,
                        onPageChanged: (index, reason) {
                          setIdx(index);
                        },
                      ),
                    ),
                  ),
                  if (feed.mediaUrls.length > 1)
                    Positioned(
                      bottom: 4,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 4,
                        children: [
                          for (int i = 0; i < feed.mediaUrls.length; i++)
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: idx == i
                                    ? MyColor.primary
                                    : MyColor.grey200,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
        Row(
          spacing: 12,
          children: [
            Row(
              spacing: 4,
              children: [
                GestureDetector(
                  onTap: isLocked
                      ? _confirmUnlock
                      : () => context.read<AlbumProvider>().toggleLike(
                            widget.albumId,
                          ),
                  child: IconWidget(
                    icon: stat.isLiked ? "like_on" : "like_off",
                    width: 24,
                  ),
                ),
                Text(
                  stat.likeCount.toString(),
                  style: MyTypo.subTitle2.copyWith(color: MyColor.grey700),
                ),
              ],
            ),
            Row(
              spacing: 4,
              children: [
                GestureDetector(
                  onTap: () {
                    if (widget.isDetail) return;

                    if (isLocked) {
                      _confirmUnlock();
                      return;
                    }

                    context.push(AppRoute.post.path, extra: widget.albumId);
                  },
                  child: const IconWidget(icon: "comment", width: 24),
                ),
                Text(
                  stat.commentCount.toString(),
                  style: MyTypo.subTitle2.copyWith(color: MyColor.grey700),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        ViewersRow(viewers: feed.viewers),
        const SizedBox(height: 8),
        Text(_formatDate(feed.createdAt), style: MyTypo.subTitle3),
        const SizedBox(height: 4),
        if (!isLocked)
          ExpandableText(
            text: feed.content,
            style: MyTypo.body2,
            moreStyle: MyTypo.body2.copyWith(color: MyColor.grey500),
            isExpanded: widget.isDetail ? true : widget.isContentExpanded,
            onExpandChanged: widget.onContentExpandChanged,
          ),
        const SizedBox(height: 8),
      ],
    );
  }
}

String _formatDate(DateTime date) {
  return "${date.year}년 ${date.month.toString().padLeft(2, '0')}월 ${date.day.toString().padLeft(2, '0')}일 ${date.weekdayLabel}요일";
}

bool _isVideoUrl(String url) {
  const videoExtensions = {
    '.mp4',
    '.mov',
    '.m4v',
    '.avi',
    '.mkv',
    '.webm',
    '.3gp',
  };

  final path = Uri.tryParse(url)?.path.toLowerCase() ?? url.toLowerCase();
  return videoExtensions.any(path.endsWith);
}
