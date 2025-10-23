// features/user_list/cubit/persistence_cubit.dart
// (Crie este novo arquivo)

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/data/repositories/user_repository_impl.dart';
import '../../../core/models/user_model.dart';
import 'user_state.dart';

class PersistenceCubit extends Cubit<UserState> {
  final UserRepository _userRepository;

  PersistenceCubit(this._userRepository) : super(UserInitial());

  Future<void> loadPersistedUsers() async {
    try {
      emit(UserLoading());
      final users = await _userRepository.getPersistedUsers();
      emit(UserSuccess(users));
    } catch (e) {
      emit(UserError('Falha ao carregar usuários salvos: $e'));
    }
  }

  Future<void> deleteUser(UserModel user) async {
    try {
      await _userRepository.deleteUser(user);

      await loadPersistedUsers();
    } catch (e) {
      emit(UserError('Falha ao remover usuário: $e'));
    }
  }
}
