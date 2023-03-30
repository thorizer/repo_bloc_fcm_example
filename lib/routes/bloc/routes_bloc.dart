// ignore_for_file: lines_longer_than_80_chars, avoid_print
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:hive/hive.dart';
import 'package:ngi_repository/ngi_repository.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tuple/tuple.dart';
import 'package:winplan/main.dart';
part 'routes_event.dart';
part 'routes_state.dart';

class RouteBloc extends Bloc<RouteEvent, RouteState> {
  RouteBloc({
    required RouteRepository routeRepository,
  })  : _routeRepository = routeRepository,
        super(const RouteState()) {
    on<SetLanguage>(_onSetLanguage);
    on<SendSMS>(_onSendSMS);
    on<FirebaseSubscriptionRequested>(
      _onFirebaseSubscriptionRequested,
    );
    on<AssetMapNavigateToAsset>(_onAssetMapNavigateToAsset);
    on<AssetMapFollowAsset>(_onAssetMapFollowAsset);
    on<AssetMapSelectAsset>(_onAssetMapSelectAsset);
    on<AssetMapUnselectAsset>(_onAssetMapUnselectAsset);
    on<AssetMapResetZoom>(_onAssetMapResetZoom);
    on<AssetMapFitBounds>(_onAssetMapFitBounds);
    on<DisposeDataStatus>(_onDisposeDataStatus);
    on<RouteLoaded>(_onRouteLoaded);
    on<changeDestinationType>(_onChangeDestinationType);
    on<changeTaskTabValue>(_onchangeTaskTabValue);
    on<ExcuteDestinationAction>(_onExcuteDestinationAction);
    on<SetDriverId>(_onSetDriverId);
    on<SetDriverPos>(_onSetDriverPos);
  }
  final RouteRepository _routeRepository;

  void _onAssetMapResetZoom(
    AssetMapResetZoom event,
    Emitter<RouteState> emit,
  ) async {
    MapControllerState? mapC = state.mapControllerState;
    final dateNowSting = DateTime.now().toIso8601String();
    mapC = MapControllerState(
        id: dateNowSting,
        mapEvent: MapAssetEvent.resetZoom,
        assetID: null,
        location: null);
    emit(state.copyWith(mapControllerState: mapC));
  }

  void _onAssetMapFitBounds(
    AssetMapFitBounds event,
    Emitter<RouteState> emit,
  ) async {
    MapControllerState? mapC = state.mapControllerState;
    final dateNowSting = DateTime.now().toIso8601String();
    mapC = MapControllerState(
        id: dateNowSting,
        mapEvent: MapAssetEvent.fitBounds,
        assetID: null,
        location: null);
    emit(state.copyWith(mapControllerState: mapC));
  }

