import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:retali/luggages/screens/luggage_scan_screen.dart';
import 'package:retali/navigation_map/LocationScreen%20.dart';
import 'package:retali/profile/ProfileScreen.dart';
import '../auth/providers/auth_provider.dart';
import 'notification/notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends State {
  int _currentCarouselIndex = 0;
  final ScrollController _scrollController = ScrollController();
  bool _showTitle = false;

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
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
                  _buildJamaahSection(),
                  const SizedBox(height: 24),
                  _buildScheduleSection(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavigationBar(),
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
        'image': 'http://192.168.241.13:8000/storage/2/01JCT1250JN7AD5T92BFKKQKKW.jpg',
        'title': 'Panduan Ibadah Umrah',
      },
      {
        'image': 'http://192.168.241.13:8000/storage/2/01JCT1250JN7AD5T92BFKKQKKW.jpg',
        'title': 'Jadwal Sholat',
      },
      {
        'image': 'http://192.168.241.13:8000/storage/2/01JCT1250JN7AD5T92BFKKQKKW.jpg',
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
    {'icon': Icons.group, 'label': 'Jamaah', 'color': Colors.green, 'screen': ()},
    {'icon': Icons.calendar_today, 'label': 'Jadwal', 'color': Colors.blue, 'screen': ()},
    {'icon': Icons.location_on, 'label': 'Lokasi', 'color': Colors.red, 'screen': LocationScreen()},
    {'icon': Icons.menu_book, 'label': 'Panduan', 'color': Colors.orange, 'screen': ()},
    {'icon': Icons.medical_services, 'label': 'Kesehatan', 'color': Colors.purple, 'screen': ()},
    {'icon': Icons.luggage, 'label': 'Bagasi', 'color': Colors.brown, 'screen': ()},
    {'icon': Icons.mosque, 'label': 'Ibadah', 'color': Colors.teal, 'screen': ()},
    {'icon': Icons.support_agent, 'label': 'Bantuan', 'color': Colors.indigo, 'screen': ()},
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
          // Fungsi navigasi ke layar tertentu
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => category['screen'] as Widget),
          );
        },
      );
    },
  );
}

  Widget _buildCategoryItem(IconData icon, String label, Color color, VoidCallback onTap) {
  return InkWell(
    onTap: onTap, // Fungsi navigasi di sini
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

  Widget _buildJamaahSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Daftar Jamaah',
              style: TextStyle(
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
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) => _buildJamaahCard(),
        ),
      ],
    );
  }

  Widget _buildJamaahCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(Icons.person),
        ),
        title: Text('Nama Jamaah'),
        subtitle: Text('No. Passport: AB123456'),
        trailing: Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }

  Widget _buildScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Jadwal Hari Ini',
              style: TextStyle(
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
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) => _buildScheduleCard(),
        ),
      ],
    );
  }

  Widget _buildScheduleCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.event, color: Colors.blue),
        ),
        title: Text('Tawaf & Sa\'i'),
        subtitle: Text('09:00 - Masjidil Haram'),
        trailing: Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const LuggageScanScreen(),
          ),
        );
      },
            child: Icon(Icons.qr_code, color: Colors.white),
      backgroundColor: const Color.fromARGB(255, 78, 29, 87),
      shape: CircleBorder(),
      elevation: 6.0,
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.group),
            onPressed: () {
            },
          ),
          const SizedBox(width: 40),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              
                Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ProfileScreen(),
          ),
        );
            },
          ),
        ],
      ),
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
                ? Color.fromARGB(255, 78, 29, 87)
                : Colors.grey.shade300,
          ),
        );
      }),
    );
  }


  }

