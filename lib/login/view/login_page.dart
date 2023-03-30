// ignore_for_file: lines_longer_than_80_chars

/*  The LoginPage is responsible for exposing the Route
as well as creating and providing the LoginBloc to the LoginForm.
Note: RepositoryProvider.of<AuthenticationRepository>(context) is used to lookup
the instance of AuthenticationRepository via the BuildContext.
*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:winplan/login/login.dart';
import 'package:ngi_repository/ngi_repository.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // we are using this to determine Keyboard is opened or not
    final defaultLoginSize = size.height ;
    // final defaultRegisterSize = size.height - (size.height * 0.1);

    return Scaffold(
      body: Stack(
        children: [
          // Lets add some decorations


          BlocProvider(
            create: (context) {
              return LoginBloc(
                authenticationRepository:
                    RepositoryProvider.of<AuthenticationRepository>(context),
              );
            },
            child: LoginForm(
              size: size,
              defaultLoginSize: defaultLoginSize,
            ),
          ),
        ],
      ),
    );
  }
}
