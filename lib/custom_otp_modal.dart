import 'package:flutter/material.dart';
import 'dart:async';

class OtpModal {
  final BuildContext context;
  final TextInputType keyboardType;
  final Color backgroundColor;
  final Color textColor;
  final Color buttonColor;
  final Color borderColor;
  final TextStyle? titleTextStyle;
  final TextStyle? contentTextStyle;
  final TextStyle? buttonTextStyle;
  final int codeLength;
  final int boxSize;
  final double margin;
  final bool autoFocus;
  final int otpTtl;

  late TextEditingController otpController;
  late String otpValue;
  late bool isVerified;
  late int remainingTime;
  late bool timerActive;
  Timer? timer;

  OtpModal({
    required this.context,
    required this.keyboardType,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.buttonColor = Colors.white,
    this.borderColor = Colors.blue,
    this.titleTextStyle,
    this.contentTextStyle,
    this.buttonTextStyle,
    this.codeLength = 6,
    this.boxSize = 35,
    this.margin = 4.0,
    this.autoFocus = true,
    this.otpTtl = 60,
  }) {
    otpController = TextEditingController();
    otpValue = '';
    isVerified = false;
    timerActive = true;
    remainingTime = otpTtl;
  }

  Future<String?> show() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          if (remainingTime == otpTtl && timer == null) {
            startTimer(setState);
          }

          return AlertDialog(
            backgroundColor: backgroundColor,
            title: Text(
              "OTP Verification",
              style: titleTextStyle ?? TextStyle(color: textColor),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Enter the OTP sent to your mobile",
                  style: contentTextStyle ?? TextStyle(color: textColor),
                ),
                const SizedBox(height: 16.0),
                TextFieldPin(
                  keyboardType: keyboardType,
                  onChange: (String value) {
                    otpValue = value;
                  },
                  margin: margin,
                  defaultBoxSize: boxSize.toDouble(),
                  selectedBoxSize: boxSize.toDouble(),
                  codeLength: codeLength,
                  textController: otpController,
                  textStyle: TextStyle(fontSize: 20, color: borderColor),
                  defaultDecoration: BoxDecoration(
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                  ),
                  selectedDecoration: BoxDecoration(
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                  ),
                  autoFocus: autoFocus,
                  alignment: MainAxisAlignment.center,
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: timerActive,
                      child: Text(
                        'Time remaining: $remainingTime',
                        style: TextStyle(color: textColor),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Visibility(
                      visible: !timerActive,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          textStyle: buttonTextStyle,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Resend",
                              style: TextStyle(color: borderColor),
                            ),
                            Icon(
                              Icons.restart_alt,
                              color: borderColor,
                            ),
                          ],
                        ),
                        onPressed: () {
                          remainingTime = otpTtl;
                          timerActive = true;
                          startTimer(setState);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  textStyle: buttonTextStyle,
                ),
                child: Text(
                  "Cancel",
                  style: TextStyle(color: borderColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(width: 20),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  textStyle: buttonTextStyle,
                ),
                child: Text(
                  "Submit",
                  style: TextStyle(color: borderColor),
                ),
                onPressed: () {
                  Navigator.pop(context, otpValue);
                },
              ),
            ],
          );
        });
      },
    );

    return otpValue;
  }

  void startTimer(StateSetter updateState) {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      updateState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          timerActive = false;
          timer.cancel();
        }
      });
    });
  }
}

class TextFieldPin extends StatefulWidget {
  final Function(String) onChange;
  final double defaultBoxSize;
  final double selectedBoxSize;
  final BoxDecoration? defaultDecoration;
  final int codeLength;
  final TextStyle? textStyle;
  final double margin;
  final BoxDecoration? selectedDecoration;
  final bool autoFocus;
  final MainAxisAlignment alignment;
  final TextEditingController textController;
  final TextInputType keyboardType;

  TextFieldPin({
    super.key,
    required this.onChange,
    required this.defaultBoxSize,
    defaultDecoration,
    selectedBoxSize,
    required this.codeLength,
    this.textStyle,
    this.margin = 16.0,
    this.selectedDecoration,
    this.autoFocus = false,
    this.alignment = MainAxisAlignment.center,
    required this.keyboardType,
    TextEditingController? textController,
  })  : textController = textController ?? TextEditingController(),
        selectedBoxSize = selectedBoxSize ?? defaultBoxSize,
        defaultDecoration = defaultDecoration ??
            BoxDecoration(
              border: Border.all(color: Colors.white),
            );

  @override
  _TextFieldPinState createState() => _TextFieldPinState();
}

class _TextFieldPinState extends State<TextFieldPin> {
  late int focusedIndex;

  @override
  void initState() {
    super.initState();
    focusedIndex = 0;
    widget.textController.addListener(_updateFocusedIndex);
  }

  @override
  void dispose() {
    widget.textController.removeListener(_updateFocusedIndex);
    widget.textController.dispose();
    super.dispose();
  }

  void _updateFocusedIndex() {
    setState(() {
      focusedIndex = widget.textController.text.length;
    });
  }

  List<Widget> getField() {
    final List<Widget> result = <Widget>[];
    for (int i = 1; i <= widget.codeLength; i++) {
      result.add(Padding(
        padding: EdgeInsets.symmetric(
          horizontal: widget.margin,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              height: widget.defaultBoxSize,
              width: widget.defaultBoxSize,
              decoration: i == focusedIndex + 1
                  ? widget.selectedDecoration?.copyWith(
                      border: Border.all(color: Colors.white, width: 2))
                  : widget.defaultDecoration,
            ),
            if (widget.textController.text.length >= i)
              Container(
                decoration: widget.selectedDecoration,
                width: widget.selectedBoxSize,
                height: widget.selectedBoxSize,
                child: Center(
                  child: Text(
                    widget.textController.text[i - 1],
                    style: widget.textStyle,
                  ),
                ),
              ),
          ],
        ),
      ));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: widget.defaultBoxSize >= widget.selectedBoxSize
                ? widget.defaultBoxSize
                : widget.selectedBoxSize,
            child: Row(
              mainAxisAlignment: widget.alignment,
              children: getField(),
            ),
          ),
          defaultTextField(),
        ],
      ),
    );
  }

  Widget defaultTextField() {
    return Opacity(
      opacity: 0.0,
      child: TextField(
        maxLength: widget.codeLength,
        showCursor: false,
        enableSuggestions: false,
        autocorrect: false,
        autofocus: widget.autoFocus,
        enableIMEPersonalizedLearning: false,
        enableInteractiveSelection: false,
        style: const TextStyle(color: Colors.transparent),
        decoration: const InputDecoration(
            fillColor: Colors.transparent,
            counterStyle: TextStyle(color: Colors.transparent),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            filled: true),
        keyboardType: widget.keyboardType,
        controller: widget.textController,
        onChanged: widget.onChange,
      ),
    );
  }
}