import 'package:csharp_annotations/csharp_annotations.dart';
import 'package:json_annotation/json_annotation.dart';
import 'address.dart';

part 'user.g.dart';

@CSharp()
@JsonSerializable()
class User {
  User(this.name, this.email, this.address);

  String name;
  String email;
  Address address;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
