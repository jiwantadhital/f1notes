import 'dart:io';

import 'package:f1notes/resources/extracted_widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPress;
  final String? text;
  final Color? color;
  final Color? textColor;
  final bool isFull;
  final bool isLoading;
  final bool isNewButton;
  final double? padBot;
  final double borderRadius;
  final IconData? icon;

  const CustomButton({
    Key? key,
    this.onPress,
    this.text,
    this.color,
    this.textColor,
    this.isFull = true,
    this.isLoading = false,
    this.isNewButton = false,
    this.padBot,
    this.borderRadius = 4.0,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: isFull ? double.infinity : null,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: padBot ?? (Platform.isIOS ? 16.0 : 8.0),
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPress,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: isLoading
                ? theme.primaryColor.withOpacity(0.4)
                : color ?? theme.primaryColor,
            disabledBackgroundColor: theme.disabledColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              side: isNewButton
                  ? BorderSide(color: theme.primaryColor)
                  : BorderSide.none,
            ),
          ),
          child: isLoading
              ? const _LoadingIndicator()
              : Padding(
                  padding: EdgeInsets.symmetric(vertical: isFull ? 14.0 : 0.0),
                  child: icon == null
                      ? CustomText(
                          text: text ?? "",
                          fontSize: 13,
                          weight: FontWeight.w500,
                          color: textColor ?? theme.colorScheme.onPrimary,
                          textOverflow: TextOverflow.ellipsis,
                        )
                      : Icon(
                          icon,
                          color: Colors.white,
                          size: 25,
                        ),
                ),
        ),
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(
          strokeWidth: 3.0,
          color: Colors.white,
        ),
      ),
    );
  }
}
