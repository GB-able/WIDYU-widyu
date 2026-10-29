part of '../my_page_screen.dart';

class _PointView extends StatelessWidget {
  const _PointView({required this.point, required this.isPointLoading});

  final int? point;
  final bool isPointLoading;

  @override
  Widget build(BuildContext context) {
    final isLoading = point == null && isPointLoading;

    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Assets.images.img28Point.image(
            width: 28,
            height: 28,
          ),
        ),
        const SizedBox(width: 4),
        Text('포인트', style: MyTypo.subTitle5.copyWith(color: MyColor.white)),
        const Spacer(),
        Skeletonizer(
          enabled: isLoading,
          child: Text(
            isLoading ? '999P' : "${point ?? "- "}P",
            style: MyTypo.title4.copyWith(color: MyColor.white),
          ),
        ),
        IconButton(
          onPressed: () => context.push(AppRoute.point.path),
          icon: WiduIcon(
            icon: Assets.icons.ic20ChevronRight,
            width: 20,
            height: 20,
            color: MyColor.white,
          ),
        )
      ],
    );
  }
}
