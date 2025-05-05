import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intermediate_flutter/components/register_form.dart';
import 'package:intermediate_flutter/provider/auth_provider.dart';
import 'package:intermediate_flutter/localization/main.dart';
import 'package:intermediate_flutter/provider/localization_provider.dart';

class RegisterScreen extends StatefulWidget {
  final Function() onLogin;
  final Function(String name, String email, String password) onRegister;

  const RegisterScreen({
    Key? key,
    required this.onLogin,
    required this.onRegister,
  }) : super(key: key);

  static const String routeName = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
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
                      right: MediaQuery.of(context).size.width * 0.15,
                    ),
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
                              'Register',
                              style: TextStyle(
                                fontSize: 32.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Form(
                              key: formKey,
                              child: RegisterForm(
                                nameController: _nameController,
                                emailController: _emailController,
                                passwordController: _passwordController,
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            // the register button
                            value.isFetching
                                ? const CircularProgressIndicator()
                                : SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (formKey.currentState!.validate()) {
                                          value.setIsFetching(true);
                                          await widget.onRegister(
                                            _nameController.text,
                                            _emailController.text,
                                            _passwordController.text,
                                          );
                                        }
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!.register,
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.haveAccount,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: TextButton(
                                    onPressed: () => widget.onLogin(),
                                    child: Text(
                                      AppLocalizations.of(context)!.login,
                                    ),
                                  ),
                                ),
                              ],
                            )
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
                      right: MediaQuery.of(context).size.width * 0.15,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        // the children should be aligned to the center
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // the title
                          const Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Form(
                            key: formKey,
                            child: RegisterForm(
                              nameController: _nameController,
                              emailController: _emailController,
                              passwordController: _passwordController,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          // the register button
                          value.isFetching
                              ? const CircularProgressIndicator()
                              : SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        value.setIsFetching(true);
                                        await widget.onRegister(
                                          _nameController.text,
                                          _emailController.text,
                                          _passwordController.text,
                                        );
                                      }
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.register,
                                    ),
                                  ),
                                ),
                          const SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.haveAccount,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: TextButton(
                                  onPressed: () => widget.onLogin(),
                                  child: Text(
                                    AppLocalizations.of(context)!.login,
                                  ),
                                ),
                              ),
                            ],
                          )
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
