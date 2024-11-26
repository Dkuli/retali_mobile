import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({Key? key, required this.onComplete}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4E1D57), Color(0xFF8E2DE2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  OnboardingPage(
                    imagePath: 'assets/images/jamaah.png',
                    title: 'Insya Allah Mabrur',
                    description: 'Selamat datang di Aplikasi UmrahApp. Silahkan login dengan akun Gmail Anda.',
                  ),
                  OnboardingPage(
                    imagePath: 'assets/images/travel_umrah.png',
                    title: 'Kemudahan Ibadah',
                    description: 'Nikmati kemudahan dalam mengatur perjalanan ibadah Anda bersama UmrahApp.',
                  ),
                  OnboardingPage(
                    imagePath: 'assets/images/mekah.png',
                    title: 'Pantau Perjalanan',
                    description: 'Dapatkan notifikasi dan informasi penting selama perjalanan Anda.',
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 10,
                  width: _currentIndex == index ? 24 : 12,
                  decoration: BoxDecoration(
                    color: _currentIndex == index ? Colors.white : Colors.grey[400],
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentIndex == 2) {
                      widget.onComplete();
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    backgroundColor: _currentIndex == 2
                        ? const Color.fromARGB(255, 113, 6, 97)
                        : const Color.fromARGB(255, 243, 243, 243),
                      ),
                      child: Text(
                      _currentIndex == 2 ? 'Mulai' : 'Berikutnya',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: _currentIndex == 2 ? Colors.white : Color.fromARGB(255, 113, 6, 97),
                      ),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: widget.onComplete,
              child: const Text(
                'Lewati',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const OnboardingPage({
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20), // Jarak horizontal
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [
                Colors.white24, // Efek transisi lembut di sekitar gambar
                Colors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1), // Shadow halus
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              imagePath,
              height: 250,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 30),
        Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ),
      ],
    );
  }
}
