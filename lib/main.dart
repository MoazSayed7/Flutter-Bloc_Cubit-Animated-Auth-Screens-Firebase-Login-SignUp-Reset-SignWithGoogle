import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'firebase_options.dart';
import 'routing/app_router.dart';
import 'routing/routes.dart';
import 'theming/colors.dart';

late String initialRoute;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ),
    ScreenUtil.ensureScreenSize(),
    preloadSVGs(['assets/svgs/google_logo.svg'])
  ]);

  FirebaseAuth.instance.authStateChanges().listen(
    (user) {
      if (user == null || !user.emailVerified) {
        initialRoute = Routes.loginScreen;
      } else {
        initialRoute = Routes.homeScreen;
      }
    },
  );

  runApp(MyApp(router: AppRouter()));
}

Future<void> preloadSVGs(List<String> paths) async {
  for (final path in paths) {
    final loader = SvgAssetLoader(path);
    await svg.cache.putIfAbsent(
      loader.cacheKey(null),
      () => loader.loadBytes(null),
    );
  }
}

class MyApp extends StatelessWidget {
  final AppRouter router;

  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          title: 'Login & Signup App',
          theme: ThemeData(
            useMaterial3: true,
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: ColorsManager.mainBlue,
              selectionColor: Color.fromARGB(188, 36, 124, 255),
              selectionHandleColor: ColorsManager.mainBlue,
            ),
          ),
          onGenerateRoute: router.generateRoute,
          debugShowCheckedModeBanner: false,
          initialRoute: initialRoute,
        );
      },
    );
  }
}
