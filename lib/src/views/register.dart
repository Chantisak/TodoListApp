import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:todo_list/src/constants/constants.dart';

import '../services/network_service.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool _passwordVisible = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'สมัครใช้งาน',
        ),
      ),
      body: Container(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Image.asset(
                'assets/images/to-do-list 1.png',
                height: 80,
              ),
              Text(
                'ToDoList',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(
                height: 30,
              ),
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
                        hintText: 'ชื่อ',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        )),
                    controller: nameController),
              ),
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
                    obscureText: !_passwordVisible,
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
                          .register(
                        nameController.text.trim(),
                        usernameController.text.trim(),
                        passwordController.text.trim(),
                      )
                          .then((value) async {
                        if (value.result == 'ok') {
                          Navigator.pop(context);
                          const snackBar = SnackBar(
                            content: Text('สมัครสำเร็จ'),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          SnackBar snackBar = SnackBar(
                            content: Text(value.message ?? ''),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      });
                    },
                    child: Text('สมัคร'),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
