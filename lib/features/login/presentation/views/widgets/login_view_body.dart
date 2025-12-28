import 'package:drop_z_ecommerce_app/constants.dart';
import 'package:drop_z_ecommerce_app/core/utils/Validators%20.dart';
import 'package:drop_z_ecommerce_app/core/utils/app_router.dart';
import 'package:drop_z_ecommerce_app/core/utils/styles.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_button.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_edit_text.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_app_logo_only.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_loading_indicator.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_snakebar_message.dart';
import 'package:drop_z_ecommerce_app/features/login/presentation/manager/login_cubit/login_cubit.dart';
import 'package:drop_z_ecommerce_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) async {
        if (state is LoginSuccess) {
          FocusScope.of(context).unfocus();
          await Future.delayed(const Duration(milliseconds: 80), () {});
          if (state.role.isNotEmpty) {
            GoRouter.of(context).pushReplacement(
              state.role == "seller"
                  ? AppRouter.kSellerDashboard
                  : AppRouter.kCustomerHome,
            );
          }
        } else if (state is LoginFailure) {
          CustomSnakeBar(context, state.errMessage);
        }
      },
      builder: (context, state) {
        if (state is LoginLoading) {
          CustomLoadingIndicator();
        }
        return SingleChildScrollView(
          child: IntrinsicHeight(
            child: Column(
              children: [
                const CustomAppBarLogoOnly(),
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(.2)
                        : Colors.black.withOpacity(.2),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${localizations.welcomeBack}",
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        Text(
                          "${localizations.loginToContinue}",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),

                        const SizedBox(height: 16),

                        CustomTextEdit(
                          labelText: "${localizations.email}",
                          validator: Validators.validateEmail,
                          textController: _emailController,
                        ),

                        const SizedBox(height: 16),

                        CustomTextEdit(
                          labelText: "${localizations.password}",
                          isPassword: true,
                          textController: _passwordController,
                        ),

                        const SizedBox(height: 16),
                        CustomButton(
                          isLoading: state is LoginLoading ? true : false,
                          text: "${localizations.login}",
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context
                                  .read<LoginCubit>()
                                  .loginWithEmailNPassword(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  );
                            }
                          },
                        ),
                        Center(
                          child: Text(
                            "${localizations.or}",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        CustomButton(
                          text: "${localizations.loginWithGoogle}",
                          onPressed: () {},
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.onPrimary,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${localizations.dontHaveAccount}",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () {
                                GoRouter.of(
                                  context,
                                ).push(AppRouter.kRegisterView);
                              },
                              child: Text(
                                "${localizations.signUp}",
                                style: Styles.textStyle16SemiBold.copyWith(
                                  decorationStyle: TextDecorationStyle.solid,
                                  decoration: TextDecoration.underline,
                                  decorationColor: kSecondaryColor,
                                  decorationThickness: 2,
                                  fontWeight: FontWeight.w900,
                                  // backgroundColor: Colors.grey[900],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  allRightsReserved,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SecondaryBorderedElevation extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  const SecondaryBorderedElevation({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    this.radius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(radius),

        // Border
        border: Border.all(color: kSecondaryColor, width: 2),

        // Elevation
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withOpacity(0.6)
                : Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}
