import 'package:dio/dio.dart';
import 'package:ferrisfwt/product/manager/network/core/product_service_path.dart';
import 'package:ferrisfwt/product/manager/network/manager/network_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  String token = "60bffe91-185f-4eca-886e-c2d945789a65";
  late final NetworkClient client;
  setUp(() {
    client =
        NetworkClient(dio: Dio(), baseUrl: "https://dev.fwtsolutions.co.uk");
  });

  test("Login", () async {
    final response = await client.post(
      ServicePath.login.value,
      queryParameters: {
        "email": "office@yunggroup.com",
        "password": "FerrisOffice327\$",
      },
      options: Options(
        headers: {'Accept': 'application/json'},
      ),
    );

    expect(response.data, isNotNull);
  });

  test("Verify OTP", () async {
    final response = await client.post(
      ServicePath.verifyOtp.value,
      queryParameters: {
        "userId": "14",
        "token":
            "AYABeKm7AMM1zmOWu_Px8DH2s9gAHQABAAdTZXJ2aWNlABBDb2duaXRvVXNlclBvb2xzAAEAB2F3cy1rbXMAS2Fybjphd3M6a21zOmV1LXdlc3QtMjo1MDA3OTI3NjA3NTc6a2V5LzBhNjgxMWMyLThjY2YtNDBkMi04NjU0LTExNzM2Y2YyZmM0NQC4AQIBAHj46-_t327XTraE8SD_shwsH1Yq1Icb9FDnGG0l5sDaWQFeTqdYdxLfe9Y3xEv-sxz-AAAAfjB8BgkqhkiG9w0BBwagbzBtAgEAMGgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMG2Dsq8tP5nTokvKqAgEQgDtO_BQX3yb6vWxRpqHoJN84CUL4w8XCtl8I6ns46YD1Nl31SDGLKnhzb5YvFnREkrJWyQwWcCaKtCYdBwIAAAAADAAAEAAAAAAAAAAAAAAAAADUJrWHxCosoX4zeqrQ9oN4_____wAAAAEAAAAAAAAAAAAAAAEAAAIJnaFGXHPSdvyBSHbz-drKUuiczgtN0LRyjkCVjiool3Aahmgs4-Jazces_HQI3RNDngwTd8XCSal2EXsSKmhaxvYLN9OG1Ev6FYk3yriG1axIqLOsC_N06y4Ao3aPa6EvC32wyOeFJsAHQVa-OdeTn7ZQZj2bjYRb9A4_PEU-Hc3GK32mVHSOKOMNXn30JiVVejRzh46BitqmsQmqN4p7_43Nu9tALJW6_Iw8pZj7vpPn0WXtsCtA21sG5KWBR09XgboKm270tgKpD49z9gHx_xB6z4qh6f8paIeLnYDqctkabLJRWZmzAT2Ywk3hJ3JXgEV0iPkDwXeolY4ZYw8I95c0p8ldr4ZzS-x13YOrXisrvIPpcPBCTwHYS8hUlIgUhAglXkhtW0Jk--RBqeAXtOPZRBPWStEiXmTy8nXqE-EHXhckYmV_vtm3L5O8kX2BD_jJl1C5xJvVVL_G1qknMdAMtowJqUpzmoy_JXav0VAVp-37IMIr0eLdXGRnaTeRG9xSWuXuoGj8TjnbeKNSns1OL4d47alhLlT-Y_re6wdXPQsmNWYronRPe7dX7pDtET7CLCsZY6JP1rVCyKp4nEXw-iAbrWB8RyncrO-AZW-twWI_-TvaMaAgmKijrreN3wTykjERuZFTb37D1cvh8FrBmCSxXcVbft_RCUznGZJ3n6T_NYru-TWHc09EaaGHpzt4E1z505PJ",
        "code": "713361"
      },
      options: Options(
        headers: {'Accept': 'application/json'},
      ),
    );

    expect(response.data, isNotNull);
  });

  test("Get User", () async {
    final response = await client.post(
      ServicePath.getUser.value,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    expect(response.data, isNotNull);
  });

  test("Logout", () async {
    final response = await client.post(
      ServicePath.logout.value,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    expect(response.data, isNotNull);
  });

  test("Set Device Token", () async {
    final response = await client.post(ServicePath.setDeviceToken.value,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          "deviceToken":
              "dy0Idmfg6UpgjpdQ1E-e1a:APA91bGLGPg_oUqs8x9TUf0Yy1B2V_k3qu5sQuEEDA_e4YyMRiY9E7YHXF2ef279ZkpBHKP6OYf-dwnGEV_sjnd2iZ1uoYH8HoNIQ3IWctH3yGnIAcsHpnCXJT1CwfEe9ULTCKwBiumD",
        });

    expect(response.data, isNotNull);
  });
}
