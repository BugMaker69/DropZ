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
                    color: Colors.white.withOpacity(.2),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome back,",
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        Text(
                          "Login To Continue",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),

                        const SizedBox(height: 16),

                        CustomTextEdit(
                          labelText: "Email address",
                          validator: Validators.validateEmail,
                          textController: _emailController,
                          // onChanged: (value) {
                          //   print("value $value");
                          //   context.read<LoginCubit>().emailChanged(value);
                          // },
                        ),

                        const SizedBox(height: 16),

                        CustomTextEdit(
                          labelText: "Password",
                          isPassword: true,
                          // validator: Validators.validatePassword,
                          textController: _passwordController,
                          // onChanged: (value) {
                          //   print("value $value");
                          //   context.read<LoginCubit>().passwordChanged(value);
                          // },
                        ),

                        const SizedBox(height: 16),
                        CustomButton(
                          text: "Login",
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
                            "OR",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        CustomButton(
                          text: "Login with Google",
                          onPressed: () {},
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.onPrimary,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don’t have an account?",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () {
                                GoRouter.of(
                                  context,
                                ).push(AppRouter.kRegisterView);
                              },
                              child: Text(
                                "Sign up",
                                style: Styles.textStyle16SemiBold.copyWith(
                                  decorationStyle: TextDecorationStyle.solid,
                                  decoration: TextDecoration.underline,
                                  decorationColor: kSecondaryColor,
                                  decorationThickness: 2,
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
                Text(allRightsReserved, style: Styles.textStyle16SemiBold),
              ],
            ),
          ),
        );
      },
    );
  }
}
