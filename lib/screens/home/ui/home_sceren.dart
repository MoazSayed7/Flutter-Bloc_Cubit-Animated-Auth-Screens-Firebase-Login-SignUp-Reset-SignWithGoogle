import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '/helpers/extensions.dart';
import '/routing/routes.dart';
import '/theming/styles.dart';
import '../../../core/widgets/app_text_button.dart';
import '../../../core/widgets/no_internet.dart';
import '../../../core/widgets/progress_indicaror.dart';
import '../../../logic/cubit/auth_cubit.dart';
import '../../../theming/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          return connected ? _homePage(context) : const BuildNoInternet();
        },
        child: const Center(
          child: CircularProgressIndicator(
            color: ColorsManager.mainBlue,
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

  SafeArea _homePage(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 200.h,
                width: 200.w,
                child: FirebaseAuth.instance.currentUser!.photoURL != null
                    ? CachedNetworkImage(
                        imageUrl: FirebaseAuth.instance.currentUser!.photoURL!,
                        placeholder: (context, url) =>
                            Image.asset('assets/images/loading.gif'),
                        fit: BoxFit.cover,
                      )
                    : Image.asset('assets/images/placeholder.png'),
              ),
              Text(
                FirebaseAuth.instance.currentUser!.displayName!,
                style: TextStyles.font15DarkBlue500Weight
                    .copyWith(fontSize: 30.sp),
              ),
              BlocConsumer<AuthCubit, AuthState>(
                buildWhen: (previous, current) => previous != current,
                listenWhen: (previous, current) => previous != current,
                listener: (context, state) async {
                  if (state is AuthLoading) {
                    ProgressIndicaror.showProgressIndicator(context);
                  } else if (state is UserSignedOut) {
                    context.pop();
                    context.pushNamedAndRemoveUntil(
                      Routes.loginScreen,
                      predicate: (route) => false,
                    );
                  } else if (state is AuthError) {
                    await AwesomeDialog(
                      context: context,
                      dialogType: DialogType.info,
                      animType: AnimType.rightSlide,
                      title: 'Sign out error',
                      desc: state.message,
                    ).show();
                  }
                },
                builder: (context, state) {
                  return AppTextButton(
                    buttonText: 'Sign Out',
                    textStyle: TextStyles.font15DarkBlue500Weight,
                    onPressed: () {
                      try {
                        GoogleSignIn().disconnect();
                      } finally {
                        context.read<AuthCubit>().signOut();
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
