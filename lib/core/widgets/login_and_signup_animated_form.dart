import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:rive/rive.dart';

import '../../../helpers/app_regex.dart';
import '../../../routing/routes.dart';
import '../../../theming/styles.dart';
import '../../helpers/extensions.dart';
import '/screens/login/ui/widgets/animation_enum.dart';
import 'app_text_button.dart';
import 'app_text_form_field.dart';
import 'password_validations.dart';

class EmailAndPassword extends StatefulWidget {
  final bool? isSignUpPage;
  const EmailAndPassword({super.key, this.isSignUpPage});

  @override
  State<EmailAndPassword> createState() => _EmailAndPasswordState();
}

class _EmailAndPasswordState extends State<EmailAndPassword> {
  bool isObscureText = true;
  bool hasLowercase = false;
  bool hasUppercase = false;
  bool hasSpecialCharacters = false;
  bool hasNumber = false;
  bool hasMinLength = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();
  Artboard? riveArtboard;
  late RiveAnimationController controllerIdle;
  late RiveAnimationController controllerHandsUp;
  late RiveAnimationController controllerHandsDown;
  late RiveAnimationController controllerSuccess;
  late RiveAnimationController controllerFail;
  late RiveAnimationController controllerLookDownRight;
  late RiveAnimationController controllerLookDownLeft;
  final passwordFocuseNode = FocusNode();
  final passwordConfirmationFocuseNode = FocusNode();

  bool isLookingRight = false;
  bool isLookingLeft = false;
  void removeAllControllers() {
    final listOfControllers = [
      controllerIdle,
      controllerHandsUp,
      controllerHandsDown,
      controllerSuccess,
      controllerFail,
      controllerLookDownRight,
      controllerLookDownLeft,
    ];
    for (RiveAnimationController controller in listOfControllers) {
      riveArtboard!.removeController(controller);
    }
    isLookingLeft = false;
    isLookingRight = false;

    listOfControllers.clear();
  }

  void addIdleController() {
    removeAllControllers();
    riveArtboard!.addController(controllerIdle);
  }

  void addHandsUpController() {
    removeAllControllers();
    riveArtboard!.addController(controllerHandsUp);
  }

  void addHandsDownController() {
    removeAllControllers();
    riveArtboard!.addController(controllerHandsDown);
  }

  void addSuccessController() {
    removeAllControllers();
    riveArtboard!.addController(controllerSuccess);
  }

  void addFailController() {
    removeAllControllers();
    riveArtboard!.addController(controllerFail);
  }

  void addDownRightController() {
    removeAllControllers();
    riveArtboard!.addController(controllerLookDownRight);
    isLookingRight = true;
  }

  void addDownLeftController() {
    removeAllControllers();
    riveArtboard!.addController(controllerLookDownLeft);
    isLookingLeft = true;
  }

  void checkForPasswordFocused() {
    passwordFocuseNode.addListener(() {
      if (passwordFocuseNode.hasFocus && isObscureText) {
        addHandsUpController();
      } else if (!passwordFocuseNode.hasFocus && isObscureText) {
        addHandsDownController();
      }
    });
  }

  void checkForPasswordConfirmationFocused() {
    passwordConfirmationFocuseNode.addListener(() {
      if (passwordConfirmationFocuseNode.hasFocus && isObscureText) {
        addHandsUpController();
      } else if (!passwordConfirmationFocuseNode.hasFocus && isObscureText) {
        addHandsDownController();
      }
    });
  }

