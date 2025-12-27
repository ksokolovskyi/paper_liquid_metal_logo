import 'package:flutter/material.dart';
import 'package:paper_liquid_metal_logo/control_panel.dart';
import 'package:paper_liquid_metal_logo/liquid_metal_logo.dart';
import 'package:paper_liquid_metal_logo/liquid_metal_logo_state.dart';
import 'package:paper_liquid_metal_logo/liquid_metal_shader_controller.dart';
import 'package:paper_liquid_metal_logo/logo_selector.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LiquidMetalLogoState(),
          lazy: false,
        ),
        Provider(
          create: (_) => LiquidMetalShaderController.withDefaults(
            vsync: this,
          )..start(),
          dispose: (_, controller) => controller.dispose(),
          lazy: false,
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.black,
          body: Screen(),
        ),
      ),
    );
  }
}

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> with SingleTickerProviderStateMixin {
  final GlobalKey<State<StatefulWidget>> _logoKey = GlobalKey();
  final GlobalKey<State<StatefulWidget>> _panelKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final logo = KeyedSubtree(
      key: _logoKey,
      child: const LiquidMetalLogo(),
    );
    final panel = KeyedSubtree(
      key: _panelKey,
      child: const ControlPanel(),
    );

    return SingleChildScrollView(
      child: Builder(
        builder: (context) {
          final windowSize = MediaQuery.sizeOf(context);
          final isRowLayout = windowSize.width >= 1200;

          return ConstrainedBox(
            constraints: BoxConstraints(minHeight: windowSize.height),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 72,
                  width: double.infinity,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: isRowLayout
                        ? Row(
                            spacing: 32,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [logo, panel],
                          )
                        : Column(
                            spacing: 24,
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [logo, panel],
                          ),
                  ),
                ),
                const LogoSelector(),
              ],
            ),
          );
        },
      ),
    );
  }
}
