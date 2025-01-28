import 'dart:convert';

class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final String userType;
  final UserInfo userInfo;

  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.userType,
    required this.userInfo,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      userType: json['userType'],
      userInfo: UserInfo.fromJson(json['userInfo']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'userType': userType,
      'userInfo': userInfo.toJson(),
    };
  }
}

class UserInfo {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final bool isEmailVerified;
  final String createdAt;
  final String updatedAt;
  final String roleId;
  final String? googleId;
  final String provider;
  final Role role;
  final dynamic client; // Nullable field
  final dynamic vendor; // Nullable field
  final Driver? driver;

  UserInfo({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.isEmailVerified,
    required this.createdAt,
    required this.updatedAt,
    required this.roleId,
    this.googleId,
    required this.provider,
    required this.role,
    this.client,
    this.vendor,
    this.driver,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      isEmailVerified: json['isEmailVerified'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      roleId: json['roleId'],
      googleId: json['googleId'],
      provider: json['provider'],
      role: Role.fromJson(json['Role']),
      client: json['Client'],
      vendor: json['Vendor'],
      driver: json['Driver'] != null ? Driver.fromJson(json['Driver']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'isEmailVerified': isEmailVerified,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'roleId': roleId,
      'googleId': googleId,
      'provider': provider,
      'Role': role.toJson(),
      'Client': client,
      'Vendor': vendor,
      'Driver': driver?.toJson(),
    };
  }
}

class Role {
  final String id;
  final String name;

  Role({
    required this.id,
    required this.name,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Driver {
  final String id;
  final String userId;
  final String licenseNumber;
  final String licenseExpiry;
  final String vehicleType;
  final String vehiclePlate;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final double latitude;
  final double longitude;
  final String phone;
  final String? profilePicture;
  final bool isAvailable;
  final bool isVerified;
  final int rating;
  final int completedDeliveries;
  final String createdAt;
  final String updatedAt;

  Driver({
    required this.id,
    required this.userId,
    required this.licenseNumber,
    required this.licenseExpiry,
    required this.vehicleType,
    required this.vehiclePlate,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.latitude,
    required this.longitude,
    required this.phone,
    this.profilePicture,
    required this.isAvailable,
    required this.isVerified,
    required this.rating,
    required this.completedDeliveries,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'],
      userId: json['userId'],
      licenseNumber: json['licenseNumber'],
      licenseExpiry: json['licenseExpiry'],
      vehicleType: json['vehicleType'],
      vehiclePlate: json['vehiclePlate'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zipCode'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      phone: json['phone'],
      profilePicture: json['profilePicture'],
      isAvailable: json['isAvailable'],
      isVerified: json['isVerified'],
      rating: json['rating'],
      completedDeliveries: json['completedDeliveries'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'licenseNumber': licenseNumber,
      'licenseExpiry': licenseExpiry,
      'vehicleType': vehicleType,
      'vehiclePlate': vehiclePlate,
      'address': address,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'profilePicture': profilePicture,
      'isAvailable': isAvailable,
      'isVerified': isVerified,
      'rating': rating,
      'completedDeliveries': completedDeliveries,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
