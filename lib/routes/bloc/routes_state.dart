// ignore_for_file: lines_longer_than_80_chars

part of 'routes_bloc.dart';

enum DataStatus { initial, success, failure, Unauthorized, retry, disposed }

enum AdressStatus { initial, success }

enum RealtimeStatus { initial, success, outdated }

enum MapAssetEvent {
  none,
  navigateToAsset,
  resetZoom,
  fitBounds,
  selectAsset,
  followAsset
}

class RouteState extends Equatable {
  const RouteState({
    // main route
    this.id = null,
    this.driver_id = null,
    this.driver_pos = null,
    this.notification_route_id = null,
    this.route_id = null,
    this.duration = 0,
    this.distance = 0,
    this.destinations = const <Destination>[],
    this.plannedDestinations = const <Destination>[],
    this.completedDestinations = const <Destination>[],
    this.cancelledDestinations = const <Destination>[],
    this.status = RouteStatus.planned,
    this.startLocation,
    this.history = const <HistoryEvent>[],
    this.dataStatus = DataStatus.initial,
    this.lastAction = 'initial',
    this.path = const [],
    // secondary route
    this.temp_id = null,
    this.temp_route_id = null,
    this.temp_duration = 0,
    this.temp_distance = 0,
    this.temp_destinations = const <Destination>[],
    this.temp_plannedDestinations = const <Destination>[],
    this.temp_completedDestinations = const <Destination>[],
    this.temp_cancelledDestinations = const <Destination>[],
    this.temp_status = RouteStatus.planned,
    this.temp_startLocation,
    this.temp_history = const <HistoryEvent>[],
    this.temp_dataStatus = DataStatus.initial,
    this.temp_lastAction = 'initial',
    this.temp_path = const [],
    // map and ui
    this.isMainRoute = true,
    this.destinationType = 0,
    this.taskTabValue = 1,
    this.selectedDateCalendar = null,
    this.mapControllerState = const MapControllerState(
      id: 'init',
      assetID: null,
      location: null,
      mapEvent: MapAssetEvent.none,
    ),
    this.language = 'fr',
  });

  // main route
  final String? id;
  final String? driver_id;
  final String? driver_pos;
  final String? notification_route_id;
  final String? route_id;
  final double duration;
  final double distance;
  final List<Destination> destinations;
  final List<Destination> plannedDestinations;
  final List<Destination> completedDestinations;
  final List<Destination> cancelledDestinations;
  final List<double>? startLocation;
  final RouteStatus status;
  final List<HistoryEvent> history;
  final DataStatus dataStatus;
  final String lastAction;
  final List<List<LatLng>> path;
  // secondary route
  final String? temp_id;
  final String? temp_route_id;
  final double temp_duration;
  final double temp_distance;
  final List<Destination> temp_destinations;
  final List<Destination> temp_plannedDestinations;
  final List<Destination> temp_completedDestinations;
  final List<Destination> temp_cancelledDestinations;
  final List<double>? temp_startLocation;
  final RouteStatus temp_status;
  final List<HistoryEvent> temp_history;
  final DataStatus temp_dataStatus;
  final String temp_lastAction;
  final List<List<LatLng>> temp_path;
  // map and ui
  final bool isMainRoute;
  final int destinationType;
  final int taskTabValue;
  final DateTime? selectedDateCalendar;
  final MapControllerState mapControllerState;
  final String? language;

  /*  @override
  String toString() =>
      'RouteState(selectedFleet: ${selectedFleet?.name},  status: $status, lastRtGps: $lastRtGps,   assets: ${assets.length}  fleets: ${fleets.length} fleetAssets: ${fleetAssets.length})'; */

  @override
  String toString() =>
      'RouteState(Language: ${language},  destinations : ${destinations.length},  status: $status,)';

