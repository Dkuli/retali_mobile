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
      backgroundColor: Colors.white,
      body: Column(
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
            children: List.generate(3, (index) => buildDot(index, context)),
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
                    widget.onComplete(); // Panggil callback saat onboarding selesai
                  } else {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 78, 29, 87),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  _currentIndex == 2 ? 'Mulai' : 'Berikutnya',
                  style: const TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: widget.onComplete, // Langsung panggil onComplete saat Lewati
            child: const Text(
              'Lewati',
              style: TextStyle(color: Color.fromARGB(255, 110, 16, 9)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildDot(int index, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      width: _currentIndex == index ? 20 : 10,
      decoration: BoxDecoration(
        color: _currentIndex == index ? const Color.fromARGB(255, 117, 0, 70) : Colors.grey,
        borderRadius: BorderRadius.circular(5),
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
        Image.asset(imagePath, height: 250),
        const SizedBox(height: 30),
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 110, 16, 9),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
