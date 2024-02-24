import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import '../../../theming/colors.dart';
import '../../../core/widgets/sign_in_with_google_text.dart';
import '../../../helpers/google_sign_in.dart';
import '../../../core/widgets/login_and_signup_animated_form.dart';
import '../../../core/widgets/terms_and_conditions_text.dart';
import '../../../core/widgets/no_internet.dart';
import '../../../theming/styles.dart';
import 'widgets/do_not_have_account.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
          return connected ? _loginPage(context) : const BuildNoInternet();
        },
        child: const Center(
          child: CircularProgressIndicator(
            color: ColorsManager.mainBlue,
          ),
        ),
      ),
    );
  }

  SafeArea _loginPage(BuildContext context) {
    return SafeArea(
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
              EmailAndPassword(),
              Gap(10.h),
              const SigninWithGoogleText(),
              Gap(5.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.google),
                    onPressed: () async {
                      await GoogleSignin.signInWithGoogle(context);
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
    );
  }
}
