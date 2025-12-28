import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:widyu/core/theme/colors.dart';
import 'package:widyu/core/theme/typos.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.validator,
    this.focusNode,
    this.maxLength,
    this.suffix,
    this.title,
    this.keyboardType = TextInputType.text,
    this.inputFormatters = const [],
    this.maxLines = 1,
    this.obscureText = false,
    this.inputAction = TextInputAction.done,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final int? maxLength;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final int maxLines;
  final Widget? suffix;
  final String? title;
  final bool obscureText;
  final TextInputAction inputAction;
  final bool enabled;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final BorderRadius _radius = BorderRadius.circular(7);
  bool _forceError = false;

  void _updateErrorState(String? errorText) {
    final shouldShowError = errorText == "";
    if (_forceError != shouldShowError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _forceError = shouldShowError;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Text(
            widget.title!,
            style: MyTypo.subTitle2.copyWith(color: MyColor.grey700),
          ),
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          validator: (value) {
            final result = widget.validator!(value);
            _updateErrorState(result);
            return result == "" ? null : result;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLength: widget.maxLength,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          maxLines: widget.maxLines,
          obscureText: widget.obscureText,
          textInputAction: widget.inputAction,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: MyTypo.hint.copyWith(color: MyColor.grey300),
            counterText: "",
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
            prefix: const SizedBox(width: 15),
            suffix: widget.suffix == null
                ? const SizedBox(width: 15)
                : const SizedBox(width: 8),
            suffixIcon: widget.suffix == null
                ? null
                : Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        widget.suffix!,
                      ],
                    ),
                  ),
            errorStyle: MyTypo.helper.copyWith(color: MyColor.red),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                  color: _forceError ? MyColor.red : MyColor.grey300, width: 1),
              borderRadius: _radius,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: _forceError ? MyColor.red : MyColor.grey300, width: 1),
              borderRadius: _radius,
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: MyColor.grey300, width: 1),
              borderRadius: _radius,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: _forceError ? MyColor.red : MyColor.grey700, width: 1),
              borderRadius: _radius,
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: MyColor.red, width: 1),
              borderRadius: _radius,
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: MyColor.red, width: 1),
              borderRadius: _radius,
            ),
          ),
          style: MyTypo.hint.copyWith(
              color: widget.enabled ? MyColor.grey900 : MyColor.grey300),
          cursorColor: MyColor.grey900,
          readOnly: !widget.enabled,
          enableInteractiveSelection: widget.enabled,
        ),
      ],
    );
  }
}
