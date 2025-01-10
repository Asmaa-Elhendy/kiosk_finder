import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk_finder/features/authentication/domain/entities/user.dart';
import 'package:kiosk_finder/features/authentication/presentation/bloc/auth/auth_bloc.dart';
import 'package:kiosk_finder/features/authentication/presentation/bloc/auth/auth_event.dart';
import 'package:kiosk_finder/features/authentication/presentation/widgets/text_form_field_widget.dart';
import '../pages/sign_up_and_in_page.dart';
import 'form_btn_widget.dart';

class FormWidget extends StatefulWidget {
  final bool isLogin;
  const FormWidget({required this.isLogin, super.key});

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  // TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormFieldWidget(
                controller: emailController,
                title: "Email",
                icon: Icons.email,
                isPassword: false,
              ),
              const SizedBox(height: 20),
              TextFormFieldWidget(
                controller: passwordController,
                title: "Password",
                icon: Icons.password,
                isPassword: true,
              ),
              const SizedBox(height: 20),
              // widget.isLogin
              //     ? SizedBox()
              //     : TextFormFieldWidget(
              //         controller: confirmPasswordController,
              //         title: "Confirm Password",
              //         icon: Icons.password,
              //         isPassword: true,
              //       ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        widget.isLogin
            ? FormBtnWidget(
                title: "Sign In",
                onPressed: () {
                  onPressSignUpOrIn(true);
                })
            : FormBtnWidget(
                title: "Sign up",
                onPressed: () {
                  onPressSignUpOrIn(false);
                }),
        widget.isLogin
            ? _signupIn(context, "Don\'t have an account?", "Sign Up", () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => SignUpAndInPage(isLogin: false)),
                );
              })
            : _signupIn(context, "Already have an account?", "Login", () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => SignUpAndInPage(isLogin: true)),
                );
              })
      ],
    );
  }

  Widget _signupIn(
      context, String statement, String title, void Function() onPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(statement),
        TextButton(
            onPressed: onPressed,
            child: Text(
              title,
              style: TextStyle(color: Colors.purple),
            ))
      ],
    );
  }

  void onPressSignUpOrIn(bool isSignIn) {
    if (_formKey.currentState!.validate()) {
      final user = UserEntity(
          id: '',
          email: emailController.text,
          password: passwordController.text);
      BlocProvider.of<AuthBloc>(context)
          .add(isSignIn ? SignInEvent(user: user) : SignUpEvent(user: user));
    }
  }
}
