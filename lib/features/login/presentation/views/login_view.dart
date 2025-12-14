import 'package:drop_z_ecommerce_app/features/login/presentation/views/widgets/login_view_body.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true, // ✅ يخلي الشاشة تطلع لفوق مع الكيبورد
        // appBar: AppBar(leading: Image.asset(AssetsData.logo)),
        // backgroundColor: kPrimaryColor,
        body: LoginViewBody(),
      ),
    );
  }
}
