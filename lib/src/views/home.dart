import 'package:flutter/material.dart';
import 'package:todo_list/src/services/network_service.dart';
import 'package:todo_list/src/views/add.dart';
import 'package:todo_list/src/views/edit.dart';

import '../models/todo_model.dart';
import '../widgets/main_drawer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        
        title: const Text('หน้าแรก'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello ToDoList',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Expanded(
                  child: FutureBuilder<List<ToDoModel>>(
                    future: NetworkService().get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data;
                        if (data!.isEmpty) {
                          return Center(
                            child: Text(
                              'คุณยังไม่ได้เพิ่ม ToDoList',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.grey),
                            ),
                          );
                        }

                        return ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final formdata = data[index];
                              return Card(
                                color: Colors.grey[200],
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            formdata.title ?? '',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall,
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Edit(formdata)),
                                                    );
                                                  },
                                                  icon: Icon(Icons.edit,
                                                      color: Colors.yellow)),
                                              IconButton(
                                                  onPressed: () {
                                                    _dialogBuilder(context,
                                                        data: formdata);
                                                  },
                                                  icon: Icon(Icons.delete,
                                                      color: Colors.red)),
                                            ],
                                          )
                                        ],
                                      ),
                                      Text(formdata.content ?? '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(color: Colors.grey)),
                                    ],
                                  ),
                                ),
                              );
                            });
                      }

                      return Container();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Add()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context, {ToDoModel? data}) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ต้องการลบข้อมูล ?'),
          content: Text('ลบข้อมูล ${data?.title} ?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('ตกลง',style: TextStyle(color: Colors.red),),
              onPressed: () {
                NetworkService().delete(data?.id ?? '').then((value) {
                  if (value.result == 'ok') {
                    Navigator.of(context).pop();
                  } else {
                    const snackBar = SnackBar(
                      content: Text('เกิดข้อผิดพลาด'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }
}
