import 'package:flutter/material.dart';

class RewardsPage extends StatefulWidget {
  @override
  _RewardsPageState createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    IconButton(
          icon: Icon(Icons.arrow_back), 
          onPressed: () {
            Navigator.pop(context);
          },
                    ),
                    SizedBox(width: 10),
                    Text("Rewards Earned", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
                  ],
                ),
                GridView(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3/2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  // itemCount: 8,
                  // itemBuilder: (BuildContext context, index) => CustomGridCard(title: "40% OFF", subtitle: "Use Code: FOUND40"),
                  children: [
                    CustomGridCard(title: "40% off on Home Delivery", subtitle: "Use code: \"40FREE\"", color: Colors.amber,),
                    CustomGridCard(title: "25% off on 500 and above", subtitle: "Use code: \"TOTAL25\"", color: Colors.purple,),
                    CustomGridCard(title: "20% off on Home Delivery", subtitle: "Use code: \"20CUT\"", color: Colors.red,),
                    CustomGridCard(title: "Buy 2 Get 1 Free", subtitle: "Use code: \"2PLUS1\"", color: Colors.cyan,),
                    CustomGridCard(title: "30% off on Any Purchase", subtitle: "Use code: \"30FREE\"", color: Colors.blue,),
                    CustomGridCard(title: "45% off on Order With App", subtitle: "Use code: \"45APP\"", color: Colors.green,),
                    CustomGridCard(title: "40% off on Selected Items", subtitle: "Use code: \"FULL40\"", color: Colors.pink,),
                    CustomGridCard(title: "40% off on All Items", subtitle: "Use code: \"40FREE\"", color: Colors.amber,),
                  ],
                ),
              ],
            ),
        ),
      ),
    );
  }
}

class CustomGridCard extends StatelessWidget {

  final String title;
  final String subtitle;
  final Color color;

  CustomGridCard({required this.title, required this.subtitle, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      elevation: 3,
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(fontSize: 20, color: Colors.white),textAlign: TextAlign.center,),
          SizedBox(height: 10),
          Text(subtitle, style: TextStyle(fontSize: 16, color: Colors.white),),
          SizedBox(height: 10),
          // MaterialButton(
          //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          //   color: Colors.white.withOpacity(0.7),
          //   onPressed: () {},
          //   child: Text("Claim", style: TextStyle(fontSize: 16),),
          // )
        ],
      ),
    );
  }
}