  Future<void> _onRouteLoaded(
    RouteLoaded event,
    Emitter<RouteState> emit,
  ) async {
    if (state.dataStatus != DataStatus.initial &&
        state.dataStatus != DataStatus.success &&
        state.isMainRoute == true) {
      emit(state.copyWith(dataStatus: DataStatus.retry));
    }

    print('route loaded');
    print(event.daySelected);
    Tuple2<RouteData, int>? routeTupple;

    final todayDate = DateTime.now().day.toString().padLeft(2, '0') +
        DateTime.now().month.toString().padLeft(2, '0') +
        DateTime.now().year.toString().padLeft(4, '0');
    final selectedDate =
        event.daySelected == 'today' ? todayDate : event.daySelected;
    if (event.daySelected != todayDate ||
        state.dataStatus != DataStatus.success) {
      emit(state.copyWith(temp_dataStatus: DataStatus.initial));
    }
    routeTupple = await _routeRepository.getAllDriverRoutesQueryByDate(
        date: selectedDate, driverId: event.driverId);
    final route = routeTupple != null
        ? routeTupple.item1
        : RouteData(id: '', route_id: '0', destinations: []);
    final routeStatusCode = routeTupple != null ? routeTupple.item2 : 200;
    late DataStatus newStatus;
    if (routeStatusCode == 200) {
      newStatus = DataStatus.success;
    } else if (routeStatusCode == 401) {
      newStatus = DataStatus.retry;
    } else {
      newStatus = DataStatus.failure;
    }
    print('route loaded $newStatus');

    final pathtolatlng = route.path
        .map((path) => path
            .map((coordinates) => coordinates
                .map((coordinates) => coordinates.toDouble())
                .toList())
            .map((e) => LatLng(e[0], e[1]))
            .toList())
        .toList();
    print(route.destinations);
    if (event.daySelected == 'today' || event.daySelected == todayDate)
      emit(state.copyWith(
          id: route.id,
          dataStatus: newStatus,
          distance: route.distance,
          duration: route.duration,
          route_id: route.route_id,
          status: route.status,
          startLocation: route.startLocation,
          selectedDateCalendar: event.date,
          //list of List<List<List<double>>> to List<List<LatLng>>
          path: pathtolatlng,
          destinations: route.destinations,
          completedDestinations: route.destinations
              .where((destination) =>
                  destination.status == DestinationStatus.failed ||
                  destination.status == DestinationStatus.success)
              .toList(),
          cancelledDestinations: route.destinations
              .where((destination) =>
                  destination.status == DestinationStatus.postponed ||
                  destination.status == DestinationStatus.rejected)
              .toList(),
          plannedDestinations: route.destinations
              .where((destination) =>
                  destination.status == DestinationStatus.planned ||
                  destination.status == DestinationStatus.upcoming ||
                  destination.status == DestinationStatus.inProgress)
              .toList(),
          history: route.history,
          isMainRoute: true));
    else
      emit(state.copyWith(
          temp_id: route.id,
          temp_dataStatus: newStatus,
          temp_distance: route.distance,
          temp_duration: route.duration,
          temp_route_id: route.route_id,
          temp_status: route.status,
          selectedDateCalendar: event.date,
          temp_startLocation: route.startLocation,
          temp_path: pathtolatlng,
          temp_destinations: route.destinations,
          temp_completedDestinations: route.destinations
              .where((destination) =>
                  destination.status == DestinationStatus.failed ||
                  destination.status == DestinationStatus.success)
              .toList(),
          temp_cancelledDestinations: route.destinations
              .where((destination) =>
                  destination.status == DestinationStatus.postponed ||
                  destination.status == DestinationStatus.rejected)
              .toList(),
          temp_plannedDestinations: route.destinations
              .where((destination) =>
                  destination.status == DestinationStatus.planned ||
                  destination.status == DestinationStatus.upcoming ||
                  destination.status == DestinationStatus.inProgress)
              .toList(),
          temp_history: route.history,
          isMainRoute: false));
  }

  Future<void> _onChangeDestinationType(
    changeDestinationType event,
    Emitter<RouteState> emit,
  ) async {
    emit(state.copyWith(
      destinationType: event.destinationType,
    ));
  }

  //_onchangeTaskTabValue
  Future<void> _onchangeTaskTabValue(
    changeTaskTabValue event,
    Emitter<RouteState> emit,
  ) async {
    emit(state.copyWith(
      taskTabValue: event.taskTabValue,
    ));
  }

