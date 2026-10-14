part of '../post_screen.dart';

class _CommentTextField extends StatelessWidget {
  const _CommentTextField({
    required this.profileImage,
    required this.controller,
    required this.onSend,
  });

  final String? profileImage;
  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        16 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: MyColor.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(8, 0),
          ),
        ],
        color: MyColor.white,
      ),
      child: Row(
        spacing: 8,
        children: [
          ProfileWidget(profileImage: profileImage, size: 52),
          Expanded(
            child: Stack(
              children: [
                TextFormField(
                  controller: controller,
                  onFieldSubmitted: (_) => onSend(),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(
                      20,
                      15.5,
                      56,
                      15.5,
                    ),
                    hintText: "따뜻한 댓글을 작성해 주세요.",
                    hintStyle: MyTypo.hint.copyWith(color: MyColor.grey500),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(9999)),
                      borderSide: BorderSide(color: MyColor.grey300, width: 1),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(9999)),
                      borderSide: BorderSide(color: MyColor.grey300, width: 1),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(9999)),
                      borderSide: BorderSide(color: MyColor.grey300, width: 1),
                    ),
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: GestureDetector(
                    onTap: onSend,
                    child: Container(
                      width: 44,
                      height: 44,
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: MyColor.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const IconWidget(icon: "send", width: 36),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
