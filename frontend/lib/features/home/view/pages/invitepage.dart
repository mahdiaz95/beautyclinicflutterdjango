import 'package:PARLACLINIC/features/home/view/viewmodels/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InvitePage extends ConsumerStatefulWidget {
  const InvitePage({super.key});

  @override
  ConsumerState<InvitePage> createState() => _InvitePageState();
}

class _InvitePageState extends ConsumerState<InvitePage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isSubmitting = false;

  Future<void> _submitInvite() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      await ref.read(createinviteProvider(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
      ).future);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('دعوت با موفقیت ارسال شد'),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );

      // Refresh invite list
      await ref.read(inviteRequestsViewModelProvider.notifier).refresh();

      _formKey.currentState?.reset();
      _firstNameController.clear();
      _lastNameController.clear();
      _emailController.clear();
      _phoneController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطا: ${e.toString()}'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );
    }

    setState(() => _isSubmitting = false);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inviteListAsync = ref.watch(inviteRequestsViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'دعوت‌نامه‌ها',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade800, Colors.blue.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildIntroCard(),
                const SizedBox(height: 24),
                _buildInviteForm(),
                const SizedBox(height: 32),
                const Divider(color: Colors.grey, thickness: 0.5),
                _buildInviteList(inviteListAsync),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIntroCard() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          'با دعوت دوستان خود به کلینیک پارلا، از هر خدمتی که آنها انجام می‌دهند، درصدی به عنوان هدیه در کیف پول شما شارژ می‌شود. '
          'دوستان دعوت‌شده پس از تأیید و ثبت‌نام، در بخش «زیرمجموعه‌های من» در پروفایل کاربری شما قابل مشاهده خواهند بود. '
          'لطفاً توجه داشته باشید که در هر لحظه می‌توانید حداکثر دو نفر را دعوت کنید و پس از تأیید آنها، امکان دعوت افراد جدید فراهم می‌شود.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade800,
            height: 1.6,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.right,
        ),
      ),
    );
  }

  Widget _buildInviteForm() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'ارسال دعوت جدید',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                _firstNameController,
                'نام',
                'لطفاً نام را وارد کنید',
                Icons.person,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                _lastNameController,
                'نام خانوادگی',
                'لطفاً نام خانوادگی را وارد کنید',
                Icons.person_outline,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                _emailController,
                'ایمیل',
                'لطفاً ایمیل معتبر وارد کنید',
                Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'لطفاً ایمیل را وارد کنید';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'ایمیل نامعتبر است';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                _phoneController,
                'شماره تلفن',
                'لطفاً شماره تلفن معتبر وارد کنید',
                Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'لطفاً شماره تلفن را وارد کنید';
                  }
                  if (!RegExp(r'^09[0-9]{9}$').hasMatch(value)) {
                    return 'شماره تلفن نامعتبر است';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitInvite,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    shadowColor: Colors.blueAccent.withOpacity(0.4),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'ارسال دعوت',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInviteList(AsyncValue<List<dynamic>> inviteListAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'دعوت‌های ارسال‌شده',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 16),
        inviteListAsync.when(
          data: (invites) => invites.isEmpty
              ? Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'هیچ دعوتی یافت نشد.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: invites.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final invite = invites[index];
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        title: Text(
                          '${invite.firstName} ${invite.lastName}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blueAccent,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              'ایمیل: ${invite.email}',
                              style: TextStyle(color: Colors.grey.shade700),
                              textAlign: TextAlign.right,
                            ),
                            Text(
                              'تلفن: ${invite.phone}',
                              style: TextStyle(color: Colors.grey.shade700),
                              textAlign: TextAlign.right,
                            ),
                            Text(
                              'وضعیت: ${_getStatusText(invite.status)}',
                              style: TextStyle(
                                color: _getStatusColor(invite.status),
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                        trailing: Text(
                          invite.createdAt.toLocal().toString().split(' ')[0],
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade600),
                        ),
                        onTap: () {
                          // Optional: Add interaction for invite details
                        },
                      ),
                    );
                  },
                ),
          loading: () => const Center(
            child: CircularProgressIndicator(color: Colors.blueAccent),
          ),
          error: (e, _) => Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'خطا در دریافت دعوت‌نامه‌ها: $e',
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String errorMessage,
    IconData icon, {
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.blue.shade700),
        prefixIcon: Icon(icon, color: Colors.blue.shade700),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade700, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade700, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      textDirection: TextDirection.rtl,
      keyboardType: keyboardType,
      validator: validator ?? (value) => value!.isEmpty ? errorMessage : null,
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'در انتظار';
      case 'accepted':
        return 'تأیید شده';
      case 'rejected':
        return 'رد شده';
      default:
        return 'نامشخص';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange.shade700;
      case 'accepted':
        return Colors.green.shade700;
      case 'rejected':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade700;
    }
  }
}
