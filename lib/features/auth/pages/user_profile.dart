import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProfileScreen(
      actions: [
        SignedOutAction((context) {
          Navigator.of(context).pop();
        })
      ],
      providerConfigs: const [
        EmailProviderConfiguration(), //fmfn
        GoogleProviderConfiguration(
          clientId: '...',
        ),
      ],
      avatarSize: 24,
    );
  }
}
