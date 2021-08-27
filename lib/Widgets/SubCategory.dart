class SubCategory {
  final int id;
  final String name;
  final String SubCategoryCode;

  const SubCategory(this.id, this.name, this.SubCategoryCode);


}

const List<SubCategory> getSubCategory = <SubCategory>[
  SubCategory(1, 'English', 'mobile'),
  SubCategory(2, "tele", 'phone'),
  SubCategory(3, 'پشتو', 'ps'),
];