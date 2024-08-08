enum ChecklistItemOption {
  yes(1),
  no(2),
  notApplicable(3);

  const ChecklistItemOption(this.value);

  static ChecklistItemOption fromValue(int value) {
    switch (value) {
      case 1:
        return ChecklistItemOption.yes;
      case 2:
        return ChecklistItemOption.no;
      case 3:
        return ChecklistItemOption.notApplicable;
      default:
        throw Exception('Invalid value for ChecklistItemOption: value: $value');
    }
  }

  /// use value property for sending to server
  final int value;

  String get label {
    switch (this) {
      case ChecklistItemOption.yes:
        return 'Yes';
      case ChecklistItemOption.no:
        return 'No';
      case ChecklistItemOption.notApplicable:
        return 'N/A';
      default:
        throw Exception('Invalid value for ChecklistItemOption: value: $value');
    }
  }
}