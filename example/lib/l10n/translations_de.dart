/// Deutsche Übersetzungen
class DeTranslations {
  static const Map<String, String> values = {
    // App-Name
    'appName': 'BSLD',
    
    // Allgemein
    'confirm': 'Bestätigen',
    'cancel': 'Abbrechen',
    'ok': 'OK',
    'save': 'Speichern',
    'delete': 'Löschen',
    'edit': 'Bearbeiten',
    'loading': 'Wird geladen...',
    'success': 'Erfolg',
    'error': 'Fehler',
    'warning': 'Warnung',
    'retry': 'Wiederholen',
    'back': 'Zurück',
    'next': 'Weiter',
    'finish': 'Fertig',
    'skip': 'Überspringen',

    // Anmeldung und Registrierung
    'login': 'Anmelden',
    'register': 'Registrieren',
    'noAccount': 'Noch kein Konto?',
    'hasAccount': 'Bereits ein Konto?',
    'logout': 'Abmelden',
    'forgotPassword': 'Passwort vergessen',
    'resetPassword': 'Passwort zurücksetzen',
    'phoneNumber': 'Telefonnummer',
    'password': 'Passwort',
    'confirmPassword': 'Passwort bestätigen',
    'verificationCode': 'Verifizierungscode',
    'sendCode': 'Code senden',
    'resendCode': 'Erneut senden',
    'getCode': 'Code erhalten',
    'pleaseEnterPhoneNumber': 'Bitte Telefonnummer eingeben',
    'pleaseEnterPassword': 'Bitte Passwort eingeben',
    'passwordStrengthHint': '8-20 Zeichen, mindestens 2 Typen',
    'passwordLengthError': 'Passwort muss 8-20 Zeichen lang sein',
    'passwordComplexityError': 'Muss mindestens 2 Typen enthalten: Zahlen, Buchstaben, Symbole',
    'pleaseEnterConfirmPassword': 'Bitte Passwort bestätigen',
    'pleaseEnterVerificationCode': 'Bitte Verifizierungscode eingeben',
    'passwordsDoNotMatch': 'Passwörter stimmen nicht überein',
    'invalidPhoneNumber': 'Ungültige Telefonnummer',
    'invalidVerificationCode': 'Ungültiger oder abgelaufener Verifizierungscode',
    'loginSuccess': 'Anmeldung erfolgreich',
    'registerSuccess': 'Registrierung erfolgreich',
    'passwordResetSuccess': 'Passwort zurücksetzung erfolgreich',
    'accountNotFound': 'Konto nicht gefunden',
    'wrongPassword': 'Falsches Passwort',
    'accountDisabled': 'Konto deaktiviert',
    
    // E-Mail
    'emailAddress': 'E-Mail-Adresse',
    'pleaseEnterEmail': 'Bitte E-Mail-Adresse eingeben',
    'invalidEmail': 'Ungültige E-Mail-Adresse',
    'recoveryMethod': 'Wiederherstellungsmethode',
    'viaPhone': 'Per Telefon',
    'viaEmail': 'Per E-Mail',
    'selectRecoveryMethod': 'Wiederherstellungsmethode auswählen',
    'codeWillSendToPhone': 'Verifizierungscode wird an Ihr Telefon gesendet',
    'codeWillSendToEmail': 'Verifizierungscode wird an Ihre E-Mail gesendet',

    // Benutzervereinbarung und Datenschutzrichtlinie
    'userAgreement': 'Benutzervereinbarung',
    'privacyPolicy': 'Datenschutzrichtlinie',
    'agreeToTerms': 'Ich habe gelesen und stimme zu',
    'mustAgreeToTerms': 'Bitte stimmen Sie den Bedingungen zu',
    'readAndAgree': 'Lesen und zustimmen',
    'and': 'und',
    'lastUpdated': 'Zuletzt aktualisiert',
    
    // Abschnittstitel der Benutzervereinbarung
    'uaAcceptance': '1. Annahme und Änderung der Vereinbarung',
    'uaServices': '2. Service-Inhalt',
    'uaRegistration': '3. Benutzerregistrierung und Konto',
    'uaConduct': '4. Benutzerverhalten',
    'uaIP': '5. Geistiges Eigentum',
    'uaDisclaimer': '6. Haftungsausschluss',
    'uaTermination': '7. Kündigung der Vereinbarung',
    'uaLaw': '8. Anwendbares Recht und Streitbeilegung',
    
    // Abschnittstitel der Datenschutzrichtlinie
    'ppIntro': 'Einführung',
    'ppCollection': '1. Wie wir Ihre persönlichen Daten sammeln und verwenden',
    'ppCookies': '2. Wie wir Cookies und verwandte Technologien verwenden',
    'ppSharing': '3. Wie wir Ihre persönlichen Daten teilen, übertragen und offenlegen',
    'ppProtection': '4. Wie wir Ihre persönlichen Daten schützen',
    'ppRights': '5. Ihre Rechte',
    'ppMinors': '6. Wie wir mit persönlichen Daten von Minderjährigen umgehen',
    'ppUpdates': '7. Aktualisierung dieser Datenschutzrichtlinie',
    'ppContact': '8. Kontakt aufnehmen',

    // Länderauswahl
    'selectCountry': 'Land/Region auswählen',
    'searchCountry': 'Land/Region suchen',
    'countryRegion': 'Land/Region',

    // Startseite
    'welcomeToTTLock': 'Willkommen bei BSLD',
    'manageSmartDevices': 'Verwalten Sie Ihre Smart-Geräte',
    'smartDevices': 'Smart-Geräte',
    'smartLock': 'Smart-Schloss',
    'controlManage': 'Steuerung und Verwaltung',
    'networkHub': 'Netzwerk-Hub',
    'powerMonitor': 'Strommonitor',
    'accessControl': 'Zugangskontrolle',
    'usageTracker': 'Nutzungsverfolger',
    
    // Raumverwaltung
    'roomManagement': 'Raumverwaltung',

    // Scan-Seite
    'searchingDevices': 'Geräte werden gesucht...',
    'makeSurePairingMode': 'Stellen Sie sicher, dass sich das Gerät im Kopplungsmodus befindet',
    'alreadyInitialized': 'Bereits initialisiert',
    'tapToInitialize': 'Tippen zum Initialisieren',
    'tapToConnect': 'Tippen zum Verbinden',
    'touchKeyboard': 'Bitte berühren Sie die Tastatur des Schlosses',
    'powerOnGateway': 'Bitte schalten Sie das Gateway erneut ein',

    // Fehlermeldungen
    'networkError': 'Netzwerkverbindung fehlgeschlagen',
    'serverError': 'Serverfehler',
    'timeoutError': 'Zeitüberschreitung der Anfrage',
    'unknownError': 'Unbekannter Fehler',
  };
}
