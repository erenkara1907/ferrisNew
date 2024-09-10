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

  test("Expense Index", () async {
    final response = await client.get(
      ServicePath.jobExpenses.value,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    expect(response.data, isNotNull);
  });

  test("Expense Show", () async {
    final response = await client.get(
      "${ServicePath.jobExpenses.value}/610",
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    expect(response.data, isNotNull);
  });

  test("Expense Store", () async {
    final response = await client.post(
      ServicePath.jobExpenses.value,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
      data: {
        "jobId": 1108,
        "categoryId": 2,
        "price": 43.21,
        "receipt": null,
        "reasonNoReceipt":
            "Et Lorem Lorem voluptate ipsum fugiat sunt et magna culpa et exercitation nostrud sit."
      },
    );

    expect(response.data, isNotNull);
  });

  test("Expense Update", () async {
    final response = await client.post(
      "${ServicePath.jobExpenses.value}/610",
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
      data: {"categoryId": 6},
    );

    expect(response.data, isNotNull);
  });

  test("Expense Delete", () async {
    final response = await client.delete(
      "${ServicePath.jobExpenses.value}/610",
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
