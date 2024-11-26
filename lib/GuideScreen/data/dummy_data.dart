import 'package:flutter/material.dart';
import 'package:retali/GuideScreen/GuideCategory.dart';
import '../guide_screen.dart';

class DummyData {
  static final List<GuideCategory> guideCategories = [
    GuideCategory(
      title: 'Persiapan Umroh',
      icon: Icons.checklist,
      color: Colors.blue,
      guides: [
        Guide(
          title: 'Dokumen Penting',
          description: 'Panduan untuk memastikan dokumen penting tersedia.',
          imageUrl: 'http://192.168.241.13:8000/storage/2/01JCT1250JN7AD5T92BFKKQKKW.jpg',
          content:
              'Pastikan Anda memiliki paspor yang masih berlaku minimal 6 bulan, visa umroh, tiket pesawat, dan kartu vaksinasi internasional.',
        ),
        Guide(
          title: 'Barang Bawaan',
          description: 'Daftar barang yang perlu dibawa saat umroh.',
          imageUrl: 'http://192.168.241.13:8000/storage/2/01JCT1250JN7AD5T92BFKKQKKW.jpg',
          content:
              'Bawa pakaian ihram, pakaian sehari-hari yang nyaman, perlengkapan mandi, sandal, Al-Qur’an kecil, obat-obatan pribadi, dan power bank.',
        ),
      ],
    ),
    GuideCategory(
      title: 'Rukun dan Wajib Umroh',
      icon: Icons.book,
      color: Colors.green,
      guides: [
        Guide(
          title: 'Tawaf',
          description: 'Penjelasan mengenai tata cara tawaf.',
          imageUrl: 'assets/images/banner_ceklis.jpg',
          content:
              'Tawaf adalah mengelilingi Ka’bah sebanyak 7 kali dengan niat beribadah kepada Allah. Mulai dari Hajar Aswad dan berakhir di titik yang sama.',
        ),
        Guide(
          title: 'Sai',
          description: 'Panduan pelaksanaan sai antara Safa dan Marwah.',
          imageUrl: 'assets/images/banner_ceklis.jpg',
          content:
              'Sai dilakukan dengan berjalan bolak-balik antara bukit Safa dan Marwah sebanyak 7 kali. Dimulai dari Safa dan berakhir di Marwah.',
        ),
      ],
    ),
    GuideCategory(
      title: 'Tips Selama di Tanah Suci',
      icon: Icons.lightbulb,
      color: Colors.orange,
      guides: [
        Guide(
          title: 'Menjaga Kesehatan',
          description: 'Tips untuk menjaga kesehatan selama ibadah.',
          imageUrl: 'assets/images/banner_ceklis.jpg',
          content:
              'Minum air yang cukup, hindari makanan pedas atau berat sebelum ibadah, dan gunakan masker untuk melindungi diri dari debu.',
        ),
        Guide(
          title: 'Berkomunikasi',
          description: 'Cara berkomunikasi di tanah suci.',
          imageUrl: 'assets/images/banner_ceklis.jpg',
          content:
              'Gunakan aplikasi komunikasi seperti WhatsApp untuk tetap terhubung dengan keluarga. Pastikan Anda memiliki paket data internasional.',
        ),
      ],
    ),
  ];
}
