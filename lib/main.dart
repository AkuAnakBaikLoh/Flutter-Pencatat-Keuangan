import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pencatatan_keuangan/models/transaction_model.dart';
import 'package:pencatatan_keuangan/pages/main_page.dart';
import 'package:pencatatan_keuangan/pages/login_page.dart';
import 'package:pencatatan_keuangan/pages/register_page.dart';
import 'package:provider/provider.dart';
import 'package:pencatatan_keuangan/providers/transaction_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionModelAdapter());

  await Hive.openBox<TransactionModel>('transactions');
  await Hive.openBox('userBox');
  await Hive.openBox('authBox');

  final authBox = Hive.box('authBox');
  final isLoggedIn = authBox.get('isLoggedIn', defaultValue: false);

  runApp(
    ChangeNotifierProvider(
      create: (_) => TransactionProvider()..loadTransactions(),
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({required this.isLoggedIn, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: isLoggedIn ? '/main' : '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/main': (context) => MainPage(),
      },
    );
  }
}
