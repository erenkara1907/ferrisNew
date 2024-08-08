class ValueController<T> {
  T value;

  ValueController(this.value);

  @override
  bool operator ==(Object other) {
    if (other is ValueController) {
      return value == other.value;
    }
    return false;
  }

  @override
  int get hashCode => value.hashCode;
}
