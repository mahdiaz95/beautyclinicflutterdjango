import 'package:PARLACLINIC/features/home/view/pages/ProfilePage.dart';
import 'package:PARLACLINIC/features/home/view/pages/articlepage.dart';
import 'package:PARLACLINIC/features/home/view/pages/contactpage.dart';
import 'package:PARLACLINIC/features/home/view/pages/faqpage.dart';
import 'package:PARLACLINIC/features/home/view/pages/invitepage.dart';
import 'package:PARLACLINIC/features/home/view/pages/personnelpage.dart';
import 'package:PARLACLINIC/features/home/view/pages/portfoliopage.dart';
import 'package:PARLACLINIC/features/home/view/pages/serviceavaiablepage.dart';
import 'package:PARLACLINIC/features/home/view/pages/servicepage.dart';
import 'package:PARLACLINIC/features/home/view/pages/takhfifpage.dart';
import 'package:PARLACLINIC/features/home/view/pages/transactippage.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _currentIndex = 2;

  final List<Widget> _pages = [
    const ProfilePage(),
    const ContactPage(),
    HomeTab(),
    const WalletPage(),
    const ServicePage(),
  ];

  final List<Map<String, dynamic>> navItems = [
    {'icon': Icons.person, 'title': 'پروفایل'},
    {'icon': Icons.contact_page, 'title': 'درباره ما'},
    {'icon': Icons.apps, 'title': 'خانه'},
    {'icon': Icons.sync_alt, 'title': 'تراکنش‌ها'},
    {'icon': Icons.medical_services, 'title': 'خدمات'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey.shade600,
        backgroundColor: Colors.white,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: navItems.map((item) {
          return BottomNavigationBarItem(
            icon: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(8),
              child: Icon(item['icon'], size: 24),
            ),
            label: item['title'],
          );
        }).toList(),
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  HomeTab({super.key});

  final List<Map<String, String>> features = [
    {'title': 'تخفیف‌ها', 'icon': '🎁'},
    {'title': 'سوالات متداول', 'icon': '❓'},
    {'title': 'نمونه کارها', 'icon': '🧾'},
    {'title': 'دعوت دوستان', 'icon': '📨'},
    {'title': 'مقالات', 'icon': '📚'},
    {'title': 'پرسنل', 'icon': '👩‍⚕️'},
    {'title': 'خدمات قابل ارائه', 'icon': '💆‍♀️'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'کلینیک پارلا',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.blue.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blueAccent.shade100, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blueAccent, Colors.blue.shade700],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.favorite, color: Colors.white, size: 40),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'به کلینیک پارلا خوش آمدید',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: GridView.builder(
                    itemCount: features.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.2,
                    ),
                    itemBuilder: (context, index) {
                      final feature = features[index];
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          child: InkWell(
                            onTap: () {
                              if (index == 0) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const PromotionsPage()),
                                );
                              } else if (index == 1) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const FAQPage()),
                                );
                              } else if (index == 2) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const PortfolioPage()),
                                );
                              } else if (index == 3) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const InvitePage()),
                                );
                              } else if (index == 4) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const ArticlesPage()),
                                );
                              } else if (index == 5) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const PersonnelPage()),
                                );
                              } else if (index == 6) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const ServicesPage()),
                                );
                              }
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 32,
                                  backgroundColor:
                                      Colors.blueAccent.withOpacity(0.1),
                                  child: Text(
                                    feature['icon']!,
                                    style: const TextStyle(fontSize: 28),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  feature['title']!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blueAccent.shade700,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
