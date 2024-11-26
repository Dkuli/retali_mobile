import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:retali/ContentUpload/ContentUploadScreen.dart';
import 'package:retali/GuideScreen/guide_screen.dart';
import 'package:retali/main_layout.dart';
import 'package:retali/location/page/locations_list_page.dart';
import 'package:retali/surah/screens/doa_umrah_screen.dart';
import 'package:retali/task/TaskScreen.dart';
import '../auth/providers/auth_provider.dart';
import 'notification/notification_screen.dart';
import 'package:retali/luggages/screens/luggage_history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showTitle = false;
  int _currentCarouselIndex = 0;

   @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
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
    return MainLayout(
      currentIndex: 0, // Index for Home
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _buildCarousel(),
                  const SizedBox(height: 24),
                  _buildCategories(context),
                  const SizedBox(height: 24),
                  _buildHorizontalImageList(
                    title: 'Potensi Masalah',
                    images: List.generate(
                      5,
                      (index) =>
                          'http://192.168.190.13:8000/storage/5/01JCWPVDQAQWD7VSJ9YFJ7WHP7.jpg',
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      title: AnimatedOpacity(
        opacity: _showTitle ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: const Text(
          'Beranda',
          style: TextStyle(color: Colors.black),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
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
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                authProvider.tourLeaderName ?? 'Muthowif',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: 'GoogleSans',
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildNotificationBadge(),
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

  Widget _buildCarousel() {
    final carouselItems = [
      {
        'image':
            'http://192.168.190.13:8000/storage/2/01JCT1250JN7AD5T92BFKKQKKW.jpg',
        'title': 'Informasi Penting',
      },
      {
        'image':
            'http://192.168.190.13:8000/storage/2/01JCT1250JN7AD5T92BFKKQKKW.jpg',
        'title': 'Informasi Penting',
      },
      {
        'image':
            'http://192.168.190.13:8000/storage/2/01JCT1250JN7AD5T92BFKKQKKW.jpg',
        'title': 'Informasi Penting',
      },
    ];

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 200,
            viewportFraction: 0.92,
            enlargeCenterPage: true,
            autoPlay: true,
            onPageChanged: (index, reason) {
              setState(() => _currentCarouselIndex = index);
            },
          ),
          items: carouselItems.map((item) => _buildCarouselItem(item)).toList(),
        ),
        const SizedBox(height: 12),
        _buildCarouselIndicator(carouselItems.length),
      ],
    );
  }

  Widget _buildCarouselItem(Map<String, String> item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: item['image']!,
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
                item['title']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
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
        'screen': const TaskScreen()
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
        'screen': const ContentUploadScreen()
      },
      {
        'icon': Icons.luggage,
        'label': 'Bagasi',
        'color': Colors.brown,
        'screen': const LuggageHistoryScreen()
      },
      {
        'icon': Icons.description,
        'label': 'Naskah',
        'color': Colors.indigo,
        'screen': const TaskScreen()
      },
      {
        'icon': Icons.group,
        'label': 'Jamaah',
        'color': Colors.green,
        'screen': const TaskScreen()
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
        );
      },
    );
  }

  Widget _buildCategoryItem(
      IconData icon, String label, Color color, VoidCallback onTap) {
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
            style: const TextStyle(
              fontSize: 12,
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

  Widget _buildHorizontalImageList(
      {required String title, required List<String> images}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Lihat Semua'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Card(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: images[index],
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
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationBadge() {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationScreen(),
              ),
            );
          },
        ),
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            constraints: const BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: const Text(
              '3',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCarouselIndicator(int itemCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: _currentCarouselIndex == index ? 24 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: _currentCarouselIndex == index
                ? const Color.fromARGB(255, 78, 29, 87)
                : Colors.grey.shade300,
          ),
        );
      }),
    );
  }
}