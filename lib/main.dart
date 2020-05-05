import 'package:app/constants.dart';
import 'package:app/screens/create_post_screen.dart';
import 'package:app/screens/home_screen.dart';
import 'package:app/screens/login_screen.dart';
import 'package:app/screens/register_screen.dart';
import 'package:app/screens/splash_screen.dart';
import 'package:app/services/auth_service.dart';
import 'package:app/services/feed_service.dart';
import 'package:app/services/post_service.dart';
import 'package:app/services/user_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  Crashlytics.instance.enableInDevMode = true;

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runApp(
    MultiProvider(
      providers: [
        Provider.value(
          value: AuthService(),
        ),
        ChangeNotifierProxyProvider<AuthService, FeedService>(
          update: (context, authService, feedService) =>
              feedService.update(authService),
          create: (BuildContext context) => FeedService(),
        ),
        ChangeNotifierProxyProvider<AuthService, PostService>(
          update: (context, authService, postService) =>
              postService.update(authService),
          create: (BuildContext context) => PostService(),
        )
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics analytics = FirebaseAnalytics();
    IconThemeData iconThemeData = IconThemeData(color: kPrimaryColor);
    TextTheme textThemeData = GoogleFonts.poppinsTextTheme();

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return MaterialApp(
      initialRoute: SplashScreen.id,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        accentColor: kPrimaryColor,
        iconTheme: iconThemeData,
        appBarTheme: AppBarTheme(
          color: Colors.white,
          brightness: Brightness.dark,
          textTheme: textThemeData,
          elevation: 0,
          iconTheme: iconThemeData,
        ),
        textTheme: textThemeData,
      ),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        CreatePostScreen.id: (context) => CreatePostScreen(),
      },
    );
  }
}
