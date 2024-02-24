import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/widgets/no_internet.dart';
import '../../../theming/colors.dart';
import '/helpers/extensions.dart';
import '/routing/routes.dart';
import '/theming/styles.dart';
import '../../../core/widgets/app_text_button.dart';

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

  SafeArea _homePage(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: FirebaseAuth.instance.currentUser!.photoURL == null
                    ? Image.asset('assets/images/placeholder.png')
                    : FadeInImage.assetNetwork(
                        placeholder: 'assets/images/loading.gif',
                        image: FirebaseAuth.instance.currentUser!.photoURL!,
                        fit: BoxFit.cover,
                      ),
              ),
              Text(
                FirebaseAuth.instance.currentUser!.displayName!,
                style: TextStyles.font15DarkBlue500Weight
                    .copyWith(fontSize: 30.sp),
              ),
              AppTextButton(
                buttonText: 'Sign Out',
                textStyle: TextStyles.font15DarkBlue500Weight,
                onPressed: () async {
                  try {
                    GoogleSignIn().disconnect();
                    FirebaseAuth.instance.signOut();
                    context.pushNamedAndRemoveUntil(
                      Routes.loginScreen,
                      predicate: (route) => false,
                    );
                  } catch (e) {
                    await AwesomeDialog(
                      context: context,
                      dialogType: DialogType.info,
                      animType: AnimType.rightSlide,
                      title: 'Sign out error',
                      desc: e.toString(),
                    ).show();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
