part of '../contact_screen.dart';

class _FamilyContactContent extends StatelessWidget {
  final int memberId;
  final String name;
  final String phoneNumber;
  final bool isRepresentative;
  final ValueChanged<int>? onUpdateRepresentative;

  const _FamilyContactContent({
    required this.memberId,
    required this.name,
    required this.phoneNumber,
    required this.isRepresentative,
    required this.onUpdateRepresentative,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              name,
              style: MyTypo.body1.copyWith(color: MyColor.grey500),
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 152,
            child: Text(
              phoneNumber,
              style: MyTypo.body1.copyWith(color: MyColor.grey900),
            ),
          ),
          const Spacer(),
          Container(
            height: 24,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: isRepresentative ? MyColor.primary : MyColor.primaryLight,
              borderRadius: BorderRadius.circular(1000),
            ),
            child: Center(
              child: GestureDetector(
                onTap: () => onUpdateRepresentative?.call(memberId),
                child: Text(
                  isRepresentative ? '현재 대표 번호' : '대표 번호로 변경',
                  style: MyTypo.helper.copyWith(
                      color: isRepresentative
                          ? MyColor.primaryLight
                          : MyColor.primary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
