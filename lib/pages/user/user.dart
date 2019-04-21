class User {
  int id;
  String name;
  String birthDate;
  String email;

  User();

  User.fromJson(Map<String, dynamic> json) :
    id = json['id'],
    name = json['name'],
    email = json['email'],
    birthDate = json['birthDate'];

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'email': email,
    'birthDate': birthDate
  };
}