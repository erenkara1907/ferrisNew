import 'dart:io';

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

  test("Stop Index", () async {
    final response = await client.get(
      ServicePath.jobStops.value,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    expect(response.data, isNotNull);
  });

  test("Stop Show", () async {
    final response = await client.get(
      "${ServicePath.jobStops.value}/297",
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    expect(response.data, isNotNull);
  });

  //TODO: I will send evidence to API
  test("Stop Store", () async {
    String filePath = '../../assets/images/destination.png';
    File file = File(filePath);
    String fileName = file.path.split('/').last;

    // Dosyayı MultipartFile'a dönüştür
    MultipartFile multipartFile =
        await MultipartFile.fromFile(file.path, filename: fileName);

    // FormData oluştur
    FormData formData = FormData.fromMap({
      "jobId": "1108",
      "reason": "test",
      "longitude": "151.209290",
      "latitude": "-33.868820",
      "categoryId": "3",
      "evidence": multipartFile, // Dosya burada gönderiliyor
    });

    // API'ye POST isteği at
    final response = await Dio().post(
      ServicePath.jobStops.value,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
      data: formData, // FormData'yı burada kullanıyoruz
    );

    // Yanıtı kontrol et
    expect(response.data, isNotNull);
  });

  test("Stop Update", () async {
    final response = await client.post(
      "${ServicePath.jobStops.value}/297",
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
      data: {"reason": "New York, ABD"},
    );

    expect(response.data, isNotNull);
  });

  test("Stop Delete", () async {
    final response = await client.delete(
      "${ServicePath.jobStops.value}/297",
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
