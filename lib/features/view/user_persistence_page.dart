import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_user_list/features/cubit/user_persistence_cubit.dart';
import 'package:random_user_list/features/view/user_detail_page.dart';

import '../../../core/api/dio_client.dart';
import '../../../core/data/datasources/user_local_datasource.dart';
import '../../../core/data/datasources/user_remote_datasource.dart';
import '../../../core/data/repositories/user_repository_impl.dart';
import '../cubit/user_state.dart';

class UserPersistencePage extends StatelessWidget {
  const UserPersistencePage({super.key});

  @override
  Widget build(BuildContext context) {
    final remoteDs = UserRemoteDataSource(dio: DioClient.instance);
    final localDs = UserLocalDataSource();
    final repository = UserRepositoryImpl(
      remoteDataSource: remoteDs,
      localDataSource: localDs,
    );

    return BlocProvider(
      create: (context) => PersistenceCubit(repository)..loadPersistedUsers(),
      child: const UserView(),
    );
  }
}

class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Usuários Persistidos'),
        ),
        body: BlocBuilder<PersistenceCubit, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is UserSuccess) {
              if (state.users.isEmpty) {
                return const Center(child: Text('Nenhum usuário persistido.'));
              }
              return ListView.builder(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  final user = state.users[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.circular(12.0),
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
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: context.read<PersistenceCubit>(),
                                      child: UserDetailPage(user: user),
                                    ),
                                  ),
                                );
                              },
                              highlightColor: Colors.grey.withOpacity(0.2),
                              splashColor: Colors.blue.withOpacity(0.1),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(user.picture.thumbnail),
                                ),
                                title: Text(user.name.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(user.email),
                              ),
                            ),
                          ),
                          VerticalDivider(width: 1.0, thickness: 1.0, color: Colors.grey[200]),
                          InkWell(
                            onTap: () {
                              context.read<PersistenceCubit>().deleteUser(user);
                            },
                            highlightColor: Colors.red.withOpacity(0.1),
                            splashColor: Colors.red.withOpacity(0.2),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(12.0),
                              bottomRight: Radius.circular(12.0),
                            ),
                            child: Container(
                              width: 60,
                              height: 80,
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                                size: 28,
                              ),
                            ),
                          ),
                        ],
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
        ));
  }
}
