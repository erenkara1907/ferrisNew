/// Interface for all network post models
abstract class INetworkSentDataModel {
  Map<String, dynamic> toMap();

  @override
  String toString() {
    return '$runtimeType(${toMap()})';
  }
}
