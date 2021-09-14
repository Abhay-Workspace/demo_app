class User {
  final String username;
  final String name;
  final int eloRating;
  final int tournamentsPlayed;
  final int tournamentsWon;
  final int winPer;
  final String imageUrl;

  User({
    required this.username,
    required this.name,
    required this.eloRating,
    required this.tournamentsPlayed,
    required this.tournamentsWon,
    required this.winPer,
    required this.imageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      name: json['name'],
      eloRating: json['elo_rating'],
      tournamentsPlayed: json['tournaments_played'],
      tournamentsWon: json['tournaments_won'],
      winPer: json['win_per'],
      imageUrl: json['image_url'],
    );
  }
}
