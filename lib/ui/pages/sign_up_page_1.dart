import 'package:bank_sha/blocs/auth/auth_bloc.dart';
import 'package:bank_sha/models/sign_up_form_model.dart';
import 'package:bank_sha/shared/shared_methods.dart';
import 'package:bank_sha/shared/theme.dart';
import 'package:bank_sha/ui/pages/sign_up_page_2.dart';
import 'package:bank_sha/ui/widgets/buttons.dart';
import 'package:bank_sha/ui/widgets/forms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final nameController = TextEditingController(text: '');
  final emailController = TextEditingController(text: '');
  final passwordController = TextEditingController(text: '');
  String errorMessage = '';

  bool validate() {
    String emailPattern = r'^[^@]+@[^@]+\.[^@]+';
    String passwordPattern = r'^(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$';

    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      setState(() {
        errorMessage = 'Semua field harus diisi';
      });
      return false;
    }

    if (!RegExp(emailPattern).hasMatch(emailController.text)) {
      setState(() {
        errorMessage = 'Email tidak valid';
      });
      return false;
    }

    if (!RegExp(passwordPattern).hasMatch(passwordController.text)) {
      setState(() {
        errorMessage =
            'Password harus terdiri dari minimal 8 karakter, 1 huruf besar, dan 1 angka';
      });
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailed) {
              showCustomSnackbar(context, state.e);
            }
            if (state is AuthCheckEmailSuccess) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SignUpPage2(
                          data: SignUpFormModel(
                              name: nameController.text,
                              email: emailController.text,
                              password: passwordController.text))));
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                Container(
                  width: 155,
                  height: 50,
                  margin: const EdgeInsets.symmetric(vertical: 100),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/img_logo_light.png'))),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Join Us to Unlock\nYour Growth',
                    style: blackTextStyle.copyWith(
                      fontSize: 20,
                      fontWeight: semiBold,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: whiteColor,
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomFormField(
                          title: 'Full Name',
                          controller: nameController,
                        ),
                        const SizedBox(height: 16),
                        CustomFormField(
                          title: 'Email Address',
                          controller: emailController,
                        ),
                        const SizedBox(height: 16),
                        CustomFormField(
                          title: 'Password',
                          obscureText: true,
                          controller: passwordController,
                        ),
                        const SizedBox(height: 30),
                        CustomFilledButton(
                          title: 'Continue',
                          onPressed: () {
                            if (validate()) {
                              context
                                  .read<AuthBloc>()
                                  .add(AuthCheckEmail(emailController.text));
                            } else {
                              showCustomSnackbar(context, errorMessage);
                            }
                          },
                        ),
                      ]),
                ),
                const SizedBox(height: 30),
                CustomTextButton(
                  title: 'Sign In',
                  onPressed: () {
                    Navigator.pushNamed(context, '/sign-in');
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
