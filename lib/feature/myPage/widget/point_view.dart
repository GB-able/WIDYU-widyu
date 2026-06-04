part of '../my_page_screen.dart';

class _PointView extends StatelessWidget {
  final bool isLoading;
  final int? points;

  const _PointView({
    this.isLoading = false,
    this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Image.asset(
            'assets/icons/ic_28_point.png',
            width: 28,
            height: 28,
          ),
        ),
        const SizedBox(width: 4),
        Text("포인트", style: MyTypo.subTitle5.copyWith(color: MyColor.white)),
        const Spacer(),
        Skeletonizer(
          enabled: isLoading,
          child: Text(
            isLoading ? '999P' : "${points ?? "- "}P",
            style: MyTypo.title4.copyWith(color: MyColor.white),
          ),
        ),
        IconButton(
          onPressed: () => context.push(AppRoute.point.path),
          icon: const WidyuIcon(
            icon: 'ic_20_chevron_right.svg',
            width: 20,
            height: 20,
            color: MyColor.white,
          ),
        )
      ],
    );
  }
}
