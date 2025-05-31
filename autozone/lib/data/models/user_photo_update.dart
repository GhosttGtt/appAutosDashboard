class UserPhotoUpdate {
  final int id;
  final String photo;

  UserPhotoUpdate({
    required this.id,
    required this.photo,
  });

  factory UserPhotoUpdate.fromJson(Map<String, dynamic> json) {
    return UserPhotoUpdate(
      id: json['id'],
      photo: json['photo'],
    );
  }
}
