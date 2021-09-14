import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String name;
  final String gameName;
  final String imageURL;

  CustomCard(this.name, this.gameName, this.imageURL);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        width * 0.05,
        0,
        width * 0.05,
        height * 0.03,
      ),
      child: Material(
        elevation: 8,
        shadowColor: Colors.black12,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        child: Column(
          children: <Widget>[
            Container(
              height: height * 0.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey,
                //     blurRadius: 5.0,
                //     spreadRadius: 5.0,
                //     offset: Offset(2.0, 2.0), // shadow direction: bottom right
                //   )
                // ],
                image: DecorationImage(
                  image: NetworkImage(this.imageURL),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black,
                //     blurRadius: 2.0,
                //     spreadRadius: 0.0,
                //     offset: Offset(2.0, 2.0), // shadow direction: bottom right
                //   )
                // ],
              ),
              child: ListTile(
                // leading: Icon(Icons.arrow_drop_down_circle),
                title: Text(
                  this.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
                subtitle: Text(
                  this.gameName,
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
