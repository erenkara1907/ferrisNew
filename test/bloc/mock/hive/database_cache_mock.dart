import 'package:ferrisfwt/feature/auth/data/models/user_model.dart';
import 'package:ferrisfwt/product/database/hive/core/hive_database_manager.dart';
import 'package:mockito/mockito.dart';

final class DatabaseCacheMock extends Mock implements HiveDatabaseManager {
  @override
  UserModel? getUserModel() {
    return const UserModel(userName: "test user");
  }

  @override
  Future<void> deleteUserModel() {
    return Future.value();
  }

  @override
  Future<void> saveUserModel(UserModel userModel) {
    return Future.value();
  }

  @override
  Future<void> updateToken({required String mail, required String token}) {
    return Future.value();
  }

  @override
  Future<void> saveJob(String jobId, String regnNumber) {
    return Future.value();
  }

  @override
  Future<void> saveTotalStop(int totalStop) {
    return Future.value();
  }

  @override
  Future<void> saveInspectionsJobId(List<int> inspectionsJobId) {
    return Future.value();
  }

  @override
  Future<void> saveInspectionsSign(int inspectionsId) {
    return Future.value();
  }
}
