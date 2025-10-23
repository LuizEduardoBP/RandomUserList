import 'package:dio/dio.dart';
import 'package:random_user_list/core/api/api_exception.dart';
import 'package:random_user_list/core/models/user_model.dart';

abstract class IUserRemoteDataSource {
  Future<List<UserModel>> getUser();
}

class UserRemoteDataSource implements IUserRemoteDataSource {
  final Dio _dio;

  UserRemoteDataSource({required Dio dio}) : _dio = dio;

  @override
  Future<List<UserModel>> getUser() async {
    try {
      final response = await _dio.get('https://randomuser.me/api/');

      if (response.statusCode == 200) {
        final userApiResponse = UserApiResponse.fromJson(response.data);

        return userApiResponse.results;
      } else {
        throw ApiException(
          message: 'Erro inesperado da API',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ApiException(
        message: 'Erro de rede: ${e.message}',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ApiException(message: 'Erro desconhecido ao fazer parse: $e');
    }
  }
}
