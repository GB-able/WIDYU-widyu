part of '../management_screen.dart';

class _InviteButton extends StatelessWidget {
  final String familyCode;

  const _InviteButton({required this.familyCode});

  void _showInviteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: MyColor.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: MyColor.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '새로운 가족 멤버에게 공유해주세요.',
                    style: MyTypo.title2.copyWith(color: MyColor.grey800),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ShareItem(
                        icon: 'ic_70_kakaotalk.svg',
                        label: '카카오톡으로\n공유하기',
                        onTap: () {},
                      ),
                      const SizedBox(width: 55),
                      _ShareItem(
                        icon: 'ic_70_message.svg',
                        label: '문자로\n공유하기',
                        onTap: () => _shareViaSms(familyCode),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: _CloseButton(onTap: dialogContext.pop),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _shareViaSms(String familyCode) async {
    final uri = Uri(
      scheme: 'sms',
      queryParameters: {
        'body': '[위듀] 가족 멤버로 초대합니다.\n초대 코드: $familyCode',
      },
    );
    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return TextBtn(
      onTap: () => _showInviteDialog(context),
      text: '새로운 가족 멤버 초대하기',
      enable: true,
    );
  }
}
