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

  test("Checklist Index", () async {
    final response = await client.get(
      "${ServicePath.jobInspectionsCheckList.value}?jobInspectionId=760",
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    expect(response.data, isNotNull);
  });

  test("Checklist Show", () async {
    final response = await client.get(
      "${ServicePath.jobInspectionsCheckList.value}/81",
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    expect(response.data, isNotNull);
  });

  test("Checklist Store", () async {
    final response = await client.post(
      ServicePath.jobInspectionsCheckList.value,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
      data: {
        "jobInspectionId": "760",
        "inflatorKit": "1",
        "evCable": "1",
        "jack": "1",
        "spareWheel": "1",
        "gelCompressorKit": "1",
        "13AmpEvChargingCable": "1",
        "hvChargingCable": "1",
        "spareKey": "1",
        "masterKey": "1",
      },
    );

    expect(response.data, isNotNull);
  });

  test("Checklist Update", () async {
    final response = await client.post(
      "${ServicePath.jobInspectionsCheckList.value}/81",
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
      data: {
        "inflatorKit": "1",
      },
    );

    expect(response.data, isNotNull);
  });
}
