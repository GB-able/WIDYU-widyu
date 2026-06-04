part of '../profile_screen.dart';

class _ProfileNameView extends StatefulWidget {
  final String name;
  final ValueChanged<String> onNameChanged;

  const _ProfileNameView({
    required this.name,
    required this.onNameChanged,
  });

  @override
  State<_ProfileNameView> createState() => _ProfileNameViewState();
}

class _ProfileNameViewState extends State<_ProfileNameView> {
  final _controller = TextEditingController();
  bool _isEditing = false;
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isEditing) {
      _controller.text = widget.name;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 72,
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            readOnly: !_isEditing,
            showCursor: _isEditing,
            cursorColor: MyColor.black,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: MyTypo.title3.copyWith(color: MyColor.black),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 4),
              enabledBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: MyColor.black,
                  width: 2,
                ),
              ),
            ),
            onSubmitted: (_) {
              widget.onNameChanged(_controller.text);
              setState(() => _isEditing = false);
            },
          ),
        ),
        Material(
          color: MyColor.transparent,
          child: InkWell(
            onTap: () => setState(() {
              if (_isEditing) {
                widget.onNameChanged(_controller.text);
                _focusNode.unfocus();
              } else {
                _focusNode.requestFocus();
              }
              _isEditing = !_isEditing;
            }),
            child: const WidyuIcon(
              icon: 'ic_24_edit.svg',
              width: 24,
              height: 24,
            ),
          ),
        ),
      ],
    );
  }
}
