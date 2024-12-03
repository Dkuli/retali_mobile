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
          address: 'King Abdulaziz Gate Rd, Makkah 24231, Arab Saudi',
          imageUrl: 'https://media.suara.com/pictures/970x544/2022/11/20/80926-masjidil-haram.webp',
          lat: 21.422487,
          lng: 39.826206,
          category: 'mosque',
        ),
        Location(
          id: 'masjid_nabawi',
          name: 'Masjid Nabawi',
          address: '8W4V+CV Al Haram, Medina 42311, Arab Saudi',
          imageUrl: 'https://media.suara.com/pictures/970x544/2021/04/18/94270-masjid-nabawi.webp',
          lat: 24.467991,
          lng: 39.611538,
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
          name: 'Le Meridien Makkah',
          address: 'Jabal Omar, Ibrahim Al Khalil Street, Makkah 24231, Arab Saudi',
          imageUrl: 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/294045884.jpg?k=c8eb89b500e1bb6f1e03df9e82db29b4a1f08991ba5e381107be0d9590ce4d01&o=&hp=1',
          lat: 21.418957,
          lng: 39.826084,
          category: 'hotel',
        ),
        Location(
          id: 'hotel_dar_al_taqwa',
          name: 'Dar Al Taqwa Hotel',
          address: 'King Fahd Rd, Al Haram, Medina 42311, Arab Saudi',
          imageUrl: 'https://q-xx.bstatic.com/xdata/images/hotel/max1024x768/294045828.jpg?k=f60dc3b112d9d9a4f558bf918d3d7a32f342c5a3e29115950b0c7c38a913634b&o=',
          lat: 24.468473,
          lng: 39.611912,
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
          address: 'Jeddah 23631, Arab Saudi',
          imageUrl: 'https://www.skyteam.com/contentapi/NWN/wp-content/uploads/2019/09/KAIA-jeddah.jpg',
          lat: 21.679564,
          lng: 39.156531,
          category: 'airport',
        ),
        Location(
          id: 'airport_madinah',
          name: 'Bandara Internasional Pangeran Mohammad Bin Abdulaziz',
          address: 'Al Madinah 42342, Arab Saudi',
          imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/6/65/Prince_Mohammad_bin_Abdulaziz_International_Airport_Interior.jpg',
          lat: 24.553421,
          lng: 39.705112,
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
          name: 'Al Baik - Al Ghazzawi',
          address: 'Ibrahim Al Khalil Rd, Al Ghazzawi, Makkah 24231, Arab Saudi',
          imageUrl: 'https://assets.aboutmanchester.co.uk/wp-content/uploads/2022/01/Al-Baik.jpg',
          lat: 21.427464,
          lng: 39.814912,
          category: 'restaurant',
        ),
        Location(
          id: 'restaurant_tazaj',
          name: 'Al Tazaj',
          address: 'King Faisal Rd, Bab Al Majidi, Medina 42311, Arab Saudi',
          imageUrl: 'https://assets.dubaichronicle.com/wp-content/uploads/2021/08/tazaj-restaurant.jpg',
          lat: 24.470869,
          lng: 39.609795,
          category: 'restaurant',
        ),
      ],
    ),
    // Tempat Bersejarah
    Category(
      id: 'historical',
      name: 'Tempat Bersejarah',
      icon: Icons.history,
      locations: [
        Location(
          id: 'jabal_rahmah',
          name: 'Jabal Rahmah',
          address: 'Mount of Mercy, Arafat, Makkah, Arab Saudi',
          imageUrl: 'https://www.islamicity.org/wp-content/uploads/2016/08/arapah-scaled.jpg',
          lat: 21.355701,
          lng: 39.984092,
          category: 'historical',
        ),
        Location(
          id: 'grotto_hira',
          name: 'Gua Hira',
          address: 'Jabal An-Nur, Makkah, Arab Saudi',
          imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/1/18/Grotto_of_Hira.jpg',
          lat: 21.458754,
          lng: 39.858565,
          category: 'historical',
        ),
        Location(
          id: 'grotto_thawr',
          name: 'Gua Thawr',
          address: 'Jabal Thawr, Makkah, Arab Saudi',
          imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/aa/Grotto_of_Thawr.jpg',
          lat: 21.377542,
          lng: 39.838373,
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
          address: 'Uhud, Medina, Arab Saudi',
          imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/5/58/Mount_Uhud.jpg',
          lat: 24.501697,
          lng: 39.620465,
          category: 'mountain',
        ),
      ],
    ),
  ];
}