import 'package:flutter/material.dart';
import 'package:kiosk_finder/features/authentication/presentation/widgets/form_btn_widget.dart';
import 'package:kiosk_finder/features/authentication/presentation/widgets/text_form_field_widget.dart';

class SignUpAndInPage extends StatelessWidget {
  final bool isLogin;
  const SignUpAndInPage({required this.isLogin, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        height: MediaQuery.of(context).size.height - 50,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              children: <Widget>[
                const SizedBox(height: 60.0),
                Text(
                  isLogin ? "Sign In" : "Sign up",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  isLogin ? "enter your account" : "Create your account",
                  style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                )
              ],
            ),
            Column(
              children: <Widget>[
                TextFormFieldWidget(
                  title: "Email",
                  icon: Icons.email,
                  isPassword: false,
                ),
                const SizedBox(height: 20),
                TextFormFieldWidget(
                  title: "Password",
                  icon: Icons.password,
                  isPassword: true,
                ),
                const SizedBox(height: 20),
                isLogin
                    ? SizedBox()
                    : TextFormFieldWidget(
                        title: "Confirm Password",
                        icon: Icons.password,
                        isPassword: true,
                      ),
              ],
            ),
            isLogin
                ? FormBtnWidget(title: "Sign In", onPressed: () {})
                : FormBtnWidget(title: "Sign up", onPressed: () {}),
            isLogin
                ? _signupIn(
                    context, "Don\'t have an account?", "Sign Up", () {})
                : _signupIn(context, "Already have an account?", "Login", () {})
          ],
        ),
      ),
    );
  }

  _signupIn(
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
}
