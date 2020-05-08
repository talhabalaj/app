import 'package:Moody/constants.dart';
import 'package:Moody/screens/home_screen.dart';
import 'package:Moody/screens/login_screen.dart';
import 'package:Moody/screens/register_screen.dart';
import 'package:Moody/screens/splash_screen.dart';
import 'package:Moody/services/auth_service.dart';
import 'package:Moody/services/feed_service.dart';
import 'package:Moody/services/post_service.dart';
import 'package:Moody/services/search_service.dart';
import 'package:Moody/services/user_service.dart';
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
        ChangeNotifierProvider(
          create: (context) => AuthService(),
        ),
        ChangeNotifierProxyProvider<AuthService, FeedService>(
          create: (BuildContext context) => FeedService(),
          update: (BuildContext context, authService, feedService) =>
              feedService.update(authService),
        ),
        ChangeNotifierProxyProvider<AuthService, PostService>(
          create: (BuildContext context) => PostService(),
          update: (BuildContext context, authService, postService) =>
              postService.update(authService),
        ),
        ChangeNotifierProxyProvider<AuthService, SearchService>(
          create: (BuildContext context) => SearchService(),
          update: (BuildContext context, authService, searchService) =>
              searchService.update(authService),
        ),
        ChangeNotifierProxyProvider<AuthService, UserService>(
          create: (BuildContext context) => UserService(),
          update: (BuildContext context, authService, userService) =>
              userService.update(authService),
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
    TextTheme textThemeData = GoogleFonts.montserratTextTheme();

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark),
    );

    return MaterialApp(
      initialRoute: SplashScreen.id,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        accentColor: kPrimaryColor,
        iconTheme: iconThemeData,
        appBarTheme: AppBarTheme(
          color: Colors.white,
          brightness: Brightness.light,
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
      },
    );
  }
}
