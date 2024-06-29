import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/api_response.dart';
import '../../services/user_service.dart';
import '../allUser.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  List<dynamic> allUser = [];
  Set<int> selectedUserIds = {};
  bool isLoading = false;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  Future<void> _getAllUser() async {
    ApiResponse response = await getMembre();
    if (response.data != null) {
      final data = jsonEncode(response.data);
      final users = jsonDecode(data)["users"];
      for (var user in users) {
        _addUser(user);
      }
    }
  }

  void _addUser(dynamic user) {
    final int index = allUser.length;
    allUser.add(user);
    _listKey.currentState?.insertItem(index);
  }

  @override
  void initState() {
    _getAllUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      initialItemCount: allUser.length,
      itemBuilder: (BuildContext context, int index, Animation<double> animation) {
        final user = allUser[index];
        return _buildItem(user, animation);
      },
    );
  }

  Widget _buildItem(dynamic user, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      axis: Axis.vertical,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.purple.withOpacity(0.1),
            width: 0.5, // très fine
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 0.2,
              blurRadius: 5,
              offset: Offset(0, 1),
            ),
          ],
        ),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey[400],
            child: Icon(
              Icons.person_outline_outlined,
              color: Colors.white,
            ),
          ),
          title: Text(
            '${user["name"]}',
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text('${user["email"]}'),
          trailing: IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
          onTap: () {},
        ),
      ),
    );
  }
}
