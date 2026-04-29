import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../theme.dart';

/// 用户协议页面
class UserAgreementPage extends StatelessWidget {
  const UserAgreementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(l10n.userAgreement),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.primaryGradient,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(l10n.uaAcceptance, l10n.translate('uaAcceptanceContent')),
            
            _buildSection(l10n.uaServices, l10n.translate('uaServicesContent')),
            
            _buildSection(l10n.uaRegistration, l10n.translate('uaRegistrationContent')),
            
            _buildSection(l10n.uaConduct, l10n.translate('uaConductContent')),
            
            _buildSection(l10n.uaIP, l10n.translate('uaIPContent')),
            
            _buildSection(l10n.uaDisclaimer, l10n.translate('uaDisclaimerContent')),
            
            _buildSection(l10n.uaTermination, l10n.translate('uaTerminationContent')),
            
            _buildSection(l10n.uaLaw, l10n.translate('uaLawContent')),
            
            const SizedBox(height: AppTheme.spacingLarge),
            
            Text(
              '${l10n.lastUpdated}: 2026-04-25',
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSmall),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.8,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// 隐私政策页面
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(l10n.privacyPolicy),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.primaryGradient,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(l10n.ppIntro, l10n.translate('ppIntroContent')),
            
            _buildSection(l10n.ppCollection, l10n.translate('ppCollectionContent')),
            
            _buildSection(l10n.ppCookies, l10n.translate('ppCookiesContent')),
            
            _buildSection(l10n.ppSharing, l10n.translate('ppSharingContent')),
            
            _buildSection(l10n.ppProtection, l10n.translate('ppProtectionContent')),
            
            _buildSection(l10n.ppRights, l10n.translate('ppRightsContent')),
            
            _buildSection(l10n.ppMinors, l10n.translate('ppMinorsContent')),
            
            _buildSection(l10n.ppUpdates, l10n.translate('ppUpdatesContent')),
            
            _buildSection(l10n.ppContact, l10n.translate('ppContactContent')),
            
            const SizedBox(height: AppTheme.spacingLarge),
            
            Text(
              '${l10n.lastUpdated}: 2026-04-25',
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSmall),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.8,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
