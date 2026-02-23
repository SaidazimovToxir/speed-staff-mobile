// class FCMService {
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  // final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  // Future<void> initialize() async {
  //   // Request permission for iOS devices
  //   await _firebaseMessaging.requestPermission(
  //     alert: true,
  //     announcement: false,
  //     badge: true,
  //     carPlay: false,
  //     criticalAlert: false,
  //     provisional: false,
  //     sound: true,
  //   );

  //   // Initialize local notifications
  //   const initializationSettingsAndroid =
  //       AndroidInitializationSettings('@mipmap/ic_launcher');
  //   const initializationSettingsIOS = DarwinInitializationSettings(
  //     requestAlertPermission: true,
  //     requestBadgePermission: true,
  //     requestSoundPermission: true,
  //   );
  //   const initializationSettings = InitializationSettings(
  //     android: initializationSettingsAndroid,
  //     iOS: initializationSettingsIOS,
  //   );

  //   await _flutterLocalNotificationsPlugin.initialize(
  //     initializationSettings,
  //     onDidReceiveNotificationResponse: (details) {
  //       final payload = details.payload;
  //       if (payload != null) {
  //         final movieId = int.tryParse(payload);
  //         if (movieId != null) {
  //           _navigateToMovieDetails(movieId);
  //         }
  //       }
  //     },
  //   );

  //   // Handle background messages
  //   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  //   // Handle foreground messages
  //   FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

  //   // Handle when app is opened from terminated state
  //   FirebaseMessaging.instance.getInitialMessage().then((message) {
  //     if (message != null) {
  //       _handleMessage(message);
  //     }
  //   });

  //   // Handle when app is in background but opened
  //   FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  // }

  // Future<String?> getFCMToken() async {
  //   try {
  //     return await _firebaseMessaging.getToken();
  //   } catch (e) {
  //     throw 'fcm_token_error'.tr();
  //   }
  // }

  // void _handleForegroundMessage(RemoteMessage message) async {
  //   RemoteNotification? notification = message.notification;
  //   AndroidNotification? android = message.notification?.android;

  //   if (notification != null && android != null) {
  //     final movieId = message.data['movieId'];

  //     await _flutterLocalNotificationsPlugin.show(
  //       notification.hashCode,
  //       notification.title,
  //       notification.body,
  //       NotificationDetails(
  //         android: AndroidNotificationDetails(
  //           'high_importance_channel',
  //           'High Importance Notifications',
  //           channelDescription:
  //               'This channel is used for important notifications.',
  //           importance: Importance.max,
  //           priority: Priority.high,
  //           icon: '@mipmap/ic_launcher',
  //         ),
  //         iOS: const DarwinNotificationDetails(
  //           presentAlert: true,
  //           presentBadge: true,
  //           presentSound: true,
  //         ),
  //       ),
  //       payload: movieId,
  //     );
  //   }
  // }

  // void _handleMessage(RemoteMessage message) {
  //   if (message.data.isNotEmpty) {
  //     final movieId = int.tryParse(message.data['movieId'] ?? '');
  //     if (movieId != null) {
  //       _navigateToMovieDetails(movieId);
  //     }
  //   }
  // }

  // void _navigateToMovieDetails(int movieId) {
  //   // TODO: Implement navigation to movie details
  //   // AppKeys.rootNavigatorKey.currentState?.push(
  //   // MaterialPageRoute(
  //   //   builder: (context) => MovieDetailsPage(id: movieId),
  //   // ),
  //   // );
  // }
// }

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // Handle background messages
// }
