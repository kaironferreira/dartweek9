import 'package:delivery_app/app/core/ui/base_state/base_state.dart';
import 'package:delivery_app/app/core/ui/styles/text_styles.dart';
import 'package:delivery_app/app/core/ui/widgets/delivery_appbar.dart';
import 'package:delivery_app/app/core/ui/widgets/delivery_button.dart';
import 'package:delivery_app/app/pages/auth/register/register_controller.dart';
import 'package:delivery_app/app/pages/auth/register/register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:validatorless/validatorless.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends BaseState<RegisterPage, RegisterController> {
  final _formKey = GlobalKey<FormState>();
  final _nameEC = TextEditingController();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();

  @override
  void dispose() {
    _nameEC.dispose();
    _emailEC.dispose();
    _passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterController, RegisterState>(
      listener: (context, state) {
        state.status.matchAny(
            any: () => hideLoader(),
            register: () => showLoader(),
            error: () {
              hideLoader();
              showError('Erro ao registar usuário');
            },
            success: () {
              hideLoader();
              showSuccess('Cadastro realizado com sucesso');
              Navigator.pop(context);
            });
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/Signup.png',
                    width: 280,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Cadastre-se',
                    style: context.textStyles.textTitle,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Preenche os campos abaixo para criar o seu cadastro.',
                    style: context.textStyles.textMedium.copyWith(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: _nameEC,
                    validator: Validatorless.required("Nome obrigatório"),
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailEC,
                    validator: Validatorless.multiple([
                      Validatorless.required("E-mail obrigatório"),
                      Validatorless.email("E-mail inválido")
                    ]),
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: _passwordEC,
                    validator: Validatorless.multiple([
                      Validatorless.required("Senha obrigatória"),
                      Validatorless.min(
                          6, "Senha deve conter pelo menos 6 caracteres")
                    ]),
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    validator: Validatorless.multiple([
                      Validatorless.required("Confirma senha obrigatória"),
                      Validatorless.compare(
                          _passwordEC, "Senhas devem ser iguais")
                    ]),
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirmar senha',
                    ),
                  ),
                  SizedBox(
                    height: 23,
                  ),
                  DeliveryButton(
                    width: double.infinity,
                    label: 'Entrar',
                    onPressed: () {
                      final validate =
                          _formKey.currentState?.validate() ?? false;
                      if (validate) {
                        controller.register(
                          _nameEC.text,
                          _emailEC.text,
                          _passwordEC.text,
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
