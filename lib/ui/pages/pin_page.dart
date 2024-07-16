import 'package:bank_sha/blocs/auth/auth_bloc.dart';
import 'package:bank_sha/shared/shared_methods.dart';
import 'package:bank_sha/shared/theme.dart';
import 'package:bank_sha/ui/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

class PinPage extends StatefulWidget {
  const PinPage({super.key});

  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  bool isPressed = false;
  final TextEditingController pinController = TextEditingController(text: '');
  String pin = '';
  bool isError = false;

  addPin(String number) async {
    if (pinController.text.length < 6) {
      setState(() {
        isError = false;
        pinController.text = pinController.text + number;
      });
    }
    if (pinController.text.length == 6) {
      if (pinController.text == pin) {
        Navigator.pop(context, true);
      } else {
        setState(() {
          isError = true;
        });
        showCustomSnackbar(
            context, 'PIN yang anda masukkan salah. Silakan coba lagi.');
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          pinController.text = '';
        });
      }
    }
  }

  deletePin() {
    if (pinController.text.isNotEmpty) {
      setState(() {
        isError = false;
        pinController.text =
            pinController.text.substring(0, pinController.text.length - 1);
      });
    }
  }

  //Dijalankan ketika page dibuka
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      pin = authState.user.pin!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 58),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sha PIN',
                style: whiteTextStyle.copyWith(
                  fontSize: 20,
                  fontWeight: semiBold,
                ),
              ),
              const SizedBox(height: 72),
              SizedBox(
                width: 200,
                child: TextFormField(
                  controller: pinController,
                  obscureText: true,
                  obscuringCharacter: '*',
                  enabled: false,
                  decoration: InputDecoration(
                    disabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: numberBackgroundColor,
                        width: 2,
                      ),
                    ),
                  ),
                  style: whiteTextStyle.copyWith(
                      fontSize: 36,
                      fontWeight: medium,
                      letterSpacing: 16,
                      color: isError ? redColor : whiteColor),
                ),
              ),
              const SizedBox(height: 66),
              Wrap(
                spacing: 40,
                runSpacing: 40,
                children: [
                  CustomNumberButton(
                    number: '1',
                    onTap: () {
                      addPin('1');
                    },
                  ),
                  CustomNumberButton(
                    number: '2',
                    onTap: () {
                      addPin('2');
                    },
                  ),
                  CustomNumberButton(
                    number: '3',
                    onTap: () {
                      addPin('3');
                    },
                  ),
                  CustomNumberButton(
                    number: '4',
                    onTap: () {
                      addPin('4');
                    },
                  ),
                  CustomNumberButton(
                    number: '5',
                    onTap: () {
                      addPin('5');
                    },
                  ),
                  CustomNumberButton(
                    number: '6',
                    onTap: () {
                      addPin('6');
                    },
                  ),
                  CustomNumberButton(
                    number: '7',
                    onTap: () {
                      addPin('7');
                    },
                  ),
                  CustomNumberButton(
                    number: '8',
                    onTap: () {
                      addPin('8');
                    },
                  ),
                  CustomNumberButton(
                    number: '9',
                    onTap: () {
                      addPin('9');
                    },
                  ),
                  const SizedBox(
                    width: 60,
                    height: 60,
                  ),
                  CustomNumberButton(
                    number: '0',
                    onTap: () {
                      addPin('0');
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      deletePin();
                    },
                    onTapDown: (_) {
                      setState(() {
                        isPressed = true;
                      });
                    },
                    onTapUp: (_) {
                      setState(() {
                        isPressed = false;
                      });
                    },
                    onTapCancel: () {
                      setState(() {
                        isPressed = false;
                      });
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isPressed ? whiteColor : numberBackgroundColor,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: isPressed ? numberBackgroundColor : whiteColor,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