  Future<void> _onExcuteDestinationAction(
    ExcuteDestinationAction event,
    Emitter<RouteState> emit,
  ) async {
    final isDestinationFirst = state.destinations.every((dest) =>
        dest.status == DestinationStatus.planned ||
        dest.status == DestinationStatus.upcoming);
    final driverP = state.driver_pos ?? '0_0';
    print('driverP ' + driverP);
    final startActionLocation =
        driverP.split('_').map((e) => double.parse(e)).toList();

    if (event.destinationAction == DestinationAction.start) {
      late Tuple2<RouteData, int> routeTupple;
      if (isDestinationFirst) {
        routeTupple = await _routeRepository.getRouteAfterAction(
            routeId: state.id ?? '',
            destinationId: event.destinationId,
            action: event.destinationAction.name,
            startLocation: startActionLocation);
      } else {
        routeTupple = await _routeRepository.getRouteAfterAction(
            routeId: state.id ?? '',
            destinationId: event.destinationId,
            action: event.destinationAction.name);
      }
      if (routeTupple.item2 == 200) {
        final route = routeTupple.item1;
        final pathtolatlng = route.path
            .map((path) => path
                .map((coordinates) => coordinates
                    .map((coordinates) => coordinates.toDouble())
                    .toList())
                .map((e) => LatLng(e[0], e[1]))
                .toList())
            .toList();
        emit(state.copyWith(
            path: pathtolatlng,
            startLocation: route.startLocation,
            destinations: route.destinations,
            lastAction: DateTime.now().toString() + '_start',
            history: route.history));
      }
    } else if (event.destinationAction == DestinationAction.accomplish) {
      {
        final routeTupple = await _routeRepository.getRouteAfterAction(
            routeId: state.id ?? '',
            destinationId: event.destinationId,
            action: event.destinationAction.name,
            isAck: [true, true, true, true],
            ackData: ['commentaire', 'photo', 'sign', 'code']);

        if (routeTupple.item2 == 200) {
          final route = routeTupple.item1;
          final pathtolatlng = route.path
              .map((path) => path
                  .map((coordinates) => coordinates
                      .map((coordinates) => coordinates.toDouble())
                      .toList())
                  .map((e) => LatLng(e[0], e[1]))
                  .toList())
              .toList();
          emit(state.copyWith(
              status: route.status,
              path: pathtolatlng,
              destinations: route.destinations,
              lastAction: DateTime.now().toString() + '_accomplish',
              history: route.history));
        }
      }
    } else if (event.destinationAction == DestinationAction.fail) {
      final routeTupple = await _routeRepository.getRouteAfterAction(
        routeId: state.id ?? '',
        destinationId: event.destinationId,
        action: event.destinationAction.name,
      );
      if (routeTupple.item2 == 200) {
        final route = routeTupple.item1;
        final pathtolatlng = route.path
            .map((path) => path
                .map((coordinates) => coordinates
                    .map((coordinates) => coordinates.toDouble())
                    .toList())
                .map((e) => LatLng(e[0], e[1]))
                .toList())
            .toList();
        emit(state.copyWith(
            status: route.status,
            path: pathtolatlng,
            destinations: route.destinations,
            lastAction: DateTime.now().toString() + '_fail',
            history: route.history));
      }
    } else if (event.destinationAction == DestinationAction.postpone) {
      late Tuple2<RouteData, int> routeTupple;
      if (isDestinationFirst)
        routeTupple = await _routeRepository.getRouteAfterAction(
          routeId: state.id ?? '',
          destinationId: event.destinationId,
          action: event.destinationAction.name,
          startLocation: startActionLocation,
        );
      else
        routeTupple = await _routeRepository.getRouteAfterAction(
          routeId: state.id ?? '',
          destinationId: event.destinationId,
          action: event.destinationAction.name,
        );

      if (routeTupple.item2 == 200) {
        final route = routeTupple.item1;
        final pathtolatlng = route.path
            .map((path) => path
                .map((coordinates) => coordinates
                    .map((coordinates) => coordinates.toDouble())
                    .toList())
                .map((e) => LatLng(e[0], e[1]))
                .toList())
            .toList();
        emit(state.copyWith(
          path: pathtolatlng,
          destinations: route.destinations,
          lastAction: DateTime.now().toString() + '_postpone',
          history: route.history,
          startLocation: route.startLocation,
        ));
      }
    } else if (event.destinationAction == DestinationAction.reject) {
      late Tuple2<RouteData, int> routeTupple;
      if (isDestinationFirst)
        routeTupple = await _routeRepository.getRouteAfterAction(
          routeId: state.id ?? '',
          destinationId: event.destinationId,
          action: event.destinationAction.name,
          startLocation: startActionLocation,
        );
      else
        routeTupple = await _routeRepository.getRouteAfterAction(
          routeId: state.id ?? '',
          destinationId: event.destinationId,
          action: event.destinationAction.name,
        );
      if (routeTupple.item2 == 200) {
        final route = routeTupple.item1;
        final pathtolatlng = route.path
            .map((path) => path
                .map((coordinates) => coordinates
                    .map((coordinates) => coordinates.toDouble())
                    .toList())
                .map((e) => LatLng(e[0], e[1]))
                .toList())
            .toList();
        emit(state.copyWith(
          path: pathtolatlng,
          destinations: route.destinations,
          lastAction: DateTime.now().toString() + '_reject',
          history: route.history,
          startLocation: route.startLocation,
        ));
      }
    } else if (event.destinationAction == DestinationAction.reschedule) {
    } else if (event.destinationAction == DestinationAction.reaccept) {
      final routeTupple = await _routeRepository.getRouteAfterAction(
        routeId: state.id ?? '',
        destinationId: event.destinationId,
        action: event.destinationAction.name,
      );
      if (routeTupple.item2 == 200) {
        final route = routeTupple.item1;
        final pathtolatlng = route.path
            .map((path) => path
                .map((coordinates) => coordinates
                    .map((coordinates) => coordinates.toDouble())
                    .toList())
                .map((e) => LatLng(e[0], e[1]))
                .toList())
            .toList();
        emit(state.copyWith(
            path: pathtolatlng,
            destinations: route.destinations,
            lastAction: DateTime.now().toString() + '_reaccept',
            history: route.history));
      }
    } else if (event.destinationAction == DestinationAction.reset) {
      final routeTupple = await _routeRepository.getRouteAfterAction(
        routeId: state.id ?? '',
        destinationId: event.destinationId,
        action: event.destinationAction.name,
      );
      if (routeTupple.item2 == 200) {
        final route = routeTupple.item1;
        final pathtolatlng = route.path
            .map((path) => path
                .map((coordinates) => coordinates
                    .map((coordinates) => coordinates.toDouble())
                    .toList())
                .map((e) => LatLng(e[0], e[1]))
                .toList())
            .toList();
        emit(state.copyWith(
            path: pathtolatlng,
            destinations: route.destinations,
            lastAction: DateTime.now().toString() + '_reset',
            status: route.status,
            startLocation: route.startLocation,
            distance: route.distance,
            duration: route.duration,
            history: route.history));
      }
    }

    emit(state.copyWith(
      completedDestinations: state.destinations
          .where((destination) =>
              destination.status == DestinationStatus.failed ||
              destination.status == DestinationStatus.success)
          .toList(),
      plannedDestinations: state.destinations
          .where((destination) =>
              destination.status == DestinationStatus.planned ||
              destination.status == DestinationStatus.upcoming ||
              destination.status == DestinationStatus.inProgress)
          .toList(),
      cancelledDestinations: state.destinations
          .where((destination) =>
              destination.status == DestinationStatus.postponed ||
              destination.status == DestinationStatus.rejected)
          .toList(),
      lastAction: DateTime.now().toString() + '_refilterDestination',
    ));
  }

