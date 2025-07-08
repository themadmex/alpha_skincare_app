import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/screens/login_screen.dart';
import '../../auth/services/auth_service.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(authServiceProvider).currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile & History')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(user?.photoURL ?? ''),
            child: user?.photoURL == null ? const Icon(Icons.person, size: 50) : null,
          ),
          const SizedBox(height: 16),
          ListTile(title: const Text('Email'), subtitle: Text(user?.email ?? '')),
          const Divider(),
          ListTile(
            title: const Text('Scan History'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => context.go('/history'),
          ),
          ListTile(
            title: const Text('Settings'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => context.go('/settings'),
          ),
          ListTile(
            title: const Text('Sign Out'),
            leading: const Icon(Icons.logout),
            onTap: () {
              ref.read(authServiceProvider).signOut();
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }
}