import 'package:flutter/material.dart';
import 'package:bmprogresshud/progresshud.dart';
import 'package:ttlock_flutter/ttelectricMeter.dart';
import 'package:ttlock_flutter/ttwaterMeter.dart';
import 'scan_page.dart';
import 'config.dart';
import 'theme.dart';
import 'l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  HomePage() : super();
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BuildContext? _context;

  void _startScanGateway() {
    if (GatewayConfig.uid == 0 ||
        GatewayConfig.ttlockLoginPassword.length == 0) {
      String text = 'Please config the ttlockUid and the ttlockLoginPassword';
      ProgressHud.of(_context!)!.showAndDismiss(ProgressHudType.error, text);
      return;
    }
    _startScan(ScanType.gateway);
  }

  void _startScanLock() {
    _startScan(ScanType.lock);
  }

  void _startScanElectricMeter() {
    ElectricMeterServerParamMode electricMeterServerParamMode =
        ElectricMeterServerParamMode();
    electricMeterServerParamMode.url = "https://cntestservlet.sciener.cn";
    electricMeterServerParamMode.clientId = '607ab4bcc9504a5da58c43575a1b3746';
    electricMeterServerParamMode.accessToken =
        'fj81Mf4Mnglw5knoaTmjLG8c4H2fdhpWB37wwFJh2dI=';

    TTElectricMeter.configServer(electricMeterServerParamMode);
    _startScan(ScanType.electricMeter);
  }

  void _startScanWaterMeter() {
    WaterMeterServerParamMode waterMeterServerParamMode =
        WaterMeterServerParamMode();

    waterMeterServerParamMode.url =
        "https://cnapi.ttlock.com/v3/waterMeter/executeCommand";
    waterMeterServerParamMode.clientId = '8fdb192b4f0245cd99323f7dd714783e';
    waterMeterServerParamMode.accessToken =
        '731480c3e35c567add6a5f6e7531c292';

    TTWaterMeter.configServer(waterMeterServerParamMode);
    _startScan(ScanType.waterMeter);
  }

  void _startKeyPadPage() {
    _startScan(ScanType.keyPad);
  }

  void _startScan(ScanType scanType) {
    Navigator.push(context,
        new MaterialPageRoute(builder: (BuildContext context) {
      return ScanPage(
        scanType: scanType,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).appName),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.primaryGradient,
          ),
        ),
        actions: [
          // 语言切换按钮
          PopupMenuButton<String>(
            icon: const Icon(Icons.language_rounded, color: Colors.white),
            onSelected: (String locale) {
              // TODO: 实现语言切换逻辑
              print('切换到: $locale');
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'zh_CN',
                child: Row(
                  children: [
                    Text('🇨🇳', style: TextStyle(fontSize: 20)),
                    SizedBox(width: 8),
                    Text('简体中文'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'en_US',
                child: Row(
                  children: [
                    Text('🇺🇸', style: TextStyle(fontSize: 20)),
                    SizedBox(width: 8),
                    Text('English'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ProgressHud(
        child: Builder(
          builder: (context) {
            _context = context;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppTheme.spacingLarge),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(
                        AppTheme.borderRadiusXLarge,
                      ),
                      boxShadow: AppTheme.elevatedShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.lock_open_rounded,
                          color: Colors.white,
                          size: 48,
                        ),
                        const SizedBox(height: AppTheme.spacingMedium),
                        const Text(
                          '欢迎使用宝士力得',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingSmall),
                        Text(
                          '管理您的智能设备',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppTheme.spacingXLarge),
                  
                  // Section Title
                  const Text(
                    '智能设备',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingMedium),
                  
                  // Device Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: AppTheme.spacingMedium,
                    mainAxisSpacing: AppTheme.spacingMedium,
                    childAspectRatio: 1.1,
                    children: [
                      _buildDeviceCard(
                        icon: Icons.lock_rounded,
                        title: '智能门锁',
                        subtitle: '控制与管理',
                        color: const Color(0xFF3B82F6),
                        onTap: _startScanLock,
                      ),
                      _buildDeviceCard(
                        icon: Icons.wifi_tethering_rounded,
                        title: '网关',
                        subtitle: '网络中枢',
                        color: const Color(0xFF8B5CF6),
                        onTap: _startScanGateway,
                      ),
                      _buildDeviceCard(
                        icon: Icons.electric_bolt_rounded,
                        title: '电表',
                        subtitle: '电力监控',
                        color: const Color(0xFFF59E0B),
                        onTap: _startScanElectricMeter,
                      ),
                      _buildDeviceCard(
                        icon: Icons.keyboard_rounded,
                        title: '键盘',
                        subtitle: '门禁控制',
                        color: const Color(0xFF10B981),
                        onTap: _startKeyPadPage,
                      ),
                      _buildDeviceCard(
                        icon: Icons.water_drop_rounded,
                        title: '水表',
                        subtitle: '用量追踪',
                        color: const Color(0xFF06B6D4),
                        onTap: _startScanWaterMeter,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppTheme.spacingLarge),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDeviceCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingMedium),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 36,
              ),
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
