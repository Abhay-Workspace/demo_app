class Tournament {
  final String name;
  final String gameName;
  final String imageURL;

  Tournament({
    required this.name,
    required this.gameName,
    required this.imageURL,
  });

  factory Tournament.fromJson(Map<String, dynamic> json) {
    return Tournament(
      name: json['name'],
      gameName: json['game_name'],
      imageURL: json['cover_url'],
    );
  }
  static List<Tournament> parseList(List<dynamic> list) {
    return list.map((i) => Tournament.fromJson(i)).toList();
  }
}
