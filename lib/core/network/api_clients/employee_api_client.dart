import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'employee_api_client.g.dart';

@RestApi()
abstract class EmployeeApiClient {
  factory EmployeeApiClient(Dio dio, {String baseUrl}) = _EmployeeApiClient;

  @GET('/employees')
  Future<HttpResponse<dynamic>> getEmployees();

  @GET('/employees/{id}')
  Future<HttpResponse<dynamic>> getEmployee(@Path('id') String id);

  @POST('/employees')
  Future<HttpResponse<dynamic>> createEmployee(
    @Body() Map<String, dynamic> body,
  );

  @PUT('/employees/{id}')
  Future<HttpResponse<dynamic>> updateEmployee(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/employees/{id}')
  Future<HttpResponse<dynamic>> deleteEmployee(@Path('id') String id);
}
