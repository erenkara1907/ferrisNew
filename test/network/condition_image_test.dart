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

  // TODO: I will send condition image to API
  test("Condition Image Store", () async {
    final response = await client.post(ServicePath.jobConditionImage.value,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          "jobInspectionId": "1108",
          "image": "",
        });

    expect(response.data, isNotNull);
  });

  test("Condition Image Delete", () async {
    final response = await client.delete(
      "${ServicePath.jobConditionImage.value}/30",
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
