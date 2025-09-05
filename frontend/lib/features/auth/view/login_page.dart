import 'package:PARLACLINIC/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:PARLACLINIC/features/home/view/pages/homepage.dart';
import 'package:PARLACLINIC/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? appVersion;
  bool _isPrivacyPolicyAccepted = false;

  @override
  void initState() {
    super.initState();
    _loadAppVersion();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final upgradeDetails = ref.read(upgradeDetailsProvider);
      if (upgradeDetails != null) {
        _showUpgradeDialog(upgradeDetails);
        ref.read(upgradeDetailsProvider.notifier).state = null;
      }
    });
  }

  void _showUpgradeDialog(String downloadUrl) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        title: Text(
          'نسخه قدیمی است',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent.shade700,
          ),
          textDirection: TextDirection.rtl,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: TextDirection.rtl,
          children: [
            Text(
              'نسخه فعلی اپلیکیشن پارلا منقضی شده است.\nبرای دانلود نسخه جدید روی "دانلود" کلیک کنید:',
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 8),
            Text(
              downloadUrl,
              style: const TextStyle(color: Colors.blueAccent, fontSize: 14),
              textDirection: TextDirection.ltr,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'انصراف',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _launchUrl(downloadUrl);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('دانلود'),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطا در باز کردن $url'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
    });
  }

  void _showHelpSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: TextDirection.rtl,
          children: [
            Text(
              'پشتیبانی کلینیک پارلا',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent.shade700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'برای پشتیبانی یا طرح هرگونه سوال با شماره زیر تماس حاصل فرمایید:',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 8),
            Text(
              'شماره همراه: 09150910045',
              style: TextStyle(fontSize: 16, color: Colors.blueAccent.shade700),
            ),
            const SizedBox(height: 8),
            Text(
              'کلینیک پارلا انتخاب اول زیباجویان',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    elevation: 5,
                  ),
                  child: const Text(
                    'انصراف',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPrivacyPolicyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        title: Text(
          'سیاست حفظ حریم خصوصی',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent.shade700,
          ),
          textDirection: TextDirection.rtl,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            textDirection: TextDirection.rtl,
            children: [
              Text(
                'اپلیکیشن کلینیک پارلا متعهد به حفاظت از حریم خصوصی کاربران است. اطلاعات شما از طریق تماس یا مراجعه حضوری به کلینیک دریافت و ثبت می‌گردد. آدرس کلینیک: مشهد - احمدآباد - پرستار ۱/۸ - ساختمان اکسیر - طبقه چهارم، شماره تماس: ۰۵۱۳۸۴۶۶۵۲۳. این سیاست حفظ حریم خصوصی شرح می‌دهد که چه اطلاعاتی از شما جمع‌آوری می‌کنیم، چگونه از آن‌ها استفاده می‌کنیم و چگونه از آن‌ها محافظت می‌کنیم.',
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 16),
              Text(
                'داده‌های جمع‌آوری‌شده:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent.shade700,
                ),
              ),
              Text(
                '- کد ملی: برای شناسایی و احراز هویت کاربر.\n'
                '- شماره تلفن (اولیه و ثانویه): برای ارتباط با کاربر و اطلاع‌رسانی خدمات.\n'
                '- شماره پرونده: برای مدیریت سوابق پزشکی کاربر.\n'
                '- نام پدر: برای تکمیل اطلاعات هویتی.\n'
                '- نحوه آشنایی: برای تحلیل بازاریابی و بهبود خدمات.\n'
                '- شماره تلفن ثابت: برای تماس‌های احتمالی.\n'
                '- وضعیت تأهل: برای تحلیل آماری و ارائه خدمات متناسب.\n'
                '- شهر: برای ارائه خدمات محلی.\n'
                '- تاریخ تولد: برای تأیید سن و ارائه خدمات متناسب.\n'
                '- شغل: برای تحلیل آماری و شخصی‌سازی خدمات.\n'
                '- جنسیت: برای ارائه خدمات متناسب با نیازهای کاربر.\n'
                '- کد رفرال و معرف: برای مدیریت برنامه‌های ارجاع و پاداش.',
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 16),
              Text(
                'هدف از جمع‌آوری داده‌ها:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent.shade700,
                ),
              ),
              Text(
                'این اطلاعات صرفاً برای ارائه خدمات کلینیک پارلا، احراز هویت، مدیریت پرونده‌های پزشکی، اطلاع‌رسانی و بهبود تجربه کاربری استفاده می‌شوند. ما متعهد هستیم که اطلاعات شما را با اشخاص یا سازمان‌های ثالث به اشتراک نگذاریم، مگر در مواردی که قانوناً الزام شده باشد.',
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 16),
              Text(
                'حفاظت از داده‌ها:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent.shade700,
                ),
              ),
              Text(
                'تمامی داده‌های شما با استفاده از پروتکل‌های رمزنگاری مدرن (مانند HTTPS) منتقل و ذخیره می‌شوند. ما اقدامات امنیتی لازم را برای حفاظت از اطلاعات شما در برابر دسترسی غیرمجاز، افشا یا سوءاستفاده انجام می‌دهیم.',
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 16),
              Text(
                'حقوق شما:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent.shade700,
                ),
              ),
              Text(
                'شما حق دارید درخواست دسترسی، اصلاح یا حذف اطلاعات شخصی خود را داشته باشید. برای این منظور، می‌توانید با پشتیبانی کلینیک پارلا از طریق شماره 09150910045 تماس بگیرید.',
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 16),
              Text(
                'تماس با ما:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent.shade700,
                ),
              ),
              Text(
                'در صورت داشتن هرگونه سوال درباره این سیاست حفظ حریم خصوصی، لطفاً با ما از طریق شماره 09150910045 تماس بگیرید.',
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('بستن'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref
        .watch(authViewModelProvider.select((val) => val?.isLoading == true));

    ref.listen(authViewModelProvider, (_, next) {
      next?.when(
        data: (data) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Homepage()),
            (_) => false,
          );
        },
        error: (error, st) {
          final errorMessage = error.toString();
          if (errorMessage.contains("link")) {
            final downloadUrl = extractUrl(errorMessage);
            _showUpgradeDialog(downloadUrl);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: Colors.red.shade600,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        loading: () {},
      );
    });

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blueAccent.shade100, Colors.white],
            ),
          ),
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                  ),
                )
              : SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(
                              Icons.help_outline,
                              color: Colors.blueAccent.shade700,
                            ),
                            onPressed: () => _showHelpSheet(context),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          child: Image.asset(
                            'assets/background.png',
                            fit: BoxFit.contain,
                            width: double.infinity,
                          ),
                        ),
                        Card(
                          elevation: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      'کلینیک پارلا',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent.shade700,
                                      ),
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  TextFormField(
                                    controller: nameController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor:
                                          Colors.blueAccent.withOpacity(0.05),
                                      labelText: "نام کاربری",
                                      labelStyle: TextStyle(
                                          color: Colors.grey.shade700),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade300),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            color: Colors.blueAccent, width: 2),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'لطفاً نام کاربری را وارد کنید';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: passwordController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor:
                                          Colors.blueAccent.withOpacity(0.05),
                                      labelText: "رمز عبور",
                                      labelStyle: TextStyle(
                                          color: Colors.grey.shade700),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade300),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            color: Colors.blueAccent, width: 2),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'لطفاً رمز عبور را وارد کنید';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Checkbox(
                                        value: _isPrivacyPolicyAccepted,
                                        onChanged: (value) {
                                          setState(() {
                                            _isPrivacyPolicyAccepted =
                                                value ?? false;
                                          });
                                        },
                                        activeColor: Colors.blueAccent,
                                      ),
                                      Flexible(
                                        child: GestureDetector(
                                          onTap: () =>
                                              _showPrivacyPolicyDialog(context),
                                          child: Text(
                                            'با سیاست حفظ حریم خصوصی موافقم',
                                            style: TextStyle(
                                              color: Colors.blueAccent.shade700,
                                              fontSize: 14,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueAccent,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        elevation: 5,
                                        minimumSize:
                                            const Size(double.infinity, 50),
                                      ),
                                      onPressed: _isPrivacyPolicyAccepted
                                          ? () {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                ref
                                                    .read(authViewModelProvider
                                                        .notifier)
                                                    .loginUser(
                                                      email:
                                                          nameController.text,
                                                      password:
                                                          passwordController
                                                              .text,
                                                    );
                                              }
                                            }
                                          : null,
                                      child: const Text(
                                        "ورود",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Center(
                                    child: GestureDetector(
                                      onTap: () => _showHelpSheet(context),
                                      child: Text(
                                        "نیاز به کمک دارم",
                                        style: TextStyle(
                                          color: Colors.blueAccent.shade700,
                                          fontSize: 14,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () => _launchUrl('tel:09154942758'),
                          child: Center(
                            child: Text(
                              'ساخته‌شده توسط گروه نرم‌افزاری اطلس',
                              style: TextStyle(
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          appVersion != null
                              ? "نسخه $appVersion"
                              : "در حال بارگذاری نسخه...",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  String extractUrl(String message) {
    final regex = RegExp(r'link:\s*(.+)', caseSensitive: false);
    final match = regex.firstMatch(message);
    return match?.group(1)?.trim() ?? '';
  }
}
