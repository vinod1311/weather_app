import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';

class UserModel extends  UserEntity{


  const UserModel({
    required super.uid,
    required super.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
    );
  }

  factory UserModel.fromFirebaseUser(dynamic firebaseUser) {
    return UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
    };
  }

  @override
  List<Object?> get props => [uid,email];
}