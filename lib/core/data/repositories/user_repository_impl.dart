import 'package:random_user_list/core/models/user_model.dart';

import '../datasources/user_local_datasource.dart';
import '../datasources/user_remote_datasource.dart';

abstract class UserRepository {
  Future<List<UserModel>> getPersistedUsers();
  Future<UserModel> fetchAndSaveNewUser();
  Future<void> deleteUser(UserModel user);
}

class UserRepositoryImpl implements UserRepository {
  final IUserRemoteDataSource remoteDataSource;
  final IUserLocalDataSource localDataSource;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<UserModel>> getPersistedUsers() async {
    return await localDataSource.getUsers();
  }

  @override
  Future<UserModel> fetchAndSaveNewUser() async {
    try {
      final userListFromApi = await remoteDataSource.getUser();
      if (userListFromApi.isEmpty) {
        throw Exception('API não retornou usuários.');
      }
      final newUser = userListFromApi.first;

      await localDataSource.saveUser(newUser);

      return newUser;
    } catch (e) {
      print('Erro no repositório: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteUser(UserModel user) async {
    await localDataSource.deleteUser(user);
  }
}
