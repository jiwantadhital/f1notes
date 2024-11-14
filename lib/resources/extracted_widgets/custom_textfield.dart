import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final hintText,
      controller,
      keyboardType,
      textInputAction,
      maxLength,
      isPass,
      onchange,
      suffixIconEnabled,
      textAlign,
      validator,
      icon,
      key,
      isFloating,
      readOnly,
      onPress,
      floatingLabelColor,
      enabled,
      focusedColor,
      isLabel,
      autoFocus,
      onSubmit,
      showCount,
      prefixIcon,
      maxLines,
      focusNode,
      inputFormatters,
      textCap,
      contentPadding,
      onFocusChange,
      fill,
      fillColor,
      suffixIcon;

  const CustomTextField(
      {this.autoFocus = false,
      this.key,
      this.showCount = false,
      this.onSubmit = null,
      this.onPress,
      this.fill = true,
      this.fillColor,
      this.maxLines = 1,
      this.suffixIconEnabled = true,
      this.floatingLabelColor,
      this.isLabel = true,
      this.readOnly = false,
      this.textAlign = TextAlign.start,
      required this.hintText,
      required this.controller,
      this.keyboardType = TextInputType.text,
      this.maxLength = 1000,
      this.isPass = false,
      this.contentPadding,
      this.icon,
      this.validator,
      this.enabled = true,
      this.onchange,
      this.focusedColor,
      this.textInputAction = TextInputAction.next,
      this.prefixIcon = null,
      this.isFloating = false,
      this.textCap = TextCapitalization.none,
      this.focusNode,
      this.onFocusChange,
      this.inputFormatters,
      this.suffixIcon,
      });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return TextFormField(
      key: widget.key,
      onTap: widget.onPress,

      maxLines: widget.maxLines,
      onTapOutside:(e){
            FocusManager.instance.primaryFocus!.unfocus();
      },
      textCapitalization: widget.textCap,
      // textAlignVertical: TextAlignVertical.top,
      readOnly: widget.readOnly,
      autofocus: widget.autoFocus,
      inputFormatters: widget.inputFormatters, //
      textAlign: widget.textAlign,
      cursorColor: Theme.of(context).primaryColor,
      // onChanged: widget.onchange,
      focusNode: widget.focusNode,
      style: TextStyle(
        color: theme.onSurface,
        fontWeight: FontWeight.w500,
        fontSize: 13,
      ),
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,

      maxLength: widget.maxLength,
      validator: widget.validator,
      enabled: widget.enabled,
      decoration: InputDecoration(
        filled: widget.fill,
        fillColor: widget.fillColor,
        prefixIcon: widget.prefixIcon,
        floatingLabelBehavior: widget.isFloating
            ? FloatingLabelBehavior.always
            : FloatingLabelBehavior.auto,
        suffixIcon: widget.suffixIcon,
        counterText: widget.showCount ? null : '',
        labelStyle: TextStyle(
          color: theme.onSurfaceVariant,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        errorBorder:
            OutlineInputBorder(borderSide: BorderSide(color: theme.error)),
        disabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: theme.outline)),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: theme.outline)),
        floatingLabelStyle: TextStyle(
          color: widget.floatingLabelColor ??
              Theme.of(context).colorScheme.outline,
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          width: widget.readOnly == true ? 1 : 2,
          color: widget.focusedColor ?? Theme.of(context).primaryColor,
        )),
        hintText: widget.isLabel ? null : widget.hintText,
        hintStyle: TextStyle(
          color: theme.onSurfaceVariant,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        border: OutlineInputBorder(),
        labelText: widget.isLabel ? widget.hintText : null,
        contentPadding: widget.contentPadding == null
            ? widget.suffixIconEnabled
                ? EdgeInsets.only(right: 0, left: 16)
                : EdgeInsets.only(right: 15, left: 0)
            : widget.contentPadding,
      ),
    );
  }
}