/// 用户协议和隐私政策的多语言内容管理
class TermsContent {
  /// 获取用户协议内容
  static Map<String, String> getUserAgreementSections(String languageCode) {
    if (languageCode == 'zh') {
      return {
        'acceptance': '''
1.1 欢迎使用宝士力得智能家居应用（以下简称"本应用"）。在使用本应用之前，请您仔细阅读并理解本用户协议（以下简称"本协议"）。

1.2 当您注册、登录或使用本应用时，即表示您已阅读、理解并同意接受本协议的全部内容。

1.3 我们有权根据需要不时地修订本协议及/或各类规则，并以线上公告的方式进行变更公告。若您在前述公告修订后继续使用本应用，即视为您已阅读、理解并接受经过修订的协议和规则。
''',
        'services': '''
2.1 本应用提供智能门锁、网关、电表、水表等智能设备的管理和控制服务。

2.2 您理解并同意，本应用提供的服务中包含的任何文字、图表、音频、视频、软件、程序、代码等信息或材料均受著作权法、商标法或其他法律法规的保护。

2.3 我们致力于为您提供稳定、安全的服务，但不保证服务一定能满足您的要求，也不保证服务不会中断。
''',
        'registration': '''
3.1 您在注册账号时，应提供真实、准确、完整的个人信息，并及时更新这些信息。

3.2 您有责任妥善保管您的账号和密码，对您账号下发生的所有活动承担责任。

3.3 如您发现任何非法使用您账号的情况，应立即通知我们。
''',
        'conduct': '''
4.1 您在使用本应用时，应遵守相关法律法规，不得利用本应用从事违法违规行为。

4.2 您不得对本应用进行反向工程、反向编译或反汇编，不得试图发现源代码。

4.3 您不得通过任何方式干扰或试图干扰本应用的正常运行。
''',
        'ip': '''
5.1 本应用及其包含的所有内容（包括但不限于文字、图片、音频、视频、软件、程序等）的知识产权均归我们或相关权利人所有。

5.2 未经我们或相关权利人的书面许可，您不得以任何方式使用、复制、传播、展示、修改这些内容。
''',
        'disclaimer': '''
6.1 在法律允许的范围内，我们对因以下原因导致的损失不承担责任：
   - 不可抗力因素
   - 您的操作不当
   - 第三方服务的问题
   - 网络通信故障

6.2 您理解并同意，使用本应用产生的风险由您自行承担。
''',
        'termination': '''
7.1 您有权随时停止使用本应用并注销账号。

7.2 如您违反本协议的任何条款，我们有权立即终止向您提供服务。
''',
        'law': '''
8.1 本协议的订立、执行和解释及争议的解决均应适用中华人民共和国法律。

8.2 如双方就本协议内容或其执行发生任何争议，应尽量友好协商解决；协商不成时，任何一方均可向我们所在地的人民法院提起诉讼。
''',
      };
    } else {
      // 英文版本
      return {
        'acceptance': '''
1.1 Welcome to BSLD Smart Home Application (hereinafter referred to as "this Application"). Before using this Application, please read and understand this User Agreement (hereinafter referred to as "this Agreement") carefully.

1.2 By registering, logging in, or using this Application, you acknowledge that you have read, understood, and agree to be bound by all terms of this Agreement.

1.3 We reserve the right to revise this Agreement and/or various rules from time to time as needed, and will post changes through online announcements. If you continue to use this Application after such announcements, you are deemed to have read, understood, and accepted the revised Agreement and rules.
''',
        'services': '''
2.1 This Application provides management and control services for smart devices including smart locks, gateways, electric meters, water meters, etc.

2.2 You understand and agree that any information or materials contained in the services provided by this Application, including but not limited to text, charts, audio, video, software, programs, code, etc., are protected by copyright law, trademark law, or other laws and regulations.

2.3 We are committed to providing you with stable and secure services, but we do not guarantee that the services will meet your requirements or that the services will not be interrupted.
''',
        'registration': '''
3.1 When registering an account, you should provide true, accurate, and complete personal information, and update this information in a timely manner.

3.2 You are responsible for properly safeguarding your account and password, and for all activities that occur under your account.

3.3 If you discover any unauthorized use of your account, you should notify us immediately.
''',
        'conduct': '''
4.1 When using this Application, you must comply with relevant laws and regulations, and must not use this Application to engage in illegal activities.

4.2 You must not reverse engineer, decompile, or disassemble this Application, or attempt to discover the source code.

4.3 You must not interfere or attempt to interfere with the normal operation of this Application in any way.
''',
        'ip': '''
5.1 The intellectual property rights of this Application and all its contents (including but not limited to text, images, audio, video, software, programs, etc.) belong to us or related rights holders.

5.2 Without written permission from us or related rights holders, you may not use, copy, distribute, display, or modify these contents in any way.
''',
        'disclaimer': '''
6.1 To the extent permitted by law, we are not liable for losses caused by the following reasons:
   - Force majeure factors
   - Your improper operations
   - Problems with third-party services
   - Network communication failures

6.2 You understand and agree that you bear the risks arising from the use of this Application.
''',
        'termination': '''
7.1 You have the right to stop using this Application and delete your account at any time.

7.2 If you violate any terms of this Agreement, we have the right to immediately terminate the provision of services to you.
''',
        'law': '''
8.1 The formation, execution, interpretation of this Agreement, and the resolution of disputes shall be governed by the laws of the People's Republic of China.

8.2 If any dispute arises between the parties regarding the content or execution of this Agreement, both parties shall try to resolve it through friendly negotiations; if negotiations fail, either party may file a lawsuit with the people's court where we are located.
''',
      };
    }
  }