  RouteState copyWith({
    // main route
    String? id,

    // the current driver id
    String? driver_id,

    // the current driver pos
    String? driver_pos,

    // the current notification route id
    String? notification_route_id,

    /// The current id of the route
    String? route_id,

    /// The current duration of the route
    double? duration,

    /// The current distance of the route
    double? distance,

    /// The current destinations of the route
    List<Destination>? destinations,

    /// The current planned destinations of the route
    List<Destination>? plannedDestinations,

    /// The current completed destinations of the route
    List<Destination>? completedDestinations,

    /// The current cancelled destinations of the route
    List<Destination>? cancelledDestinations,

    /// The current start location of the route
    List<double>? startLocation,

    /// The current status of the route
    RouteStatus? status,

    /// The current history of the route
    List<HistoryEvent>? history,

    /// The current data status of the route
    DataStatus? dataStatus,

    /// The last action of the route
    String? lastAction,

    /// the current path of the route
    List<List<LatLng>>? path,

    // secondary route
    String? temp_id,

    /// The current id of the temp route
    String? temp_route_id,

    /// The current duration of the temp route
    double? temp_duration,

    /// The current distance of the temp route
    double? temp_distance,

    /// The current destinations of the temp route
    List<Destination>? temp_destinations,

    /// The current planned destinations of the temp route
    List<Destination>? temp_plannedDestinations,

    /// The current completed destinations of the temp route
    List<Destination>? temp_completedDestinations,

    /// The current cancelled destinations of the temp route
    List<Destination>? temp_cancelledDestinations,

    /// The current start location of the temp route
    List<double>? temp_startLocation,

    /// The current status of the temp route
    RouteStatus? temp_status,

    /// The current history of the temp route
    List<HistoryEvent>? temp_history,

    /// The current data status of the temp route
    DataStatus? temp_dataStatus,

    /// The last action of the temp route
    String? temp_lastAction,

    /// the current path of the temp route
    List<List<LatLng>>? temp_path,

    /// The current main route status
    bool? isMainRoute,

    /// The current destination type
    int? destinationType,

    /// The current task tab value
    int? taskTabValue,

    /// The current selected date calendar
    DateTime? selectedDateCalendar,

    /// The current map controller state
    MapControllerState? mapControllerState,

    /// The current language
    String? language,
  }) {
    return RouteState(
      // main route
      id: id ?? this.id,
      driver_id: driver_id ?? this.driver_id,
      driver_pos: driver_pos ?? this.driver_pos,
      notification_route_id: notification_route_id ?? this.notification_route_id,
      route_id: route_id ?? this.route_id,
      duration: duration ?? this.duration,
      distance: distance ?? this.distance,
      destinations: destinations ?? this.destinations,
      plannedDestinations: plannedDestinations ?? this.plannedDestinations,
      completedDestinations:
          completedDestinations ?? this.completedDestinations,
      cancelledDestinations:
          cancelledDestinations ?? this.cancelledDestinations,
      startLocation: startLocation ?? this.startLocation,
      status: status ?? this.status,
      history: history ?? this.history,
      dataStatus: dataStatus ?? this.dataStatus,
      lastAction: lastAction ?? this.lastAction,
      path: path ?? this.path,
      // secondary route
      temp_id: temp_id ?? this.temp_id,
      temp_route_id: temp_route_id ?? this.temp_route_id,
      temp_duration: temp_duration ?? this.temp_duration,
      temp_distance: temp_distance ?? this.temp_distance,
      temp_destinations: temp_destinations ?? this.temp_destinations,
      temp_plannedDestinations:
          temp_plannedDestinations ?? this.temp_plannedDestinations,
      temp_completedDestinations:
          temp_completedDestinations ?? this.temp_completedDestinations,
      temp_cancelledDestinations:
          temp_cancelledDestinations ?? this.temp_cancelledDestinations,
      temp_startLocation: temp_startLocation ?? this.temp_startLocation,
      temp_status: temp_status ?? this.temp_status,
      temp_history: temp_history ?? this.temp_history,
      temp_dataStatus: temp_dataStatus ?? this.temp_dataStatus,
      temp_lastAction: temp_lastAction ?? this.temp_lastAction,
      temp_path: temp_path ?? this.temp_path,
      isMainRoute: isMainRoute ?? this.isMainRoute,
      destinationType: destinationType ?? this.destinationType,
      taskTabValue: taskTabValue ?? this.taskTabValue,
      mapControllerState: mapControllerState ?? this.mapControllerState,
      selectedDateCalendar: selectedDateCalendar ?? this.selectedDateCalendar,
      language: language ?? this.language,
    );
  }

  @override
  List<Object?> get props => [
        id,
        driver_id,
        driver_pos,
        notification_route_id,
        taskTabValue,
        destinationType,
        route_id,
        temp_route_id,
        status,
        temp_status,
        dataStatus,
        temp_dataStatus,
        lastAction,
        temp_lastAction,
        mapControllerState.id,
        language,
        isMainRoute,
        selectedDateCalendar
      ];
}

class MapControllerState extends Equatable {
  const MapControllerState({
    required this.id,
    this.mapEvent = MapAssetEvent.none,
    this.assetID = null,
    this.location = null,
  });

  final String id;
  final MapAssetEvent mapEvent;
  final String? assetID;
  final LatLng? location;

  @override
  String toString() =>
      'MapControllerState(mapEvent: $mapEvent, assetID: $assetID, location: $location)';

  MapControllerState copyWith({
    String? id,
    MapAssetEvent? mapEvent,
    String? assetID,
    LatLng? location,
  }) {
    return MapControllerState(
      id: id ?? this.id,
      mapEvent: mapEvent ?? MapAssetEvent.none,
      assetID: assetID ?? this.assetID,
      location: location ?? this.location,
    );
  }

  @override
  List<Object?> get props => [
        id,
      ];
}
