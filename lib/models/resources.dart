import 'package:flutter/material.dart';

final GlobalKey<FormState> SignInKey = GlobalKey<FormState>();
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController nameController = TextEditingController();
String? email;
String? password;
String? name;
bool viewPassword = true;
dynamic person;



//
final GlobalKey<FormState> logInKey = GlobalKey<FormState>();
TextEditingController emailControllerLog = TextEditingController();
TextEditingController passwordControllerLog = TextEditingController();
String? logEmail;
String? logPassword;
bool logViewPassword = true;