import 'package:flutter/material.dart';
import 'dart:io';
import '../database/database_helper.dart';
import '../models/user.dart';
import '../themes/app_theme.dart';
import 'messages.dart';

class UsersPage extends StatefulWidget {
  final int currentUserId;
  final String currentUserName;

  const UsersPage({
    super.key,
    required this.currentUserId,
    required this.currentUserName,
  });

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<User> users = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    final result = await DatabaseHelper.instance.getAllUsers();

    setState(() {
      // Kendini listede gösterme
      users = result.where((u) => u.id != widget.currentUserId).toList();
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sohbetler"),
        centerTitle: true,
      ),

      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : users.isEmpty
              ? const Center(
                  child: Text("Kayıtlı kullanıcı bulunamadı."),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(AppTheme.pagePadding),
                  itemCount: users.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppTheme.itemSpacing),
                  itemBuilder: (context, index) {
                    final user = users[index];

                    return Card(
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 3,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                            backgroundImage:
                                user.profileImage != null &&
                                user.profileImage!.isNotEmpty &&
                                File(user.profileImage!).existsSync()
                                    ? FileImage(File(user.profileImage!))
                                    : null,
                            child:
                                user.profileImage == null ||
                                user.profileImage!.isEmpty ||
                                !File(user.profileImage!).existsSync()
                                    ? Text(
                                        user.fullName[0].toUpperCase(),
                                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black) ,
                                      )
                                    : null,
                              ),
                        ),
                        title: Text(
                          user.fullName,
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: AppTheme.bold),
                          ),

                        subtitle: Text("@${user.username}",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: AppTheme.semiBold),),

                        trailing: Icon(
                          Icons.chevron_right,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => WebSocketPage(
                                name: widget.currentUserName,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}