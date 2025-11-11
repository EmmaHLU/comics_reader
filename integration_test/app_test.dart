import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:integration_test/integration_test.dart';
import 'package:learning_assistant/features/comics/presentation/pages/comic_search_page.dart';
import 'package:learning_assistant/main.dart' as app;
final sl = GetIt.instance; // Get the singleton instance
void main() {

  setUp(() {
    // This removes all previously registered singletons, allowing them to be registered again.
    sl.reset(); 
  });
  // Initialize the Integration Test Widgets Binding
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Comic Search End-to-End Tests', () {

    // --- Test 1: Initial Launch and UI Verification ---
    testWidgets('Verify ComicSearchPage loads and has necessary elements', (WidgetTester tester) async {
      
      // ARRANGE: Launch the application
      app.main(); 
      
      // ACT: Wait for the application to settle
      await tester.pumpAndSettle();

      // ASSERT: Verify the application lands on the ComicSearchPage
      expect(find.byType(ComicSearchPage), findsOneWidget);
      
      // ASSER: Check for key UI elements expected on a search page
      // Find the main input field (assuming it's a TextField)
      expect(find.byType(TextField), findsOneWidget, reason: 'Should find the search input field.');

      // Find the search icon/button (assuming a common search icon is used)
      expect(find.byIcon(Icons.search), findsOneWidget, reason: 'Should find the search button/icon.');

    });

    // --- Test 2: Successful Search and Result Display ---
    // testWidgets('Perform a search and verify the result is displayed', (WidgetTester tester) async {
      
    //   // ARRANGE: Launch the application
    //   app.main(); 
    //   await tester.pumpAndSettle();

    //   const testQuery = '100'; //text api doesn't work for the moment

    //   //Enter text into the search field
    //   await tester.enterText(find.byType(TextField).first, testQuery);
    //   await tester.pump(); // Pump to register the text change

    //   // This sends the "Done" action, which typically triggers a search/submit.
    //   await tester.testTextInput.receiveAction(TextInputAction.done);
            
    //   //  Wait for the API call to complete and the UI to update.
    //   await tester.pumpAndSettle(const Duration(seconds: 5)); 
      
    //   // ASSERT: Verify a search result appears.
    //   expect(find.byType(ListTile), findsWidgets, reason: 'Should find at least one ListTile/widget showing the comic result.');
      
    // });
  });
}