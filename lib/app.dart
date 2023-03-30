// ignore_for_file: no_default_cases, library_private_types_in_public_api

/*
Note: app.dart is split into two parts App and AppView.
App is responsible for creating/providing the AuthenticationBloc
which will be consumed by the AppView. This decoupling will enable us
to easily test both the App and AppView widgets later on.

Note: RepositoryProvider is used to provide the single instance of
AuthenticationRepository to the entire application
which will come in handy later on.

AppView is a StatefulWidget because it maintains a GlobalKey
which is used to access the NavigatorState. By default,
AppView will render the SplashPage (which we will see later)
and it uses BlocListener to navigate to different pages based on changes
in the AuthenticationState. */

import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:winplan/authentication/authentication.dart';
import 'package:winplan/home/home.dart';
import 'package:winplan/login/login.dart';
import 'package:winplan/shared/constants.dart';
import 'package:winplan/splash/splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ngi_repository/ngi_repository.dart';

import 'main.dart';

GlobalKey globalKey = GlobalKey();

class App extends StatelessWidget {
  const App({
    Key? key,
    required this.authenticationRepository,
  }) : super(key: key);

  final AuthenticationRepository authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
        ),
        child: const AppView(),
      ),
    );
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class AppView extends StatefulWidget {
  final String? message;
  const AppView({
    Key? key,
    this.message,
  }) : super(key: key);

  @override
  _AppViewState createState() => _AppViewState(); 
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;
  @override
  void initState() {
    super.initState();
    setupInteractedMessage();

    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage? message) async {
        RemoteNotification? notification = message?.notification!;

        print(notification != null ? notification.title : '');
      });
    }

    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      FirebaseMessaging.onMessage.listen((message) async {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        if (notification != null && android != null && !kIsWeb) {
          String action = jsonEncode(message.data['route_id']);

          flutterLocalNotificationsPlugin!.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel!.id,
                  channel!.name,
                  //priority:  Priority.high,
                  importance: Importance.max,
                  setAsGroupSummary: true,
                  styleInformation: DefaultStyleInformation(true, true),
                  largeIcon:
                      DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
                  channelShowBadge: true,
                  autoCancel: true,
                  icon: '@mipmap/ic_launcher',
                ),
              ),
              payload: action);
        }
        print('A new event was published!');
      });
    }

    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      FirebaseMessaging.onMessageOpenedApp
          .listen((message) => _handleMessage(message.data));
    }
  }

  Future<dynamic> onSelectNotification(payload) async {
    Map<String, dynamic> action = jsonDecode(payload);
    _handleMessage(action);
  }

  Future<void> setupInteractedMessage() async {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      await FirebaseMessaging.instance
          .getInitialMessage()
          .then((value) => _handleMessage(value != null ? value.data : Map()));
    }
  }

  void _handleMessage(Map<String, dynamic> data) {
    if (data['redirect'] == "product") {
      /* Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(message: data['message'])));
    } */
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: ColorThemeMatch.m3_01));
    return MaterialApp(
      title: 'WinPlan',
      scrollBehavior: AppScrollBehavior(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          primaryColor: Color.fromARGB(255, 55, 95, 155),
          primaryColorLight: Color.fromARGB(255, 175, 202, 243),
          primaryColorDark: Color.fromARGB(255, 0, 52, 155),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Color.fromARGB(255, 55, 95, 155),
            onPrimary: Color.fromARGB(255, 213, 235, 255),
            primaryContainer: Color.fromARGB(255, 0, 52, 155),
            secondary: Color.fromARGB(255, 170, 214, 255),
            onSecondary: Color.fromARGB(255, 0, 116, 224),
            secondaryContainer: Color.fromARGB(255, 215, 0, 30),
            onSecondaryContainer: Color.fromARGB(255, 165, 213, 255),
            tertiary: Color.fromARGB(255, 0, 116, 224),
            onTertiary: Color.fromARGB(255, 213, 235, 255),
            tertiaryContainer: Color.fromARGB(255, 114, 234, 255),
            onTertiaryContainer: Color.fromARGB(255, 134, 0, 0),
            surface: Color.fromARGB(255, 255, 255, 255),
            onSurface: Color.fromARGB(255, 181, 205, 252),
            background: Color.fromARGB(255, 244, 241, 255),
            onBackground: Color.fromARGB(255, 0, 52, 155),
            error: Color.fromARGB(255, 255, 0, 0),
            onError: Color.fromARGB(255, 244, 241, 255),
            surfaceVariant: Color.fromARGB(117, 255, 255, 255),
            onSurfaceVariant: Color.fromARGB(255, 181, 205, 252),
            brightness: Brightness.light,
          ),
          textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
          scrollbarTheme: ScrollbarThemeData().copyWith(
            thumbColor: MaterialStateProperty.all(Colors.teal),
            thickness: MaterialStateProperty.all(5),
          )),
      navigatorKey: _navigatorKey,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      builder: (context, child) {
        /*  Widget error = const Text('...rendering error...');
        if (widget is Scaffold || widget is Navigator) {
          error = Scaffold(body: Center(child: error));
        }
        ErrorWidget.builder = (errorDetails) => error; */
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                _navigator.pushAndRemoveUntil<void>(
                  HomePage.route(),
                  (route) => false,
                );
                break;
              case AuthenticationStatus.unauthenticated:
                _navigator.pushAndRemoveUntil<void>(
                  LoginPage.route(),
                  (route) => false,
                );
                break;
              default:
                SizedBox();
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
