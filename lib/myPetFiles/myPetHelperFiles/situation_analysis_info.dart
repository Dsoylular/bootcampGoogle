import 'package:flutter/material.dart';
import '../../helperFiles/app_colors.dart';

class SituationAnalysisInfo extends StatelessWidget {
  const SituationAnalysisInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: cream,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 65),
            Text(
              "Durum Takip Grafik\nKullanım Kılavuzu",
              style: TextStyle(
                fontFamily: 'Baloo',
                fontSize: 24,
                color: darkBlue,
              ),
              textAlign: TextAlign.center,
            ),
            const Divider(),
            const SizedBox(height: 20),
            Container(
              constraints: BoxConstraints(
                maxWidth: screenWidth * 0.8,
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.asset(
                  'assets/images/situation_photo.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Text(
                "Bu grafikte, son 7 günün değişimlerini takip edebilirsiniz\n\n"
                    "Evcil hayvanınızın normal ve sağlıklı bir ortamdaki davranışı 3 olarak temsil edilmektedir.\n\n"
                    "Yemek, Egzersiz, Kilo, Uyku sekmeleri arasında dolaşarak son zamanlardaki anormal değişimleri takip edebilirsiniz.",
                style: TextStyle(
                  fontFamily: 'Baloo',
                  fontSize: 16,
                  height: 1.5,
                  color: brown,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              constraints: BoxConstraints(
                maxWidth: screenWidth * 0.8,
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.asset(
                  'assets/images/check_up_photo.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Text(
                "Check-Up sayfasında evcil hayvanınızın son zamanlardaki davranış model verilerini 1-5 arasında değerlendirip girebilirsiniz",
                style: TextStyle(
                  fontFamily: 'Baloo',
                  fontSize: 16,
                  height: 1.5,
                  color: brown,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
