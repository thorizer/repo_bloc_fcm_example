// ignore_for_file: lines_longer_than_80_chars

/* The LoginForm handles notifying the LoginBloc of user events
and also responds to state changes using BlocBuilder and BlocListener.

BlocListener is used to show a SnackBar if the login submission fails.
In addition, BlocBuilder widgets are used to wrap each of the TextField widgets
and make use of the buildWhen property in order to optimize for rebuilds.
The onChanged callback is used to notify the LoginBloc of changes
to the username/password.

The _LoginButton widget is only enabled if the status of the form is valid
and a CircularProgressIndicator is shown in its place while the form
is being submitted.
*/

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:winplan/login/widgets/rounded_input.dart';
import 'package:winplan/login/widgets/rounded_password_input.dart';
import 'package:winplan/login/login.dart';
import 'package:winplan/shared/shared.export.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ngi_api/ngi_api.export.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
    required this.size,
    required this.defaultLoginSize,
  }) : super(key: key);

  final Size size;
  final double defaultLoginSize;
  @override
  Widget build(BuildContext context) {
    context.select(
      (LoginBloc bloc) => bloc.state.error,
    );
    return BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          //print ('Login State: ${state.message}');
          if (state.status.isSubmissionFailure && state.error.isNotEmpty) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                    content: Text(
                      state.error,
                      style: TextStyle(fontSize: 10),
                    ),
                    backgroundColor: Colors.redAccent),
              );
          } else if (state.message.isNotEmpty) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                    content: Text(
                      state.message,
                      style: TextStyle(fontSize: 10),
                    ),
                    backgroundColor: Colors.green),
              );
          }
        },
        child: Stack(children: [
          Container(
              color: Color.fromARGB(255, 5, 81, 143),
              child: SizedBox(
                height: defaultLoginSize,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /* Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(216, 255, 255, 255),
                          borderRadius: BorderRadius.circular(150),
                        ),
                        child: Image.asset('assets/images/login/ngi3.png',
                            height: size.height * 0.2),
                      ), */
                      // backround image  filling the sytack with transparency 0.5

                      const SizedBox(height: 40),
                      /* Text(
                        EnvironmentActive.EnvLabel,
                        style: GoogleFonts.anekGurmukhi(
                          fontWeight: FontWeight.bold,
                          fontSize: 42,
                          color: Color.fromARGB(255, 141, 200, 248),
                          shadows: [
                            Shadow(
                              blurRadius: 8.0,
                              color: Color.fromARGB(255, 1, 9, 17),
                              offset: Offset(1.0, 1.0),
                            ),
                          ],
                        ),
                      ), */
                     
                      Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            //color:  Color.fromARGB(255, 127, 136, 143),
                            child: Image.asset(
                              "assets/images/login/win5.png",

                              height: 70,
                            ),
                          ),
                        ),
                         SizedBox(
                        height: 20,
                      ),
                      Opacity(
                        opacity: 0.6,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            //color:  Color.fromARGB(255, 127, 136, 143),
                            child: Image.asset(
                              "assets/images/login/fleet4.png",
                              height: 200,
                              //width: size.width,
                            ),
                          ),
                        ),
                      ),
                       SizedBox(
                        height: 20,
                      ),
                      /* BlocBuilder<LoginBloc, LoginState>(
                        buildWhen: (previous, current) =>
                            previous.env != current.env,
                        builder: (context, state) {
                          return GestureDetector(
                            onTap: () {},
                            child: Text(
                              state.env.envConf.label,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 36,
                                color: Color.fromARGB(255, 79, 205, 199),
                              ),
                            ),
                          );
                        },
                      ), */
                      //const SizedBox(height: 15),
                      // 3 icons profiles , language , env
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // profile
                          BlocBuilder<LoginBloc, LoginState>(
                            builder: (context, state) {
                              return MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    //context.read<LoginBloc>().add(ChangeProfile());
                                  },
                                  child: Image.asset(
                                    "assets/images/login/account.png",
                                    height: 50,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 20),
                          // language
                          BlocBuilder<LoginBloc, LoginState>(
                            buildWhen: (previous, current) =>
                                previous.language != current.language,
                            builder: (context, state) {
                              return MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    //context.read<LoginBloc>().add(ChangeLanguage());
                                  },
                                  child: Container(
                                    height: 52,
                                    width: 52,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 213, 252, 255),
                                      borderRadius: BorderRadius.circular(150),
                                      border: Border.all(
                                        width: 2,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ),
                                    child: Image.asset(
                                      "assets/images/login/padlock.png",
                                      height: 20,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          /* const SizedBox(width: 20),
                          // env
                          BlocBuilder<LoginBloc, LoginState>(
                            buildWhen: (previous, current) =>
                                previous.env != current.env,
                            builder: (context, state) {
                              return MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    //context.read<LoginBloc>().add(ChangeEnv());
                                  },
                                  child: Image.asset(
                                    "assets/images/login/settings.png",
                                    height: 50,
                                  ),
                                ),
                              );
                            },
                          ), */
                        ],
                      ),
                      const SizedBox(height: 10),

                      //SvgPicture.asset('assets/images/login.svg', height: size.height * 0.4),

                      _UsernameInput(),

                      _PasswordInput(),

                      const SizedBox(height: 10),

                      _LoginButton(),

                      const SizedBox(height: 20),
                      Container(
                        //width:  size.width * 0.5,
                        //color: Color.fromARGB(255, 240, 178, 96),
                        child: BlocBuilder<LoginBloc, LoginState>(
                            buildWhen: (previous, current) =>
                                previous.language != current.language,
                            builder: (context, state) {
                              // vertical animated toogle switch

                              return Container(
                                //color: Color.fromARGB(255, 240, 178, 96),
                                child: AnimatedToggleSwitch<String>.rolling(
                                  current: state.language,
                                  values: ['en', 'fr'],
                                  onChanged: (i) {
                                    context.setLocale(Locale(i));
                                    context
                                        .read<LoginBloc>()
                                        .add(SetLanguage(i));
                                  },
                                  borderWidth: 2,
                                  dif: 10,

                                  //borderColor:  Colors.transparent,
                                  indicatorColor:
                                      Color.fromARGB(108, 5, 61, 78),
                                  //innerColor:  Color.fromARGB(33, 10, 224, 196),
                                  //dragCursor:  SystemMouseCursors.grab,
                                  //draggingCursor:  SystemMouseCursors.grabbing,
                                  iconBuilder: (String value, Size size,
                                      bool isSelected) {
                                    String flagImage = value == 'en'
                                        ? 'assets/images/flags/uk.png'
                                        : 'assets/images/flags/fr.png';

                                    return Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Image.asset(
                                        flagImage,
                                        height: size.height + 6,
                                        width: size.width + 6,
                                      ),
                                    );
                                  },
                                ),
                              );
                            }),
                      ),
                      const SizedBox(height: 40),
                      Center(
                        child: Builder(builder: (context) {
                          final listWidth = 150 *
                                  environments.Active.length.toDouble() +
                              5 * (environments.Active.length.toDouble() + 1);
                          final sizeWidth = size.width * 0.8;
                          // smallet width
                          final wdth =
                              listWidth < sizeWidth ? listWidth : sizeWidth;
                          return Container(
                           // color: Color.fromARGB(255, 231, 210, 172),
                            width: wdth,
                            alignment: Alignment.center,
                            //margin: EdgeInsets.only(left: size.width * 0.2),
                            child: BlocBuilder<LoginBloc, LoginState>(
                              builder: (context, state) {
                                return Container(
                                  //margin: EdgeInsets.only( right: 20),

                                  height: 100,

                                  //color: Color.fromARGB(255, 231, 210, 172),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: GestureDetector(
                                          onTap: () {
                                            context.read<LoginBloc>().add(
                                                  EnvChanged(
                                                    environments.Active[index],
                                                  ),
                                                );
                                            EnvironmentActive.activeEnv =
                                                environments.Active[index];
                                            // change language
                                            final lang = environments
                                                .WinplanEnvList[index]
                                                .envConf
                                                .language;
                                            context
                                                .read<LoginBloc>()
                                                .add(SetLanguage(lang));
                                            context.setLocale(Locale(lang));
                                          },
                                          /* child: Builder(builder: (context) {
                                            final activeLabel = environments
                                                    .Active[index]
                                                    .envConf
                                                    .label ==
                                                state.env.envConf.label;
                                            return Card(
                                              elevation: 5,
                                              //color: Color.fromARGB(255, 200, 247, 240),
                                              // darker if active environment
                                              color: activeLabel
                                                  ? Color.fromARGB(
                                                      255, 181, 235, 215)
                                                  : Color.fromARGB(
                                                      255, 230, 230, 230),
                                              margin: EdgeInsets.all(5),

                                              //color:  Color.fromARGB(255, 27, 71, 218),
                                              child: Container(
                                                width: 150,
                                                child: Stack(children: [
                                                  Positioned(
                                                    top: 10,
                                                    child: Container(
                                                      height: 20,
                                                      width: 150,
                                                      color: Color.fromARGB(
                                                          255, 23, 108, 178),
                                                      child: Text(
                                                        environments
                                                            .WinplanEnvList[
                                                                index]
                                                            .envConf
                                                            .label,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    255),
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                  ),
                                                  // logo image from env name
                                                  Positioned(
                                                    bottom: 5,
                                                    width: 110,
                                                    left: 10,
                                                    child: Image.asset(
                                                      "assets/images/login/${environments.Active[index].envConf.name}.png",
                                                      height: 50,
                                                    ),
                                                  ),
                                                  Positioned(
                                                    right: 5,
                                                    bottom: 5,
                                                    child: Image.asset(
                                                      "assets/images/flags/${environments.Active[index].envConf.countryCode}.png",
                                                      width: 15,
                                                      height: 15,
                                                    ),
                                                  ),
                                                ]),

                                                // better design
                                                //trailing: Icon(Icons.arrow_forward_ios),
                                              ),
                                            );
                                          }), */
                                        ),
                                      );
                                    },
                                    itemCount:
                                        environments.WinplanEnvList.length,
                                    itemExtent: 150,
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                      ),
                      /*   Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Center(
                          child: Container(
                            color: Color.fromARGB(255, 127, 136, 143),
                            child: Center(
                              child: Wrap(
                                  alignment: WrapAlignment.spaceBetween,
                                  children: [
                                    BlocBuilder<LoginBloc, LoginState>(
                                        buildWhen: (previous, current) =>
                                            previous.language !=
                                            current.language,
                                        builder: (context, state) {
                                          // vertical animated toogle switch

                                          return RotatedBox(
                                            //alignment:  Alignment.topCenter,
                                            quarterTurns: 1,
                                            child: Container(
                                              //color: Color.fromARGB(255, 240, 178, 96),
                                              child: AnimatedToggleSwitch<
                                                  String>.rolling(
                                                current: state.language,
                                                values: ['en', 'fr'],
                                                onChanged: (i) {
                                                  context.setLocale(Locale(i));
                                                  context
                                                      .read<LoginBloc>()
                                                      .add(SetLanguage(i));
                                                },
                                                borderWidth: 2,
                                                dif: 10,

                                                //borderColor:  Colors.transparent,
                                                indicatorColor: Color.fromARGB(
                                                    108, 5, 61, 78),
                                                //innerColor:  Color.fromARGB(33, 10, 224, 196),
                                                //dragCursor:  SystemMouseCursors.grab,
                                                //draggingCursor:  SystemMouseCursors.grabbing,
                                                iconBuilder: (String value,
                                                    Size size,
                                                    bool isSelected) {
                                                  String flagImage = value ==
                                                          'en'
                                                      ? 'assets/images/flags/uk.png'
                                                      : 'assets/images/flags/fr.png';

                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
                                                    child: Image.asset(
                                                      flagImage,
                                                      height: size.height + 6,
                                                      width: size.width + 6,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          );
                                        }),
                                    const SizedBox(width: 10),
                                    BlocBuilder<LoginBloc, LoginState>(
                                      builder: (context, state) {
                                        return Expanded(
                                          child: Container(
                                            //margin: EdgeInsets.only( right: 20),

                                            height: 100,

                                            //color: Color.fromARGB(255, 231, 210, 172),
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return MouseRegion(
                                                  cursor:
                                                      SystemMouseCursors.click,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      context
                                                          .read<LoginBloc>()
                                                          .add(
                                                            EnvChanged(
                                                              environments
                                                                      .Active[
                                                                  index],
                                                            ),
                                                          );
                                                      EnvironmentActive
                                                              .activeEnv =
                                                          environments
                                                              .Active[index];
                                                      // change language
                                                      final lang = environments
                                                          .NgiGpsEnvList[index]
                                                          .envConf
                                                          .language;
                                                      context
                                                          .read<LoginBloc>()
                                                          .add(SetLanguage(
                                                              lang));
                                                      context.setLocale(
                                                          Locale(lang));
                                                    },
                                                    child: Builder(
                                                        builder: (context) {
                                                      final activeLabel =
                                                          environments
                                                                  .Active[index]
                                                                  .envConf
                                                                  .label ==
                                                              state.env.envConf
                                                                  .label;
                                                      return Card(
                                                        elevation: 5,
                                                        //color: Color.fromARGB(255, 200, 247, 240),
                                                        // darker if active environment
                                                        color: activeLabel
                                                            ? Color.fromARGB(
                                                                255,
                                                                181,
                                                                235,
                                                                215)
                                                            : Color.fromARGB(
                                                                255,
                                                                230,
                                                                230,
                                                                230),
                                                        margin:
                                                            EdgeInsets.all(5),

                                                        //color:  Color.fromARGB(255, 27, 71, 218),
                                                        child: Container(
                                                          width: 150,
                                                          child:
                                                              Stack(children: [
                                                            Positioned(
                                                              top: 10,
                                                              child: Container(
                                                                height: 20,
                                                                width: 150,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        23,
                                                                        108,
                                                                        178),
                                                                child: Text(
                                                                  environments
                                                                      .NgiGpsEnvList[
                                                                          index]
                                                                      .envConf
                                                                      .label,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          255),
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              ),
                                                            ),
                                                            // logo image from env name
                                                            Positioned(
                                                              bottom: 5,
                                                              width: 110,
                                                              left: 10,
                                                              child:
                                                                  Image.asset(
                                                                "assets/images/login/${environments.Active[index].envConf.name}.png",
                                                                height: 50,
                                                              ),
                                                            ),
                                                            Positioned(
                                                              right: 5,
                                                              bottom: 5,
                                                              child:
                                                                  Image.asset(
                                                                "assets/images/flags/${environments.Active[index].envConf.countryCode}.png",
                                                                width: 15,
                                                                height: 15,
                                                              ),
                                                            ),
                                                          ]),

                                                          // better design
                                                          //trailing: Icon(Icons.arrow_forward_ios),
                                                        ),
                                                      );
                                                    }),
                                                  ),
                                                );
                                              },
                                              itemCount: environments
                                                  .NgiGpsEnvList.length,
                                              itemExtent: 150,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                      ), */
                      //const SizedBox(height: 20),
                      const SizedBox(height: 20),

                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              )),
          // image background
        ]));
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return RoundedInput(
          key: const Key('loginForm_usernameInput_textField'),
          icon: Icons.mail,
          hint: 'Username',

          //label: 'Username',
          error: state.username.invalid ? '❌ Invalid Username' : null,
          onChanged: (username) =>
              context.read<LoginBloc>().add(LoginUsernameChanged(username)),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return RoundedPasswordInput(
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<LoginBloc>().add(LoginPasswordChanged(password)),
          error: state.password.invalid ? '❌ Invalid Password' : null,
          hint: 'Password',
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : InkWell(
                key: const Key('loginForm_continue_raisedButton'),
                onTap: state.status.isValidated
                    ? () {
                        context.read<LoginBloc>().add(const LoginSubmitted());
                      }
                    : null,
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  width: size.width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: state.status.isValidated
                        ? Color.fromARGB(218, 144, 203, 252)
                        : kDisabledColor,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  child: Text(
                    'LOGIN',
                    style: GoogleFonts.almarai(
                      color: state.status.isValidated
                          ? Color.fromARGB(255, 45, 77, 124)
                          : Color.fromARGB(255, 114, 114, 114),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
      },
    );
  }
}
