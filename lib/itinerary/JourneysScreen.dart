import 'package:flutter/material.dart';
import 'itinerary_card.dart';

class JourneysScreen extends StatelessWidget {
  final List<Map<String, dynamic>> journeys = [
    {
      "title": "Malta First Day",
      "date": "10 June",
      "itinerary": [
        {"time": "06:00 AM", "activity": "Flight Departure", "details": "London → Malta"},
        {"time": "08:00 AM", "activity": "Hotel Check-In", "details": "Hotel Cavalleri"},
        {"time": "10:00 AM", "activity": "Drinks", "details": "Happy Days Bar"},
      ],
    },
    {
      "title": "Malta Second Day",
      "date": "11 June",
      "itinerary": [
        {"time": "08:00 AM", "activity": "Breakfast", "details": "Hotel Restaurant"},
        {"time": "10:00 AM", "activity": "City Tour", "details": "Guided city walk"},
      ],
    },
    {
      "title": "Malta Third Day",
      "date": "12 June",
      "itinerary": [
        {"time": "09:00 AM", "activity": "Beach Visit", "details": "Golden Bay Beach"},
        {"time": "12:00 PM", "activity": "Lunch", "details": "Beachside Restaurant"},
        {"time": "03:00 PM", "activity": "Shopping", "details": "City Market"},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Journeys",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: journeys.length,
        itemBuilder: (context, index) {
          final journey = journeys[index];
          return ItineraryCard(
            title: journey['title'],
            date: journey['date'],
            itinerary: journey['itinerary'],
          );
        },
      ),
    );
  }
}
