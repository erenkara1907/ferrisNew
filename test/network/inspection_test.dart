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

  test("Inspection Index", () async {
    final response = await client.get(
      ServicePath.jobInspections.value,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    expect(response.data, isNotNull);
  });

  test("Inspection Show", () async {
    final response = await client.get(
      "${ServicePath.jobInspections.value}/760",
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    expect(response.data, isNotNull);
  });

  test("Inspection Update", () async {
    final response = await client.post(
      "${ServicePath.jobInspectionsUpdate.value}/760",
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
      data: {
        "odoReading": "10",
        "fuelLevel": "20",
      },
    );

    expect(response.data, isNotNull);
  });

  test("Inspection Abort Types", () async {
    final response = await client.get(
      ServicePath.jobInspectionsAbortTypes.value,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    expect(response.data, isNotNull);
  });

  // TODO: I will send customer signature image to API
  test("Inspection Customer Sign", () async {
    final response = await client.post(
      "${ServicePath.jobInspectionsCustomerSign.value}/760",
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
      data: {
        "customerSignatureImg": "",
        "customerSignerName": "test",
        "customerSignLatitude": "20",
        "customerSignLongitude": "20",
        "date": "2024-09-10 10:46:19",
      },
    );

    expect(response.data, isNotNull);
  });

  // TODO: I will send inspector signature image to API
  test("Inspection Inspector Sign", () async {
    final response = await client.post(
      "${ServicePath.jobInspectionsInspectorSign.value}/760",
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
      data: {
        "inspectorSignatureImg": "",
        "inspectorSignerName": "test",
        "inspectorSignLongitude": "20",
        "inspectorSignLatitude": "20",
        "date": "2024-09-10 10:46:19",
      },
    );

    expect(response.data, isNotNull);
  });
}
