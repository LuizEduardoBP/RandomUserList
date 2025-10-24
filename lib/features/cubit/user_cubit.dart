import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/scheduler.dart';
import 'package:random_user_list/core/models/user_model.dart';
import '../../../core/data/repositories/user_repository_impl.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository _userRepository;

  late final Ticker _ticker;
  Duration _lastFetchTime = Duration.zero;
  bool _isFetching = false;

  UserCubit(
    this._userRepository, {
    required TickerProvider vsync,
  }) : super(UserInitial()) {
    _ticker = vsync.createTicker(_onTick);
  }

  void _onTick(Duration elapsed) {
    if (_isFetching) return;

    if ((elapsed - _lastFetchTime).inSeconds >= 5) {
      print('Buscando novo usuário...');
      _lastFetchTime = elapsed;
      fetchNewUser();
    }
  }

  Future<void> loadInitialUsers() async {
    try {
      emit(UserLoading());
      final users = await _userRepository.getPersistedUsers(true);
      emit(UserSuccess(users));

      if (!_ticker.isTicking) {
        _ticker.start();
      }
    } catch (e) {
      emit(UserError('Falha ao carregar usuários salvos: $e'));
    }
  }

  Future<void> loadPersistedUsers() async {
    try {
      emit(UserLoading());
      final users = await _userRepository.getPersistedUsers(true);
      emit(UserSuccess(users));
    } catch (e) {
      emit(UserError('Falha ao carregar usuários salvos: $e'));
    }
  }

  Future<void> fetchNewUser() async {
    if (_isFetching) return;

    try {
      _isFetching = true;

      if (state is! UserSuccess) {
        emit(UserLoading());
      }

      await _userRepository.fetchAndSaveNewUser(true);

      final updatedUsers = await _userRepository.getPersistedUsers(true);

      emit(UserSuccess(updatedUsers));
    } catch (e) {
      emit(UserError('Falha ao buscar novo usuário: $e'));
    } finally {
      _isFetching = false;
    }
  }

  Future<void> deleteUser(UserModel user) async {
    try {
      await _userRepository.deleteUser(user, true);

      final updatedUsers = await _userRepository.getPersistedUsers(true);

      emit(UserSuccess(updatedUsers));
    } catch (e) {
      emit(UserError('Falha ao remover usuário: $e'));
    }
  }

  Future<void> saveUser(UserModel user) async {
    try {
      await _userRepository.saveUser(user, false);
      final updatedUsers = await _userRepository.getPersistedUsers(true);

      emit(UserSuccess(updatedUsers));
    } catch (e) {
      emit(UserError('Falha ao remover usuário: $e'));
    }
  }

  @override
  Future<void> close() {
    print('Cubit fechado. Destruindo Ticker.');
    _ticker.dispose();
    return super.close();
  }
}
