import 'package:chatapp_flutter/helpers/helper_function_class.dart';
import 'package:flutter/material.dart';

import '../../helpers/firebase_auth_helper.dart';
import '../../models/resources.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.deepPurple.shade200,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 45),
              child: Expanded(
                flex: 4,
                child: Container(
                  color: Colors.deepPurple.shade200,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20, left: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                color: Colors.black),
                          ),
                        ),
                        Center(
                          child: Icon(
                            Icons.supervised_user_circle,
                            size: 170,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Container(
                decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          offset: Offset(-1, -2),
                          blurRadius: 15),
                    ],
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(70))),
                child: Form(
                  key: SignInKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'User name',
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.bold),
                              contentPadding: EdgeInsets.all(25),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Icon(
                                  Icons.person,
                                  size: 25,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              fillColor: Colors.grey.shade200,
                              focusColor: Colors.grey.shade200,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                                borderSide:
                                    const BorderSide(color: Colors.white),
                              ),
                            ),
                            controller: nameController,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please enter your name...';
                              }
                              return null;
                            },
                            onSaved: (val) {
                              name = val;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'User email',
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.bold),
                              contentPadding: EdgeInsets.all(25),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Icon(
                                  Icons.email_rounded,
                                  size: 25,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              fillColor: Colors.grey.shade200,
                              focusColor: Colors.grey.shade200,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                                borderSide:
                                    const BorderSide(color: Colors.white),
                              ),
                            ),
                            controller: emailController,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please enter your Email...';
                              }
                              return null;
                            },
                            onSaved: (val) {
                              email = val;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.bold),
                              contentPadding: const EdgeInsets.all(25),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Icon(
                                  Icons.password,
                                  size: 25,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              fillColor: Colors.grey.shade200,
                              focusColor: Colors.grey.shade200,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                                borderSide:
                                    const BorderSide(color: Colors.white),
                              ),
                              suffix: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    {
                                      if (viewPassword == true) {
                                        viewPassword = false;
                                      } else {
                                        viewPassword = true;
                                      }
                                    }
                                  });
                                },
                                child: (viewPassword == true)
                                    ? const Icon(
                                        Icons.remove_red_eye_outlined,
                                        size: 20,
                                        color: Colors.grey,
                                      )
                                    : const Icon(
                                        Icons.remove_red_eye,
                                        size: 20,
                                        color: Colors.grey,
                                      ),
                              ),
                            ),
                            obscuringCharacter: '*',
                            obscureText: viewPassword,
                            controller: passwordController,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please enter your password...';
                              }
                              return null;
                            },
                            onSaved: (val) {
                              setState(() {
                                password = val;
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: GestureDetector(
                            onTap: () {},
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade600),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shadowColor: MaterialStateProperty.all(
                                Colors.black,
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                Colors.deepPurple,
                              ),
                            ),
                            onPressed: () async {
                              if (SignInKey.currentState!.validate()) {
                                SignInKey.currentState!.save();
                                Map<String, dynamic> res =
                                    await FirebaseAuthHelper.firebaseAuthHelper
                                        .createUserWithEmailPassword(
                                            fullName: name,
                                            email: email,
                                            password: password);
                                if (res['error'] != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.red,
                                      content: Text(
                                        '${res['error']}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                } else if (res['user'] != null) {
                                  person = res['user'];
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.green,
                                      content: Text(
                                        'Successfully Sign Up',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                  await helperFunction
                                      .savedUserLoggedInStatus(true);
                                  await helperFunction.savedUserEmail(email!);
                                  await helperFunction.savedUserName(name!);
                                  Navigator.pushReplacementNamed(context, '/');
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.red,
                                      content: Text(
                                        'Unsuccessful operation',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                            child: const SizedBox(
                              height: 60,
                              width: double.infinity,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
