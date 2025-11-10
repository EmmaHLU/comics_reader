import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_assistant/core/di/injection_container.dart';
import 'package:learning_assistant/core/localization/l10n/generated/app_localizations.dart';
import 'package:learning_assistant/core/localization/language_provider.dart';
import 'package:learning_assistant/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:learning_assistant/features/auth/presentation/pages/signin_page.dart';
import 'package:learning_assistant/features/comics/presentation/bloc/comic_bloc.dart';
import 'package:learning_assistant/features/comics/presentation/pages/comic_explore_page.dart';
import 'package:learning_assistant/features/comics/presentation/pages/comic_search_page.dart';
import 'package:learning_assistant/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:learning_assistant/features/profile/presentation/pages/profile_page.dart';
import 'package:learning_assistant/firebase_options.dart';
import 'package:learning_assistant/shared/theme/theme.dart';
import 'package:learning_assistant/shared/widgets/gradient_scaffold.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // initialize Firebase
  );
  await initDependencies();
  final languageProvider = LanguageProvider();
  await languageProvider.loadSaved();

  // Schedule periodic task every hour
  await Workmanager().registerPeriodicTask(
    "checkXKCDTask",
    "checkForNewComic",
    frequency: Duration(hours: 1),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LanguageProvider>.value(value: languageProvider),
        BlocProvider(create: (context) => sl<AuthBloc>()), 
        BlocProvider(create: (context) => sl<ProfileBloc>()),     
        BlocProvider(create: (context) => sl<ComicBloc>(),)  
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
      title: "Comic Reader",
      theme: mistPurpleTheme,
      home: const SignInPage(autolog: true),
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
  int _selectedIndex = 1;
  late final List<Widget> _pages;

  @override
  void initState(){
    super.initState();
    _pages = [
      // ExplorePage(),
      // Gemini(database: dbchat),
      ComicExplorePage(),
      ComicSearchPage(),
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
      body: IndexedStack(index:_selectedIndex, children: _pages,), // Show selected tab page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateToTab,
        selectedItemColor: Colors.deepPurple,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold, 
          fontSize: 14,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold, 
          fontSize: 12,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: tr.explore,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded),
            label: tr.search,
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
