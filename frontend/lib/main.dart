import 'package:PARLACLINIC/core/providers/current_user_notifier.dart';
import 'package:PARLACLINIC/features/auth/view/login_page.dart';
import 'package:PARLACLINIC/features/home/view/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/theme.dart';
import 'services/api_service.dart';
import 'features/auth/viewmodel/auth_viewmodel.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest.dart' as tz; // Add timezone import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fa', null);
  tz.initializeTimeZones(); // Initialize timezone database
  final container = ProviderContainer();
  await container.read(authViewModelProvider.notifier).initSharedPreferences();
  await container.read(authViewModelProvider.notifier).getData();

  runApp(UncontrolledProviderScope(
      container: container,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: MyApp(),
      )));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentuser = ref.watch(currentUserNotifierProvider);
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      title: 'کلینیک پارلا',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.brightThemeMode,
      darkTheme: AppTheme.darkThemeMode,
      themeMode: themeMode,
      locale: const Locale('fa', 'IR'),
      supportedLocales: const [
        Locale('fa', 'IR'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        PersianMaterialLocalizations.delegate,
        PersianCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      navigatorKey: ref.watch(navigatorKeyProvider),
      home: currentuser != null ? Homepage() : const LoginPage(),
    );
  }
}
