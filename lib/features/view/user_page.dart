import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_user_list/features/view/user_detail_page.dart';
import 'package:random_user_list/features/view/user_persistence_page.dart';

import '../../../core/api/dio_client.dart';
import '../../../core/data/datasources/user_local_datasource.dart';
import '../../../core/data/datasources/user_remote_datasource.dart';
import '../../../core/data/repositories/user_repository_impl.dart';
import '../cubit/user_cubit.dart';
import '../cubit/user_state.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> with SingleTickerProviderStateMixin {
  late UserCubit _userCubit;

  @override
  void initState() {
    super.initState();

    final remoteDs = UserRemoteDataSource(dio: DioClient.instance);
    final localDs = UserLocalDataSource();

    final repository = UserRepositoryImpl(
      remoteDataSource: remoteDs,
      localDataSource: localDs,
    );

    _userCubit = UserCubit(
      repository,
      vsync: this,
    );

    _userCubit.loadInitialUsers();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _userCubit,
      child: const UserView(),
    );
  }

  @override
  void dispose() {
    _userCubit.close();
    super.dispose();
  }
}

class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Usuários'),
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is UserSuccess) {
            if (state.users.isEmpty) {
              return const Center(child: Text('Nenhum usuário encontrado!'));
            }
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<UserCubit>(),
                          child: UserDetailPage(user: user),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user.picture.thumbnail),
                      ),
                      title: Text(user.name.fullName),
                      subtitle: Text(user.email),
                    ),
                  ),
                );
              },
            );
          }
          if (state is UserError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(state.message, textAlign: TextAlign.center),
              ),
            );
          }
          return const Center(child: Text('Bem-vindo!'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<UserCubit>(),
                child: const UserPersistencePage(),
              ),
            ),
          );
        },
        tooltip: 'Usuários persistidos',
        child: const Icon(Icons.sd_storage_sharp),
      ),
    );
  }
}
