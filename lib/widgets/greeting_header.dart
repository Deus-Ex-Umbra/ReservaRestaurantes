import 'package:flutter/material.dart';

class GreetingHeader extends StatelessWidget {
  final String userName;
  final String? profileImagePath;
  final VoidCallback? onNotificationPressed;

  const GreetingHeader({
    Key? key,
    required this.userName,
    this.profileImagePath,
    this.onNotificationPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage:
                    profileImagePath != null
                        ? AssetImage(profileImagePath!)
                        : null,
                backgroundColor: const Color.fromARGB(255, 56, 159, 243),
                child:
                    profileImagePath == null
                        ? Icon(Icons.person, color: Colors.grey[600])
                        : null,
              ),
              SizedBox(width: 12),
              Text(
                'Hello, $userName',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              size: 24,
              color: Colors.grey[600],
            ),
            onPressed: onNotificationPressed,
          ),
        ],
      ),
    );
  }
}
