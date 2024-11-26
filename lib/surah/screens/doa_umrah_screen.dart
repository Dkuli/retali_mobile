
import 'package:flutter/material.dart';
import '../widgets/doa_card.dart';
import '../models/doa.dart';
import '../data/doa_data.dart';

class DoaUmrahScreen extends StatelessWidget {
  const DoaUmrahScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Doa Umrah',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: doaList.length,
        itemBuilder: (context, index) {
          return DoaCard(doa: doaList[index]);
        },
      ),
    );
  }
}