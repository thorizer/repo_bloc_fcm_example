part of 'routes_bloc.dart';

@immutable
abstract class RouteEvent extends Equatable {
  const RouteEvent();

  @override
  List<Object> get props => [];
}

class SocketStatusChanged extends RouteEvent {
  const SocketStatusChanged(this.status);

  final SocketConnectionStatus status;

  @override
  List<Object> get props => [status];
}

class AssetsLoaded extends RouteEvent {}

class RouteLoaded extends RouteEvent {
  const RouteLoaded(this.driverId, this.daySelected, this.date);
  final String driverId;
  final String daySelected;
  final DateTime date;

  @override
  List<Object> get props => [driverId, daySelected, date];
}

class changeDestinationType extends RouteEvent {
  const changeDestinationType(this.destinationType);
  final int destinationType;

  @override
  List<Object> get props => [destinationType];
}

class changeTaskTabValue extends RouteEvent {
  const changeTaskTabValue(this.taskTabValue);
  final int taskTabValue;

  @override
  List<Object> get props => [taskTabValue];
}

class ExcuteDestinationAction extends RouteEvent {
  const ExcuteDestinationAction(this.destinationAction, this.destinationId);

  final DestinationAction destinationAction;
  final String destinationId;

  @override
  List<Object> get props => [destinationAction, destinationId];
}

class FleetSelected extends RouteEvent {
  const FleetSelected(this.fleet);
  final Fleet fleet;

  @override
  List<Object> get props => [fleet.id];
}

class CompanySelected extends RouteEvent {
  const CompanySelected(this.company);
  final CompanyOwnerRepo company;

  @override
  List<Object> get props => [company.id];
}

class RtAssetsLoaded extends RouteEvent {}

/* class RtAdressLoaded extends RouteEvent {} */

class SetLanguage extends RouteEvent {
  const SetLanguage(this.language);
  final String language;

  @override
  List<Object> get props => [language];
}

class AssetFliterChanged extends RouteEvent {
  const AssetFliterChanged(
      this.searchAsset, this.filterStatusGYRB, this.filterType);
  final String searchAsset;
  final String filterStatusGYRB;
  final String filterType;

  @override
  List<Object> get props => [searchAsset, filterStatusGYRB];
}

class FirebaseSubscriptionRequested extends RouteEvent {
  const FirebaseSubscriptionRequested();
}

class AlertSubscriptionRequested extends RouteEvent {
  const AlertSubscriptionRequested();
}

class AssetMapNavigateToAsset extends RouteEvent {
  const AssetMapNavigateToAsset(this.mapControllerState);
  final MapControllerState mapControllerState;
}

class AssetMapFollowAsset extends RouteEvent {
  const AssetMapFollowAsset(this.mapControllerState);
  final MapControllerState mapControllerState;
}

class AssetMapSelectAsset extends RouteEvent {
  const AssetMapSelectAsset(this.mapControllerState);
  final MapControllerState mapControllerState;
}

class AssetMapUnselectAsset extends RouteEvent {
  const AssetMapUnselectAsset(this.mapControllerState);
  final MapControllerState mapControllerState;
}

class AssetMapResetZoom extends RouteEvent {
  const AssetMapResetZoom(this.mapControllerState);
  final MapControllerState mapControllerState;
}

class AssetMapFitBounds extends RouteEvent {
  const AssetMapFitBounds(this.mapControllerState);
  final MapControllerState mapControllerState;
}

class SendSMS extends RouteEvent {
  const SendSMS(this.message, this.recipent);
  final String? message;
  final String? recipent;
}

class DisposeDataStatus extends RouteEvent {
  const DisposeDataStatus();
}

class SetDriverId extends RouteEvent {
  const SetDriverId(this.driverId);
  final String driverId;
  @override
  List<Object> get props => [driverId];
}

class SetDriverPos extends RouteEvent {
  const SetDriverPos(this.driverPos);
  final String driverPos;
  @override
  List<Object> get props => [driverPos];
}
