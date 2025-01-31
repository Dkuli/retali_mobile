
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:retali/providers/auth_provider.dart';


class LuggageHistoryScreen extends StatefulWidget {
  const LuggageHistoryScreen({Key? key}) : super(key: key);

  @override
  State<LuggageHistoryScreen> createState() => _LuggageHistoryScreenState();
}

class _LuggageHistoryScreenState extends State<LuggageHistoryScreen> {
  bool isLoading = true;
  List<dynamic> luggageHistory = [];

  @override
  void initState() {
    super.initState();
    _fetchLuggageHistory();
  }

  Future<void> _fetchLuggageHistory() async {
    try {
      final auth = context.read<AuthProvider>();
      final response = await http.get(
        Uri.parse('${AuthProvider}/api/v1/luggage_history'),
        headers: {
          'Authorization': 'Bearer ${auth.token}',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          luggageHistory = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load luggage history');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Luggage History'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: luggageHistory.length,
              itemBuilder: (context, index) {
                final item = luggageHistory[index];
                return ListTile(
                  title: Text('Luggage ID: ${item['id']}'),
                  subtitle: Text('Scanned at: ${item['scanned_at']}'),
                );
              },
            ),
    );
  }
}