part of '../profile_screen.dart';

class _ProfileInformationView extends StatelessWidget {
  final String name;
  final String birthDate;
  final String phoneNumber;
  final String address;
  final String inviteCode;

  const _ProfileInformationView({
    required this.name,
    required this.birthDate,
    required this.phoneNumber,
    required this.address,
    required this.inviteCode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '기본정보',
            style: MyTypo.title3.copyWith(color: MyColor.black),
          ),
          const SizedBox(height: 16),
          _InfoRow(label: '이름', value: name),
          _InfoRow(label: '생년월일', value: birthDate),
          _InfoRow(label: '휴대폰번호', value: phoneNumber.formattedPhoneNumber),
          _InfoRow(label: '주소', value: address),
          _InfoRow(label: '초대 숫자', value: inviteCode),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
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
              label,
              style: MyTypo.body1.copyWith(color: MyColor.grey500),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            value,
            style: MyTypo.body1.copyWith(color: MyColor.black),
          ),
        ],
      ),
    );
  }
}
