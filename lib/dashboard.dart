import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:todo_application/widgets/custom_background.dart';
import 'package:todo_application/widgets/custom_button.dart';
import 'package:todo_application/widgets/custom_text_field.dart';
import 'package:todo_application/widgets/custom_text_field_label.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Dashboard extends StatefulWidget {
  final String token;

  const Dashboard({super.key, required this.token});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String userId = '';
  String username = '';
  TextEditingController _todoTitle = TextEditingController();
  TextEditingController _todoDescription = TextEditingController();

  List? items;

  final Color _primaryColor = const Color(0xFF4F46E5);
  final Color _darkTextColor = const Color(0xFF0F172A);
  final Color _bodyTextColor = const Color(0xFF475569);
  final Color _borderColor = const Color(0xFFE2E8F0);
  final Color _bgLight = const Color(0xFFF8FAFC);

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecoderToken = JwtDecoder.decode(widget.token);
    userId = (jwtDecoderToken['_id'] as String?) ?? '';
    String email = (jwtDecoderToken['email'] as String?) ?? '';
    username = email.split('@').first;
    username = username[0].toUpperCase() + username.substring(1);
    getTodoList(userId);
  }

  void addTodo() async {
    if (_todoTitle.text.isNotEmpty && _todoDescription.text.isNotEmpty) {
      var reqBody = {
        "userId": userId,
        "title": _todoTitle.text,
        "description": _todoDescription.text,
      };

      var response = await http.post(
        Uri.parse(addtodo),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody),
      );

      var jsonResponse = jsonDecode(response.body);

      print(jsonResponse['status']);

      if (jsonResponse['status']) {
        // _todoTitle.clear();
        // _todoDescription.clear();
        Navigator.pop(context);
        getTodoList(userId);
      } else {
        print('not created');
      }
    }
  }

  void updateTodo(id) async {
    if (_todoTitle.text.isNotEmpty && _todoDescription.text.isNotEmpty) {
      var reqBody = {
        "title": _todoTitle.text,
        "description": _todoDescription.text,
      };

      var response = await http.put(
        Uri.parse('$updatetodo$id'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody),
      );

      var jsonResponse = jsonDecode(response.body);

      print(jsonResponse['status']);

      if (jsonResponse['status']) {
        // _todoTitle.clear();
        // _todoDescription.clear();
        Navigator.pop(context);
        getTodoList(userId);
      } else {
        print('not updated');
      }
    }
  }

  void getTodoList(userId) async {
    // var reqBody = {"userId": userId};

    var response = await http.get(
      Uri.parse('$getusertodolist?userId=$userId'),
      headers: {"Content-Type": "application/json"},
    );
    print(response.body);

    var jsonResponse = jsonDecode(response.body);

    items = jsonResponse['success'];

    setState(() {});
  }

  void deleteItem(id) async {
    print('Deleting: $deletetodo$id'); // lägg till

    var response = await http.delete(
      Uri.parse('$deletetodo$id'),
      headers: {"Content-Type": "application/json"},
    );
    print(response.statusCode);
    print(response.body);

    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status']) {
      getTodoList(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgLight,
      body: Container(
        padding: EdgeInsets.only(top: 60, left: 30, right: 30, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Hej! 👋",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Text(
              "${username} ",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              (items ?? []).isNotEmpty
                  ? "${items!.length} Tasks"
                  : "No tasks entered",
              style: TextStyle(fontSize: 16),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: _bgLight,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: items == null
                      ? null
                      : ListView.builder(
                          itemCount: items!.length,
                          itemBuilder: (context, int index) {
                            return Slidable(
                              key: const ValueKey(0),
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                dismissible: DismissiblePane(
                                  onDismissed: () {
                                    deleteItem('${items![index]['_id']}');
                                  },
                                ),
                                children: [
                                  SlidableAction(
                                    backgroundColor: Colors.red,
                                    foregroundColor: _bgLight,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                    onPressed: (BuildContext context) {
                                      print('${items![index]['_id']}');
                                    },
                                  ),
                                ],
                              ),
                              child: Card(
                                margin: EdgeInsets.all(2),
                                borderOnForeground: false,
                                color: _bgLight,
                                child: ListTile(
                                  onTap: () => _displayTextInputDialog(
                                    context,
                                    item: items![index],
                                  ),
                                  leading: Icon(Icons.task),
                                  title: Text('${items![index]['title']}'),
                                  subtitle: Text(
                                    '${items![index]['description']}',
                                    maxLines: 3,
                                  ),
                                  trailing: Icon(Icons.arrow_back),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _darkTextColor,
        foregroundColor: _bgLight,
        onPressed: () => _displayTextInputDialog(context),
        child: Icon(Icons.add),
        tooltip: "Add todo",
      ),
    );
  }

  Future<void> _displayTextInputDialog(
    BuildContext context, {
    dynamic item,
  }) async {
    bool isEditing = item != null;
    if (isEditing) {
      _todoTitle.text = item['title'];
      _todoDescription.text = item['description'];
    } else {
      _todoTitle.clear();
      _todoDescription.clear();
    }
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            width: 300,
            height: 360,
            child: Stack(
              children: [
                CustomBackground(
                  color: _primaryColor,
                  topPosition: -60,
                  leftPosition: -60,
                  rightPosition: -60,
                  bottomPosition: -80,
                  upperBlobSize: 280,
                  lowerBlobSize: 230,
                ),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        CustomTextFieldLabel(
                          text: isEditing ? "Edit Todo" : "Add Todo",
                          bodyColor: _darkTextColor,
                          fontSize: 16,
                        ),
                        SizedBox(height: 6),
                        CustomTextField(
                          bodyColor: _bodyTextColor,
                          borderColor: _borderColor,
                          controller: _todoTitle,
                          darkColor: _darkTextColor,
                          icon: Icons.title,
                          hint: "Title",
                          primaryColor: _primaryColor,
                          maxLines: 1,
                        ),
                        SizedBox(height: 12),
                        CustomTextField(
                          bodyColor: _bodyTextColor,
                          borderColor: _borderColor,
                          controller: _todoDescription,
                          darkColor: _darkTextColor,
                          icon: Icons.description,
                          hint: "Description",
                          primaryColor: _primaryColor,
                          maxLines: 3,
                        ),

                        SizedBox(height: 12),

                        CustomButton(
                          btnColor: _darkTextColor,
                          buttonText: isEditing ? "Update" : "Save",
                          onPressedButton: () {
                            isEditing ? updateTodo(item['_id']) : addTodo();
                          },
                        ),
                        SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
