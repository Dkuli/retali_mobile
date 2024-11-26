import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/location.dart';

class DummyData {
  static const List<Category> categories = [
    // Masjid
    Category(
      id: 'mosque',
      name: 'Masjid',
      icon: Icons.mosque,
      locations: [
        Location(
          id: 'masjid_haram',
          name: 'Masjidil Haram',
          address: 'Makkah, Arab Saudi',
          imageUrl: 'assets/images/masjid_haram.jpg',
          lat: 21.4225,
          lng: 39.8262,
          category: 'mosque',
        ),
        Location(
          id: 'masjid_nabawi',
          name: 'Masjid Nabawi',
          address: 'Madinah, Arab Saudi',
          imageUrl: 'assets/images/masjid_nabawi.jpg',
          lat: 24.4672,
          lng: 39.6111,
          category: 'mosque',
        ),
      ],
    ),
    // Hotel
    Category(
      id: 'hotel',
      name: 'Hotel',
      icon: Icons.hotel,
      locations: [
        Location(
          id: 'hotel_zamzam',
          name: 'Hotel Zamzam Pullman',
          address: 'Ajyad St, Makkah, Arab Saudi',
          imageUrl: 'assets/images/hotel_zamzam.jpg',
          lat: 21.4186,
          lng: 39.8256,
          category: 'hotel',
        ),
        Location(
          id: 'hotel_dar_al_taqwa',
          name: 'Hotel Dar Al Taqwa',
          address: 'Madinah, Arab Saudi',
          imageUrl: 'assets/images/hotel_dar_al_taqwa.jpg',
          lat: 24.4684,
          lng: 39.6119,
          category: 'hotel',
        ),
      ],
    ),
    // Bandara
    Category(
      id: 'airport',
      name: 'Bandara',
      icon: Icons.flight,
      locations: [
        Location(
          id: 'airport_jeddah',
          name: 'Bandara Internasional King Abdulaziz',
          address: 'Jeddah, Arab Saudi',
          imageUrl: 'assets/images/airport_jeddah.jpg',
          lat: 21.6796,
          lng: 39.1565,
          category: 'airport',
        ),
        Location(
          id: 'airport_madinah',
          name: 'Bandara Internasional Pangeran Mohammad Bin Abdulaziz',
          address: 'Madinah, Arab Saudi',
          imageUrl: 'assets/images/airport_madinah.jpg',
          lat: 24.5534,
          lng: 39.7051,
          category: 'airport',
        ),
      ],
    ),
    // Restoran
    Category(
      id: 'restaurant',
      name: 'Restoran',
      icon: Icons.restaurant,
      locations: [
        Location(
          id: 'restaurant_albaik',
          name: 'Restoran Al Baik',
          address: 'Makkah, Arab Saudi',
          imageUrl: 'assets/images/restaurant_albaik.jpg',
          lat: 21.4225,
          lng: 39.8262,
          category: 'restaurant',
        ),
        Location(
          id: 'restaurant_tazaj',
          name: 'Restoran Al Tazaj',
          address: 'Madinah, Arab Saudi',
          imageUrl: 'assets/images/restaurant_tazaj.jpg',
          lat: 24.4672,
          lng: 39.6111,
          category: 'restaurant',
        ),
      ],
    ),
    // Tempat Bersejarah
    Category(
      id: 'historical',
      name: 'historical',
      icon: Icons.history,
      locations: [
        Location(
          id: 'jabal_rahmah',
          name: 'Jabal Rahmah',
          address: 'Arafah, Arab Saudi',
          imageUrl: 'assets/images/jabal_rahmah.jpg',
          lat: 21.3557,
          lng: 39.9841,
          category: 'historical',
        ),
        Location(
          id: 'grotto_hira',
          name: 'Gua Hira',
          address: 'Makkah, Arab Saudi',
          imageUrl: 'assets/images/grotto_hira.jpg',
          lat: 21.4225,
          lng: 39.8262,
          category: 'historical',
        ),
        Location(
          id: 'grotto_thawr',
          name: 'Gua Thawr',
          address: 'Makkah, Arab Saudi',
          imageUrl: 'assets/images/grotto_thawr.jpg',
          lat: 21.4225,
          lng: 39.8262,
          category: 'historical',
        ),
      ],
    ),
    // Gunung
    Category(
      id: 'mountain',
      name: 'Gunung',
      icon: Icons.terrain,
      locations: [
        Location(
          id: 'mount_uhud',
          name: 'Gunung Uhud',
          address: 'Madinah, Arab Saudi',
          imageUrl: 'assets/images/mount_uhud.jpg',
          lat: 24.5017,
          lng: 39.6205,
          category: 'mountain',
        ),
      ],
    ),
  ];
}