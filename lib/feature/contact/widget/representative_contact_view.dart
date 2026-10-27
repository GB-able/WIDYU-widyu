part of '../contact_screen.dart';

class _RepresentativeContactView extends StatelessWidget {
  final Representative? representative;

  const _RepresentativeContactView({required this.representative});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '대표 비상연락처',
            style: MyTypo.title3.copyWith(color: MyColor.grey900),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: MyColor.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: MyColor.black.withValues(alpha: 0.2),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Row(
              children: [
                Text(
                  representative?.name ?? '대표 연락처가 없습니다.',
                  style: MyTypo.body1.copyWith(color: MyColor.grey900),
                ),
                const Spacer(),
                Text(
                  representative?.phoneNumber.formattedPhoneNumber ?? '',
                  style: MyTypo.body1.copyWith(color: MyColor.grey900),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
