import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'user_api_client.g.dart';

@RestApi()
abstract class UserApiClient {
  factory UserApiClient(Dio dio, {String baseUrl}) = _UserApiClient;

  @GET('/users')
  Future<HttpResponse<dynamic>> getUsers();

  @GET('/users/{id}')
  Future<HttpResponse<dynamic>> getUser(@Path('id') String id);

  @POST('/users')
  Future<HttpResponse<dynamic>> createUser(@Body() Map<String, dynamic> body);

  @PUT('/users/{id}')
  Future<HttpResponse<dynamic>> updateUser(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/users/{id}')
  Future<HttpResponse<dynamic>> deleteUser(@Path('id') String id);
}
