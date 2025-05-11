import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intermediate_flutter/components/login_form.dart';
import 'package:intermediate_flutter/provider/auth_provider.dart';
import 'package:intermediate_flutter/localization/main.dart';
import 'package:intermediate_flutter/provider/localization_provider.dart';

class LoginScreen extends StatefulWidget {
  final Function(String email, String password) onLogin;
  final Function() onRegister;

  const LoginScreen({
    super.key,
    required this.onLogin,
    required this.onRegister,
  });

  static const String routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Consumer2<AuthProvider, LocalizationProvider>(
      builder: (context, authProvider, localizationProvider, child) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: theme.colorScheme.secondary,
            onPressed: () {
              localizationProvider.setLocale(
                localizationProvider.locale == const Locale('en')
                    ? const Locale('id')
                    : const Locale('en'),
              );
            },
            child: Icon(Icons.translate, color: theme.colorScheme.onSecondary),
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.colorScheme.primary.withOpacity(0.8),
                  theme.colorScheme.primaryContainer,
                ],
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: size.width > 600 ? 500 : double.infinity,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // App Logo/Title
                          Icon(
                            Icons.account_circle,
                            size: 80,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            AppLocalizations.of(context)!.login,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context)!.loginDesc,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Login Form
                          Form(
                            key: formKey,
                            child: LoginForm(
                              emailController: _emailController,
                              passwordController: _passwordController,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Login Button
                          authProvider.isFetching
                              ? const CircularProgressIndicator()
                              : SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      backgroundColor: theme.colorScheme.primary,
                                    ),
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        authProvider.setIsFetching(true);
                                        widget.onLogin(
                                          _emailController.text,
                                          _passwordController.text,
                                        );
                                      }
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.login,
                                      style: TextStyle(
                                        color: theme.colorScheme.onPrimary,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                          const SizedBox(height: 24),

                          // Divider
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: theme.colorScheme.onSurface.withOpacity(0.2),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  AppLocalizations.of(context)!.or,
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: theme.colorScheme.onSurface.withOpacity(0.2),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Sign Up Prompt
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.dontHaveAccount,
                                style: theme.textTheme.bodyMedium,
                              ),
                              TextButton(
                                onPressed: () => widget.onRegister(),
                                style: TextButton.styleFrom(
                                  foregroundColor: theme.colorScheme.primary,
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.signUp,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}