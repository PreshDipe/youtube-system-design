import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_client/cubits/auth/auth_cubit.dart';
import 'package:flutter_client/cubits/upload_video/upload_video_cubit.dart';
import 'package:flutter_client/pages/auth/signup_page.dart';
import 'package:flutter_client/pages/home/home_page.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => UploadVideoCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().isAuthenticated();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YT Clone',
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            minimumSize: Size(double.infinity, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.all(27),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300, width: 3),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 3),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 3),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 3),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        ),
      ),
      home: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthInitial) {
            return SignupPage();
          } else if (state is AuthLoginSuccess) {
            return HomePage();
          } else if (state is AuthError) {
            return SignupPage();
          }

          return const SizedBox();
        },
      ),
    );
  }
}
