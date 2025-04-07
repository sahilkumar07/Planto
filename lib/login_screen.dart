import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:planto/auth_controller.dart';
import 'package:planto/homepage.dart';
import 'package:planto/signup_screen.dart';
import 'package:planto/strings.dart';
import 'package:planto/our_button.dart';
import 'package:planto/custom_TextField.dart';

const Color redColor = Color.fromRGBO(230, 46, 4, 1);
const Color lightGrey = Color.fromRGBO(230, 230, 230, 1);
const Color fontGrey = Color.fromRGBO(107, 115, 119, 1);
const Color golden = Color.fromRGBO(255, 168, 0, 1);
const Color whiteColor = Color.fromRGBO(255, 255, 255, 1);

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  (context.screenHeight * 0.1).heightBox,
                  10.heightBox,
                  "Login".text.fontFamily("sans_bold").black.size(18).make(),
                  15.heightBox,
                  Obx(
                    () => Column(
                      children: [
                        customTextField(
                          hint: emailHint,
                          title: email,
                          isPass: false,
                          controller: controller.emailController,
                          prefixIcon: Icons.email,
                        ),
                        customTextField(
                          hint: passwordHint,
                          title: password,
                          isPass: true,
                          controller: controller.passwordController,
                          prefixIcon: Icons.lock,
                        ),
                        5.heightBox,
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: forgetPass.text.make(),
                          ),
                        ),
                        10.heightBox,
                        controller.isloading.value
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(redColor),
                              )
                            : OurButton(
                                color: redColor,
                                title: login,
                                textColor: whiteColor,
                                onPress: () async {
                                  controller.isloading(true);
                                  await controller.loginMethod(context: context).then((value) {
                                    if (value != null && value.user != null) {
                                      VxToast.show(context, msg: loggedin);
                                      Get.offAll(() => const Home());
                                    } else {
                                      controller.isloading(false);
                                    }
                                  });
                                },
                              ).box.width(context.screenWidth - 50).make(),
                        10.heightBox,
                        createNewAccount.text.color(fontGrey).make(),
                        10.heightBox,
                        OurButton(
                          color: golden,
                          title: signup,
                          textColor: redColor,
                          onPress: () {
                            Get.to(() => const SignupScreen());
                          },
                        ).box.width(context.screenWidth - 50).make(),
                        15.heightBox,
                      ],
                    )
                        .box
                        .white
                        .rounded
                        .padding(const EdgeInsets.all(16))
                        .width(context.screenWidth - 70)
                        .shadowSm
                        .make(),
                  ),
                  20.heightBox,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
