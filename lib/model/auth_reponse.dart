import 'dart:convert';

AuthReponse loginResponseFromJson(String str) =>
    AuthReponse.fromJson(json.decode(str));

String loginResponseToJson(AuthReponse data) => json.encode(data.toJson());

class AuthReponse {
  final int id;
  final String email;

  final String userToken;

  AuthReponse({
    required this.id,
    required this.email,
    required this.userToken,
  });

  factory AuthReponse.fromJson(Map<String, dynamic> json) => AuthReponse(
        id: json["id"],
        email: json["email"],
        userToken: json["userToken"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "userToken": userToken,
      };
}
