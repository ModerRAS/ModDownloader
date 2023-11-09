import 'dart:async';

import 'package:ModDownloader/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:system_theme/system_theme.dart';
import 'package:window_manager/window_manager.dart';
import 'ffi.dart' if (dart.library.html) 'ffi_web.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Page, Colors;
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;

const String appTitle = "Mod下载器";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemTheme.accentColor.load();
  await flutter_acrylic.Window.initialize();
  await flutter_acrylic.Window.hideWindowControls();
  await WindowManager.instance.ensureInitialized();
  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setTitleBarStyle(
      TitleBarStyle.hidden,
      windowButtonVisibility: false,
    );
    await windowManager.setMinimumSize(const Size(500, 600));
    await windowManager.show();
    await windowManager.setPreventClose(true);
    await windowManager.setSkipTaskbar(false);
  });

  runApp(const MyApp());
}

final _appTheme = AppTheme();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _appTheme,
      builder: (context, child) {
        final appTheme = context.watch<AppTheme>();
        return FluentApp.router(
          title: appTitle,
          themeMode: appTheme.mode,
          debugShowCheckedModeBanner: false,
          color: appTheme.color,
          darkTheme: FluentThemeData(
            brightness: Brightness.dark,
            accentColor: appTheme.color,
            visualDensity: VisualDensity.standard,
            focusTheme: FocusThemeData(
              glowFactor: is10footScreen(context) ? 2.0 : 0.0,
            ),
          ),
          theme: FluentThemeData(
            accentColor: appTheme.color,
            visualDensity: VisualDensity.standard,
            focusTheme: FocusThemeData(
              glowFactor: is10footScreen(context) ? 2.0 : 0.0,
            ),
          ),
          locale: appTheme.locale,
          builder: (context, child) {
            return Directionality(
              textDirection: appTheme.textDirection,
              child: NavigationPaneTheme(
                data: NavigationPaneThemeData(
                  backgroundColor: appTheme.windowEffect !=
                          flutter_acrylic.WindowEffect.disabled
                      ? Colors.transparent
                      : null,
                ),
                child: child!,
              ),
            );
          },
          routeInformationParser: router.routeInformationParser,
          routerDelegate: router.routerDelegate,
          routeInformationProvider: router.routeInformationProvider,
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

extension<L, R> on (FutureOr<L>, FutureOr<R>) {
  // A convenience method enabled by Dart 3, which will be useful later.
  Future<(L, R)> join() async {
    final fut =
        await Future.wait([Future.value(this.$1), Future.value(this.$2)]);
    return (fut[0] as L, fut[1] as R);
  }
}

class _MyHomePageState extends State<MyHomePage> {
  // These futures belong to the state and are only initialized once,
  // in the initState method.
  late Future<Platform> platform;
  late Future<bool> isRelease;
  late Future<String> test;
  late int topIndex;

  @override
  void initState() {
    super.initState();
    platform = api.platform();
    isRelease = api.rustReleaseMode();
    test = api.test();
    topIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    // Do not define the `items` inside the `Widget Build` function
// otherwise on running `setstate`, new item can not be added.

    List<NavigationPaneItem> items = [
      PaneItem(
        icon: const Icon(FluentIcons.home),
        title: const Text('Home'),
        body: const Text("text"),
      ),
      PaneItemSeparator(),
      PaneItem(
        icon: const Icon(FluentIcons.issue_tracking),
        title: const Text('Track orders'),
        infoBadge: const InfoBadge(source: Text('8')),
        body: const Text(
          'Badging is a non-intrusive and intuitive way to display '
          'notifications or bring focus to an area within an app - '
          'whether that be for notifications, indicating new content, '
          'or showing an alert. An InfoBadge is a small piece of UI '
          'that can be added into an app and customized to display a '
          'number, icon, or a simple dot.',
        ),
      ),
      PaneItem(
        icon: const Icon(FluentIcons.disable_updates),
        title: const Text('Disabled Item'),
        body: const Text("text"),
        enabled: false,
      ),
    ];

// Return the NavigationView from `Widegt Build` function
    return NavigationView(
      appBar: const NavigationAppBar(
        title: Text('NavigationView'),
      ),
      pane: NavigationPane(
        selected: topIndex,
        onChanged: (index) => setState(() => topIndex = index),
        displayMode: PaneDisplayMode.open,
        items: items,
        footerItems: [
          PaneItem(
            icon: const Icon(FluentIcons.settings),
            title: const Text('Settings'),
            body: const Text("text"),
          ),
          PaneItemAction(
            icon: const Icon(FluentIcons.add),
            title: const Text('Add New Item'),
            onTap: () {
              // Your Logic to Add New `NavigationPaneItem`
              items.add(
                PaneItem(
                  icon: const Icon(FluentIcons.new_folder),
                  title: const Text('New Item'),
                  body: const Center(
                    child: Text(
                      'This is a newly added Item',
                    ),
                  ),
                ),
              );
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
final router = GoRouter(navigatorKey: rootNavigatorKey, routes: [
  ShellRoute(
    navigatorKey: _shellNavigatorKey,
    builder: (context, state, child) {
      return MyHomePage(
        // shellContext: _shellNavigatorKey.currentContext,
        title: '',
        // child: child,
      );
    },
    routes: [
      /// Home
      GoRoute(path: '/', builder: (context, state) => const Text("a")),

      /// Settings
      GoRoute(path: '/settings', builder: (context, state) => const Text("b")),

      /// /// Input
      /// Buttons
      GoRoute(
        path: '/inputs/buttons',
        builder: (context, state) => const Text("data"),
      )
    ],
  ),
]);
