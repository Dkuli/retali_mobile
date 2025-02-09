// profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retali/providers/auth_provider.dart';
import 'package:retali/widgets/main_layout.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the theme
    return MainLayout(
      theme: theme,
      currentIndex: 3,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.appBarTheme.backgroundColor,
          elevation: theme.appBarTheme.elevation,
          centerTitle: theme.appBarTheme.centerTitle,
          title: Text(
            'Profil',
            style: theme.appBarTheme.titleTextStyle,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildProfileHeader(context),
              const SizedBox(height: 24),
              buildStatisticsSection(),
              const SizedBox(height: 24),
              buildProfileMenu(context),
              const SizedBox(height: 24),
              buildSettingsSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileHeader(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        final userData = auth.userData;
        final userName = userData?['name'] ?? 'Nama Pengguna';
        final userEmail = userData?['email'] ?? 'email@example.com';
        final avatarUrl = userData?['avatar'];
        final theme = Theme.of(context); // Access the theme
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: theme.cardTheme.shape.runtimeType is RoundedRectangleBorder
                ? (theme.cardTheme.shape as RoundedRectangleBorder).borderRadius
                : BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: avatarUrl != null
                    ? NetworkImage(avatarUrl)
                    : const AssetImage('assets/default_avatar.png') as ImageProvider,
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: theme.textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      userEmail,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildStatisticsSection() {
    // Define the buildStatisticsSection method
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text('Statistics Section', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          // Add more widgets here as needed
        ],
      ),
    );
  }

  Widget buildProfileMenu(BuildContext context) {
    final theme = Theme.of(context); // Access the theme
    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: theme.cardTheme.shape.runtimeType is RoundedRectangleBorder
            ? (theme.cardTheme.shape as RoundedRectangleBorder).borderRadius
            : BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          buildMenuItem(context, Icons.person_outline, 'Informasi Pribadi', () {}),
          const Divider(height: 1),
          buildMenuItem(context, Icons.group_outlined, 'Kelompok Jamaah', () {}),
          const Divider(height: 1),
          buildMenuItem(context, Icons.history, 'Riwayat Perjalanan', () {}),
        ],
      ),
    );
  }

  Widget buildSettingsSection(BuildContext context) {
    final theme = Theme.of(context); // Access the theme
    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: theme.cardTheme.shape.runtimeType is RoundedRectangleBorder
            ? (theme.cardTheme.shape as RoundedRectangleBorder).borderRadius
            : BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          buildMenuItem(context, Icons.settings_outlined, 'Pengaturan', () {}),
          const Divider(height: 1),
          buildMenuItem(context, Icons.help_outline, 'Bantuan', () {}),
          const Divider(height: 1),
          buildMenuItem(
            context,
            Icons.logout,
            'Keluar',
            () async {
              // Show confirmation dialog
              final shouldLogout = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Konfirmasi Keluar'),
                  content: const Text('Apakah Anda yakin ingin keluar?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Keluar'),
                    ),
                  ],
                ),
              );
              if (shouldLogout == true) {
                await Provider.of<AuthProvider>(context, listen: false).logout();
                if (context.mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildMenuItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    final theme = Theme.of(context); // Access the theme
    return ListTile(
      leading: Icon(icon, color: theme.primaryColor),
      title: Text(title, style: theme.textTheme.bodyLarge),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}