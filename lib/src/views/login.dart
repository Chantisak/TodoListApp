import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:todo_list/src/views/home.dart';
import 'package:todo_list/src/views/register.dart';

import '../constants/constants.dart';
import '../services/local_storage_service.dart';
import '../services/network_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _passwordVisible = false;
  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
     
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30,),
              Image.asset(
                'assets/images/to-do-list 1.png',
                height: 80,
              ),
              Text(
                'ToDoList',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 30,),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Constant.WHITE_COLOR,
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.all(16),
                        isDense: false,
                        hintText: 'ชื่อผู้ใช้',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        )),
                    controller: usernameController),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    obscureText: !_passwordVisible, //ซ่อนรหัสผ่าน
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Constant.WHITE_COLOR,
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.all(16),
                        isDense: false,
                        hintText: 'รหัสผ่าน',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.red,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        )),
                    controller: passwordController),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      NetworkService()
                          .login(
                        usernameController.text.trim(),
                        passwordController.text.trim(),
                      )
                          .then((value) async {
                        if (value.status == 'Ok') {
                          // Obtain shared preferences.

                          LocalStorageService()
                              .setUserInfo(value.name ?? '', value.token ?? '');
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const Home()),
                              (Route<dynamic> route) => false);
                        } else {
                          const snackBar = SnackBar(
                            content: Text('รหัสผ่านไม่ถูกต้อง'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      });
                    },
                    child: Text('เข้าสู่ระบบ'),
                  ),
                ),
              ),
              Spacer(),
              Text(
                'หากยังไม่มีบัญชี',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Register()),
                    );
                  },
                  child: Text(
                    'สมัครใช้งาน',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.red),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
