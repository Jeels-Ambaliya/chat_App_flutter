import 'package:chatapp_flutter/helpers/helper_function_class.dart';
import 'package:chatapp_flutter/views/screens/LoginScreen.dart';
import 'package:chatapp_flutter/views/screens/entry_point_login_screen.dart';
import 'package:chatapp_flutter/views/screens/homeScreen.dart';
import 'package:chatapp_flutter/views/screens/search_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isSignedIn = false;

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    bool? value = await helperFunction.getUserLoggedIn();
    if (value != null) {
      isSignedIn = value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ),
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      initialRoute: (isSignedIn == true) ? '/' : 'entryLoginScreen',
      routes: {
        '/': (context) => HomeScreen(),
        'entryLoginScreen': (context) => EntryLoginScreen(),
        'loginScreen': (context) => LoginScreen(),
        'searchScreen': (context) => SearchScreen(),
      },
    );
  }
}
