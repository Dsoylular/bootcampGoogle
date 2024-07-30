import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../helperFiles/app_colors.dart';

class PawdiInfo extends StatelessWidget {
  const PawdiInfo({super.key});

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Link kopyalandı!'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [pink, pink.withOpacity(0.8)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
              ),
              child: const Center(
                child: Text(
                  "Pawdi",
                  style: TextStyle(
                    fontSize: 40,
                    fontFamily: 'Baloo',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "Ürün Açıklaması:",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Baloo',
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Pawdi evcil hayvanının hareketliliği, yemek yemesi veya uyku durumunu takip edebildiğimiz ve bir sıkıntı ile karşılaştığında 'veterinere gitmeli miyim?' veya gitmeden önce ne yapmalıyım gibi sorulara yapay zeka ile cevap alabileceğimiz bir uygulama.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Ürün Birincil Fonksiyonu:",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Baloo',
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Evcil hayvanları hangi durumlarda veterinere gitmeli sorularının cevabına uygulama sayesinde hızlıca cevap bulabilecek ve veterinere gitmeden bazı sorunlar için çözüm sağlayabilecek. Evcil hayvanlarının durumlarını uygulama üzerinden takip edebilecek ve oluşabilecek bazı rahatsızlıklar için hızlıca çözüm sağlayabilecekler.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Ürün İkinci Fonksiyonu:",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Baloo',
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Uygulama içindeki blog yazıları sayesinde diğer kullanıcıların yazılarını takip edebilecek belki veterinerlerin yazıları sayelerinde evcil hayvanları ile ilgili daha geniş bilgi sahibi olabilecekler.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Ürün Özellikleri:",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Baloo',
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "• Evcil hayvan sahipleri hayvanları hakkında uykulu-uykusuz, hareketli-hareketsiz gibi durumlarını takip edebilecekler.\n"
                        "• Her evcil hayvan için ayrı bir profil sayfası olacak ve bu profil sayfalarında evcil hayvanlar ile ilgili profil fotoğrafı, isim, hakkında, durum gibi bilgileri kaydedebilecek ve düzenlemeler yapılabilecek.\n"
                        "• Kendi profil sayfamızda yine fotoğraf, kişisel bilgileri ve hakkında gibi ayrıntıları kaydedebileceğiz.\n"
                        "• Ask Me sayfasında evcil hayvanlarımız hakkında yapay zekaya sorular sorabilecek bazı durumlar için nasıl bir yol izleyeceğimizi bu sayede oluşturabileceğiz.\n"
                        "• Ask Me sayfasındaki sık sorulan sorular kısmında tuvalet-sağlık-beslenme-genel bazı sık sorulan soruların cevabına hızlıca ulaşılabilecek.\n"
                        "• Journal sayfasında evcil hayvanlarımız hakkında blog yazıları yazabilecek ya da diğer kullanıcıların/veterinerlerin eklemiş olduğu blog yazılarını okuyabileceğiz.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "İletişim (kopyalamak için tıklayınız):",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Baloo',
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () => _copyToClipboard(context,
                        "https://www.linkedin.com/in/pawdi-pawdi-06941a320?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app"),
                    child: Row(
                      children: [
                        Icon(Icons.link, color: pink),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "LinkedIn",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Baloo',
                              color: darkBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () => _copyToClipboard(context,
                        "https://www.instagram.com/pawdiouaf56?igsh=MXI3YThsdmxvanUyeA%3D%3D"),
                    child: Row(
                      children: [
                        Icon(Icons.link, color: pink),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Instagram",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Baloo',
                              color: darkBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  GestureDetector(
                    onTap: () => _copyToClipboard(context, "pawdi.oua.f56@gmail.com"),
                    child: Row(
                      children: [
                        Icon(Icons.email, color: pink),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Mail",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Baloo',
                              color: darkBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  GestureDetector(
                    onTap: () => _copyToClipboard(context,
                        "https://github.com/Dsoylular/bootcampGoogle"),
                    child: Row(
                      children: [
                        Icon(Icons.code, color: pink),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Github",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Baloo',
                              color: darkBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
