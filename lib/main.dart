import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:bestlocaleats/pages/homepage.dart';
import 'package:bestlocaleats/pages/login.dart';
import 'package:bestlocaleats/pages/signup.dart';
import 'package:bestlocaleats/pages/forgot.dart';
import 'package:bestlocaleats/pages/otp.dart';
import 'package:bestlocaleats/pages/reset.dart';
import 'package:bestlocaleats/pages/allrestaurantpage.dart';
import 'package:bestlocaleats/pages/about.dart';
import 'package:bestlocaleats/pages/search.dart';
import 'package:bestlocaleats/pages/favorite.dart';
import 'package:bestlocaleats/pages/notification.dart';
import 'package:bestlocaleats/pages/contact.dart';
import 'package:bestlocaleats/pages/profile.dart';
import 'package:bestlocaleats/pages/subscription.dart';
import 'package:bestlocaleats/pages/error.dart';

import 'package:bestlocaleats/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setPathUrlStrategy();
  runApp(const MyApp());
}

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'login',
          builder: (BuildContext context, GoRouterState state) {
            return const LoginPage();
          },
        ),
        GoRoute(
          path: 'signup',
          builder: (BuildContext context, GoRouterState state) {
            return const SignupPage();
          },
        ),
        GoRoute(
          path: 'forgot',
          builder: (BuildContext context, GoRouterState state) {
            return const ForgotPage();
          },
        ),
        GoRoute(
          path: 'otp',
          builder: (BuildContext context, GoRouterState state) {
            return const OTPPage();
          },
        ),
        GoRoute(
          path: 'reset',
          builder: (BuildContext context, GoRouterState state) {
            return const ResetPage();
          },
        ),
        GoRoute(
          path: 'all',
          builder: (BuildContext context, GoRouterState state) {
            return const AllRestaurantPage();
          },
        ),
        GoRoute(
          path: 'about',
          builder: (BuildContext context, GoRouterState state) {
            return const AboutPage();
          },
        ),
        GoRoute(
          path: 'search',
          builder: (BuildContext context, GoRouterState state) {
            return const SearchPage();
          },
        ),
        GoRoute(
          path: 'favorite',
          builder: (BuildContext context, GoRouterState state) {
            return const FavoritePage();
          },
        ),
        GoRoute(
          path: 'notification',
          builder: (BuildContext context, GoRouterState state) {
            return const NotificationPage();
          },
        ),
        GoRoute(
          path: 'contact',
          builder: (BuildContext context, GoRouterState state) {
            return const ContactPage();
          },
        ),
        GoRoute(
          path: 'subscription',
          builder: (BuildContext context, GoRouterState state) {
            return const SubscriptionPage();
          },
        ),
        GoRoute(
          path: 'profile',
          builder: (BuildContext context, GoRouterState state) {
            return const ProfilePage();
          },
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => const ErrorPage(),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Bestlocaleats',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: const InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(color: Colors.white)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(color: CustomColor.primaryColor)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(color: CustomColor.activeColor)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(color: CustomColor.activeColor)),
            filled: true,
            fillColor: Colors.white),
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
