import 'package:delivery_app/app/core/ui/base_state/base_state.dart';
import 'package:delivery_app/app/core/ui/styles/text_styles.dart';
import 'package:delivery_app/app/core/ui/widgets/delivery_appbar.dart';
import 'package:delivery_app/app/core/ui/widgets/delivery_button.dart';
import 'package:delivery_app/app/pages/auth/login/login_controller.dart';
import 'package:delivery_app/app/pages/auth/login/login_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends BaseState<LoginPage, LoginController> {
  final _formKey = GlobalKey<FormState>();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailEC.dispose();
    _passwordEC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginController, LoginState>(
      listener: (context, state) {
        state.status.matchAny(
          any: () => hideLoader(),
          login: () => showLoader(),
          loginError: () {
            hideLoader();
            showError('Login ou senha inválidos');
          },
          error: () {
            hideLoader();
            showError('Erro o realizar Login');
          },
          success: () {
            hideLoader();
            Navigator.pop(context, true);
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/Login.png',
                        width: 280,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        'Login',
                        style: context.textStyles.textTitle,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: _emailEC,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validatorless.multiple([
                          Validatorless.required('E-mail obrigatório'),
                          Validatorless.email('E-mail inválido'),
                        ]),
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: _passwordEC,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        validator: Validatorless.multiple([
                          Validatorless.required('Senha obrigatória'),
                        ]),
                        decoration: const InputDecoration(
                          labelText: 'Senha',
                        ),
                      ),
                      const SizedBox(
                        height: 23,
                      ),
                      DeliveryButton(
                        width: double.infinity,
                        label: 'Entrar',
                        onPressed: () {
                          final validate =
                              _formKey.currentState?.validate() ?? false;
                          if (validate) {
                            controller.login(_emailEC.text, _passwordEC.text);
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Não possui uma conta?',
                          style: context.textStyles.textBold,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/auth/register');
                          },
                          child: Text(
                            'Cadastre-se',
                            style: context.textStyles.textBold,
                          ),
                        ),
                      ]),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
