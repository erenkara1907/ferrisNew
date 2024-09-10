import 'package:dio/dio.dart';
import 'package:ferrisfwt/product/manager/network/index.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  String token = "60bffe91-185f-4eca-886e-c2d945789a65";
  late final NetworkClient client;
  setUp(() {
    client =
        NetworkClient(dio: Dio(), baseUrl: "https://dev.fwtsolutions.co.uk");
  });

  test("Stop Categories Index", () async {
    final response = await client.get(
      ServicePath.jobsStopCategories.value,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    expect(response.data, isNotNull);
  });
}
