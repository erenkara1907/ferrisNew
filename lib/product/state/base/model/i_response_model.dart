/// Interface for response models. data part of all response models should
/// implement this interface.
abstract class IResponseModel {
  IResponseModel();

  IResponseModel.fromMap(Map<String, dynamic> map);

  IResponseModel.fromJson(String json);
}
