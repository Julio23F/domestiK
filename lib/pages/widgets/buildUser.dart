import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/user_provider.dart';

class UserItem extends StatelessWidget {
  final dynamic user;
  final int index;
  final bool isGrouping;
  final int? editingUserId;
  final TextEditingController nameController;
  final Function(int, String) startEditing;
  final Function stopEditing;
  final Function(int) saveChanges;
  final Widget Function(dynamic, UserProvider, int) buildPopupMenu;
  final Function(int) onItemSelected;
  final bool isSelected;

  UserItem({
    required this.user,
    required this.index,
    required this.isGrouping,
    required this.editingUserId,
    required this.nameController,
    required this.startEditing,
    required this.stopEditing,
    required this.saveChanges,
    required this.buildPopupMenu,
    required this.onItemSelected,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          leading: Icon(Icons.person),
          title: editingUserId == user["id"]
              ? TextField(
            controller: nameController,
            decoration: InputDecoration(hintText: "Nom de l'utilisateur"),
          )
              : Text(user["name"]),
          subtitle: Text(user["role"] ?? ''),
          trailing: editingUserId == user["id"]
              ? _buildEditingActions(context)
              : buildPopupMenu(userProvider, user, index),
          onTap: () {
            if (isGrouping) {
              onItemSelected(user["id"]);
            }
          },
          tileColor: isSelected ? Colors.grey.shade300 : null,
        ),
      ),
    );
  }

  Widget _buildEditingActions(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.save),
          onPressed: () => saveChanges(user["id"]),
        ),
        IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: stopEditing(),
        ),
      ],
    );
  }
}
