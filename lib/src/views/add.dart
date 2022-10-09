import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:todo_list/src/services/network_service.dart';

import '../constants/constants.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  TextEditingController nameController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('เพิ่มข้อมูล'),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
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
                SizedBox(
                  height: 5,
                ),
                TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Constant.WHITE_COLOR,
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.all(16),
                        isDense: false,
                        hintText: 'เนื้อหา',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        )),
                    controller: titleController),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      NetworkService()
                          .add(nameController.text, titleController.text)
                          .then((value) {
                            print(value.result);
                        if (value.result == 'ok') {Navigator.pop(context);
                        } else {
                           const snackBar = SnackBar(
                            content: Text('เกิดข้อผิดพลาด'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      });
                    
                    },
                    child: Text('บันทึก'),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
