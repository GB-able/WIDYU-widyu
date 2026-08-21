part of '../point_screen.dart';

class _PointHistoryView extends StatelessWidget {
  final List<PointUiModel> histories;

  const _PointHistoryView({required this.histories});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: histories.length,
      itemBuilder: (context, index) {
        final history = histories[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '포인트 ${history.isEarningPoint ? '적립' : '사용'}',
                    style: MyTypo.body1.copyWith(color: MyColor.grey900),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat('yyyy.MM.dd HH:mm').format(history.createdAt),
                    style: MyTypo.helper.copyWith(color: MyColor.grey500),
                  )
                ],
              ),
              const Spacer(),
              Text(
                '${history.isEarningPoint ? '+' : ''}${history.amount}P',
                style: MyTypo.subTitle5.copyWith(
                    color: history.isEarningPoint
                        ? MyColor.blue500
                        : MyColor.red500),
              ),
            ],
          ),
        );
      },
    );
  }
}
