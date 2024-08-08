enum CategoryIcon {
  ELECTRONICS,
  JEWELERY,
  MENS_CLOTHING,
  WOMENS_CLOTHING,
}

extension CategoryIconValuesExtension on CategoryIcon {
  static CategoryIcon fromCategoryName(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case "electronics":
        return CategoryIcon.ELECTRONICS;
      case "jewelery":
        return CategoryIcon.JEWELERY;
      case "men's clothing":
        return CategoryIcon.MENS_CLOTHING;
      case "women's clothing":
        return CategoryIcon.WOMENS_CLOTHING;
      default:
        return CategoryIcon.ELECTRONICS; 
    }
  }
}
