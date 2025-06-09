import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KonversiPage extends StatefulWidget {
  const KonversiPage({super.key});

  @override
  State<KonversiPage> createState() => _KonversiPageState();
}

class _KonversiPageState extends State<KonversiPage> {
  // Dummy rates
  final Map<String, double> rates = {
    'IDR': 1.0,
    'USD': 0.000065,
    'EUR': 0.000060,
    'GBP': 0.000052,
  };
  String fromCurrency = 'IDR';
  String toCurrency = 'USD';
  double inputAmount = 0;
  double resultAmount = 0;

  // Waktu
  final List<String> zonaWaktu = ['WIB', 'WITA', 'WIT', 'London'];
  String fromTimeZone = 'WIB';
  String toTimeZone = 'London';
  TimeOfDay selectedTime = TimeOfDay.now();
  String resultTime = '';

  void konversiMataUang() {
    setState(() {
      resultAmount = inputAmount * (rates[toCurrency]! / rates[fromCurrency]!);
    });
  }

  void konversiWaktu() {
    // Offset dalam jam
    final offsets = {
      'WIB': 7,
      'WITA': 8,
      'WIT': 9,
      'London': 0,
    };
    int selisih = offsets[toTimeZone]! - offsets[fromTimeZone]!;
    int jamBaru = (selectedTime.hour + selisih) % 24;
    if (jamBaru < 0) jamBaru += 24;
    resultTime =
        '${jamBaru.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              Text('Konversi Mata Uang & Waktu', style: GoogleFonts.roboto())),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Konversi Mata Uang',
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'Jumlah', border: OutlineInputBorder()),
                    onChanged: (val) {
                      inputAmount = double.tryParse(val) ?? 0;
                    },
                  ),
                ),
                SizedBox(width: 8),
                DropdownButton<String>(
                  value: fromCurrency,
                  items: rates.keys
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => fromCurrency = val!),
                ),
                Icon(Icons.arrow_forward),
                DropdownButton<String>(
                  value: toCurrency,
                  items: rates.keys
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => toCurrency = val!),
                ),
              ],
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: konversiMataUang,
              child: Text('Konversi'),
            ),
            SizedBox(height: 8),
            Text('Hasil: $resultAmount $toCurrency',
                style: GoogleFonts.roboto(fontSize: 16)),
            Divider(height: 32),
            Text('Konversi Waktu',
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 8),
            Row(
              children: [
                DropdownButton<String>(
                  value: fromTimeZone,
                  items: zonaWaktu
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => fromTimeZone = val!),
                ),
                Icon(Icons.arrow_forward),
                DropdownButton<String>(
                  value: toTimeZone,
                  items: zonaWaktu
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => toTimeZone = val!),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showTimePicker(
                        context: context, initialTime: selectedTime);
                    if (picked != null) setState(() => selectedTime = picked);
                  },
                  child: Text('Pilih Jam'),
                ),
              ],
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: konversiWaktu,
              child: Text('Konversi Waktu'),
            ),
            SizedBox(height: 8),
            Text('Hasil: $resultTime ($toTimeZone)',
                style: GoogleFonts.roboto(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
