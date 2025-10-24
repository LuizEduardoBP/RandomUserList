import 'package:hive/hive.dart';
import 'package:random_user_list/core/models/user_model.dart';
import '../../../../main.dart';

abstract class IUserLocalDataSource {
  Future<List<UserModel>> getUsers(bool isTemp);
  Future<void> saveUser(UserModel user, bool isTemp);
  Future<void> deleteUser(UserModel user, bool isTemp);
}

class UserLocalDataSource implements IUserLocalDataSource {
  final Box<List<dynamic>> _userTempBox;
  final Box<List<dynamic>> _userPersistedBox;

  UserLocalDataSource()
      : _userTempBox = Hive.box<List<dynamic>>(userTempBox),
        _userPersistedBox = Hive.box<List<dynamic>>(userPersistedBox);

  static const String _tempUserListKey = 'temp_users';
  static const String _persistedUserListKey = 'persisted_users';

  @override
  Future<List<UserModel>> getUsers(bool isTemp) async {
    if (isTemp) {
      final userList = _userTempBox.get(_tempUserListKey) ?? [];
      return userList.cast<UserModel>().toList();
    } else {
      final userList = _userPersistedBox.get(_persistedUserListKey) ?? [];
      return userList.cast<UserModel>().toList();
    }
  }

  @override
  Future<void> saveUser(UserModel user, bool isTemp) async {
    if (isTemp) {
      final userList = await getUsers(isTemp);
      userList.add(user);
      await _userTempBox.put(_tempUserListKey, userList);
      print('Usuário temporario ${user.name.fullName} salvo. Total de usuários: ${userList.length}');
    } else {
      final userList = await getUsers(isTemp);
      userList.add(user);
      await _userPersistedBox.put(_persistedUserListKey, userList);
      print('Usuário ${user.name.fullName} Persistido. Total de usuários: ${userList.length}');
    }
  }

  @override
  Future<void> deleteUser(UserModel userToDelete, bool isTemp) async {
    if (isTemp) {
      final userList = await getUsers(isTemp);
      userList.removeWhere((user) => user.email == userToDelete.email);
      await _userTempBox.put(_tempUserListKey, userList);
      print('Usuário temporario ${userToDelete.name.fullName} removido.');
    } else {
      final userList = await getUsers(isTemp);
      userList.removeWhere((user) => user.email == userToDelete.email);
      await _userPersistedBox.put(_persistedUserListKey, userList);
      print('Usuário ${userToDelete.name.fullName} removido.');
    }
  }
}
