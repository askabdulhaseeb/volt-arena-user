import 'package:flutter/material.dart';
import 'package:volt_arena/database/user_local_data.dart';
import 'package:volt_arena/utilities/custom_images.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static const String routeName = '/ProfileScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 80),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                width: double.infinity,
                child: (UserLocalData.getUserImageUrl == '')
                    ? Image.asset(CustomImages.icon, fit: BoxFit.cover)
                    : Image.network(
                        UserLocalData.getUserImageUrl,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              UserLocalData.getUserDisplayName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              UserLocalData.getUserEmail,
              style: const TextStyle(color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}
