import '../../../helpers/extensions.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../core/widgets/already_have_account_text.dart';
import '../../../core/widgets/progress_indicaror.dart';
import '../../../core/widgets/terms_and_conditions_text.dart';
import '../../../logic/cubit/auth_cubit.dart';
import '../../../theming/styles.dart';
import 'widgets/password_reset.dart';

class ForgetScreen extends StatefulWidget {
  const ForgetScreen({super.key});

  @override
  State<ForgetScreen> createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.only(left: 30.w, right: 30.w, bottom: 15.h, top: 5.h),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Reset',
                              style: TextStyles.font24Blue700Weight,
                            ),
                            Gap(10.h),
                            Text(
                              "Enter email to reset password",
                              style: TextStyles.font14Grey400Weight,
                            ),
                          ],
                        ),
                      ),
                      Gap(20.h),
                      BlocConsumer<AuthCubit, AuthState>(
                        listenWhen: (previous, current) => previous != current,
                        listener: (context, state) async {
                          if (state is AuthLoading) {
                            ProgressIndicaror.showProgressIndicator(context);
                          } else if (state is AuthError) {
                            context.pop();
                            context.pop();
                            await AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'Error',
                              desc: state.message,
                            ).show();
                          } else if (state is ResetPasswordSent) {
                            context.pop();
                            context.pop();
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.info,
                              animType: AnimType.rightSlide,
                              title: 'Reset Password',
                              desc:
                                  'Link to Reset password send to your email, please check inbox messages.',
                            ).show();
                          }
                        },
                        buildWhen: (previous, current) {
                          return previous != current;
                        },
                        builder: (context, state) {
                          return const PasswordReset();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Ensure minimum height
                  children: [
                    const TermsAndConditionsText(),
                    Gap(24.h),
                    const AlreadyHaveAccountText(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    BlocProvider.of<AuthCubit>(context);
  }
}