  Future<void> _onFirebaseSubscriptionRequested(
    FirebaseSubscriptionRequested event,
    Emitter<RouteState> emit,
  ) async {
    messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    //If subscribe based sent notification then use this token
    final fcmToken = await messaging.getToken();
    print(fcmToken);
    final topic = await Hive.box<dynamic>('login').get('topic') ?? 'all';

    // unsubscrive from all topics
    //await messaging.unsubscribeFromTopic(oldtopic ?? 'all');
    await messaging.subscribeToTopic(topic ?? 'all');
    print('subscribed to $topic');

    // Set the background messaging handler early on, as a named top-level function
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    if (!kIsWeb) {
      channel = AndroidNotificationChannel(
          topic, // id
          'flutter_notification_title', // title
          importance: Importance.high,
          enableLights: true,
          enableVibration: true,
          showBadge: true,
          playSound: true);

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      final android = AndroidInitializationSettings('@mipmap/ic_launcher');
      final iOS = DarwinInitializationSettings();
      final initSettings = InitializationSettings(android: android, iOS: iOS);

      await flutterLocalNotificationsPlugin!.initialize(initSettings,
          onDidReceiveNotificationResponse: notificationTapBackground,
          onDidReceiveBackgroundNotificationResponse:
              notificationTapBackground);

      emit(state.copyWith(
        notification_route_id: notificationResponse.payload,
      ));

      await messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  void notificationTapBackground(NotificationResponse notificationResponse) {
    print('notification(${notificationResponse.id}) action tapped: '
        '${notificationResponse.actionId} with'
        ' payload: ${notificationResponse.payload}');
    if (notificationResponse.input?.isNotEmpty ?? false) {
      print(
          'notification action tapped with input: ${notificationResponse.input}');
    }
  }

  Future<void> _onSetLanguage(
    SetLanguage event,
    Emitter<RouteState> emit,
  ) async {
    emit(state.copyWith(
      language: event.language,
    ));
  }

  Future<void> _onAssetMapNavigateToAsset(
    AssetMapNavigateToAsset event,
    Emitter<RouteState> emit,
  ) async {
    emit(state.copyWith(mapControllerState: event.mapControllerState));
  }

  Future<void> _onAssetMapFollowAsset(
    AssetMapFollowAsset event,
    Emitter<RouteState> emit,
  ) async {
    emit(state.copyWith(mapControllerState: event.mapControllerState));
  }

  Future<void> _onAssetMapSelectAsset(
    AssetMapSelectAsset event,
    Emitter<RouteState> emit,
  ) async {
    emit(state.copyWith(mapControllerState: event.mapControllerState));
  }

  Future<void> _onAssetMapUnselectAsset(
    AssetMapUnselectAsset event,
    Emitter<RouteState> emit,
  ) async {
    emit(state.copyWith(mapControllerState: event.mapControllerState));
  }

  Future<void> _onSendSMS(
    SendSMS event,
    Emitter<RouteState> emit,
  ) async {
    try {
      String? message = event.message ?? '';
      String? recipent = event.recipent ?? '';
      //await _sendSMS(message, recipents);
      await _sendSMSmessage(message, recipent);
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  Future<void> _sendSMSmessage(String msg, String targetPhone) async {
    bool result;
    List<String> recipients = [];

    // Can the device send SMS?
    result = await canSendSMS();
    if (!result) {
      print("Device cannot send SMS messages");
      return;
    }
    print("Device can send SMS messages");

    // Do we have permission to send SMS?
    result = await Permission.sms.request().isGranted;
    if (!result) {
      print("Permission denied");
      return;
    }
    print("Permission granted");

    // Populate the target name and phone number variables

    print("Sending message to ($targetPhone)");
    recipients.clear();
    recipients.add(targetPhone);
    try {
      String result = await sendSMS(
        message: msg,
        recipients: recipients,
        sendDirect: true,
      );
      print(result);
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> _onSetDriverId(
    SetDriverId event,
    Emitter<RouteState> emit,
  ) async {
    emit(state.copyWith(
      driver_id: event.driverId,
    ));
  }

  Future<void> _onSetDriverPos(
    SetDriverPos event,
    Emitter<RouteState> emit,
  ) async {
    print('set driver pos' + event.driverPos);
    emit(state.copyWith(
      driver_pos: event.driverPos,
    ));
  }

  Future<void> _onDisposeDataStatus(
    DisposeDataStatus event,
    Emitter<RouteState> emit,
  ) async {
    // unsubscrive from all topics
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      await messaging.unsubscribeFromTopic(state.driver_id ?? 'all');
      print('unsubscribed from ${state.driver_id}');
    }
    emit(state.copyWith(dataStatus: DataStatus.disposed));
  }

  @override
  Future<void> close() async {
    //await SocketApi.dispose();
    //await _SocketStatusSubscription.cancel();
    return super.close();
  }
}
