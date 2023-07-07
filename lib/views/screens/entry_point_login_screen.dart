import 'package:chatapp_flutter/helpers/helper_function_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../helpers/firebase_auth_helper.dart';
import '../../helpers/firebase_firestore.dart';
import '../../models/resources.dart';

class EntryLoginScreen extends StatefulWidget {
  const EntryLoginScreen({Key? key}) : super(key: key);

  @override
  State<EntryLoginScreen> createState() => _EntryLoginScreenState();
}

class _EntryLoginScreenState extends State<EntryLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: const [
          Icon(
            Icons.help,
            size: 25,
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Please,',
                            style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                color: Colors.black),
                          ),
                        ),
                        const Text(
                          'Log In Here to Continue...',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Center(
                          child: Icon(
                            Icons.supervised_user_circle,
                            size: 170,
                            color: Colors.deepPurple.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(-1, -2),
                        blurRadius: 15)
                  ],
                  color: Colors.deepPurple.shade200,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(70),
                  ),
                ),
                child: Form(
                  key: logInKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade500,
                                  offset: const Offset(1, 2),
                                  blurRadius: 10,
                                )
                              ],
                            ),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hoverColor: Colors.grey,
                                isDense: true,
                                isCollapsed: true,
                                hintText: 'User email',
                                hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.bold),
                                contentPadding: const EdgeInsets.all(25),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Icon(
                                    Icons.email_rounded,
                                    size: 25,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                fillColor: Colors.grey.shade50,
                                focusColor: Colors.grey.shade50,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                ),
                              ),
                              controller: emailControllerLog,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Please enter your Email...';
                                }
                                return null;
                              },
                              onSaved: (val) {
                                logEmail = val;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade500,
                                  offset: const Offset(1, 2),
                                  blurRadius: 10,
                                )
                              ],
                            ),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.bold),
                                contentPadding: const EdgeInsets.all(25),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Icon(
                                    Icons.password,
                                    size: 25,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                fillColor: Colors.grey.shade50,
                                focusColor: Colors.grey.shade50,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  borderSide: BorderSide(
                                    width: 3,
                                    color: Colors.grey.shade300,
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
                                        if (logViewPassword == true) {
                                          logViewPassword = false;
                                        } else {
                                          logViewPassword = true;
                                        }
                                      }
                                    });
                                  },
                                  child: (logViewPassword == true)
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
                              obscureText: logViewPassword,
                              controller: passwordControllerLog,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Please enter your password...';
                                }
                                return null;
                              },
                              onSaved: (val) {
                                setState(() {
                                  logPassword = val;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: GestureDetector(
                            onTap: () {},
                            child: const Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
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
                              if (logInKey.currentState!.validate()) {
                                logInKey.currentState!.save();
                                Map<String, dynamic> res =
                                    await FirebaseAuthHelper.firebaseAuthHelper
                                        .logInUser(
                                            email: logEmail,
                                            password: logPassword);
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
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.green,
                                      content: Text(
                                        'Successfully log in',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                  QuerySnapshot snapshot =
                                      await DatabaseServices(
                                              uid: FirebaseAuth
                                                  .instance.currentUser!.uid)
                                          .gettingUserData(logEmail!);

                                  await helperFunction
                                      .savedUserLoggedInStatus(true);
                                  await helperFunction
                                      .savedUserEmail(logEmail!);
                                  await helperFunction
                                      .savedUserName(snapshot.docs[0]['name']);
                                  Navigator.pushReplacementNamed(context, '/');

                                  // Navigator.pushNamedAndRemoveUntil(
                                  //     context, '/', (route) => false);
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
                                  'Sign In',
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
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, 'loginScreen');
                          },
                          child: Text(
                            'click Here to register...',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.grey.shade700,
                            ),
                          ),
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
