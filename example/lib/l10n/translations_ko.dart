/// 한국어 번역
class KoTranslations {
  static const Map<String, String> values = {
    // 앱 이름
    'appName': 'BSLD',
    
    // 일반
    'confirm': '확인',
    'cancel': '취소',
    'ok': '확인',
    'save': '저장',
    'delete': '삭제',
    'edit': '편집',
    'loading': '로딩 중...',
    'success': '성공',
    'error': '오류',
    'warning': '경고',
    'retry': '다시 시도',
    'back': '뒤로',
    'next': '다음',
    'finish': '완료',
    'skip': '건너뛰기',

    // 로그인 및 등록
    'login': '로그인',
    'register': '회원가입',
    'noAccount': '계정이 없으신가요?',
    'hasAccount': '이미 계정이 있으신가요?',
    'logout': '로그아웃',
    'forgotPassword': '비밀번호 찾기',
    'resetPassword': '비밀번호 재설정',
    'phoneNumber': '전화번호',
    'password': '비밀번호',
    'confirmPassword': '비밀번호 확인',
    'verificationCode': '인증 코드',
    'sendCode': '인증 코드 발송',
    'resendCode': '재전송',
    'getCode': '코드 받기',
    'pleaseEnterPhoneNumber': '전화번호를 입력하세요',
    'pleaseEnterPassword': '비밀번호를 입력하세요',
    'passwordStrengthHint': '8-20자, 최소 2가지 유형',
    'passwordLengthError': '비밀번호는 8-20자여야 합니다',
    'passwordComplexityError': '숫자, 문자, 기호 중 최소 2가지를 포함해야 합니다',
    'pleaseEnterConfirmPassword': '비밀번호를 확인하세요',
    'pleaseEnterVerificationCode': '인증 코드를 입력하세요',
    'passwordsDoNotMatch': '비밀번호가 일치하지 않습니다',
    'invalidPhoneNumber': '잘못된 전화번호',
    'invalidVerificationCode': '인증 코드가 잘못되었거나 만료되었습니다',
    'loginSuccess': '로그인 성공',
    'registerSuccess': '회원가입 성공',
    'passwordResetSuccess': '비밀번호 재설정 성공',
    'accountNotFound': '계정을 찾을 수 없습니다',
    'wrongPassword': '잘못된 비밀번호',
    'accountDisabled': '계정이 비활성화되었습니다',
    
    // 이메일 관련
    'emailAddress': '이메일 주소',
    'pleaseEnterEmail': '이메일 주소를 입력하세요',
    'invalidEmail': '잘못된 이메일 주소',
    'recoveryMethod': '복구 방법',
    'viaPhone': '전화로',
    'viaEmail': '이메일로',
    'selectRecoveryMethod': '복구 방법 선택',
    'codeWillSendToPhone': '인증 코드가 휴대폰으로 전송됩니다',
    'codeWillSendToEmail': '인증 코드가 이메일로 전송됩니다',

    // 사용자 계약 및 개인정보 보호정책
    'userAgreement': '사용자 계약',
    'privacyPolicy': '개인정보 보호정책',
    'agreeToTerms': '읽고 동의합니다',
    'mustAgreeToTerms': '사용자 계약 및 개인정보 보호정책에 동의해주세요',
    'readAndAgree': '읽고 동의하기',
    'and': '및',
    'lastUpdated': '최종 업데이트',
    
    // 사용자 계약 섹션 제목
    'uaAcceptance': '1. 계약의 수락 및 수정',
    'uaServices': '2. 서비스 내용',
    'uaRegistration': '3. 사용자 등록 및 계정',
    'uaConduct': '4. 사용자 행동規範',
    'uaIP': '5. 지적 재산권',
    'uaDisclaimer': '6. 면책 조항',
    'uaTermination': '7. 계약 종료',
    'uaLaw': '8. 준거법 및 분쟁 해결',
    
    // 개인정보 보호정책 섹션 제목
    'ppIntro': '소개',
    'ppCollection': '1. 개인 정보 수집 및 사용 방법',
    'ppCookies': '2. 쿠키 및 관련 기술 사용',
    'ppSharing': '3. 개인 정보 공유, 양도 및 공개',
    'ppProtection': '4. 개인 정보 보호',
    'ppRights': '5. 고객님의 권리',
    'ppMinors': '6. 미성년자 개인 정보 처리',
    'ppUpdates': '7. 개인정보 보호정책 업데이트',
    'ppContact': '8. 문의하기',

    // 국가 선택
    'selectCountry': '국가/지역 선택',
    'searchCountry': '국가/지역 검색',
    'countryRegion': '국가/지역',

    // 홈페이지
    'welcomeToTTLock': 'BSLD에 오신 것을 환영합니다',
    'manageSmartDevices': '스마트 기기 관리',
    'smartDevices': '스마트 기기',
    'smartLock': '스마트 잠금장치',
    'controlManage': '제어 및 관리',
    'networkHub': '네트워크 허브',
    'powerMonitor': '전력 모니터',
    'accessControl': '출입 통제',
    'usageTracker': '사용량 추적기',

    // 스캔 페이지
    'searchingDevices': '기기 검색 중...',
    'makeSurePairingMode': '기기가 페어링 모드인지 확인하세요',
    'alreadyInitialized': '이미 초기화됨',
    'tapToInitialize': '탭하여 초기화',
    'tapToConnect': '탭하여 연결',
    'touchKeyboard': '잠금장치의 키보드를 터치하세요',
    'powerOnGateway': '게이트웨이 전원을 다시 켜세요',

    // 오류 메시지
    'networkError': '네트워크 연결 실패',
    'serverError': '서버 오류',
    'timeoutError': '요청 시간 초과',
    'unknownError': '알 수 없는 오류',
  };
}
