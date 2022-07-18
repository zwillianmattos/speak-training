class Category {
  Category({
    this.title = '',
    this.imagePath = '',
    this.lessonCount = 0,
    this.money = 0,
    this.rating = 0.0,
  });

  String title;
  int lessonCount;
  int money;
  double rating;
  String imagePath;

  static List<Category> popularCourseList = <Category>[
    Category(
      imagePath: 'https://cth.edu.vn/wp-content/uploads/2021/03/english-converstion-scaled.jpg',
      title: 'Common expressions',
      lessonCount: 131,
      money: 0,
      rating: 0,
    ),
  ];
}
