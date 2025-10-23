import 'package:hive/hive.dart';
import 'package:random_user_list/core/models/user_model.dart';
import '../../../../main.dart';

abstract class IUserLocalDataSource {
  Future<List<UserModel>> getUsers();
  Future<void> saveUser(UserModel user);
  Future<void> deleteUser(UserModel user);
}

class UserLocalDataSource implements IUserLocalDataSource {
  final Box<List<dynamic>> _userBox;

  UserLocalDataSource() : _userBox = Hive.box<List<dynamic>>(userListBox);

  static const String _userListKey = 'users';

  @override
  Future<List<UserModel>> getUsers() async {
    final userList = _userBox.get(_userListKey) ?? [];

    return userList.cast<UserModel>().toList();
  }

  @override
  Future<void> saveUser(UserModel user) async {
    final userList = await getUsers();

    userList.add(user);

    await _userBox.put(_userListKey, userList);

    print('Usuário ${user.name.fullName} salvo. Total de usuários: ${userList.length}');
  }

  @override
  Future<void> deleteUser(UserModel userToDelete) async {
    final userList = await getUsers();

    userList.removeWhere((user) => user.email == userToDelete.email);

    await _userBox.put(_userListKey, userList);

    print('Usuário ${userToDelete.name.fullName} removido.');
  }
}
