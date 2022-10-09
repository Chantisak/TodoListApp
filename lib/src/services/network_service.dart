import 'dart:convert';
import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/src/models/todo_model.dart';

import '../models/login_model.dart';
import '../models/register_model.dart';
import '../models/response.dart';

class NetworkService {
  NetworkService._internal();
  static final NetworkService _instance = NetworkService._internal();

  factory NetworkService() => _instance;
  static final Dio _dio = Dio()
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (requestOptions, handler) async {
          requestOptions.connectTimeout = 5000;
          requestOptions.receiveTimeout = 5000;
          requestOptions.baseUrl = 'http://student.crru.ac.th/611413005/bn';

          return handler.next(requestOptions);
        },
        onResponse: (response, handler) async {
          return handler.next(response);
        },
        onError: (dioError, handler) async {
          return handler.next(dioError);
        },
      ),
    );

  Future<LoginModel> login(
    final String username,
    final String password,
  ) async {
    var formData = FormData.fromMap({
      'username': username,
      'password': password,
    });
    final response = await _dio.post(
      '/login/login.php',
      data: formData,
    );
    return loginModelFromJson(jsonEncode(response.data));
  }

  Future<RegisterModel> register(
    final String name,
    final String username,
    final String password,
  ) async {
    var formData = FormData.fromMap({
      'name': name,
      'username': username,
      'password': password,
    });
    final response = await _dio.post(
      '/login/singup.php',
      data: formData,
    );
    return registerModelFromJson(jsonEncode(response.data));
  }

  Future<List<ToDoModel>> get() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String id = prefs.getString('token') ?? '';
    final response = await _dio.get('/todo/?id=$id');
    return toDoModelFromJson(jsonEncode(response.data));
  }

  Future<ResponseModel> add(String? title, content) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String id = prefs.getString('token') ?? '';
    var formData = FormData.fromMap({
      'id': id,
      'title': title,
      'content': content,
    });
    final response = await _dio.post('/todo/post.php',data: formData,);
    return responseModelFromJson(jsonEncode(response.data));
  }
  
  Future<ResponseModel> edit(String?id, title, content) async{
    var formData = FormData.fromMap({
      'id': id,
      'title': title,
      'content': content,
    });
    final response = await _dio.post('/todo/put.php',data: formData,);
    return responseModelFromJson(jsonEncode(response.data)); 
  }

  Future<ResponseModel> delete(String?id ) async{
    var formData = FormData.fromMap({
      'id': id,
    });
    final response = await _dio.post('/todo/del.php',data: formData,);
    return responseModelFromJson(jsonEncode(response.data));
  }
}
