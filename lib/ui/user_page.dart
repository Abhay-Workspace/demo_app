import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widgets/achievements.dart';
import '../widgets/card.dart';
import '../widgets/recommendations.dart';
import '../model/user_details.dart';

class UserPage extends StatefulWidget {
  final String userid;

  UserPage(this.userid);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late Future<User> futureUser;

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
  }

  Future<User> fetchUser() async {
    final response = await http.get(Uri.parse(
        'https://sample-user-details.herokuapp.com/' + widget.userid));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return User.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load user details');
    }
  }

  Widget topSection(height, width, username, name, tournamentsPlayed,
          tournamentsWon, winPer, imageUrl) =>
      Container(
        height: height * 0.45,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            AppBar(
              centerTitle: true,
              title: Text(
                username,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.0,
                ),
              ),
              backgroundColor: Colors.white,
              leading: Icon(Icons.drag_handle_outlined),
              iconTheme: IconThemeData(
                size: 30.0,
                color: Colors.black,
                opacity: 10.0,
              ),
              elevation: 0.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: height * 0.05,
                horizontal: width * 0.05,
              ),
              child: Row(
                children: <Widget>[
                  leftSection(width, imageUrl),
                  middleSection(height, width, name),
                ],
              ),
            ),
            Achievments(tournamentsPlayed, tournamentsWon, winPer),
          ],
        ),
      );
  Widget leftSection(width, imageUrl) => Container(
        child: CircleAvatar(
          // backgroundImage: AssetImage('logo.png'),
          backgroundImage: NetworkImage(imageUrl),
          backgroundColor: Colors.orange,
          radius: width * 0.1,
        ),
      );

  Widget middleSection(height, width, name) => Expanded(
        child: Container(
          padding: EdgeInsets.only(left: width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                name,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 20.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(height * 0.01),
              ),
              Container(
                width: width * 0.4,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                  ),
                  // color: Colors.green[500],
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    width * 0.03,
                    width * 0.02,
                    width * 0.02,
                    width * 0.02,
                  ),
                  child: Row(
                    children: [
                      Text(
                        '2250',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(width * 0.01),
                      ),
                      Text(
                        'Elo rating',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                          fontSize: 9.0,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            FutureBuilder<User>(
              future: futureUser,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return topSection(
                    height,
                    width,
                    snapshot.data!.username,
                    snapshot.data!.name,
                    snapshot.data!.tournamentsPlayed,
                    snapshot.data!.tournamentsWon,
                    snapshot.data!.winPer,
                    snapshot.data!.imageUrl,
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: height * 0.02,
                horizontal: width * 0.05,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Recommended for you',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 22.0,
                  ),
                ),
              ),
            ),
            Recommendations(),
          ],
        ),
      ),
    );
  }
}