  /// 获取隐私政策内容
  static Map<String, String> getPrivacyPolicySections(String languageCode) {
    if (languageCode == 'zh') {
      return {
        'intro': '''
宝士力得（以下简称"我们"）深知个人信息对您的重要性，我们将按照法律法规要求，采取相应的安全保护措施，尽力保护您的个人信息安全可控。

本隐私政策将帮助您了解以下内容：
1. 我们如何收集和使用您的个人信息
2. 我们如何使用 Cookie 和相关技术
3. 我们如何共享、转让、公开披露您的个人信息
4. 我们如何保护您的个人信息
5. 您的权利
6. 我们如何处理未成年人的个人信息
7. 本隐私政策如何更新
8. 如何联系我们
''',
        'collection': '''
1.1 为了向您提供服务，我们会收集以下信息：
   - 账号信息：手机号码、密码等注册信息
   - 设备信息：蓝牙MAC地址、设备型号、固件版本等
   - 使用记录：开锁记录、操作日志等
   - 位置信息：用于提供基于位置的服务（需您授权）

1.2 我们会出于以下目的收集和使用您的信息：
   - 提供智能设备管理和控制服务
   - 保障服务安全
   - 改进和优化服务
   - 遵守法律法规要求
''',
        'cookies': '''
2.1 为确保应用正常运转，我们会在您的设备上存储名为 Cookie 的小数据文件。

2.2 Cookie 通常包含标识符、站点名称以及一些号码和字符。借助于 Cookie，我们能够存储您的偏好设置等数据。

2.3 您可以根据自己的偏好管理或删除 Cookie。
''',
        'sharing': '''
3.1 共享：我们不会与任何公司、组织和个人分享您的个人信息，但以下情况除外：
   - 获得您的明确同意
   - 根据法律法规或政府主管部门的强制性要求
   - 与我们的关联公司共享（仅会共享必要的个人信息）

3.2 转让：我们不会将您的个人信息转让给任何公司、组织和个人，但以下情况除外：
   - 获得您的明确同意
   - 在涉及合并、收购或破产清算时

3.3 公开披露：我们仅会在以下情况下公开披露您的个人信息：
   - 获得您明确同意
   - 基于法律的披露
''',
        'protection': '''
4.1 我们已使用符合业界标准的安全防护措施保护您提供的个人信息。

4.2 我们采取的技术措施包括：
   - 数据加密传输（SSL/TLS）
   - 数据加密存储
   - 访问控制和身份验证
   - 安全审计和监控

4.3 我们建议您：
   - 使用复杂密码并定期更换
   - 不要将密码告知他人
   - 妥善保管您的移动设备
''',
        'rights': '''
5.1 您对自己的个人信息享有以下权利：
   - 访问权：您有权访问您的个人信息
   - 更正权：您有权更正您的个人信息
   - 删除权：在特定情况下，您有权删除您的个人信息
   - 撤回同意权：您有权撤回您的授权同意

5.2 您可以通过应用设置或联系我们来行使这些权利。
''',
        'minors': '''
6.1 我们非常重视未成年人的个人信息保护。

6.2 若您是未成年人，应在监护人的指导下阅读本隐私政策，并在取得监护人同意的前提下使用我们的服务。

6.3 若您是未成年人的监护人，请监督未成年人的网络行为，防止未成年人未经授权收集个人信息。
''',
        'updates': '''
7.1 我们可能会适时修订本隐私政策。

7.2 当隐私政策发生变更时，我们会通过应用内公告或其他适当方式通知您。

7.3 建议您定期查看本隐私政策，以了解最新的隐私保护措施。
''',
        'contact': '''
8.1 如果您对本隐私政策有任何疑问、意见或建议，可以通过以下方式联系我们：

   - 电子邮件：support@bsld.com
   - 客服电话：400-xxx-xxxx
   - 公司地址：中国xx省xx市xx区xx路xx号

8.2 我们将在收到您的问题后尽快回复，一般在15个工作日内给予答复。
''',
      };
    } else {
      // 英文版本
      return {
        'intro': '''
BSLD (hereinafter referred to as "we") understands the importance of personal information to you. We will take appropriate security measures in accordance with legal and regulatory requirements to protect the security and controllability of your personal information.

This Privacy Policy will help you understand the following:
1. How we collect and use your personal information
2. How we use Cookies and related technologies
3. How we share, transfer, and publicly disclose your personal information
4. How we protect your personal information
5. Your rights
6. How we handle minors' personal information
7. How this Privacy Policy is updated
8. How to contact us
''',
        'collection': '''
1.1 To provide you with services, we collect the following information:
   - Account information: phone number, password, and other registration information
   - Device information: Bluetooth MAC address, device model, firmware version, etc.
   - Usage records: unlock records, operation logs, etc.
   - Location information: used to provide location-based services (requires your authorization)

1.2 We collect and use your information for the following purposes:
   - Provide smart device management and control services
   - Ensure service security
   - Improve and optimize services
   - Comply with legal and regulatory requirements
''',
        'cookies': '''
2.1 To ensure the normal operation of the application, we store small data files called Cookies on your device.

2.2 Cookies typically contain identifiers, site names, and some numbers and characters. With the help of Cookies, we can store your preference settings and other data.

2.3 You can manage or delete Cookies according to your preferences.
''',
        'sharing': '''
3.1 Sharing: We will not share your personal information with any company, organization, or individual, except in the following circumstances:
   - Obtain your explicit consent
   - According to legal and regulatory requirements or mandatory requirements from government authorities
   - Share with our affiliated companies (only necessary personal information will be shared)

3.2 Transfer: We will not transfer your personal information to any company, organization, or individual, except in the following circumstances:
   - Obtain your explicit consent
   - In cases involving mergers, acquisitions, or bankruptcy liquidation

3.3 Public Disclosure: We will only publicly disclose your personal information in the following circumstances:
   - Obtain your explicit consent
   - Legal disclosure based on law
''',
        'protection': '''
4.1 We have used industry-standard security measures to protect the personal information you provide.

4.2 Technical measures we take include:
   - Data encryption transmission (SSL/TLS)
   - Data encryption storage
   - Access control and authentication
   - Security audit and monitoring

4.3 We recommend that you:
   - Use complex passwords and change them regularly
   - Do not share your password with others
   - Properly safeguard your mobile devices
''',
        'rights': '''
5.1 You have the following rights regarding your personal information:
   - Right of access: You have the right to access your personal information
   - Right of correction: You have the right to correct your personal information
   - Right of deletion: Under certain circumstances, you have the right to delete your personal information
   - Right to withdraw consent: You have the right to withdraw your authorized consent

5.2 You can exercise these rights through application settings or by contacting us.
''',
        'minors': '''
6.1 We attach great importance to the protection of minors' personal information.

6.2 If you are a minor, you should read this Privacy Policy under the guidance of your guardian and use our services with the consent of your guardian.

6.3 If you are the guardian of a minor, please supervise the minor's online behavior to prevent unauthorized collection of personal information by minors.
''',
        'updates': '''
7.1 We may revise this Privacy Policy from time to time.

7.2 When the Privacy Policy changes, we will notify you through in-app announcements or other appropriate methods.

7.3 We recommend that you review this Privacy Policy regularly to understand the latest privacy protection measures.
''',
        'contact': '''
8.1 If you have any questions, comments, or suggestions about this Privacy Policy, you can contact us through the following methods:

   - Email: support@bsld.com
   - Customer service phone: 400-xxx-xxxx
   - Company address: No. xx, xx Road, xx District, xx City, xx Province, China

8.2 We will respond to your inquiries as soon as possible, generally within 15 working days.
''',
      };
    }
  }
}
