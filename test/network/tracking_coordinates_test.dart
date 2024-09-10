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

  /// Timeout Exception
  test("Tracking Coordinates Index", () async {
    final response = await client.get(
      ServicePath.jobTrackings.value,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    expect(response.data, isNotNull);
  });

  test("Tracking Coordinates Show", () async {
    final response = await client.get(
      "${ServicePath.jobTrackings.value}/?jobId=1108",
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    expect(response.data, isNotNull);
  });

  test("Tracking Coordinates Store", () async {
    final response = await client.post(
      ServicePath.jobTrackings.value,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
      data: {"jobId": 1108, "latitude": "41.102094", "longitude": "28.802943"},
    );

    expect(response.data, isNotNull);
  });

  test("Tracking Coordinates Bulk", () async {
    final response = await client.post(
      ServicePath.jobTrackingsBulk.value,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
      data: {
        "jobId": 1069,
        "cordinates": [
          {
            "latitude": "55.067154",
            "longitude": "-1.465417",
            "addedTime": 1723322417
          }
        ]
      },
    );

    expect(response.data, isNotNull);
  });
}
