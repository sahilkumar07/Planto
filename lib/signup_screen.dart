import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:planto/firebase_consts.dart';
import 'package:planto/strings.dart';
import 'package:planto/auth_controller.dart';
import 'package:planto/homepage.dart';
import 'package:planto/our_button.dart';
import 'package:planto/custom_TextField.dart';

const Color fontGrey = Color.fromRGBO(107, 115, 119, 1);
const Color redColor = Color.fromRGBO(230, 46, 4, 1);
const Color whiteColor = Color.fromRGBO(255, 255, 255, 1);
const Color lightGrey = Color.fromRGBO(230, 230, 230, 1);

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool? isCheck = false;
  var controller = Get.put(AuthController());
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordRetypeController = TextEditingController();
  var mobileController = TextEditingController();

  bool isNameValid = true;
  bool isEmailValid = true;
  bool isPasswordValid = true;
  bool isPasswordRetypeValid = true;
  bool isMobileValid = true;

  bool areFieldsFilled() {
    return nameController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty &&
        emailController.text.contains('@') &&
        passwordController.text.trim().length >= 6 &&
        passwordController.text == passwordRetypeController.text &&
        mobileController.text.trim().isNotEmpty &&
        isCheck == true;
  }

  void validateFields() {
    setState(() {
      isNameValid = nameController.text.trim().isNotEmpty;
      isEmailValid = emailController.text.trim().isNotEmpty &&
          emailController.text.contains('@');
      isPasswordValid = passwordController.text.trim().length >= 6;
      isPasswordRetypeValid =
          passwordController.text == passwordRetypeController.text;
      isMobileValid = mobileController.text.trim().isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              (context.screenHeight * 0.1).heightBox,
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 236, 233, 233)
                          .withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    10.heightBox,
                    "Welcome to Planto"
                        .text
                        .fontFamily("sans_bold")
                        .size(18)
                        .make(),
                    15.heightBox,
                    Obx(() => Column(
                          children: [
                            customTextField(
                              hint: nameHint,
                              title: name,
                              controller: nameController,
                              isPass: false,
                              errorText:
                                  isNameValid ? null : "Name cannot be empty",
                              prefixIcon: Icons.person,
                              onChanged: (_) => validateFields(),
                            ),
                            customTextField(
                              hint: emailHint,
                              title: email,
                              controller: emailController,
                              isPass: false,
                              errorText: isEmailValid ? null : "Invalid email",
                              prefixIcon: Icons.email,
                              onChanged: (_) => validateFields(),
                            ),
                            customTextField(
                              hint: passwordHint,
                              title: password,
                              controller: passwordController,
                              isPass: true,
                              errorText: isPasswordValid
                                  ? null
                                  : "Password must be 6+ chars",
                              prefixIcon: Icons.lock,
                              onChanged: (_) => validateFields(),
                            ),
                            customTextField(
                              hint: retypePassword,
                              title: 'Retype Password',
                              controller: passwordRetypeController,
                              isPass: true,
                              errorText: isPasswordRetypeValid
                                  ? null
                                  : "Passwords do not match",
                              prefixIcon: Icons.lock_outline,
                              onChanged: (_) => validateFields(),
                            ),
                            customTextField(
                              hint: '123-456-7890',
                              title: 'Mobile Number',
                              controller: mobileController,
                              isPass: false,
                              errorText: isMobileValid
                                  ? null
                                  : "Mobile number required",
                              prefixIcon: Icons.phone,
                              onChanged: (_) => validateFields(),
                            ),
          
                            5.heightBox,
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: whiteColor,
                                  activeColor: redColor,
                                  value: isCheck,
                                  onChanged: (newValue) {
                                    setState(() {
                                      isCheck = newValue;
                                    });
                                  },
                                ),
                                10.widthBox,
                                Expanded(
                                  child: RichText(
                                    text: const TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "I agree to the ",
                                          style: TextStyle(
                                            fontFamily: "sans_regular",
                                            color: fontGrey,
                                          ),
                                        ),
                                        TextSpan(
                                          text: termAndCond,
                                          style: TextStyle(
                                            fontFamily: "sans_regular",
                                            color: redColor,
                                          ),
                                        ),
                                        TextSpan(
                                          text: " & ",
                                          style: TextStyle(
                                            fontFamily: "sans_bold",
                                            color: fontGrey,
                                          ),
                                        ),
                                        TextSpan(
                                          text: privacypolicy,
                                          style: TextStyle(
                                            fontFamily: "sans_regular",
                                            color: redColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            10.heightBox,
                            controller.isloading.value
                                ? const CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(redColor),
                                  )
                                : IgnorePointer(
                                    ignoring: !areFieldsFilled(),
                                    child: Opacity(
                                      opacity: areFieldsFilled() ? 1.0 : 0.6,
                                      child: OurButton(
                                        color: areFieldsFilled()
                                            ? redColor
                                            : lightGrey,
                                        title: signup,
                                        textColor: whiteColor,
                                        onPress: () async {
                                          validateFields();
                                          if (areFieldsFilled()) {
                                            controller.isloading(true);
                                            try {
                                              await controller
                                                  .signupMethod(
                                                    email:
                                                        emailController.text,
                                                    password:
                                                        passwordController.text,
                                                    context: context,
                                                  )
                                                  .then((value) {
                                                if (value != null) {
                                                  VxToast.show(context,
                                                      msg:
                                                          'Signup successful');
                                                  Get.offAll(() => Home());
                                                }
                                              });
                                            } catch (e) {
                                              auth.signOut();
                                              VxToast.show(context,
                                                  msg: e.toString());
                                              controller.isloading(false);
                                            }
                                          } else {
                                            VxToast.show(
                                              context,
                                              msg:
                                                  'Please fill all fields correctly',
                                            );
                                          }
                                        },
                                      ).box.width(context.screenWidth - 50).make(),
                                    ),
                                  ),
                            15.heightBox,
                            RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: alreadyHaveaccount,
                                    style: TextStyle(
                                        fontFamily: "sans_bold",
                                        color: fontGrey),
                                  ),
                                  TextSpan(
                                    text: login,
                                    style: TextStyle(
                                        fontFamily: "sans_bold",
                                        color: redColor),
                                  ),
                                ],
                              ),
                            ).onTap(() {
                              Get.back();
                            }),
                            10.heightBox,
                          ],
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
