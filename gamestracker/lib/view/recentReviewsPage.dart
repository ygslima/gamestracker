import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gamestracker/controller/telaController.dart';
import '../model/review.dart';
import '../model/game.dart';
import '../model/user.dart';

class RecentReviewsPage extends StatefulWidget {
  const RecentReviewsPage({super.key});

  static const String routeName = "/recentReviewsPage";

  @override
  State<RecentReviewsPage> createState() => _RecentReviewsPageState();
}

class _RecentReviewsPageState extends State<RecentReviewsPage> {

  List<Review?>recentReviews = [];
  List<Map<String, dynamic>> reviewsCompleta =[];
  

  void loadRecentReviews(int dias) async{
    recentReviews = await TelaController.getRecentReviews(dias);
    for(Review? review in recentReviews){
      Game? game = await TelaController.getGameById(review!.toMap()["game_id"]);
      User? user = await TelaController.getUserById(review.toMap()["user_id"]);
      reviewsCompleta.add({
        "review": review,
        "game": game,
        "user": user
      });
    }
    // print("recent: ${recentReviews[0]!.toMap()["description"]}");
    setState(() {
      
    });


  }



  @override
  void initState(){
    super.initState();
    loadRecentReviews(7);
    
  }



  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reviews Recentes"), backgroundColor: Colors.blueGrey,),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: recentReviews.length,
                itemBuilder: (context, index) {
                  final review = reviewsCompleta[index];
                 
                  

                  return ListTile(
                    title: Text(review["game"].toMap()["name"]),
                    subtitle: Text("${review["user"].toMap()["name"]}: Score [${review["review"].toMap()["score"]}]:  ${review["review"].toMap()["description"]}"),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}