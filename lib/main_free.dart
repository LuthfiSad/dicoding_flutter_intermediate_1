import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intermediate_flutter/flavor_config.dart';
import 'package:intermediate_flutter/localization/main.dart';
import 'package:intermediate_flutter/provider/auth_provider.dart';
import 'package:intermediate_flutter/provider/connectivity_provider.dart';
import 'package:intermediate_flutter/provider/localization_provider.dart';
import 'package:intermediate_flutter/provider/map_provider.dart';
import 'package:intermediate_flutter/provider/story_provider.dart';
import 'package:intermediate_flutter/routes/route_information_parser.dart';
import 'package:intermediate_flutter/routes/router_delegate.dart';
import 'package:timezone/data/latest.dart' as tz;

main() async {
  tz.initializeTimeZones();
  FlavorConfig(
    flavor: FlavorType.free,
    values: const FlavorValues(
      canAddLocation: false,
      titleApp: "Story App Free",
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => StoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocalizationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ConnectivityProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MapProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late MyRouteInformationParser myRouteInformationParser;
  late MyRouteDelegate _routeDelegate;

  @override
  void initState() {
    super.initState();
    _routeDelegate = MyRouteDelegate(
      authProvider: context.read<AuthProvider>(),
      localizationProvider: context.read<LocalizationProvider>(),
      connectivityProvider: context.read<ConnectivityProvider>(),
      storyProvider:
          context.read<StoryProvider>(), // Gunakan instance yang sama
      mapProvider: context.read<MapProvider>(),
    );

    myRouteInformationParser = MyRouteInformationParser();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: FlavorConfig.instance.values.titleApp,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E88E5),
          secondary: const Color(0xFF8D6E63), // Elegant brownish-tan
          secondaryContainer: const Color(0xFF5D4037), // Deep brown
          primary: const Color(0xFF9E9D24), // Olive yellow-green
          primaryContainer: const Color(0xFF827717), // Darker olive
          surface: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.black,
          error: Colors.red,
          onError: Colors.white,
        ),
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: context.watch<LocalizationProvider>().locale,
      home: Router(
        routerDelegate: _routeDelegate,
        routeInformationParser: myRouteInformationParser,
        backButtonDispatcher: RootBackButtonDispatcher(),
      ),
    );
  }
}
