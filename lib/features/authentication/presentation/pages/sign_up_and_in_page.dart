import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk_finder/features/authentication/presentation/widgets/form_widget.dart';
import '../../../../core/util/snack_bar_message.dart';
import '../../../map&marker_display/presentation/pages/home.dart';

import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_state.dart';
import '../../../../core/widgets/loading_widget.dart';

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
            BlocConsumer<AuthBloc, AuthState>(builder: (context, state) {
              if (state is LoadingAuthState) {
                return LoadingWidget();
              }
              return FormWidget(isLogin: isLogin);
            }, listener: (context, state) {
              if (state is MessageAuthState) {
                SnackBarMessage().showSuccessSnackBar(
                    message: state.message, context: context);
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => CitySelectionPage()),
                    (route) => false);
              } else if (state is ErrorAuthState) {
                SnackBarMessage().showErrorSnackBar(
                    message: state.message, context: context);
              }
            }),
          ],
        ),
      ),
    );
  }
}
