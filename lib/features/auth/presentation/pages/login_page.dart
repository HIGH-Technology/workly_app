import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workly_flutter/core/theme/app_theme.dart';
import 'package:workly_flutter/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:workly_flutter/features/auth/presentation/bloc/login/login_event.dart';
import 'package:workly_flutter/features/auth/presentation/bloc/login/login_state.dart';
import 'package:workly_flutter/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:workly_flutter/features/home/presentation/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _navigateToHome(BuildContext context, user) {
    if (_navigated) return; // Evitar navegação duplicada

    debugPrint('🚀 Navegando para HomePage...');
    _navigated = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomePage(user: user)),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginBloc, LoginState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          debugPrint('👀 Estado atual do login: ${state.status}');

          if (state.status == LoginStatus.success && state.user != null) {
            debugPrint(
              '🌟 Login bem-sucedido! Token: ${state.user!.token.isNotEmpty ? "Presente" : "Ausente"}',
            );
            _navigateToHome(context, state.user);
          } else if (state.status == LoginStatus.failure) {
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'Falha no login. Tente novamente.',
                ),
                backgroundColor: Colors.red.shade700,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                duration: const Duration(seconds: 3),
              ),
            );
          } else if (state.status == LoginStatus.loading) {
            setState(() => _isLoading = true);
          }
        },
        builder: (context, state) {
          if (state.status == LoginStatus.success) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Entrando...', style: TextStyle(fontSize: 16)),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(32),
              height: MediaQuery.of(context).size.height,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.work_outline,
                            size: 80,
                            color: AppTheme.primaryColor,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Workly',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 32),
                          const Text(
                            'Entre com sua conta',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          CustomTextField(
                            controller: _emailController,
                            label: 'Email',
                            hint: 'Digite seu email',
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, insira seu email';
                              }
                              if (!RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              ).hasMatch(value)) {
                                return 'Por favor, insira um email válido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _passwordController,
                            label: 'Senha',
                            hint: 'Digite sua senha',
                            obscureText: !_isPasswordVisible,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, insira sua senha';
                              }
                              if (value.length < 6) {
                                return 'A senha deve ter pelo menos 6 caracteres';
                              }
                              return null;
                            },
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                'Esqueceu a senha?',
                                style: TextStyle(color: AppTheme.primaryColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed:
                            _isLoading
                                ? null
                                : () {
                                  if (_formKey.currentState!.validate()) {
                                    setState(
                                      () => _navigated = false,
                                    ); // Reset navegação
                                    debugPrint('🔑 Iniciando login...');
                                    context.read<LoginBloc>().add(
                                      LoginSubmitted(
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text,
                                      ),
                                    );
                                  }
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          disabledBackgroundColor: AppTheme.primaryColor
                              .withOpacity(0.7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child:
                            _isLoading
                                ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                                : const Text(
                                  'Entrar',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Não tem uma conta?'),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Registre-se',
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
