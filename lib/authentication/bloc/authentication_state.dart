// ignore_for_file: lines_longer_than_80_chars

part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.user = const UserRepo(id: ''),
    this.companyOwner = const CompanyOwnerRepo(id: ''),
    this.childroles = const [],
    this.permissions = const {},
    this.expirationDate = '',
    this.userData = const <String, dynamic>{},
    this.driver = '',
    this.driver_pos ,
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(
    UserRepo? user,
    CompanyOwnerRepo? companyOwner,
    List<String?> childroles,
    Map<String, String> permissions,
    String? expirationDate,
    Map<String, dynamic>? userData,
    String driver,
    String? driver_pos,
  ) : this._(
          status: AuthenticationStatus.authenticated,
          user: user,
          companyOwner: companyOwner,
          childroles: childroles,
          permissions: permissions,
          expirationDate: expirationDate,
          userData: userData,
          driver: driver,
          driver_pos: driver_pos,
        );

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  final AuthenticationStatus? status;
  final UserRepo? user;
  final String? expirationDate;
  final CompanyOwnerRepo? companyOwner;
  final List<String?> childroles;
  final Map<String, String> permissions;
  final Map<String, dynamic>? userData;
  final String driver;
  final String? driver_pos;

  @override
  List<Object?> get props => [status, user?.id, driver, driver_pos];
}
