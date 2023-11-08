import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:unifind/screens/user_profile_screen.dart';
import 'package:unifind/screens/user_info_screen.dart'; // Asegúrate de que la ruta del archivo es correcta
import 'firebase_options.dart';
import 'views/register/register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      routes: {
        '/': (context) => const MyHomePage(title: 'Flutter Demo Home Page'),
        '/register': (context) => const RegisterPage(),
        '/userProfile': (context) => UserProfileScreen(),
        '/userInfo': (context) => const UserInfoScreen(), 
      },
      initialRoute: '/',
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const RegisterPage();
  }
}
