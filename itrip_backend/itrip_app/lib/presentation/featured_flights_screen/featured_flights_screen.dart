import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class FeaturedFlightsScreen extends StatelessWidget {
  const FeaturedFlightsScreen({super.key});

  static final List<Map<String, dynamic>> _allFlights = [
    {
      "from": "Ulaanbaatar",
      "badge": "2 талдаа",
      "dateRange": "04/07 - 04/14",
      "destination": "Istanbul New Airport",
      "price": "₮ 1'735'500",
      "image": "https://images.unsplash.com/photo-1715803450839-f7dc341bee85",
      "semanticLabel":
          "Istanbul Blue Mosque with minarets surrounded by green trees and clear blue sky",
    },
    {
      "from": "Ulaanbaatar",
      "badge": "2 талдаа",
      "dateRange": "04/09 - 04/17",
      "destination": "Narita, Tokyo, Japan",
      "price": "₮ 2'150'200",
      "image": "https://images.unsplash.com/photo-1555529864-e8670a011edc",
      "semanticLabel":
          "Cherry blossom trees in full bloom with pink flowers against blue sky in Japan",
    },
    {
      "from": "Ulaanbaatar",
      "badge": "2 талдаа",
      "dateRange": "04/04 - 04/14",
      "destination": "Frankfurt Airport",
      "price": "₮ 3'023'100",
      "image": "https://images.unsplash.com/photo-1648306534757-2b9c3bbe4e46",
      "semanticLabel":
          "Frankfurt city center with historic Römer buildings and modern skyline in Germany",
    },
    {
      "from": "Ulaanbaatar",
      "badge": "2 талдаа",
      "dateRange": "04/16 - 04/23",
      "destination": "Incheon International Airport",
      "price": "₮ 1'198'700",
      "image": "https://images.unsplash.com/photo-1693274442155-7ba0649af960",
      "semanticLabel":
          "Traditional Korean architecture with curved rooftops against a golden sunset sky in Incheon",
    },
    {
      "from": "Ulaanbaatar",
      "badge": "2 талдаа",
      "dateRange": "04/12 - 04/20",
      "destination": "Suvarnabhumi Airport, Bangkok",
      "price": "₮ 1'450'000",
      "image": "https://images.unsplash.com/photo-1624791000232-7cdbcd0348ab",
      "semanticLabel":
          "Bangkok Grand Palace golden temple spires against bright blue sky in Thailand",
    },
    {
      "from": "Ulaanbaatar",
      "badge": "2 талдаа",
      "dateRange": "04/18 - 04/25",
      "destination": "Dubai International Airport",
      "price": "₮ 2'890'000",
      "image": "https://images.unsplash.com/photo-1702109768051-473fa42beeb4",
      "semanticLabel":
          "Dubai skyline with Burj Khalifa and modern skyscrapers reflecting in the water at dusk",
    },
    {
      "from": "Ulaanbaatar",
      "badge": "2 талдаа",
      "dateRange": "04/20 - 04/28",
      "destination": "Singapore Changi Airport",
      "price": "₮ 1'980'500",
      "image": "https://images.unsplash.com/photo-1645587496899-b918f2b81ce4",
      "semanticLabel":
          "Singapore city skyline with Marina Bay Sands and Gardens by the Bay at night",
    },
    {
      "from": "Ulaanbaatar",
      "badge": "2 талдаа",
      "dateRange": "04/22 - 04/30",
      "destination": "Paris Charles de Gaulle Airport",
      "price": "₮ 3'450'000",
      "image": "https://images.unsplash.com/photo-1722785350249-596de6dba562",
      "semanticLabel":
          "Eiffel Tower in Paris France with clear blue sky and green trees in foreground",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF2C3E50),
            size: 20,
          ),
        ),
        title: Text(
          'Онцлох нислэг',
          style: GoogleFonts.dmSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2C3E50),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 2.h,
            childAspectRatio: 0.72,
          ),
          itemCount: _allFlights.length,
          itemBuilder: (context, index) {
            return _buildFlightCard(context, _allFlights[index]);
          },
        ),
      ),
    );
  }

  Widget _buildFlightCard(BuildContext context, Map<String, dynamic> flight) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(18),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with badge
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
            child: SizedBox(
              height: 16.h,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    flight["image"] as String,
                    fit: BoxFit.cover,
                    semanticLabel: flight["semanticLabel"] as String,
                    errorBuilder: (_, __, ___) =>
                        Container(color: const Color(0xFF1B365D)),
                  ),
                  // "2 талдаа" badge
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(230),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: Text(
                        flight["badge"] as String,
                        style: GoogleFonts.dmSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2C3E50),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Info section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    flight["from"] as String,
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2C3E50),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.swap_vert,
                        size: 14,
                        color: Color(0xFF7F8C8D),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          flight["dateRange"] as String,
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            color: const Color(0xFF7F8C8D),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    flight["destination"] as String,
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      color: const Color(0xFF2C3E50),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Text(
                    flight["price"] as String,
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2C3E50),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
