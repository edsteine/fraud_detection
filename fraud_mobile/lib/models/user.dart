class User {
  final String username;
  final String id;
  final String _password; // Make password private
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final String? address;
  final String? country;
  final String? imageUrl;

  User({
    required this.username,
    required String password, // Accept password as a parameter
    this.firstName,
    this.lastName,
    required this.id,
    this.email,
    this.phoneNumber,
    this.address,
    this.country,
    this.imageUrl,
  }) : _password = password; // Initialize private password field

  // Factory constructor to create a User object from a JSON map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] ?? '', // Default to an empty string if null
      password: json['password'] ?? '', // Default to an empty string if null
      firstName: json['firstName'],
      lastName: json['lastName'],
      id: json['id'].toString(),
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      country: json['country'],
      imageUrl: "https://randomuser.me/api/portraits/women/1.jpg",
    );
  }

  // Convert User object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'id': id,
      'password': _password, // Return the private password field
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'imageUrl': imageUrl,
      'country': country,
    };
  }

  // Example of a method to hash the password (using a hypothetical hashing function)
  String hashPassword(String password) {
    // Implement a secure hashing algorithm here
    return password; // Placeholder for actual hashed password
  }
}
