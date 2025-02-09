// journeys_screen.dart
import 'package:flutter/material.dart';
import 'package:retali/services/api_service.dart';
import 'package:retali/models/schedule.dart';
import '../widgets/itinerary_card.dart';

class JourneysScreen extends StatefulWidget {
  @override
  _JourneysScreenState createState() => _JourneysScreenState();
}

class _JourneysScreenState extends State<JourneysScreen> {
  late Future<List<Schedule>> _futureSchedules;

  @override
  void initState() {
    super.initState();
    _futureSchedules = ApiService.getSchedule();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the theme
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Journeys",
          style: theme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: theme.appBarTheme.elevation,
        iconTheme: theme.appBarTheme.iconTheme,
      ),
      body: FutureBuilder<List<Schedule>>(
        future: _futureSchedules,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: theme.primaryColor));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: theme.textTheme.bodySmall));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No schedules available', style: theme.textTheme.bodySmall));
          }
          final schedules = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: schedules.length,
            itemBuilder: (context, index) {
              final schedule = schedules[index];
              return ItineraryCard(
                title: schedule.dayTitle,
                date: schedule.date.toLocal().toString().split(' ')[0],
                itinerary: schedule.activities.map((activity) => {
                  'time': activity.time.toLocal().toString().split(' ')[1],
                  'activity': activity.title,
                  'details': activity.location,
                }).toList(),
                theme: theme,
              );
            },
          );
        },
      ),
    );
  }
}