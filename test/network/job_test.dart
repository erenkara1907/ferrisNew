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

  test("Job Index", () async {
    final response = await client.get(
      ServicePath.job.value,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
      queryParameters: {
        "status": "0",
        "date": "2024-09-04",
      },
    );

    expect(response.data, isNotNull);
  });

  test("Job Show", () async {
    final response = await client.get(
      "${ServicePath.job.value}/1070",
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    expect(response.data, isNotNull);
  });

  test("Confirm Job", () async {
    final response = await client.get(
      "${ServicePath.job.value}/confirm/1108",
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    expect(response.data, isNotNull);
  });

  test("Start Job", () async {
    final response = await client.post(
      "${ServicePath.job.value}/start/1108",
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
      data: {"startDate": 1708085109},
    );

    expect(response.data, isNotNull);
  });

  test("End Job", () async {
    final response = await client.post(
      "${ServicePath.job.value}/end/1107",
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
      data: {
        "endDate": 1708085162,
        "customerFeedback": "aa",
        "valetStandardId": "aa"
      },
    );

    expect(response.data, isNotNull);
  });

  test("Update Job", () async {
    final response = await client.post(
      "${ServicePath.job.value}/update/1107",
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
      data: {
        "vehicleFeedback": "Vehicle Feedback Text 1",
        "fuelChargeLevelCollection": 10,
        "fuelChargeLevelDelivery": 10
      },
    );

    expect(response.data, isNotNull);
  });
}
