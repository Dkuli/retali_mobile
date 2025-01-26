import 'package:flutter/material.dart';

import '../models/briefing.dart';


class BriefingDetailPage extends StatefulWidget {
  final Briefing briefing;

  const BriefingDetailPage({Key? key, required this.briefing}) : super(key: key);

  @override
  _BriefingDetailPageState createState() => _BriefingDetailPageState();
}

class _BriefingDetailPageState extends State<BriefingDetailPage> {
  late ScrollController _scrollController;
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _showTitle = _scrollController.offset > 180;
        });
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.teal[700],
            ),
          ),
        ),
        Text(
          content,
          style: TextStyle(
            fontSize: 16,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildMapSection(String title, Map<String, String> content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.teal[700],
            ),
          ),
        ),
        ...content.entries.map((entry) => Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.key,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                entry.value,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.teal[800],
            flexibleSpace: FlexibleSpaceBar(
              title: _showTitle 
                ? Text(widget.briefing.type) 
                : null,
              background: Container(
                padding: EdgeInsets.all(24),
                alignment: Alignment.bottomLeft,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.teal[800]!,
                      Colors.teal[600]!,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.briefing.location != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          widget.briefing.location!,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    Text(
                      widget.briefing.type,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.briefing.opening,
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.6,
                      color: Colors.grey[800],
                    ),
                  ),
                  if (widget.briefing.introduction != null)
                    _buildSection('Pendahuluan', widget.briefing.introduction!),
                  if (widget.briefing.description != null)
                    _buildSection('Deskripsi', widget.briefing.description!),
                  if (widget.briefing.jamaahPreparedness?.isNotEmpty ?? false)
                    _buildMapSection('Persiapan Jamaah', widget.briefing.jamaahPreparedness!),
                  if (widget.briefing.administrationCheck?.isNotEmpty ?? false)
                    _buildMapSection('Pengecekan Administrasi', widget.briefing.administrationCheck!),
                  if (widget.briefing.coordination?.isNotEmpty ?? false)
                    _buildMapSection('Koordinasi', widget.briefing.coordination!),
                  if (widget.briefing.importantInformation?.isNotEmpty ?? false)
                    _buildMapSection('Informasi Penting', widget.briefing.importantInformation!),
                  if (widget.briefing.closing.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(top: 24),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Text(
                        widget.briefing.closing,
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          height: 1.6,
                          color: Colors.grey[800],
                        ),
                      ),
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