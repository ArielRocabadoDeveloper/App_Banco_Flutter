import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/login_controller.dart';
import 'controllers/forgot_password_controller.dart';
import 'controllers/register_controller.dart';
import 'views/login_view.dart';
import 'views/forgot_password_view.dart';
import 'views/register_view.dart';
import 'utils/colors.dart';
import 'package:wallet_app/controllers/dashboard_controller.dart';
import 'package:wallet_app/views/dashboard_view.dart';
import 'package:wallet_app/controllers/profile_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginController()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordController()),
        ChangeNotifierProvider(create: (_) => RegisterController()),
        ChangeNotifierProvider(create: (_) => DashboardController()),
        ChangeNotifierProvider(create: (_) => ProfileController()),
      ],
      child: MaterialApp(
        title: 'Wallet App',
        theme: ThemeData(
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: ColorScheme.light(
            primary: AppColors.primary,
            secondary: AppColors.secondary,
            error: AppColors.error,
          ),
          useMaterial3: true,
        ),
        home: const LoginView(),
      ),
    );
  }
}
