import 'package:flutter/material.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';

class UserUpsertScreen extends StatelessWidget {
  final User? user;

  const UserUpsertScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ScreenWrapper(child: Center(child: AppText('UserUpsertScreen'))),
    );
  }
}
