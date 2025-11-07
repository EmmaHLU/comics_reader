import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:learning_assistant/core/di/injection_container.dart';
import 'package:learning_assistant/core/localization/l10n/generated/app_localizations.dart';
import 'package:learning_assistant/core/localization/language_provider.dart';
import 'package:learning_assistant/features/auth/presentation/pages/signin_page.dart';
import 'package:learning_assistant/features/profile/presentation/pages/profile_page.dart';
import 'package:learning_assistant/firebase_options.dart';
import 'package:learning_assistant/shared/widgets/gradient_scaffold.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // initialize Firebase
  );
  await initDependencies();
  final languageProvider = LanguageProvider();
  await languageProvider.loadSaved();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LanguageProvider>.value(value: languageProvider),
      ],
      child: MyApp(),
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LanguageProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: provider.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SignInPage(autolog: true),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

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

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 1;
  late final List<Widget> _pages;

  @override
  void initState(){
    super.initState();
    _pages = [
      // ExplorePage(),
      // Gemini(database: dbchat),
      ProfilePage(),
      ProfilePage(),
    ];

  }

  void _navigateToTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    return GradientScaffold(
      body: _pages[_selectedIndex], // Show selected tab page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateToTab,
        selectedItemColor: Colors.deepPurple,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold, // 加粗
          fontSize: 14,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold, // 不加粗
          fontSize: 12,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: tr.profile,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: tr.profile,
          ),
        ],
      ),
    );
  }
}
