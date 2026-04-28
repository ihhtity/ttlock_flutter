import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/terms_content.dart';
import '../../theme.dart';

/// 用户协议页面
class UserAgreementPage extends StatelessWidget {
  const UserAgreementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final uaContent = TermsContent.getUserAgreementSections(l10n.locale.languageCode);
    
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
            _buildSection(l10n.uaAcceptance, uaContent['acceptance']!),
            
            _buildSection(l10n.uaServices, uaContent['services']!),
            
            _buildSection(l10n.uaRegistration, uaContent['registration']!),
            
            _buildSection(l10n.uaConduct, uaContent['conduct']!),
            
            _buildSection(l10n.uaIP, uaContent['ip']!),
            
            _buildSection(l10n.uaDisclaimer, uaContent['disclaimer']!),
            
            _buildSection(l10n.uaTermination, uaContent['termination']!),
            
            _buildSection(l10n.uaLaw, uaContent['law']!),
            
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
    final ppContent = TermsContent.getPrivacyPolicySections(l10n.locale.languageCode);
    
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
            _buildSection(l10n.ppIntro, ppContent['intro']!),
            
            _buildSection(l10n.ppCollection, ppContent['collection']!),
            
            _buildSection(l10n.ppCookies, ppContent['cookies']!),
            
            _buildSection(l10n.ppSharing, ppContent['sharing']!),
            
            _buildSection(l10n.ppProtection, ppContent['protection']!),
            
            _buildSection(l10n.ppRights, ppContent['rights']!),
            
            _buildSection(l10n.ppMinors, ppContent['minors']!),
            
            _buildSection(l10n.ppUpdates, ppContent['updates']!),
            
            _buildSection(l10n.ppContact, ppContent['contact']!),
            
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
