import 'package:flutter/material.dart';
import '../../helperFiles/app_colors.dart';

class VaccinationInfoPage extends StatelessWidget {
  const VaccinationInfoPage({super.key});

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
              "Aşı Takip Grafik\nKullanım Kılavuzu",
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
                  'assets/images/takvim_foto.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Text(
                "Pembe renk ile gösterilen tarih, bugünü göstermektedir.\n\n"
                    "Mavi ile gösterilen tarihler, şu anda kayıtlı gözüken aşı tarihleridir.\n\n"
                    "Eğer bu tarihler haricinde başka bir tarih eklemek isterseniz, bu tarihe tıklayıp kaydet demeniz yeterli olacaktır.\n\n"
                    "İsteğiniz zaten var olan tarihleri değiştirmek ise değiştirmek istediğiniz tarihe tıklayın. Bu hareket seçilen tarihi silecektir.\n\n"
                    "Silindikten sonra değiştirmek istediğiniz yeni tarihe tıklayabilir, veya değişiklik yapmadan kaydet butonuna tıklayabilirsiniz.",
                style: TextStyle(
                  fontFamily: 'Baloo',
                  fontSize: 16,
                  height: 1.5,
                  color: brown,
                ),
                textAlign: TextAlign.left,
              ),
            )

          ],
        ),
      ),
    );
  }
}
