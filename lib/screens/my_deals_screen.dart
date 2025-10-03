import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class MyDeal {
  final String id;
  final String popupTitle;
  final String popupDescription;
  final String imageUrl;

  MyDeal({
    required this.id,
    required this.popupTitle,
    required this.popupDescription,
    required this.imageUrl,
  });

  factory MyDeal.fromFirestore(Map<String, dynamic> json, String docId) {
    return MyDeal(
      id: docId,
      popupTitle: json['popupTitle'] ?? '',
      popupDescription: json['popupDescription'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}

class MyDealsScreen extends StatelessWidget {
  const MyDealsScreen({Key? key, required String userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Center(child: Text('Please sign in to view your deals.'));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Saved Deals",
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .collection('myDeals')
                .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final myDeals =
              snapshot.data!.docs
                  .map(
                    (doc) => MyDeal.fromFirestore(
                      doc.data() as Map<String, dynamic>,
                      doc.id,
                    ),
                  )
                  .toList();

          if (myDeals.isEmpty) {
            return Center(child: Text("No deals saved yet."));
          }

          return ListView.builder(
            itemCount: myDeals.length,
            itemBuilder: (context, index) {
              final myDeal = myDeals[index];
              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: SizedBox(
                  height: 210,
                  child: Stack(
                    children: [
                      // Full-size image background
                      Positioned.fill(
                        child:
                            myDeal.imageUrl.startsWith('http')
                                ? Image.network(
                                  myDeal.imageUrl,
                                  fit: BoxFit.cover,
                                )
                                : Image.asset(
                                  myDeal.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                      ),
                      // Solid black background for title/desc
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          color: Colors.teal.withOpacity(0.7),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                myDeal.popupTitle,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  shadows: [
                                    Shadow(blurRadius: 2, color: Colors.black),
                                  ],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                myDeal.popupDescription,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  shadows: [
                                    Shadow(blurRadius: 1, color: Colors.black),
                                  ],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
