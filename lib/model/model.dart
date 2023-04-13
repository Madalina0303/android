class UserModel {
  int user_id = 0;
  String user_name = 'admin';
  String password = 'admin';
  int punctaj = 0;

  UserModel(this.user_id, this.user_name, this.password, this.punctaj);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'user_id': user_id,
      'user_name': user_name,
      'password': password,
      'punctaj': punctaj
    };
    return map;
  }

  UserModel.fromMap(Map<String, dynamic> map) {
    user_id = map['user_id'];
    user_name = map['user_name'];
    password = map['password'];
    punctaj = map['punctaj'];
  }
}
