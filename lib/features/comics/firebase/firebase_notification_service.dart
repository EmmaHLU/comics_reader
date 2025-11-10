import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:learning_assistant/features/comics/presentation/bloc/comic_bloc.dart';
import 'package:learning_assistant/features/comics/presentation/bloc/comic_event.dart';

class FcmService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final ComicBloc comicBloc;

  FcmService({required this.comicBloc});

  Future<void> init() async {
    // Request permission for iOS
    await _messaging.requestPermission();

    // Subscribe to topic
    await _messaging.subscribeToTopic('xkcd_notifications');

    // Handle messages
    FirebaseMessaging.onMessage.listen((message) {
      final title = message.notification?.title ?? '';
      final body = message.notification?.body ?? '';
      // Dispatch an event to BLoC
      comicBloc.add(NewComicNotificationReceived(message: "$title -- $body"));
    });
  }
}
