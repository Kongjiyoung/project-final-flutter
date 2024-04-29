import 'package:flutter/material.dart';
import 'package:project_app/ui/welcome/pages/welcome_page/widgets/welcome_button.dart';

import '../../../../../_core/constants/move.dart';

class SignIn extends StatelessWidget {
  const SignIn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // 로그인
      child: WelcomeButton(
        buttonText: 'Sign in',
        routeName: Move.loginPage,
        // onTap: LoginPage(),
        color: Colors.teal,
        textColor: Colors.white,
      ),
    );
  }
}