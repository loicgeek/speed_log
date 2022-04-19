class Quarter {
  late String id;
  late String name;
  Quarter({
    required this.id,
    required this.name,
  });

  factory Quarter.fromJson(Map<String, dynamic> json) {
    return Quarter(
      id: json['id'],
      name: json['name'],
    );
  }
}
