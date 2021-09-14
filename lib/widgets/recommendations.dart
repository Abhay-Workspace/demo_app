import 'package:flutter/material.dart';
import './card.dart';
import '../model/tournament.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class Recommendations extends StatefulWidget {
  Recommendations({Key? key}) : super(key: key);

  @override
  _RecommendationsState createState() => _RecommendationsState();
}

class _RecommendationsState extends State<Recommendations> {
  late Future<List<Tournament>> futureTournament;
  late List<Tournament> _tournaments = [];
  static const _pageSize = 20;
  bool flag = true;

  @override
  Widget build(BuildContext context) {
    if (flag) fetchTournament(_pageSize);
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: _tournaments.length,
      itemBuilder: (context, index) {
        return CustomCard(_tournaments[index].name,
            _tournaments[index].gameName, _tournaments[index].imageURL);
      },
    );
  }

  Future<List<Tournament>> fetchTournament(int batch) async {
    final response = await http.get(Uri.parse(
        'https://tournaments-dot-game-tv-prod.uc.r.appspot.com/tournament/api/tournaments_list_v2?limit=10&status=all'));
    if (response.statusCode == 200) {
      setState(() {
        flag = false;
        _tournaments = Tournament.parseList(
            (jsonDecode(response.body))['data']['tournaments']);
      });
      return _tournaments;
    } else {
      throw Exception('Failed to load Tournament');
    }
  }
}
