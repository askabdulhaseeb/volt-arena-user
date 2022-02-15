import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volt_arena/database/user_api.dart';
import 'package:volt_arena/models/users.dart';
import 'package:volt_arena/provider/users_provider.dart';
import 'package:volt_arena/screens/profile_screen/profile_screen.dart';
import 'package:volt_arena/widget/tools/circular_profile_image.dart';

class SearchPerson extends StatelessWidget {
  const SearchPerson({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    UserProvider _provider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          onChanged: (String value) => _provider.onSearch(value),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(0),
            prefixIcon: const Icon(CupertinoIcons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<AppUserModel>>(
        future: UserAPI().getAllUsers(),
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Facing some issues',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }
          if (snapshot.hasData) {
            // final List<AppUserModel> _users = snapshot.data ?? <AppUserModel>[];
            _provider.addUsers(snapshot.data ?? <AppUserModel>[]);
            return ListView.builder(
              itemCount: _provider.users().length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        user: _provider.users()[index],
                      ),
                    ));
                  },
                  leading: CircularProfileImage(
                    imageURL: _provider.users()[index].imageUrl ?? '',
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  horizontalTitleGap: 4,
                  title: Text(
                    _provider.users()[index].name ?? 'Fetching issue',
                  ),
                  subtitle: Text(
                    _provider.users()[index].email ?? 'facing issue',
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Color.fromARGB(255, 53, 53, 53),
                  ),
                );
              },
              // separatorBuilder: (_, __) => const Divider(height: 1),
            );
          } else {
            return const Center(
              child: SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          }
        },
      ),
    );
  }
}
