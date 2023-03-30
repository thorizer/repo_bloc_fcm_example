// ignore_for_file: no_default_cases, avoid_void_async, avoid_print

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ngi_repository/ngi_repository.dart';
import 'package:winplan/main.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const AuthenticationState.unknown()) {
    on<AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<AuthenticationLogoutRequested>(_onAuthenticationLogoutRequested);
    _authenticationStatusSubscription = _authenticationRepository.status.listen(
      (status) => add(AuthenticationStatusChanged(status)),
    );
  }

  final AuthenticationRepository _authenticationRepository;
  late StreamSubscription<AuthenticationStatus>
      _authenticationStatusSubscription;

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    _authenticationRepository.dispose();
    return super.close();
  }

  void _onAuthenticationStatusChanged(
    AuthenticationStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) async {
    print(event.status);

    switch (event.status) {
      case AuthenticationStatus.unauthenticated:
        return emit(const AuthenticationState.unauthenticated());
      case AuthenticationStatus.authenticated:
        final userData = await _authenticationRepository.getUserData();
        final user = await _authenticationRepository.getUser();
        final companyOwner = await _authenticationRepository.getCompany();
        final childroles = await _authenticationRepository.getChildRoles();
        final permissions = await _authenticationRepository.getPermissions();
        return emit(
          user != null && companyOwner != null
              ? AuthenticationState.authenticated(
                  user,
                  companyOwner,
                  childroles,
                  permissions,
                  null,
                  userData,
                  user.driver ?? '',
                  user.driver_pos ,
                )
              : const AuthenticationState.unauthenticated(),
        );

      default:
        return emit(const AuthenticationState.unknown());
    }
  }

  Future<void> _onAuthenticationLogoutRequested(
    AuthenticationLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    print('logout');

    // unsubscrive from all topics
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      await messaging.unsubscribeFromTopic(state.driver);
      print('unsubscribed from ${state.driver}');
    }
    _authenticationRepository.logOut();
    //SocketApi.dispose();
  }
}