  @override
  void initState() {
    controllerIdle = SimpleAnimation(Animatations.idle.name);
    controllerHandsUp = SimpleAnimation(Animatations.Hands_up.name);
    controllerHandsDown = SimpleAnimation(Animatations.hands_down.name);
    controllerSuccess = SimpleAnimation(Animatations.success.name);
    controllerFail = SimpleAnimation(Animatations.fail.name);
    controllerLookDownRight =
        SimpleAnimation(Animatations.Look_down_right.name);
    controllerLookDownLeft = SimpleAnimation(Animatations.Look_down_left.name);
    rootBundle.load('assets/login_animation.riv').then((data) {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      artboard.addController(controllerIdle);
      setState(() {
        riveArtboard = artboard;
      });
    });
    super.initState();
    setupPasswordControllerListener();
    checkForPasswordFocused();
    checkForPasswordConfirmationFocused();
  }

  void setupPasswordControllerListener() {
    passwordController.addListener(() {
      setState(() {
        hasLowercase = AppRegex.hasLowerCase(passwordController.text);
        hasUppercase = AppRegex.hasUpperCase(passwordController.text);
        hasSpecialCharacters =
            AppRegex.hasSpecialCharacter(passwordController.text);
        hasNumber = AppRegex.hasNumber(passwordController.text);
        hasMinLength = AppRegex.hasMinLength(passwordController.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 5,
            child: riveArtboard != null
                ? Rive(
                    fit: BoxFit.cover,
                    artboard: riveArtboard!,
                  )
                : const SizedBox.shrink(),
          ),
          emailField(),
          Gap(18.h),
          passwordField(),
          Gap(18.h),
          passwordConfirmationField(),
          forgetPasswordTextButton(context),
          Gap(5.h),
          PasswordValidations(
            hasLowerCase: hasLowercase,
            hasUpperCase: hasUppercase,
            hasSpecialCharacters: hasSpecialCharacters,
            hasNumber: hasNumber,
            hasMinLength: hasMinLength,
          ),
          Gap(10.h),
          loginOrSignUpButton(context),
        ],
      ),
    );
  }

  Widget forgetPasswordTextButton(BuildContext context) {
    if (widget.isSignUpPage == null) {
      return TextButton(
        onPressed: () {
          context.pushNamed(Routes.forgetScreen);
        },
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            'forget password?',
            style: TextStyles.font14Blue400Weight,
          ),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget loginOrSignUpButton(BuildContext context) {
    if (widget.isSignUpPage == null) {
      return loginButton(context);
    } else {
      return signUpButton(context);
    }
  }

  AppTextButton signUpButton(BuildContext context) {
    return AppTextButton(
      buttonText: "Create Account",
      textStyle: TextStyles.font16White600Weight,
      onPressed: () async {
        passwordFocuseNode.unfocus();
        passwordConfirmationFocuseNode.unfocus();
        if (formKey.currentState!.validate()) {
          try {
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text,
            );
            await FirebaseAuth.instance.currentUser!.sendEmailVerification();
            await FirebaseAuth.instance.signOut();
            if (!context.mounted) return;

            await AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              animType: AnimType.rightSlide,
              title: 'Sign up Success',
              desc: 'Don\'t forget to verify your email check inbox.',
            ).show();

            addSuccessController();
            Future.delayed(const Duration(seconds: 2));
            removeAllControllers();
            if (!context.mounted) return;

            context.pushNamedAndRemoveUntil(
              Routes.loginScreen,
              predicate: (route) => false,
            );
          } on FirebaseAuthException catch (e) {
            addFailController();

            if (e.code == 'email-already-in-use') {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.rightSlide,
                title: 'Error',
                desc:
                    'This account already exists for that email go and login.',
              ).show();
            } else {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.rightSlide,
                title: 'Error',
                desc: e.message,
              ).show();
            }
          } catch (e) {
            addFailController();

            AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.rightSlide,
              title: 'Error',
              desc: e.toString(),
            ).show();
          }
        }
      },
    );
  }

  AppTextButton loginButton(BuildContext context) {
    return AppTextButton(
      buttonText: 'Login',
      textStyle: TextStyles.font16White600Weight,
      onPressed: () async {
        passwordFocuseNode.unfocus();

        if (formKey.currentState!.validate()) {
          try {
            final c = await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text,
            );
            if (c.user!.emailVerified) {
              addSuccessController();
              Future.delayed(const Duration(seconds: 2));
              removeAllControllers();
              if (!context.mounted) return;

              context.pushNamedAndRemoveUntil(
                Routes.homeScreen,
                predicate: (route) => false,
              );
            } else {
              await FirebaseAuth.instance.signOut();
              addFailController();
              if (!context.mounted) return;

              AwesomeDialog(
                context: context,
                dialogType: DialogType.info,
                animType: AnimType.rightSlide,
                title: 'Email Not Verified',
                desc: 'Verify your email check inbox.',
              ).show();
            }
          } on FirebaseAuthException catch (e) {
            addFailController();

            if (e.code == 'user-not-found') {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.rightSlide,
                title: 'FireBase Error',
                desc: 'No user found for that email.',
              ).show();
            } else if (e.code == 'wrong-password') {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.rightSlide,
                title: 'FireBase Error',
                desc: 'Wrong password provided for that user.',
              ).show();
            } else {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.rightSlide,
                title: 'FireBase Error',
                desc: e.message,
              ).show();
            }
          }
        }
      },
    );
  }

  AppTextFormField emailField() {
    return AppTextFormField(
      hint: 'Email',
      onChanged: (value) {
        if (value.isNotEmpty && value.length <= 13 && !isLookingLeft) {
          addDownLeftController();
        } else if (value.isNotEmpty && value.length > 13 && !isLookingRight) {
          addDownRightController();
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty || !AppRegex.isEmailValid(value)) {
          addFailController();
          return 'Please enter a valid email';
        }
      },
      controller: emailController,
    );
  }

  AppTextFormField passwordField() {
    return AppTextFormField(
      focusNode: passwordFocuseNode,
      controller: passwordController,
      hint: 'Password',
      isObscureText: isObscureText,
      suffixIcon: GestureDetector(
        onTap: () {
          setState(() {
            if (isObscureText) {
              isObscureText = false;
              addHandsDownController();
            } else {
              addHandsUpController();
              isObscureText = true;
            }
          });
        },
        child: Icon(
          isObscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
        ),
      ),
      validator: (value) {
        if (value == null ||
            value.isEmpty ||
            !AppRegex.isPasswordValid(value)) {
          addFailController();
          return 'Please enter a valid password';
        }
      },
    );
  }

  Widget passwordConfirmationField() {
    if (widget.isSignUpPage == null) {
      return const SizedBox.shrink();
    }
    return AppTextFormField(
      focusNode: passwordConfirmationFocuseNode,
      controller: passwordConfirmationController,
      hint: 'Password Confirmation',
      isObscureText: isObscureText,
      suffixIcon: GestureDetector(
        onTap: () {
          setState(() {
            if (isObscureText) {
              isObscureText = false;
              addHandsDownController();
            } else {
              addHandsUpController();
              isObscureText = true;
            }
          });
        },
        child: Icon(
          isObscureText ? Icons.visibility_off : Icons.visibility,
        ),
      ),
      validator: (value) {
        if (value != passwordController.text) {
          return 'Enter a matched password';
        }
        if (value == null ||
            value.isEmpty ||
            !AppRegex.isPasswordValid(value)) {
          addFailController();
          return 'Please enter a valid password';
        }
      },
    );
  }

  @override
  void dispose() {
    passwordController.dispose();
    passwordConfirmationController.dispose();
    emailController.dispose();
    removeAllControllers();
    controllerIdle.dispose();
    controllerHandsUp.dispose();
    controllerHandsDown.dispose();
    controllerSuccess.dispose();
    controllerFail.dispose();
    controllerLookDownRight.dispose();
    passwordFocuseNode.dispose();
    passwordConfirmationFocuseNode.dispose();
    controllerLookDownLeft.dispose();
    super.dispose();
  }
}
