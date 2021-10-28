class User{
  String id;
  String name;
  String email;
  String password;
  String image;
  String phone;
  String address;
  String point;
  String type;
  String Location;


  User({this.id, this.name, this.email,this.phone, this.password, this.address ,this.point,this.image,this.type,this.Location});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      image: json['image'] as String,
      phone: json['phoneNumber'] as String,
      address: json['address'] as String,
      point: json['point'] as String,
      type: json['type'] as String ,
      Location: json['Location'] as String ,
     );
  }
}