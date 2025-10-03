import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThingstodoFireCard extends StatelessWidget {
  final Map thing;
  final VoidCallback? onTap;

  const ThingstodoFireCard({Key? key, required this.thing, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imageUrl = thing['imageUrl'] ?? 'assets/images/placeholder_bg.png';
    bool isNetworkImage = imageUrl.startsWith('http');
    return SizedBox(
      width: 165,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 16 / 11,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child:
                      isNetworkImage
                          ? Image.network(imageUrl, fit: BoxFit.cover)
                          : Image.asset(imageUrl, fit: BoxFit.cover),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 3),
                    Text(
                      thing['name'] ?? '',
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2),
                    Text(
                      thing['address'] ??
                          '', // Make sure 'address' is a key in your thing map
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 1),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange, size: 13),
                        SizedBox(width: 2),
                        Text(
                          (thing['rating']?.toString() ?? ''),
                          style: TextStyle(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          ' (${thing['reviews'] ?? '0'})',
                          style: TextStyle(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontSize: 10,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'From ${thing['price'] ?? ''}',
                        style: TextStyle(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
