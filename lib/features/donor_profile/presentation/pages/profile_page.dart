import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharyan/features/home/presentation/pages/home_page.dart';
import 'package:sharyan/features/history/presentation/pages/donation_history_page.dart';
import 'package:sharyan/shared/widgets/custom_bottom_nav_bar.dart';
import 'package:sharyan/shared/widgets/custom_button.dart';
import 'package:sharyan/shared/widgets/custom_app_bar.dart';
import 'package:sharyan/features/auth/domain/entities/user_entity.dart';
import 'package:sharyan/features/donor_profile/presentation/providers/profile_provider.dart';
import 'package:sharyan/features/donor_profile/presentation/pages/edit_profile_page.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  int currentIndex = 2;

  @override
  void initState() {
    super.initState();
    // بدء الاستماع الفوري عند فتح الصفحة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).listenToUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);

    // عرض رسائل الخطأ
    ref.listen(profileProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: "الملف الشخصي",
        leading: Builder(
          builder: (context) => IconButton(
            icon:
                Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        
      ),
      body: profileState.isLoading && profileState.user == null
          // ── Loading ─────────────────────────────────────────────────────
          ? const Center(child: CircularProgressIndicator())
          // ── محتوى الصفحة ────────────────────────────────────────────────
          : SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildProfileSummaryCard(profileState.user),
                  const SizedBox(height: 24),
                  _buildPersonalInfoSection(profileState.user),
                  const SizedBox(height: 24),
                  _buildAddressSection(profileState.user),
                  const SizedBox(height: 32),
                  CustomButton(
                    text: 'تعديل المعلومات',
                    icon: Icons.edit,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => EditProfilePage(user: profileState.user),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
      bottomNavigationBar: buildBottomNavigationBar(
        context: context,
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DonationHistoryPage()),
            );
          } else {
            setState(() => currentIndex = index);
          }
        },
      ),
    );
  }

  // ─── بطاقة ملخص البروفايل ───────────────────────────────────────────────
  Widget _buildProfileSummaryCard(UserEntity? user) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar with badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Theme.of(context).dividerColor, width: 2),
                ),
                child: const Icon(Icons.person, size: 50),
              ),
              Positioned(
                bottom: 0,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.verified,
                        color: Colors.white, size: 14),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Name
          Text(
            user?.name ?? '---',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 8),

          // Blood type badge
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.water_drop,
                    color: Theme.of(context).primaryColor, size: 14),
                const SizedBox(width: 4),
                Text(
                  user?.bloodType ?? 'متبرع',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),

          // Stats (placeholder — يمكن ربطها بـ Firestore لاحقاً)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    '${user?.donationsCount ?? 0}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'عدد التبرعات',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).textTheme.bodySmall?.color ??
                          Colors.grey,
                    ),
                  ),
                ],
              ),
              Container(
                  width: 1,
                  height: 40,
                  color: Theme.of(context).dividerColor),
              Column(
                children: [
                  Text(
                    '${user?.points ?? 0}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'النقاط',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).textTheme.bodySmall?.color ??
                          Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── المعلومات الشخصية ───────────────────────────────────────────────────
  Widget _buildPersonalInfoSection(UserEntity? user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.person,
                color: Theme.of(context).primaryColor, size: 20),
            const SizedBox(width: 8),
            Text(
              'المعلومات الشخصية',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildInfoRow(
                icon: user?.gender == 'أنثى' ? Icons.female : Icons.male,
                label: 'الجنس',
                value: user?.gender ?? '---',
              ),
              const Divider(height: 24),
              _buildInfoRow(
                icon: Icons.cake_outlined,
                label: 'العمر',
                value: user != null ? '${user.age} سنة' : '---',
              ),
              const Divider(height: 24),
              _buildInfoRow(
                icon: Icons.phone_outlined,
                label: 'رقم الهاتف',
                value: user?.phone ?? '---',
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── العنوان ────────────────────────────────────────────────────────────
  Widget _buildAddressSection(UserEntity? user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.location_on,
                color: Theme.of(context).primaryColor, size: 20),
            const SizedBox(width: 8),
            Text(
              'العنوان',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildInfoRow(
                icon: Icons.map_outlined,
                label: 'المحافظة',
                value: user?.city ?? '---',
              ),
              const Divider(height: 24),
              _buildInfoRow(
                icon: Icons.location_city_outlined,
                label: 'المديرية',
                value: user?.area ?? '---',
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── صف معلومة واحدة ───────────────────────────────────────────────────
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon,
                color: Theme.of(context)
                    .iconTheme
                    .color
                    ?.withValues(alpha: 0.6),
                size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).textTheme.bodySmall?.color ??
                    Colors.grey,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ],
    );
  }
}
