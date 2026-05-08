part of '../contact_screen.dart';

class _FamilyContactView extends StatelessWidget {
  final List<FamilyMember> familyMembers;
  final ValueChanged<int> onUpdateRepresentative;

  const _FamilyContactView(
      {required this.familyMembers, required this.onUpdateRepresentative});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '가족그룹 멤버',
            style: MyTypo.title3.copyWith(color: MyColor.grey900),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: familyMembers.length,
              itemBuilder: (context, index) {
                final member = familyMembers[index];
                return _FamilyContactContent(
                  memberId: member.memberId,
                  name: member.name,
                  phoneNumber: member.phoneNumber.formattedPhoneNumber,
                  isRepresentative: member.isRepresentative,
                  onUpdateRepresentative:
                      member.isRepresentative ? null : onUpdateRepresentative,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
