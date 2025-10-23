import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_user_list/features/cubit/user_cubit.dart';
import '../../../core/models/user_model.dart';

class UserDetailPage extends StatelessWidget {
  final UserModel user;

  const UserDetailPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(user.name.first),
            ElevatedButton.icon(
              onPressed: () {
                context.read<UserCubit>().deleteUser(user).then((_) {
                  Navigator.pop(context);
                });
              },
              icon: const Icon(Icons.delete),
              label: const Text('Remover Usuário'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(user.picture.large),
            ),
            const SizedBox(height: 16),
            Text(
              user.name.fullName,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              user.email,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            _buildInfoTile(
              icon: Icons.phone,
              title: 'Telefone',
              subtitle: user.phone,
            ),
            _buildInfoTile(
              icon: Icons.location_on,
              title: 'Localização',
              subtitle: '${user.location.city}, ${user.location.state} - ${user.location.country}',
            ),
            _buildInfoTile(
              icon: Icons.cake,
              title: 'Idade',
              subtitle: '${user.dob.age} anos',
            ),
            const Divider(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }
}
