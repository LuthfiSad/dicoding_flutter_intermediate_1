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
    Key? key,
    required this.onLogin,
    required this.onRegister,
  }) : super(key: key);

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
    return Consumer2<AuthProvider, LocalizationProvider>(
      builder: (context, value, localizationProvider, child) {
        return OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.landscape) {
              return Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    localizationProvider.setLocale(
                      localizationProvider.locale == const Locale('en')
                          ? const Locale('id')
                          : const Locale('en'),
                    );
                  },
                  child: const Icon(Icons.translate),
                ),
                body: Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.15,
                        right: MediaQuery.of(context).size.width * 0.15),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.1,
                          bottom: MediaQuery.of(context).size.height * 0.1,
                        ),
                        child: Column(
                          // the children should be aligned to the center
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // the title
                            const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 32.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Form(
                              key: formKey,
                              child: LoginForm(
                                emailController: _emailController,
                                passwordController: _passwordController,
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            // the login button
                            value.isFetching
                                ? const CircularProgressIndicator()
                                : SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (formKey.currentState!.validate()) {
                                          value.setIsFetching(true);
                                          widget.onLogin(
                                            _emailController.text,
                                            _passwordController.text,
                                          );
                                        }
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!.login,
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 20.0),
                            // the sign up button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.dontHaveAccount,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: TextButton(
                                    onPressed: () => widget.onRegister(),
                                    child: Text(
                                      AppLocalizations.of(context)!.signUp,
                                    ),
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
              );
            } else {
              return Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    localizationProvider.setLocale(
                      localizationProvider.locale == const Locale('en')
                          ? const Locale('id')
                          : const Locale('en'),
                    );
                  },
                  child: const Icon(Icons.translate),
                ),
                body: Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.15,
                        right: MediaQuery.of(context).size.width * 0.15),
                    child: SingleChildScrollView(
                      child: Column(
                        // the children should be aligned to the center
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // the title
                          const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          // the Email field
                          Form(
                            key: formKey,
                            child: LoginForm(
                              emailController: _emailController,
                              passwordController: _passwordController,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          // the login button
                          value.isFetching
                              ? const CircularProgressIndicator()
                              : SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        value.setIsFetching(true);
                                        widget.onLogin(
                                          _emailController.text,
                                          _passwordController.text,
                                        );
                                      }
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.login,
                                    ),
                                  ),
                                ),
                          const SizedBox(height: 20.0),
                          // the sign up button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.dontHaveAccount,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: TextButton(
                                  onPressed: () => widget.onRegister(),
                                  child: Text(
                                    AppLocalizations.of(context)!.signUp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}
