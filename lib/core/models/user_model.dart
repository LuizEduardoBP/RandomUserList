import 'package:hive/hive.dart';

part 'user_model.g.dart';

class UserApiResponse {
  final List<UserModel> results;

  UserApiResponse({required this.results});

  factory UserApiResponse.fromJson(Map<String, dynamic> json) {
    final resultsList = json['results'] as List<dynamic>;
    return UserApiResponse(
      results: resultsList.map((userJson) => UserModel.fromJson(userJson)).toList(),
    );
  }
}

@HiveType(typeId: 0) // typeId único
class UserModel {
  @HiveField(0)
  final NameModel name;

  @HiveField(1)
  final LocationModel location;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final DobModel dob;

  @HiveField(4)
  final String phone;

  @HiveField(5)
  final PictureModel picture;

  @HiveField(6)
  final String nat;

  UserModel({
    required this.name,
    required this.location,
    required this.email,
    required this.dob,
    required this.phone,
    required this.picture,
    required this.nat,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: NameModel.fromJson(json['name']),
      location: LocationModel.fromJson(json['location']),
      email: json['email'] as String,
      dob: DobModel.fromJson(json['dob']),
      phone: json['phone'] as String,
      picture: PictureModel.fromJson(json['picture']),
      nat: json['nat'] as String,
    );
  }
}

@HiveType(typeId: 1)
class NameModel {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String first;

  @HiveField(2)
  final String last;

  String get fullName => '$first $last';

  NameModel({required this.title, required this.first, required this.last});

  factory NameModel.fromJson(Map<String, dynamic> json) {
    return NameModel(
      title: json['title'] as String,
      first: json['first'] as String,
      last: json['last'] as String,
    );
  }
}

@HiveType(typeId: 2)
class LocationModel {
  @HiveField(0)
  final String city;

  @HiveField(1)
  final String state;

  @HiveField(2)
  final String country;

  LocationModel({required this.city, required this.state, required this.country});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      city: json['city'] as String,
      state: json['state'] as String,
      country: json['country'] as String,
    );
  }
}

@HiveType(typeId: 3)
class DobModel {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final int age;

  DobModel({required this.date, required this.age});

  factory DobModel.fromJson(Map<String, dynamic> json) {
    return DobModel(
      date: DateTime.parse(json['date'] as String),
      age: json['age'] as int,
    );
  }
}

@HiveType(typeId: 4)
class PictureModel {
  @HiveField(0)
  final String large;

  @HiveField(1)
  final String medium;

  @HiveField(2)
  final String thumbnail;

  PictureModel({required this.large, required this.medium, required this.thumbnail});

  factory PictureModel.fromJson(Map<String, dynamic> json) {
    return PictureModel(
      large: json['large'] as String,
      medium: json['medium'] as String,
      thumbnail: json['thumbnail'] as String,
    );
  }
}
