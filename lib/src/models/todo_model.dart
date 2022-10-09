// To parse this JSON data, do
//
//     final toDoModel = toDoModelFromJson(jsonString);

import 'dart:convert';

List<ToDoModel> toDoModelFromJson(String str) => List<ToDoModel>.from(json.decode(str).map((x) => ToDoModel.fromJson(x)));

String toDoModelToJson(List<ToDoModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ToDoModel {
    ToDoModel({
        this.id,
        this.title,
        this.content,
        this.idUser,
    });

    String? id;
    String? title;
    String? content;
    String? idUser;

    factory ToDoModel.fromJson(Map<String, dynamic> json) => ToDoModel(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        idUser: json["id_user"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "content": content,
        "id_user": idUser,
    };
}
