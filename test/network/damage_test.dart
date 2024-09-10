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

  test("Damage Index", () async {
    final response = await client.get(
      ServicePath.jobInspectionsDamages.value,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    expect(response.data, isNotNull);
  });

  test("Damage Show", () async {
    final response = await client.get(
      "${ServicePath.jobInspectionsDamages.value}/458",
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    expect(response.data, isNotNull);
  });

  //TODO: I will send damage image and context image to API
  test("Damage Store", () async {
    final response = await client.post(ServicePath.jobInspectionsDamages.value,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          "jobInspectionId": "1108",
          "categoryId": "1",
          "partId": "14",
          "issueId": "38",
          "failureId": "1486",
          "repairId": "1660",
          "damageImage": "file",
          "contextImage": "file",
        });

    expect(response.data, isNotNull);
  });

  test("Damage Delete", () async {
    final response = await client.delete(
      ServicePath.jobInspectionsDamages.value,
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
