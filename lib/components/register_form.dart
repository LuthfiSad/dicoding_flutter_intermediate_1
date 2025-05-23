import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:intermediate_flutter/localization/main.dart';
import 'package:intermediate_flutter/provider/auth_provider.dart';

class RegisterForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const RegisterForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, value, child) {
        return Column(
          children: [
            FormBuilderTextField(
              name: AppLocalizations.of(context)!.name,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                  errorText: AppLocalizations.of(context)!.emptyName,
                ),
              ]),
              controller: nameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.name,
              ),
            ),
            FormBuilderTextField(
              name: AppLocalizations.of(context)!.email,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                  errorText: AppLocalizations.of(context)!.emptyEmail,
                ),
                FormBuilderValidators.email(
                  errorText: AppLocalizations.of(context)!.invalidEmail,
                ),
              ]),
              controller: emailController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.email,
              ),
            ),
            FormBuilderTextField(
              name: AppLocalizations.of(context)!.password,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                  errorText: AppLocalizations.of(context)!.emptyPassword,
                ),
                FormBuilderValidators.minLength(
                  8,
                  errorText: AppLocalizations.of(context)!.passwordLength,
                ),
              ]),
              controller: passwordController,
              obscureText: value.isPasswordVisible,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.password,
                suffixIcon: IconButton(
                  onPressed: () {
                    value.setIsPasswordVisible(
                      !value.isPasswordVisible,
                    );
                  },
                  icon: Icon(
                    value.isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
