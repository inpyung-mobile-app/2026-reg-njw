class User {
  String name;
  int? age;
  String gender;
  DateTime birth;

  User({
    required this.name,
    required this.age,
    required this.gender,
    required this.birth,
  });

  User setDate({int? year, int? month, int? day, int? hour, int? minute}) => User(
    name: name,
    age: age,
    gender: gender,
    birth: DateTime(
      year ?? birth.year,
      month ?? birth.month,
      day ?? birth.day,
      hour ?? birth.hour,
      minute ?? birth.minute,
    ),
  );

  factory User.empty() => User(
    name: '',
    age: null,
    gender: '',
    birth: DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      9,
      0,
    ),
  );
}
