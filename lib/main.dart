import 'package:Moody/constants.dart';
import 'package:Moody/screens/home_screen.dart';
import 'package:Moody/screens/login_screen.dart';
import 'package:Moody/screens/register_screen.dart';
import 'package:Moody/screens/splash_screen.dart';
import 'package:Moody/services/auth_service.dart';
import 'package:Moody/services/fcm_service.dart';
import 'package:Moody/services/feed_service.dart';
import 'package:Moody/services/notification_service.dart';
import 'package:Moody/services/post_service.dart';
import 'package:Moody/services/search_service.dart';
import 'package:Moody/services/user_service.dart';
import 'package:animations/animations.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
        ),
        ChangeNotifierProxyProvider<AuthService, NotificationService>(
          create: (BuildContext context) => NotificationService(),
          update: (BuildContext context, authService, notificationService) =>
              notificationService.update(authService),
        )
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics analytics = FirebaseAnalytics();
    IconThemeData iconThemeData = IconThemeData(color: kPrimaryColor);
    TextTheme textThemeData = GoogleFonts.interTextTheme();

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark),
    );

    return MaterialApp(
      initialRoute: SplashScreen.id,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: SharedAxisPageTransitionsBuilder(
              transitionType: SharedAxisTransitionType.horizontal,
            ),
            TargetPlatform.iOS: SharedAxisPageTransitionsBuilder(
              transitionType: SharedAxisTransitionType.horizontal,
            ),
          },
        ),
        accentColor: kPrimaryColor,
        iconTheme: iconThemeData,
        appBarTheme: AppBarTheme(
          color: Colors.white,
          brightness: Brightness.light,
          elevation: 1,
          textTheme: textThemeData,
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
