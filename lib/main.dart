import 'package:flutter/material.dart';
import 'package:ssc/src/view/introduction/introductionScreen.dart';
import 'package:ssc/src/view/main/mainScreen.dart';
import 'package:ssc/src/viewModel/home/homeProvider.dart';
import 'package:ssc/src/viewModel/main/mainProvider.dart';
import 'package:ssc/src/viewModel/shared/sharedProvider.dart';
import 'package:ssc/src/viewModel/utilities/language/globalAppProvider.dart';
import 'package:ssc/src/viewModel/utilities/theme/themeProvider.dart';
import 'package:ssc/utilities/constants.dart';
import 'package:ssc/utilities/language/appLocalizations.dart';

import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ssc/utilities/theme/appTheme.dart';

import 'infrastructure/userConfig.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  prefs.then((value){
    Widget screen = (value.getBool('seen') ?? false) ? const MainScreen() : const IntroductionScreen();
    value.setBool('seen', true);
    runApp(
      Phoenix(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeNotifier>(
              create: (BuildContext context) {
                String? theme = value.getString(Constants.APP_THEME);

                if (theme == "" || theme == Constants.SYSTEM_DEFAULT) {
                  value.setString(
                    Constants.APP_THEME, Constants.SYSTEM_DEFAULT
                  );
                  return ThemeNotifier(ThemeMode.system);
                }
                return ThemeNotifier(
                  theme == Constants.DARK ? ThemeMode.dark : ThemeMode.light
                );
              },
              lazy: false,
            ),
            ChangeNotifierProvider<GlobalAppProvider>(
              create: (BuildContext context) {
                Locale appLocale = const Locale('en');

                if (value.getString('language_code') == null) {
                  UserConfig.instance.language = "English";
                  value.setString('language_code', 'en');
                } else {
                  appLocale = Locale(value.getString('language_code')!);
                  UserConfig.instance.language =
                  value.getString('language_code') == "en"
                      ? "English"
                      : "عربي";
                }

                return GlobalAppProvider(appLocale);
              },
              lazy: false,
            )
          ],
          child: MyApp(screen: screen),
        ),
      ),
    );
  });
}

class MyApp extends StatefulWidget {
  final Widget screen;
  const MyApp({super.key, required this.screen});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainProvider(), lazy: true),
        ChangeNotifierProvider(create: (_) => SharedProvider(), lazy: true),
        ChangeNotifierProvider(create: (_) => HomeProvider(), lazy: true),
      ],
      child: Consumer<GlobalAppProvider>(builder: (context, model, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorObservers: [FlutterSmartDialog.observer],
            title: 'SSC',
            navigatorKey: navigatorKey,
            locale: model.appLocal,
            theme: AppTheme().lightTheme,
            darkTheme: AppTheme().darkTheme,
            themeMode: themeNotifier.getThemeMode(),
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('ar', 'JO'),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            home: widget.screen,
          );
        }
      ),
    );
  }
}
