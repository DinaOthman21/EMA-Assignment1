class stud {
  int? id;
  String name;
  String? gender;
  String email;
  String studentId;
  int? level;
  String password;

  stud({
    this.id,
    required this.name,
    this.gender,
    required this.email,
    required this.studentId,
    this.level,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'email': email,
      'studentId': studentId,
      'level': level,
      'password': password,
    };
  }

  stud.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        gender = map['gender'],
        email = map['email'],
        studentId = map['studentId'],
        level = map['level'],
        password = map['password'];
}
