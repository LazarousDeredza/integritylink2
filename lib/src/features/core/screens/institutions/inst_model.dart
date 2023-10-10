import 'package:cloud_firestore/cloud_firestore.dart';

class InstModel {
  final String? id;
  final String name;
  final String email;
  final String phoneNo;
  final String address;
  final String? level;
  final String? image;
  final List? groups;
  final String? createdAt;
  final String about;
  final String pushToken;

  const InstModel({
    this.id,
    required this.name,
    required this.email,
    required this.phoneNo,
    required this.address,
    this.level,
    this.groups,
    this.image,
    this.createdAt,
    required this.about,
    required this.pushToken,
  });

  toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phoneNo,
      'address': address,
      'level': level,
      'groups': groups,
      'image': image,
      'created_at': createdAt,
      'about': about,
      'push_token': pushToken,
    };
  }

  factory InstModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    return InstModel(
      id: document.id,
      name: document.data()!['name'] ?? '',
      email: document.data()!['email'] ?? '',
      phoneNo: document.data()!['phone'] ?? '',
      address: document.data()!['address'] ?? '',
      level: document.data()!['level'] ?? '',
      groups: document.data()!['groups'] ?? [],
      image: document.data()!['image'] ?? '',
      createdAt: document.data()!['created_at'] ?? '',
      about: document.data()!['about'] ?? '',
      pushToken: document.data()!['push_token'] ?? '',
    );
  }
}
