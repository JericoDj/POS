import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_storage/get_storage.dart';
import 'router/app_router.dart';
import 'providers/auth_provider.dart';
import 'providers/business_provider.dart';
import 'providers/category_provider.dart';
import 'providers/product_provider.dart';
import 'providers/sales_provider.dart';
import 'providers/subscription_provider.dart';
import 'providers/theme_provider.dart';
import 'constants/app_constants.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()..init()),
        ChangeNotifierProxyProvider<AuthProvider, BusinessProvider>(
          create: (_) => BusinessProvider(),
          update: (context, auth, business) => business!..update(auth.token),
        ),
        ChangeNotifierProxyProvider2<
          AuthProvider,
          BusinessProvider,
          CategoryProvider
        >(
          create: (_) => CategoryProvider(),
          update: (context, auth, business, category) =>
              category!..update(auth.token, business.currentBusiness?.id),
        ),
        ChangeNotifierProxyProvider2<
          AuthProvider,
          BusinessProvider,
          ProductProvider
        >(
          create: (_) => ProductProvider(),
          update: (context, auth, business, product) =>
              product!..update(auth, business.currentBusiness?.id),
        ),
        ChangeNotifierProxyProvider2<
          AuthProvider,
          BusinessProvider,
          SalesProvider
        >(
          create: (_) => SalesProvider(),
          update: (context, auth, business, sales) =>
              sales!..update(auth.token, business.currentBusiness?.id),
        ),
        ChangeNotifierProxyProvider2<
          AuthProvider,
          BusinessProvider,
          SubscriptionProvider
        >(
          create: (_) => SubscriptionProvider()..init(),
          update: (context, auth, business, subscription) =>
              subscription!..update(business, auth),
        ),
      ],
      child: const AppContent(),
    );
  }
}

class AppContent extends StatefulWidget {
  const AppContent({super.key});

  @override
  State<AppContent> createState() => _AppContentState();
}

class _AppContentState extends State<AppContent> {
  GoRouter? _router;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _router ??= createRouter(authProvider);

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp.router(
          title: AppConstants.appName,
          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,
          themeMode: themeProvider.isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,
          routerConfig: _router,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
