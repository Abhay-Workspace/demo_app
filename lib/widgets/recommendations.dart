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
  int _pageSize = 10;
  bool flag = true;
  bool _error = false;
  bool _loading = false;
  bool loadingComplete = false;
  final int _nextPageThreshold = 5;

  @override
  void initState() {
    super.initState();
    fetchTournament(_pageSize).whenComplete(() => loadingComplete = true);
    _loading = true;
    _error = false;
  }

  @override
  Widget build(BuildContext context) {
    return getBody();
  }

  Future<List<Tournament>> fetchTournament(int batch) async {
    final response = await http.get(Uri.parse(
        'https://tournaments-dot-game-tv-prod.uc.r.appspot.com/tournament/api/tournaments_list_v2?limit=' +
            batch.toString() +
            '&status=all'));
    if (response.statusCode == 200) {
      setState(() {
        flag = false;
        _loading = false;
        _error = true;
        _tournaments = Tournament.parseList(
            (jsonDecode(response.body))['data']['tournaments']);
        _pageSize += 5;
      });
      return _tournaments;
    } else {
      throw Exception('Failed to load Tournament');
    }
  }

  Widget getBody() {
    if (_tournaments.isEmpty) {
      if (_loading) {
        return Center(
            child: Padding(
          padding: const EdgeInsets.all(8),
          child: CircularProgressIndicator(),
        ));
      } else if (_error) {
        return Center(
            child: InkWell(
          onTap: () {
            setState(() {
              _loading = true;
              _error = false;
              fetchTournament(_nextPageThreshold)
                  .whenComplete(() => loadingComplete = true);
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text("Error while loading tournaments, tap to try agin"),
          ),
        ));
      }
    } else {
      // if (_tournaments.isEmpty) return CircularProgressIndicator();
      return Column(
        children: <Widget>[
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _tournaments.length,
            itemBuilder: (context, index) {
              if (index == _tournaments.length - _nextPageThreshold) {
                fetchTournament(_pageSize)
                    .whenComplete(() => loadingComplete = true);
              }
              if (index == _tournaments.length) {
                if (_error) {
                  return Center(
                      child: InkWell(
                    onTap: () {
                      setState(() {
                        _loading = true;
                        _error = false;
                        fetchTournament(_nextPageThreshold)
                            .whenComplete(() => loadingComplete = true);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                          "Error while loading tournaments, tap to try agin"),
                    ),
                  ));
                }
              }
              return CustomCard(_tournaments[index].name,
                  _tournaments[index].gameName, _tournaments[index].imageURL);
            },
          ),
          CircularProgressIndicator(),
        ],
      );
    }
    return Container();
  }
}
