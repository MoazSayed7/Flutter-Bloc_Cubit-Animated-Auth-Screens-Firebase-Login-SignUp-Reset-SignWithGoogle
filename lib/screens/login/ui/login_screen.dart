import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:signup_rest_login/core/widgets/login_with_google.dart';
import 'package:signup_rest_login/helpers/build_divider.dart';
import 'package:signup_rest_login/helpers/google_sign_in.dart';

import '../../../core/widgets/login_and_signup_animated_form.dart';
import '../../../core/widgets/terms_and_conditions_text.dart';
import '../../../theming/styles.dart';
import 'widgets/do_not_have_account.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isObscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.only(left: 30.w, right: 30.w, bottom: 15.h, top: 5.h),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Login',
                        style: TextStyles.font24Blue700Weight,
                      ),
                      Gap(10.h),
                      Text(
                        "Login To Continue Using The App",
                        style: TextStyles.font14Grey400Weight,
                      ),
                    ],
                  ),
                ),
                const EmailAndPassword(),
                Gap(10.h),
                const LoginWithGoogle(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    BuildDivider.buildDivider(),
                    Gap(5.w),
                    Text(
                      'or Sign in with',
                      style: TextStyles.font13Grey400Weight,
                    ),
                    Gap(5.w),
                    BuildDivider.buildDivider(),
                  ],
                ),
                Gap(5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.google),
                      onPressed: () async {
                        await await GoogleSignin.signInWithGoogle(context);
                      },
                    ),
                  ],
                ),
                const TermsAndConditionsText(),
                Gap(15.h),
                const DoNotHaveAccountText(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
