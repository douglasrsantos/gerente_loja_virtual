import 'package:flutter/material.dart';
import 'package:gerente_loja_virtual/blocs/login_bloc.dart';
import 'package:gerente_loja_virtual/screens/home_screen.dart';
import 'package:gerente_loja_virtual/widgets/input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginBloc = LoginBloc();

  @override
  void initState() {
    super.initState();

    _loginBloc.outState.listen((state) {
      switch (state) {
        case LoginState.SUCCESS:
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()));
          break;
        case LoginState.FAIL:
          showDialog(
            context: context,
            builder: (context) => const AlertDialog(
              title: Text('Erro'),
              content: Text('Você não possui os privilégios necessários'),
            ),
          );
          break;
        case LoginState.LOADING:
        case LoginState.IDLE:
      }
    });
  }


  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: StreamBuilder<LoginState>(
          stream: _loginBloc.outState,
          initialData: LoginState.LOADING,
          builder: (context, snapshot) {
            //print(snapshot.data!);
            switch (snapshot.data!) {
              case LoginState.LOADING:
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(
                      Colors.pinkAccent,
                    ),
                  ),
                );
              case LoginState.FAIL:
              case LoginState.SUCCESS:
              case LoginState.IDLE:
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(),
                    SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            const Icon(
                              Icons.store_mall_directory,
                              size: 160,
                              color: Colors.pinkAccent,
                            ),
                            InputField(
                              icon: Icons.person_outline,
                              hint: 'Usuário',
                              obscure: false,
                              stream: _loginBloc.outEmail,
                              onChanged: _loginBloc.changeEmail,
                            ),
                            InputField(
                              icon: Icons.lock_outline,
                              hint: 'Senha',
                              obscure: true,
                              stream: _loginBloc.outPassword,
                              onChanged: _loginBloc.changePassword,
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            StreamBuilder<bool>(
                                stream: _loginBloc.outSubmitValid,
                                builder: (context, snapshot) {
                                  return SizedBox(
                                    height: 50,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.pinkAccent,
                                          onSurface: Colors.pinkAccent,
                                          textStyle: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        onPressed: snapshot.hasData
                                            ? _loginBloc.submit
                                            : null,
                                        child: const Text('Entrar')),
                                  );
                                }),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              default:
                return Container();
            }
          }),
    );
  }
}
