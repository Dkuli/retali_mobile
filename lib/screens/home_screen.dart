// home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:retali/providers/auth_provider.dart';
import 'package:retali/screens/ContentUploadScreen.dart';
import 'package:retali/screens/JourneysScreen.dart';
import 'package:retali/screens/briefings_page.dart';
import 'package:retali/screens/doa_umrah_screen.dart';
import 'package:retali/screens/guide_screen.dart';
import 'package:retali/screens/locations_list_page.dart';
import 'package:retali/screens/luggage_history_screen.dart';
import 'package:retali/screens/pilgrim_screen.dart';
import 'package:retali/services/api_service.dart';
import 'package:retali/widgets/main_layout.dart';
import '../models/carousel.dart';
import 'detail_masalah_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showTitle = false;
  int _currentCarouselIndex = 0;
  Map<String, dynamic>? _potensiMasalah;
  List<Carousel> _carouselItems = [];
  bool _isLoadingCarousel = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadPotensiMasalah();
    _loadCarouselData();
  }

  Future<void> _loadPotensiMasalah() async {
    try {
      final jsonString = await rootBundle.loadString('assets/potensi_masalah.json');
      setState(() {
        _potensiMasalah = json.decode(jsonString);
      });
    } catch (e) {
      print('Error loading potensi masalah: $e');
    }
  }

  Future<void> _loadCarouselData() async {
    try {
      setState(() => _isLoadingCarousel = true);
      final carousels = await ApiService.getCarousels();
      setState(() {
        _carouselItems = carousels;
        _isLoadingCarousel = false;
      });
    } catch (e) {
      print('Error loading carousels: $e');
      setState(() => _isLoadingCarousel = false);
    }
  }

  void _onScroll() {
    if (_scrollController.offset > 120 && !_showTitle) {
      setState(() => _showTitle = true);
    } else if (_scrollController.offset <= 120 && _showTitle) {
      setState(() => _showTitle = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the theme
    return MainLayout(
      currentIndex: 0, // Index for Home
      theme: theme, // Pass the theme
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildSliverAppBar(theme),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildCarousel(theme),
                  const SizedBox(height: 24),
                  _buildCategories(context, theme),
                  const SizedBox(height: 24),
                  _buildHorizontalImageList(title: 'Potensi Masalah', theme: theme),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(ThemeData theme) {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: true,
      pinned: true,
      elevation: theme.appBarTheme.elevation,
      backgroundColor: theme.appBarTheme.backgroundColor,
      title: AnimatedOpacity(
        opacity: _showTitle ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Text(
          'Beranda',
          style: theme.appBarTheme.titleTextStyle,
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<AuthProvider>(
            builder: (context, auth, child) {
              final userData = auth.userData;
              final userName = userData?['name'] ?? 'Pengguna';
              return SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Assalamu\'alaikum,',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: const Color.fromARGB(255, 76, 76, 76),
                                ),
                              ),
                              Text(
                                userName,
                                style: theme.textTheme.headlineLarge?.copyWith(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontFamily: 'GoogleSans',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCarousel(ThemeData theme) {
    if (_isLoadingCarousel) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_carouselItems.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 180,
              viewportFraction: 0.92,
              enlargeCenterPage: true,
              autoPlay: true,
              onPageChanged: (index, reason) {
                setState(() => _currentCarouselIndex = index);
              },
            ),
            items: _carouselItems.map((item) {
              final mediaUrl = item.media.isNotEmpty
                  ? item.media[0].originalUrl
                  : '';
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: theme.cardTheme.shape.runtimeType is RoundedRectangleBorder
                      ? (theme.cardTheme.shape as RoundedRectangleBorder).borderRadius
                      : BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: theme.cardTheme.shape.runtimeType is RoundedRectangleBorder
                      ? (theme.cardTheme.shape as RoundedRectangleBorder).borderRadius
                      : BorderRadius.circular(20),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: mediaUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                          child: const Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.error),
                        ),
                      ),
                      if (item.title != null) ...[
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          child: Text(
                            item.title!,
                            style: theme.textTheme.headlineLarge?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          _buildCarouselIndicator(_carouselItems.length, theme),
        ],
      ),
    );
  }

  Widget _buildCarouselIndicator(int itemCount, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 10,
          width: _currentCarouselIndex == index ? 24 : 12,
          decoration: BoxDecoration(
            color: _currentCarouselIndex == index ? theme.primaryColor : Colors.grey[400],
            borderRadius: BorderRadius.circular(5),
          ),
        );
      }),
    );
  }

  Widget _buildCategories(BuildContext context, ThemeData theme) {
    final categories = [
      {
        'icon': Icons.mosque,
        'label': 'doa',
        'color': Colors.teal,
        'screen': const DoaUmrahScreen()
      },
      {
        'icon': Icons.calendar_today,
        'label': 'Jadwal',
        'color': Colors.blue,
        'screen': JourneysScreen()
      },
      {
        'icon': Icons.location_on,
        'label': 'Lokasi',
        'color': Colors.red,
        'screen': LocationsListPage()
      },
      {
        'icon': Icons.menu_book,
        'label': 'Panduan',
        'color': Colors.orange,
        'screen': const GuideScreen()
      },
      {
        'icon': Icons.camera_alt_sharp,
        'label': 'konten',
        'color': Colors.purple,
        'screen': ContentUploadScreen()
      },
      {
        'icon': Icons.luggage,
        'label': 'Bagasi',
        'color': Colors.brown,
        'screen': const LuggageScanHistoryScreen()
      },
      {
        'icon': Icons.description,
        'label': 'Naskah',
        'color': Colors.indigo,
        'screen': BriefingsPage()
      },
      {
        'icon': Icons.group,
        'label': 'Jamaah',
        'color': Colors.green,
        'screen': PilgrimScreen()
      },
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.9,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildCategoryItem(
          category['icon'] as IconData,
          category['label'] as String,
          category['color'] as Color,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => category['screen'] as Widget),
            );
          },
          theme,
        );
      },
    );
  }

  Widget _buildCategoryItem(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
    ThemeData theme,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalImageList({required String title, required ThemeData theme}) {
    if (_potensiMasalah == null) return const SizedBox.shrink();
    final items = _potensiMasalah!.entries.where((e) => e.value is Map).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Lihat Semua',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.primaryColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final imageUrl = (item.value as Map)['image'] as String? ?? '';
              final heroTag = 'masalah-${item.key}';
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailMasalahScreen(
                        title: item.key,
                        problemData: item.value as Map,
                        heroTag: heroTag,
                      ),
                    ),
                  );
                },
                child: Card(
                  child: Container(
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Hero(
                      tag: heroTag,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}