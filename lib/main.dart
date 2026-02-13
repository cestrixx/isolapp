import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/widget_previews.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isolapp/models/budget_model.dart';
import 'package:isolapp/models/item_model.dart';
import 'package:isolapp/models/part_model.dart';
import 'package:isolapp/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter(); 
  Hive.registerAdapter(VariableTypeAdapter());
  Hive.registerAdapter(PartTypeAdapter());
  Hive.registerAdapter(BudgetModelAdapter());
  Hive.registerAdapter(ItemModelAdapter());
  Hive.registerAdapter(PartModelAdapter());

  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  runApp(
    ProviderScope(
      child: App(
        savedThemeMode: savedThemeMode
      )
    )
  );
}

@Preview(
  name: 'App'
)

Widget previewApp() {
  return ProviderScope(
    child: App(),
  );
}

class App extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const App({super.key, this.savedThemeMode});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.blue,
      ),
      dark: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      // overrideMode: AdaptiveThemeMode.dark,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'Tecnit',
        theme: theme,
        darkTheme: darkTheme,
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
      ),
      debugShowFloatingThemeButton: false,
    );
  }
}
