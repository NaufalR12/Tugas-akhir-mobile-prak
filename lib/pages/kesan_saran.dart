import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:google_fonts/google_fonts.dart';

// Widget untuk menampilkan teks
class ComponentHelp extends StatelessWidget {
  final List<String> textList;

  const ComponentHelp({super.key, required this.textList});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: textList.map((text) => _text(text)).toList(),
    );
  }

  Widget _text(String text) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Text(text, style: const TextStyle(fontSize: 16)),
    );
  }
}

// Konten kesan
class KesanContent extends StatelessWidget {
  const KesanContent({super.key});

  static const List<String> textList = [
    "Tidak bisa berkata-kata..",
    "Hanya bisa diam, sedih, frustasi dan berusaha.. nyelesain tugas yang bikin PUSINGGGG BGTTT",
    "BISMILLAH DAPET NILAI YANG A😭😭",
  ];

  @override
  Widget build(BuildContext context) => const ComponentHelp(textList: textList);
}

// Konten saran
class SaranContent extends StatelessWidget {
  const SaranContent({super.key});

  static const List<String> textList = [
    "Saran = Kasih Dea Reigina nilai A ya pakk😭😭",
    "Dan kalo buat tugas tolong dirincikan pak perintahnya, kadang bingung sama perintahnya hehe",
  ];

  @override
  Widget build(BuildContext context) => const ComponentHelp(textList: textList);
}

// Halaman utama
class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  // Style untuk header accordion
  static const headerStyle = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  // Widget untuk card profil
  Widget _buildProfileCard(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/dea.jpg'),
            ),
            const SizedBox(height: 16),
            Text(
              'Dea Reigina',
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'NIM: 123220020',
              style: GoogleFonts.roboto(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Kelas: IF-C',
              style: GoogleFonts.roboto(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Testimonial',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Background circle
          Positioned(
            top: -80,
            left: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  _buildProfileCard(context),
                  Accordion(
                    headerBackgroundColor: Theme.of(context).primaryColor,
                    contentBackgroundColor: Colors.white,
                    contentBorderColor: Theme.of(context).primaryColor,
                    contentBorderWidth: 3,
                    contentHorizontalPadding: 20,
                    contentVerticalPadding: 20,
                    scaleWhenAnimating: false,
                    headerBorderRadius: 6,
                    headerPadding: const EdgeInsets.all(18),
                    sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
                    sectionClosingHapticFeedback: SectionHapticFeedback.light,
                    children: [
                      AccordionSection(
                        header: const Text('Kesan', style: headerStyle),
                        content: const Column(children: [KesanContent()]),
                      ),
                      AccordionSection(
                        header: const Text('Saran', style: headerStyle),
                        content: const Column(children: [SaranContent()]),
                      ),
                    ],
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
