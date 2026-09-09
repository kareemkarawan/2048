import 'package:_2048_game/screens/pip_screen.dart';
import 'package:_2048_game/screens/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart' as wm;
import 'package:window_manager_plus/window_manager_plus.dart' as wmp;

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  final windowId = args.isEmpty ? 0 : int.tryParse(args[0]) ?? 0;

  await wmp.WindowManagerPlus.ensureInitialized(windowId);

  if (windowId == 0) {
    await wm.windowManager.ensureInitialized();

    const windowOptions = wm.WindowOptions(maximumSize: Size(850, 600));

    wm.windowManager.waitUntilReadyToShow(windowOptions, () async {
      await wm.windowManager.show();
      await wm.windowManager.focus();
    });
  } else {
    final pipWindow = wmp.WindowManagerPlus.current;

    pipWindow.waitUntilReadyToShow(
      const wmp.WindowOptions(
        size: Size(400, 400),
        minimumSize: Size(300, 300),
        titleBarStyle: wmp.TitleBarStyle.hidden,
        windowButtonVisibility: false,
        alwaysOnTop: true,
      ),
      () async {
        await pipWindow.setAspectRatio(1.0);
        await pipWindow.show();
        await pipWindow.setAlwaysOnTop(true);
        await pipWindow.focus();

        print('PIP always on top: ${await pipWindow.isAlwaysOnTop()}');
      },
    );
  }

  runApp(MyApp(isPip: windowId != 0));
}

class MyApp extends StatelessWidget {
  final bool isPip;

  const MyApp({super.key, required this.isPip});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '2048',
      theme: ThemeData(useMaterial3: true),
      home: isPip ? const PipScreen() : const StartScreen(),
    );
  }
}
