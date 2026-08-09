import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/language_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/profile_model.dart';
import '../controller/profile_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6FB),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (controller.profile.value == null) {
          return _ErrorState(onRetry: controller.getProfile);
        }

        final profile = controller.profile.value!;

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Hero header ──────────────────────────────────────────
            SliverToBoxAdapter(child: _ProfileHero(profile: profile)),

            // ── Info cards ───────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionTitle(title: 'profile.contactInfo'.tr),
                    const SizedBox(height: 12),
                    _InfoCard(
                      children: [
                        _InfoRow(
                          icon: Icons.phone_rounded,
                          iconColor: AppColors.success,
                          label: 'profile.phone'.tr,
                          value: profile.phone,
                        ),
                        _Divider(),
                        _InfoRow(
                          icon: Icons.email_rounded,
                          iconColor: AppColors.info,
                          label: 'profile.email'.tr,
                          value: profile.email,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    _SectionTitle(title: 'profile.workInfo'.tr),
                    const SizedBox(height: 12),
                    _InfoCard(
                      children: [
                        _InfoRow(
                          icon: Icons.work_rounded,
                          iconColor: AppColors.primary,
                          label: 'profile.specialization'.tr,
                          value: profile.specialization,
                        ),
                        _Divider(),
                        _InfoRow(
                          icon: Icons.timeline_rounded,
                          iconColor: AppColors.warning,
                          label: 'profile.experience'.tr,
                          value: profile.experience,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    _SectionTitle(title: 'profile.shop'.tr),
                    const SizedBox(height: 12),
                    _InfoCard(
                      children: [
                        _InfoRow(
                          icon: Icons.store_rounded,
                          iconColor: const Color(0xff8B5CF6),
                          label: 'profile.shopName'.tr,
                          value: profile.shopName,
                        ),
                        _Divider(),
                        _InfoRow(
                          icon: Icons.location_on_rounded,
                          iconColor: AppColors.error,
                          label: 'profile.address'.tr,
                          value: profile.shopAddress,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    _SectionTitle(title: 'profile.settings'.tr),
                    const SizedBox(height: 12),
                    _InfoCard(
                      children: [
                        _LanguageRow(),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // ── Logout ────────────────────────────────────────
                    _LogoutButton(
                      onTap: () => Get.defaultDialog(
                        title: 'profile.logout'.tr,
                        middleText: 'profile.logoutConfirm'.tr,
                        textConfirm: 'profile.logoutYes'.tr,
                        textCancel: 'common.cancel'.tr,
                        confirmTextColor: Colors.white,
                        buttonColor: AppColors.error,
                        onConfirm: () {
                          Get.back();
                          controller.logout();
                        },
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hero header
// ─────────────────────────────────────────────────────────────────────────────
class _ProfileHero extends StatelessWidget {
  final ProfileModel profile;
  const _ProfileHero({required this.profile});

  String get _initials =>
      '${profile.firstName[0]}${profile.lastName[0]}'.toUpperCase();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff0B2C6A), Color(0xff1A4DB0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Stack(
        children: [
          // decorative circles
          Positioned(
            top: -10,
            right: -20,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -10,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),

          Column(
            children: [
              // Avatar
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xff22C55E), Color(0xff16A34A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Name
              Text(
                '${profile.firstName} ${profile.lastName}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              // Specialization
              Text(
                profile.specialization,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),

              const SizedBox(height: 16),

              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: profile.isActive
                      ? AppColors.success.withValues(alpha: 0.2)
                      : AppColors.error.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: profile.isActive
                        ? AppColors.success.withValues(alpha: 0.5)
                        : AppColors.error.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: profile.isActive
                            ? AppColors.success
                            : AppColors.error,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      profile.isActive
                          ? 'profile.active'.tr
                          : 'profile.inactive'.tr,
                      style: TextStyle(
                        color: profile.isActive
                            ? AppColors.success
                            : AppColors.error,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section title
// ─────────────────────────────────────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 17,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xff1A1A2E),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Info card container
// ─────────────────────────────────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Single info row
// ─────────────────────────────────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xff9E9E9E),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff1A1A2E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      indent: 70,
      endIndent: 16,
      color: Color(0xffF3F4F6),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Language row (Settings section)
// ─────────────────────────────────────────────────────────────────────────────
class _LanguageRow extends StatelessWidget {
  static const Color _iconColor = Color(0xff0EA5E9);

  // Language names are shown in their own script regardless of the app's
  // current locale, so they are intentionally not passed through `.tr`.
  static String _displayName(Locale? locale) =>
      locale?.languageCode == LanguageService.arabic.languageCode
      ? 'العربية'
      : 'English';

  void _showLanguageDialog() {
    Get.defaultDialog(
      title: 'language.select'.tr,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LanguageOption(
            label: 'English',
            selected: Get.locale?.languageCode == LanguageService.english.languageCode,
            onTap: () {
              LanguageService.changeLanguage(LanguageService.english);
              Get.back();
            },
          ),
          const SizedBox(height: 8),
          _LanguageOption(
            label: 'العربية',
            selected: Get.locale?.languageCode == LanguageService.arabic.languageCode,
            onTap: () {
              LanguageService.changeLanguage(LanguageService.arabic);
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showLanguageDialog,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.language_rounded,
                color: _iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                'language.title'.tr,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff1A1A2E),
                ),
              ),
            ),
            Text(
              _displayName(Get.locale),
              style: const TextStyle(fontSize: 13, color: Color(0xff9E9E9E)),
            ),
            const SizedBox(width: 6),
            Icon(
              Directionality.of(context) == TextDirection.rtl
                  ? Icons.chevron_left_rounded
                  : Icons.chevron_right_rounded,
              color: const Color(0xff9E9E9E),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0xffE5E7EB),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: selected ? AppColors.primary : const Color(0xff1A1A2E),
                ),
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 18),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Logout button
// ─────────────────────────────────────────────────────────────────────────────
class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;
  const _LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
            const SizedBox(width: 10),
            Text(
              'profile.logout'.tr,
              style: const TextStyle(
                color: AppColors.error,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Error state
// ─────────────────────────────────────────────────────────────────────────────
class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.person_off_rounded, size: 60, color: AppColors.grey),
          const SizedBox(height: 16),
          Text(
            'profile.loadError'.tr,
            style: const TextStyle(fontSize: 16, color: AppColors.darkGrey),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: onRetry,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'common.retry'.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
