import 'package:random_user_list/core/models/user_model.dart';

import '../datasources/user_local_datasource.dart';
import '../datasources/user_remote_datasource.dart';

abstract class UserRepository {
  Future<List<UserModel>> getPersistedUsers(bool isTemp);
  Future<UserModel> fetchAndSaveNewUser(bool isTemp);
  Future<void> saveUser(UserModel user, bool isTemp);
  Future<void> deleteUser(UserModel user, bool isTemp);
}

class UserRepositoryImpl implements UserRepository {
  final IUserRemoteDataSource remoteDataSource;
  final IUserLocalDataSource localDataSource;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<UserModel>> getPersistedUsers(bool isTemp) async {
    return await localDataSource.getUsers(isTemp);
  }

  @override
  Future<UserModel> fetchAndSaveNewUser(bool isTemp) async {
    try {
      final userListFromApi = await remoteDataSource.getUser();
      if (userListFromApi.isEmpty) {
        throw Exception('API não retornou usuários.');
      }
      final newUser = userListFromApi.first;

      await localDataSource.saveUser(newUser, isTemp);

      return newUser;
    } catch (e) {
      print('Erro no repositório: $e');
      rethrow;
    }
  }

  @override
  Future<void> saveUser(UserModel user, bool isTemp) async {
    await localDataSource.saveUser(user, isTemp);
  }

  @override
  Future<void> deleteUser(UserModel user, bool isTemp) async {
    await localDataSource.deleteUser(user, isTemp);
  }
}
