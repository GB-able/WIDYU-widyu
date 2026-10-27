part of '../home_screen.dart';

class _HomeGreetingView extends StatelessWidget {
  final bool isLoading;
  final String name;

  const _HomeGreetingView({
    required this.isLoading,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat(
            'yyyy년 M월 d일 EEEE',
            'ko_KR',
          ).format(DateTime.now()),
          style: MyTypo.subTitle2,
        ),
        const SizedBox(height: 8),
        Skeletonizer(
          enabled: isLoading,
          child: Text(
            '${(isLoading ? '사용자' : name)}님',
            style: MyTypo.title2,
          ),
        ),
        const SizedBox(height: 2),
        Skeletonizer(
          enabled: isLoading,
          child: Text(
            '오늘도 한 걸음씩! 잘하고 있어요.',
            style: MyTypo.body2,
          ),
        ),
      ],
    );
  }
}
