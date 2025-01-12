import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk_finder/features/authentication/presentation/bloc/auth/auth_bloc.dart';
import 'package:kiosk_finder/features/map&marker_display/presentation/kiosk_bloc/kiosk_bloc.dart';
import 'core/app_theme.dart';
import 'features/authentication/presentation/pages/sign_up_and_in_page.dart';
import 'injection.dart' as di; //di: refer to dependency injection

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(); // Initialize Firebase
    print('Firebase Initialization Successful');
  } catch (e) {
    print('Firebase Initialization Failed: $e');
  }
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<AuthBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<KioskBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Kiosk Finder',
        theme: appTheme,
        home: SignUpAndInPage(isLogin: false),
      ),
    );
  }
}
