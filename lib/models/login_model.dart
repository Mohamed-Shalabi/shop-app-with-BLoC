class LoginModel {
  bool? status;
  String? message;
  UserDataModel? data;

  LoginModel.fromJson(Map<String, dynamic> json) {
    this.status = json['status'];
    this.message = json['message'];
    if (json['data'] != null) {
      this.data = UserDataModel.fromJson(json['data']);
    }
  }
}

class UserDataModel {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? image;
  int? points;
  int? credit;
  String? token;

  UserDataModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.email = json['email'];
    this.phone = json['phone'];
    this.image = json['image'];
    this.points = json['points'];
    this.credit = json['credit'];
    this.token = json['token'];
  }
}
