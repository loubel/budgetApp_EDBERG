class Category {
  int category_id;
  String category_name;
  int category_max_amount;
  int category_current_amount;

  Category({
    this.category_id,
    this.category_name,
    this.category_max_amount,
    this.category_current_amount,
  });

  categoryMap() {
    var mapping = Map<String, dynamic>();
    mapping['category_id'] = category_id;
    mapping['category_name'] = category_name;
    mapping['category_max_amount'] = category_max_amount;
    mapping['category_current_amount'] = category_current_amount;

    return mapping;
  }
}
