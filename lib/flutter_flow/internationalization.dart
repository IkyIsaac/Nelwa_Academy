import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleStorageKey = '__locale_key__';

class FFLocalizations {
  FFLocalizations(this.locale);

  final Locale locale;

  static FFLocalizations of(BuildContext context) =>
      Localizations.of<FFLocalizations>(context, FFLocalizations)!;

  static List<String> languages() => ['en', 'sw', 'fr'];

  static late SharedPreferences _prefs;
  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();
  static Future storeLocale(String locale) =>
      _prefs.setString(_kLocaleStorageKey, locale);
  static Locale? getStoredLocale() {
    final locale = _prefs.getString(_kLocaleStorageKey);
    return locale != null && locale.isNotEmpty ? createLocale(locale) : null;
  }

  String get languageCode => locale.toString();
  String? get languageShortCode =>
      _languagesWithShortCode.contains(locale.toString())
          ? '${locale.toString()}_short'
          : null;
  int get languageIndex => languages().contains(languageCode)
      ? languages().indexOf(languageCode)
      : 0;

  String getText(String key) =>
      (kTranslationsMap[key] ?? {})[locale.toString()] ?? '';

  String getVariableText({
    String? enText = '',
    String? swText = '',
    String? frText = '',
  }) =>
      [enText, swText, frText][languageIndex] ?? '';

  static const Set<String> _languagesWithShortCode = {
    'ar',
    'az',
    'ca',
    'cs',
    'da',
    'de',
    'dv',
    'en',
    'es',
    'et',
    'fi',
    'fr',
    'gr',
    'he',
    'hi',
    'hu',
    'it',
    'km',
    'ku',
    'mn',
    'ms',
    'no',
    'pt',
    'ro',
    'ru',
    'rw',
    'sv',
    'th',
    'uk',
    'vi',
  };
}

/// Used if the locale is not supported by GlobalMaterialLocalizations.
class FallbackMaterialLocalizationDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackMaterialLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<MaterialLocalizations> load(Locale locale) async =>
      SynchronousFuture<MaterialLocalizations>(
        const DefaultMaterialLocalizations(),
      );

  @override
  bool shouldReload(FallbackMaterialLocalizationDelegate old) => false;
}

/// Used if the locale is not supported by GlobalCupertinoLocalizations.
class FallbackCupertinoLocalizationDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      SynchronousFuture<CupertinoLocalizations>(
        const DefaultCupertinoLocalizations(),
      );

  @override
  bool shouldReload(FallbackCupertinoLocalizationDelegate old) => false;
}

class FFLocalizationsDelegate extends LocalizationsDelegate<FFLocalizations> {
  const FFLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<FFLocalizations> load(Locale locale) =>
      SynchronousFuture<FFLocalizations>(FFLocalizations(locale));

  @override
  bool shouldReload(FFLocalizationsDelegate old) => false;
}

Locale createLocale(String language) => language.contains('_')
    ? Locale.fromSubtags(
        languageCode: language.split('_').first,
        scriptCode: language.split('_').last,
      )
    : Locale(language);

bool _isSupportedLocale(Locale locale) {
  final language = locale.toString();
  return FFLocalizations.languages().contains(
    language.endsWith('_')
        ? language.substring(0, language.length - 1)
        : language,
  );
}

final kTranslationsMap = <Map<String, Map<String, String>>>[
  // HomePage
  {
    'johhxnfz': {
      'en': 'What do you want to learn?',
      'fr': 'Qu\'est-ce que tu veux apprendre ?',
      'sw': 'Unataka kujifunza nini?',
    },
    'mgbnua7r': {
      'en': 'Popular Topics',
      'fr': 'Sujets populaires',
      'sw': 'Mada Maarufu',
    },
    '8ida4z5i': {
      'en': 'New Courses',
      'fr': 'Nouveaux cours',
      'sw': 'Kozi Mpya',
    },
    'hr4q6cqa': {
      'en': 'See All',
      'fr': 'Voir tout',
      'sw': 'Tazama Zote',
    },
    '1qloriin': {
      'en': 'Continue Watching',
      'fr': 'Continuer à regarder',
      'sw': 'Endelea Kutazama',
    },
    'rv7oxklk': {
      'en': 'We Recommend',
      'fr': 'Nous recommandons',
      'sw': 'Tunapendekeza',
    },
    'q4ippujd': {
      'en': 'See All',
      'fr': 'Voir tout',
      'sw': 'Tazama Zote',
    },
    '9s4yvmn8': {
      'en': 'Popular Courses',
      'fr': 'Cours populaires',
      'sw': 'Kozi Maarufu',
    },
    'mv65yrst': {
      'en': 'See All',
      'fr': 'Voir tout',
      'sw': 'Tazama Zote',
    },
    '3ylkrg3g': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // Onboarding
  {
    'f25lfzdw': {
      'en': 'Discover & Learn',
      'fr': 'Découvrir et apprendre',
      'sw': 'Gundua na Ujifunze',
    },
    '4nclkvm3': {
      'en':
          'Unlock your potential with top-tier courses from industry experts. Browse a wide range of topics and start learning today!',
      'fr':
          'Développez votre potentiel grâce à des formations de haut niveau dispensées par des experts du secteur. Explorez un large éventail de sujets et commencez à apprendre dès aujourd\'hui !',
      'sw':
          'Fungua uwezo wako kwa kozi za kiwango cha juu kutoka kwa wataalamu wa tasnia. Vinjari mada mbalimbali na uanze kujifunza leo!',
    },
    'ojcq7fi7': {
      'en': 'Engaging Lessons',
      'fr': 'Leçons captivantes',
      'sw': 'Masomo Yanayovutia',
    },
    'y08a2r58': {
      'en':
          'Enjoy hands-on learning with interactive projects. Stay motivated and track your progress effortlessly.',
      'fr':
          'Profitez d\'un apprentissage pratique grâce à des projets interactifs. Restez motivé et suivez vos progrès sans effort.',
      'sw':
          'Furahia kujifunza kwa vitendo ukitumia miradi shirikishi. Endelea kuwa na motisha na ufuatilie maendeleo yako bila shida.',
    },
    'emdfp21y': {
      'en': 'Elevate Your Business',
      'fr': 'Faites progresser votre entreprise',
      'sw': 'Kuinua Biashara Yako',
    },
    '4l53qh9g': {
      'en':
          'Elevate Your Business\nUnlock proven strategies from industry experts and watch your profits grow.',
      'fr':
          'Boostez votre entreprise\nDécouvrez des stratégies éprouvées d\'experts du secteur et voyez vos profits augmenter.',
      'sw':
          'Inue Biashara Yako\nFungua mikakati iliyothibitishwa kutoka kwa wataalamu wa tasnia na uangalie faida yako ikikua.',
    },
    '4cd2gisc': {
      'en': 'Skip',
      'fr': 'Sauter',
      'sw': 'Ruka',
    },
    'lfkg39id': {
      'en': 'Continue',
      'fr': 'Continuer',
      'sw': 'Endelea',
    },
    'dz9wytpw': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // Welcome
  {
    'ezkfrnwx': {
      'en': 'Discover & Learn',
      'fr': 'Découvrir et apprendre',
      'sw': 'Gundua na Ujifunze',
    },
    'uibjripp': {
      'en':
          'Unlock your potential with top-tier courses from industry experts. Browse a wide range of topics and start learning today!',
      'fr':
          'Développez votre potentiel grâce à des formations de haut niveau dispensées par des experts du secteur. Explorez un large éventail de sujets et commencez à apprendre dès aujourd\'hui !',
      'sw':
          'Fungua uwezo wako kwa kozi za kiwango cha juu kutoka kwa wataalamu wa tasnia. Vinjari mada mbalimbali na uanze kujifunza leo!',
    },
    'uka0mln1': {
      'en': 'Continue with Google',
      'fr': 'Continuer avec Google',
      'sw': 'Endelea na Google',
    },
    'tgr4ijja': {
      'en': 'Continue with Facebook',
      'fr': 'Continuez avec Facebook',
      'sw': 'Endelea na Facebook',
    },
    '8znsov1q': {
      'en': 'Sign in with password',
      'fr': 'Se connecter avec un mot de passe',
      'sw': 'Ingia ukitumia nenosiri',
    },
    'e0l87mj0': {
      'en': 'Don\'t have an account? ',
      'fr': 'Vous n\'avez pas de compte ?',
      'sw': 'Huna akaunti?',
    },
    '59mvxzo1': {
      'en': ' Sign up',
      'fr': 'S\'inscrire',
      'sw': 'Jisajili',
    },
    'p4m40xkq': {
      'en': 'Don\'t have an account& ',
      'fr': 'Vous n\'avez pas de compte ?',
      'sw': 'Sina akaunti&',
    },
    'l8uzpktd': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // SignUp
  {
    'plj6rash': {
      'en': 'Create an Account',
      'fr': 'Créer un compte',
      'sw': 'Fungua Akaunti',
    },
    'xdw33tn3': {
      'en': 'Create your account to get started.',
      'fr': 'Créez votre compte pour commencer.',
      'sw': 'Fungua akaunti yako ili kuanza.',
    },
    'm9239qrn': {
      'en': 'Email',
      'fr': 'E-mail',
      'sw': 'Barua pepe',
    },
    'j9n6b3av': {
      'en': 'Email',
      'fr': 'E-mail',
      'sw': 'Barua pepe',
    },
    'bvn5z3vu': {
      'en': 'Password',
      'fr': 'Mot de passe',
      'sw': 'Nenosiri',
    },
    'd4mt4wkb': {
      'en': 'Password',
      'fr': 'Mot de passe',
      'sw': 'Nenosiri',
    },
    '6t1ftalj': {
      'en': 'Confirm Password',
      'fr': 'Confirmez le mot de passe',
      'sw': 'Thibitisha Nenosiri',
    },
    'sja6ox20': {
      'en': 'Confirm Password',
      'fr': 'Confirmez le mot de passe',
      'sw': 'Thibitisha Nenosiri',
    },
    't3j4ob52': {
      'en': 'I agree to In Focus ',
      'fr': 'J\'accepte In Focus',
      'sw': 'Nakubali In Focus',
    },
    'on91u3qb': {
      'en': 'Term & Policy',
      'fr': 'Conditions générales',
      'sw': 'Sheria na Sera',
    },
    'yu7654d8': {
      'en': '.',
      'fr': '.',
      'sw': '.',
    },
    'd0m9rdxm': {
      'en': 'Don\'t have an account& ',
      'fr': 'Vous n\'avez pas de compte ?',
      'sw': 'Sina akaunti&',
    },
    'muaah2bm': {
      'en': 'Sign Up',
      'fr': 'S\'inscrire',
      'sw': 'Jisajili',
    },
    'mcpshz9d': {
      'en': 'Or continue with',
      'fr': 'Ou continuez avec',
      'sw': 'Au endelea na',
    },
    '3jipzskl': {
      'en': 'Already have an account?  ',
      'fr': 'Vous avez déjà un compte ?',
      'sw': 'Tayari una akaunti?',
    },
    'p9djqtu6': {
      'en': 'Sign in',
      'fr': 'Se connecter',
      'sw': 'Ingia',
    },
    'ehtfweab': {
      'en': 'Don\'t have an account& ',
      'fr': 'Vous n\'avez pas de compte ?',
      'sw': 'Sina akaunti&',
    },
    'l0gx4owb': {
      'en': 'Please enter a valid email address.',
      'fr': 'S\'il vous plaît, mettez une adresse email valide.',
      'sw': 'Tafadhali weka anwani halali ya barua pepe.',
    },
    '2i39go1k': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
      'sw': 'Tafadhali chagua chaguo kutoka kwenye menyu kunjuzi',
    },
    'cxvv7w1h': {
      'en': 'Please enter your password',
      'fr': 'Veuillez saisir votre mot de passe',
      'sw': 'Tafadhali weka nenosiri lako',
    },
    'ot9jazmj': {
      'en': 'Password must be at least 6 characters long',
      'fr': 'Le mot de passe doit comporter au moins 6 caractères.',
      'sw': 'Nenosiri lazima liwe na urefu wa angalau herufi 6',
    },
    'ocpk92av': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
      'sw': 'Tafadhali chagua chaguo kutoka kwenye menyu kunjuzi',
    },
    '59x8moiv': {
      'en': 'Please enter your password',
      'fr': 'Veuillez saisir votre mot de passe',
      'sw': 'Tafadhali weka nenosiri lako',
    },
    'fsxxfw9o': {
      'en': 'Password must be at least 6 characters long',
      'fr': 'Le mot de passe doit comporter au moins 6 caractères.',
      'sw': 'Nenosiri lazima liwe na urefu wa angalau herufi 6',
    },
    '14hu9ofb': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
      'sw': 'Tafadhali chagua chaguo kutoka kwenye menyu kunjuzi',
    },
    '1jefr9i5': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // SignIn
  {
    '2ok81es0': {
      'en': 'Create an Account',
      'fr': 'Créer un compte',
      'sw': 'Fungua Akaunti',
    },
    'grf4u2qk': {
      'en': 'Create your account to get started.',
      'fr': 'Créez votre compte pour commencer.',
      'sw': 'Fungua akaunti yako ili kuanza.',
    },
    'q98o1qa5': {
      'en': 'Email',
      'fr': 'E-mail',
      'sw': 'Barua pepe',
    },
    'hkzokzsw': {
      'en': 'Email',
      'fr': 'E-mail',
      'sw': 'Barua pepe',
    },
    'fs8vkfdc': {
      'en': 'Password',
      'fr': 'Mot de passe',
      'sw': 'Nenosiri',
    },
    'n1oq7pyt': {
      'en': 'Password',
      'fr': 'Mot de passe',
      'sw': 'Nenosiri',
    },
    '6omuhyz5': {
      'en': 'Remember me',
      'fr': 'Souviens-toi de moi',
      'sw': 'Nikumbuke',
    },
    'hbh2moxi': {
      'en': 'Forgot password?',
      'fr': 'Mot de passe oublié ?',
      'sw': 'Umesahau nenosiri?',
    },
    'egz3nt1x': {
      'en': 'Sign In',
      'fr': 'Se connecter',
      'sw': 'Ingia',
    },
    'k14xfp8w': {
      'en': 'Or continue with',
      'fr': 'Ou continuez avec',
      'sw': 'Au endelea na',
    },
    'mgpbv9vt': {
      'en': 'Don’t have an account?  ',
      'fr': 'Vous n\'avez pas de compte ?',
      'sw': 'Huna akaunti?',
    },
    'dkwvsyf4': {
      'en': 'Sign up',
      'fr': 'S\'inscrire',
      'sw': 'Jisajili',
    },
    'sqr5ymmi': {
      'en': 'Don\'t have an account& ',
      'fr': 'Vous n\'avez pas de compte ?',
      'sw': 'Sina akaunti&',
    },
    '35xqalsd': {
      'en': 'Please enter a valid email address.',
      'fr': 'S\'il vous plaît, mettez une adresse email valide.',
      'sw': 'Tafadhali weka anwani halali ya barua pepe.',
    },
    'pxwecwt6': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
      'sw': 'Tafadhali chagua chaguo kutoka kwenye menyu kunjuzi',
    },
    'q4w4macp': {
      'en': 'Please enter your password',
      'fr': 'Veuillez saisir votre mot de passe',
      'sw': 'Tafadhali weka nenosiri lako',
    },
    'mn7hp59n': {
      'en': 'Password must be at least 6 characters long',
      'fr': 'Le mot de passe doit comporter au moins 6 caractères.',
      'sw': 'Nenosiri lazima liwe na urefu wa angalau herufi 6',
    },
    'xxyq3z99': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
      'sw': 'Tafadhali chagua chaguo kutoka kwenye menyu kunjuzi',
    },
    '7bfqo7bk': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // ResetPassword
  {
    'tntv2lyp': {
      'en': 'Reset your password',
      'fr': 'Réinitialisez votre mot de passe',
      'sw': 'Weka upya nenosiri lako',
    },
    'hn0k76mw': {
      'en':
          'Enter your email, and we\'ll send you an OTP code in the next step to reset your password.',
      'fr':
          'Saisissez votre adresse e-mail, et nous vous enverrons un code OTP à l\'étape suivante pour réinitialiser votre mot de passe.',
      'sw':
          'Ingiza barua pepe yako, nasi tutakutumia msimbo wa OTP katika hatua inayofuata ili kuweka upya nenosiri lako.',
    },
    '25eqkbfk': {
      'en': 'Email address',
      'fr': 'Adresse email',
      'sw': 'Anwani ya barua pepe',
    },
    '09ytmig4': {
      'en': 'Email address',
      'fr': 'Adresse email',
      'sw': 'Anwani ya barua pepe',
    },
    'gp53zkjt': {
      'en': 'test123@gmail.com',
      'fr': 'test123@gmail.com',
      'sw': 'test123@gmail.com',
    },
    'piir0dwg': {
      'en': 'Please enter a valid email address.',
      'fr': 'S\'il vous plaît, mettez une adresse email valide.',
      'sw': 'Tafadhali weka anwani halali ya barua pepe.',
    },
    '4zjsleoz': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
      'sw': 'Tafadhali chagua chaguo kutoka kwenye menyu kunjuzi',
    },
    'w015ph88': {
      'en': 'Continue',
      'fr': 'Continuer',
      'sw': 'Endelea',
    },
    'anpwbqid': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // VerifyCode
  {
    'mjjdd40m': {
      'en': 'Verify Code',
      'fr': 'Vérifier le code',
      'sw': 'Thibitisha Nambari',
    },
    'fmcikzo4': {
      'en': 'Please enter the code we just sent to email ',
      'fr':
          'Veuillez saisir le code que nous venons de vous envoyer par courriel.',
      'sw': 'Tafadhali ingiza msimbo ambao tumetuma kwa barua pepe',
    },
    'u80mlcw6': {
      'en': 'Please enter the code we just sent to email example@email.com',
      'fr':
          'Veuillez saisir le code que nous venons d\'envoyer à l\'adresse e-mail example@email.com',
      'sw':
          'Tafadhali ingiza msimbo ambao tumetuma kwa barua pepe example@email.com',
    },
    'rhpzjspu': {
      'en': 'Resend code',
      'fr': 'Renvoyer le code',
      'sw': 'Tuma tena msimbo',
    },
    'lpcsgiyn': {
      'en': 'Continue',
      'fr': 'Continuer',
      'sw': 'Endelea',
    },
    '6pohpa9o': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // Createnewpassword
  {
    'o1q1tp0h': {
      'en': 'Create new password',
      'fr': 'Créer un nouveau mot de passe',
      'sw': 'Unda nenosiri jipya',
    },
    'mvk88i97': {
      'en':
          'Set a new password. If you forget it, you can reset it using the \'Forgot Password\' option.',
      'fr':
          'Définissez un nouveau mot de passe. Si vous l\'oubliez, vous pouvez le réinitialiser à l\'aide de l\'option « Mot de passe oublié ».',
      'sw':
          'Weka nenosiri jipya. Ukilisahau, unaweza kuliweka upya kwa kutumia chaguo la \'Umesahau Nenosiri\'.',
    },
    '5s60qbqk': {
      'en': 'New Password',
      'fr': 'Nouveau mot de passe',
      'sw': 'Nenosiri Jipya',
    },
    'q2brqzhp': {
      'en': 'New Password',
      'fr': 'Nouveau mot de passe',
      'sw': 'Nenosiri Jipya',
    },
    'iva9tkcp': {
      'en': '11111111',
      'fr': '11111111',
      'sw': '11111111',
    },
    'tkuhnqei': {
      'en': 'Confirm New Password',
      'fr': 'Confirmer le nouveau mot de passe',
      'sw': 'Thibitisha Nenosiri Jipya',
    },
    '47e41v69': {
      'en': 'Confirm New Password',
      'fr': 'Confirmer le nouveau mot de passe',
      'sw': 'Thibitisha Nenosiri Jipya',
    },
    'u0bgvzx5': {
      'en': '11111111',
      'fr': '11111111',
      'sw': '11111111',
    },
    'snvqt97d': {
      'en': 'Please enter your password',
      'fr': 'Veuillez saisir votre mot de passe',
      'sw': 'Tafadhali weka nenosiri lako',
    },
    '7nybg9hi': {
      'en': 'Password must be at least 6 characters long',
      'fr': 'Le mot de passe doit comporter au moins 6 caractères.',
      'sw': 'Nenosiri lazima liwe na urefu wa angalau herufi 6',
    },
    'iguxlikv': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
      'sw': 'Tafadhali chagua chaguo kutoka kwenye menyu kunjuzi',
    },
    'tggqymyc': {
      'en': 'Please enter your password',
      'fr': 'Veuillez saisir votre mot de passe',
      'sw': 'Tafadhali weka nenosiri lako',
    },
    'abbdkja1': {
      'en': 'Password must be at least 6 characters long',
      'fr': 'Le mot de passe doit comporter au moins 6 caractères.',
      'sw': 'Nenosiri lazima liwe na urefu wa angalau herufi 6',
    },
    '10ofgnso': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
      'sw': 'Tafadhali chagua chaguo kutoka kwenye menyu kunjuzi',
    },
    'odllnnsl': {
      'en': 'Continue',
      'fr': 'Continuer',
      'sw': 'Endelea',
    },
    'nyonw9st': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // CompeteProfile
  {
    '81fddubl': {
      'en': 'Complete Your Profile',
      'fr': 'Complétez votre profil',
      'sw': 'Kamilisha Wasifu Wako',
    },
    '2siizjdu': {
      'en': 'Create your account to get started.',
      'fr': 'Créez votre compte pour commencer.',
      'sw': 'Fungua akaunti yako ili kuanza.',
    },
    'agsky75g': {
      'en': 'Name',
      'fr': 'Nom',
      'sw': 'Jina',
    },
    'mdi2hz25': {
      'en': 'Name',
      'fr': 'Nom',
      'sw': 'Jina',
    },
    'xyx6tsfd': {
      'en': 'Please add  your name',
      'fr': 'Veuillez ajouter votre nom',
      'sw': 'Tafadhali ongeza jina lako',
    },
    'iroxc2sk': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
      'sw': 'Tafadhali chagua chaguo kutoka kwenye menyu kunjuzi',
    },
    'npl22n3w': {
      'en': 'Date of Birth ',
      'fr': 'Date de naissance',
      'sw': 'Tarehe ya Kuzaliwa',
    },
    't175j4xr': {
      'en': 'Country',
      'fr': 'Pays',
      'sw': 'Nchi',
    },
    'urrwnph0': {
      'en': 'Country',
      'fr': 'Pays',
      'sw': 'Nchi',
    },
    '8clm5mhg': {
      'en': 'Continue',
      'fr': 'Continuer',
      'sw': 'Endelea',
    },
    'f90g2sip': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // Interests
  {
    'yxbklnix': {
      'en': 'What interests you most?',
      'fr': 'Qu\'est-ce qui vous intéresse le plus ?',
      'sw': 'Ni nini kinachokuvutia zaidi?',
    },
    '62tajmz4': {
      'en': 'You must select at least 3 topics.',
      'fr': 'Vous devez sélectionner au moins 3 sujets.',
      'sw': 'Lazima uchague angalau mada 3.',
    },
    '0ssnwxdn': {
      'en': 'What do you want to learn?',
      'fr': 'Qu\'est-ce que tu veux apprendre ?',
      'sw': 'Unataka kujifunza nini?',
    },
    '222fn5dn': {
      'en': 'What is your current experience level?',
      'fr': 'Quel est votre niveau d\'expérience actuel ?',
      'sw': 'Kiwango chako cha uzoefu wa sasa ni kipi?',
    },
    'mw123snp': {
      'en': 'This helps us create a better experience for you.',
      'fr': 'Cela nous permet de vous offrir une meilleure expérience.',
      'sw': 'Hii inatusaidia kuunda uzoefu bora zaidi kwako.',
    },
    '00kffinb': {
      'en': 'What will you use ___ for?',
      'fr': 'À quoi vas-tu utiliser ___ ?',
      'sw': 'Utatumia ___ kwa ajili ya nini?',
    },
    'e13beu5g': {
      'en': 'This helps us create a better experience for you.',
      'fr': 'Cela nous permet de vous offrir une meilleure expérience.',
      'sw': 'Hii inatusaidia kuunda uzoefu bora zaidi kwako.',
    },
    'e2jvbid4': {
      'en': 'Skip',
      'fr': 'Sauter',
      'sw': 'Ruka',
    },
    '58i5dn22': {
      'en': 'Continue',
      'fr': 'Continuer',
      'sw': 'Endelea',
    },
    'hmlorzum': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // Profile
  {
    'fd6q08z5': {
      'en': 'Want to become an instructor?',
      'fr': 'Vous souhaitez devenir instructeur ?',
      'sw': 'Unataka kuwa mwalimu?',
    },
    '0ny108w4': {
      'en': 'Personal Info',
      'fr': 'Informations personnelles',
      'sw': 'Taarifa Binafsi',
    },
    '8h2uvtzv': {
      'en': 'Security',
      'fr': 'Sécurité',
      'sw': 'Usalama',
    },
    '4eiq3wnh': {
      'en': 'Analytics',
      'fr': 'Analytique',
      'sw': 'Uchanganuzi',
    },
    'rly9o702': {
      'en': 'Wish List',
      'fr': 'Liste de souhaits',
      'sw': 'Orodha ya Matamanio',
    },
    'fdbetejg': {
      'en': 'Subscriptions',
      'fr': 'Abonnements',
      'sw': 'Usajili',
    },
    '5ntverai': {
      'en': 'Activity Statistics',
      'fr': 'Statistiques d\'activité',
      'sw': 'Takwimu za Shughuli',
    },
    'hrms9g08': {
      'en': 'My Reviews',
      'fr': 'Mes avis',
      'sw': 'Mapitio Yangu',
    },
    '8wjs06xv': {
      'en': 'Notifications',
      'fr': 'Notifications',
      'sw': 'Tarifa',
    },
    'efv1yewh': {
      'en': 'Language',
      'fr': 'Langue',
      'sw': 'Lugha',
    },
    '0l6j4g8y': {
      'en': 'Dark Mode',
      'fr': 'Mode sombre',
      'sw': 'Hali Nyeusi',
    },
    'itgmtteg': {
      'en': 'Support',
      'fr': 'Soutien',
      'sw': 'Usaidizi',
    },
    '4dbmn8i1': {
      'en': 'Help Center',
      'fr': 'Centre d\'aide',
      'sw': 'Kituo cha Usaidizi',
    },
    'afiejruc': {
      'en': 'About Nelwa\'s Academy',
      'fr': 'Académie About Nelwa',
      'sw': 'Chuo cha Nelwa',
    },
    '1hx86a4t': {
      'en': 'Sign Out',
      'fr': 'Se déconnecter',
      'sw': 'Toka',
    },
    'um957l2s': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // PersonalInfo
  {
    '97dnqlml': {
      'en': 'Name',
      'fr': 'Nom',
      'sw': 'Jina',
    },
    'taarjatj': {
      'en': 'Name',
      'fr': 'Nom',
      'sw': 'Jina',
    },
    'hkgun4ed': {
      'en': 'About You',
      'fr': 'Au propos de vous',
      'sw': 'Kuhusu Wewe',
    },
    'wg36599e': {
      'en': 'Tell us a little about yourself…',
      'fr': 'Parlez-nous un peu de vous…',
      'sw': 'Tuambie kidogo kukuhusu...',
    },
    '41zfh98i': {
      'en': 'Your Specialty',
      'fr': 'Votre spécialité',
      'sw': 'Utaalamu Wako',
    },
    'w5n5g4dq': {
      'en': 'Your Specialty',
      'fr': 'Votre spécialité',
      'sw': 'Utaalamu Wako',
    },
    'y55kjqmu': {
      'en': 'Email Address',
      'fr': 'Adresse email',
      'sw': 'Anwani ya Barua Pepe',
    },
    '3egqv1rp': {
      'en': 'Email Address',
      'fr': 'Adresse email',
      'sw': 'Anwani ya Barua Pepe',
    },
    '0jlq68n5': {
      'en': 'Name is required',
      'fr': 'Le nom est requis.',
      'sw': 'Jina linahitajika',
    },
    'ojbrkfrq': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
      'sw': 'Tafadhali chagua chaguo kutoka kwenye menyu kunjuzi',
    },
    'knd3touy': {
      'en': 'about_user is required',
      'fr': 'Le champ about_user est requis.',
      'sw': 'kuhusu_mtumiaji inahitajika',
    },
    'r6f2euin': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
      'sw': 'Tafadhali chagua chaguo kutoka kwenye menyu kunjuzi',
    },
    '4krsxir5': {
      'en': 'Email Address is required',
      'fr': 'Une adresse e-mail est requise.',
      'sw': 'Anwani ya Barua Pepe inahitajika',
    },
    'puh20f83': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
      'sw': 'Tafadhali chagua chaguo kutoka kwenye menyu kunjuzi',
    },
    'cedekflr': {
      'en': 'Phone Number',
      'fr': 'Numéro de téléphone',
      'sw': 'Nambari ya Simu',
    },
    'oi3mh16d': {
      'en': 'Phone Number',
      'fr': 'Numéro de téléphone',
      'sw': 'Nambari ya Simu',
    },
    'akf9epsn': {
      'en': 'Email Address is required',
      'fr': 'Une adresse e-mail est requise.',
      'sw': 'Anwani ya Barua Pepe inahitajika',
    },
    'd081r7ur': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
      'sw': 'Tafadhali chagua chaguo kutoka kwenye menyu kunjuzi',
    },
    '5xraeogg': {
      'en': 'Date of Birth ',
      'fr': 'Date de naissance',
      'sw': 'Tarehe ya Kuzaliwa',
    },
    'qhr60kl5': {
      'en': 'Country',
      'fr': 'Pays',
      'sw': 'Nchi',
    },
    '40wsladj': {
      'en': 'Country',
      'fr': 'Pays',
      'sw': 'Nchi',
    },
    'kmx19rzs': {
      'en': 'Education (Optional)',
      'fr': 'Éducation (facultatif)',
      'sw': 'Elimu (Si lazima)',
    },
    '8pe2vzih': {
      'en': 'Education',
      'fr': 'Éducation',
      'sw': 'Elimu',
    },
    'buc5ndgy': {
      'en': 'Delete Account',
      'fr': 'Supprimer le compte',
      'sw': 'Futa Akaunti',
    },
    '12272l6n': {
      'en': 'Save',
      'fr': 'Sauvegarder',
      'sw': 'Hifadhi',
    },
    'u71yused': {
      'en': 'Personal Info',
      'fr': 'Informations personnelles',
      'sw': 'Taarifa Binafsi',
    },
    'vad36ntv': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // Security
  {
    '04y7r26a': {
      'en': 'Remember me',
      'fr': 'Souviens-toi de moi',
      'sw': 'Nikumbuke',
    },
    '0htpr3si': {
      'en': 'Stay signed in on this device.',
      'fr': 'Restez connecté sur cet appareil.',
      'sw': 'Endelea kuingia kwenye kifaa hiki.',
    },
    '1yq8glsm': {
      'en': 'Biometric ID',
      'fr': 'Identification biométrique',
      'sw': 'Kitambulisho cha biometriki',
    },
    'l9f5qpk8': {
      'en': 'Use fingerprint to sign in securely.',
      'fr':
          'Utilisez votre empreinte digitale pour vous connecter en toute sécurité.',
      'sw': 'Tumia alama za vidole kuingia kwa usalama.',
    },
    'cd8m85bi': {
      'en': 'Face ID',
      'fr': 'Face ID',
      'sw': 'Kitambulisho cha Uso',
    },
    'm8e08880': {
      'en': 'Use Face ID to sign in quickly and securely.',
      'fr':
          'Utilisez Face ID pour vous connecter rapidement et en toute sécurité.',
      'sw': 'Tumia Kitambulisho cha Uso ili kuingia haraka na kwa usalama.',
    },
    'o2d5js42': {
      'en': 'SMS Authenticator',
      'fr': 'Authentificateur de SMS',
      'sw': 'Kithibitishaji cha SMS',
    },
    '3rhpk4t3': {
      'en': 'Receive a verification code via SMS during login.',
      'fr':
          'Vous recevrez un code de vérification par SMS lors de la connexion.',
      'sw': 'Pokea nambari ya uthibitishaji kupitia SMS wakati wa kuingia.',
    },
    '57atblbu': {
      'en': 'Google Authenticator',
      'fr': 'Authentificateur Google',
      'sw': 'Kithibitishaji cha Google',
    },
    '665eb3ey': {
      'en': 'Use Google Authenticator for two-step verification.',
      'fr':
          'Utilisez Google Authenticator pour la vérification en deux étapes.',
      'sw': 'Tumia Kithibitishaji cha Google kwa uthibitishaji wa hatua mbili.',
    },
    'v0smchxp': {
      'en': 'Device Management',
      'fr': 'Gestion des périphériques',
      'sw': 'Usimamizi wa Kifaa',
    },
    '6adcdb1l': {
      'en': 'Manage and view all devices linked to your account.',
      'fr': 'Gérez et visualisez tous les appareils liés à votre compte.',
      'sw':
          'Dhibiti na uangalie vifaa vyote vilivyounganishwa na akaunti yako.',
    },
    'b1grrayh': {
      'en': 'Security',
      'fr': 'Sécurité',
      'sw': 'Usalama',
    },
    'm13nmmqb': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // PaymentAccount
  {
    'jo9zahpd': {
      'en': 'Your balance',
      'fr': 'Votre solde',
      'sw': 'Salio lako',
    },
    '0ulx2126': {
      'en': 'Sales reports',
      'fr': 'Rapports de vente',
      'sw': 'Ripoti za mauzo',
    },
    'o1gua49t': {
      'en': 'See All',
      'fr': 'Voir tout',
      'sw': 'Tazama Zote',
    },
    'vpndrqv3': {
      'en': 'Payment Account',
      'fr': 'Compte de paiement',
      'sw': 'Akaunti ya Malipo',
    },
    'fgqztce3': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // SalesReports
  {
    'ln6t7nrm': {
      'en': 'Sales Reports',
      'fr': 'Rapports de vente',
      'sw': 'Ripoti za Mauzo',
    },
    'e9cigzh1': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // NotificationsSettings
  {
    'v4avybkp': {
      'en': 'Course Activity Alerts',
      'fr': 'Alertes d\'activité du cours',
      'sw': 'Arifa za Shughuli za Kozi',
    },
    'd6759atl': {
      'en':
          'Get notified about new enrollments, student questions, and course updates.',
      'fr':
          'Soyez informé(e) des nouvelles inscriptions, des questions des étudiants et des mises à jour des cours.',
      'sw':
          'Pata arifa kuhusu usajili mpya, maswali ya wanafunzi, na masasisho ya kozi.',
    },
    'li7r4k19': {
      'en': 'Feedback & Reviews',
      'fr': 'Commentaires et avis',
      'sw': 'Maoni na Mapitio',
    },
    'h4o8h938': {
      'en':
          'Stay informed about new student reviews and feedback on your courses.',
      'fr':
          'Restez informé(e) des nouveaux avis et commentaires des étudiants sur vos cours.',
      'sw':
          'Endelea kupata taarifa kuhusu mapitio ya wanafunzi wapya na maoni kuhusu kozi zako.',
    },
    '8k8zs0pk': {
      'en': 'System Announcements',
      'fr': 'Annonces système',
      'sw': 'Matangazo ya Mfumo',
    },
    '2ovkjki1': {
      'en':
          'Be the first to know about platform updates and important instructor news.',
      'fr':
          'Soyez le premier informé des mises à jour de la plateforme et des actualités importantes destinées aux formateurs.',
      'sw':
          'Kuwa wa kwanza kujua kuhusu masasisho ya jukwaa na habari muhimu za walimu.',
    },
    '2cgpyozl': {
      'en': 'Payment & Earnings Updates',
      'fr': 'Mises à jour sur les paiements et les revenus',
      'sw': 'Masasisho ya Malipo na Mapato',
    },
    '9t5oxi7u': {
      'en': 'Get notifications about new payouts and revenue reports.',
      'fr':
          'Recevez des notifications concernant les nouveaux versements et les rapports de revenus.',
      'sw': 'Pata arifa kuhusu malipo mapya na ripoti za mapato.',
    },
    'dhvse64k': {
      'en': 'Certificate Requests',
      'fr': 'Demandes de certificats',
      'sw': 'Maombi ya Cheti',
    },
    'bduonwem': {
      'en':
          'Receive alerts when students request course completion certificates.',
      'fr':
          'Recevez des alertes lorsque les étudiants demandent des certificats de réussite de cours.',
      'sw': 'Pokea arifa wanafunzi wanapoomba vyeti vya kukamilisha kozi.',
    },
    'hl89jbie': {
      'en': 'Notifications Settings',
      'fr': 'Paramètres des notifications',
      'sw': 'Mipangilio ya Arifa',
    },
    'i8bs72hv': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // Language
  {
    'wae4tg9h': {
      'en': 'Language',
      'fr': 'Langue',
      'sw': 'Lugha',
    },
    '0qyx3sm4': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // Support
  {
    'cel1wphn': {
      'en': 'Type a message..',
      'fr': 'Saisissez un message...',
      'sw': 'Andika ujumbe..',
    },
    'bu64xzji': {
      'en': 'Support',
      'fr': 'Soutien',
      'sw': 'Usaidizi',
    },
    'iqdhzg8t': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // HelpCenter
  {
    'fy70vwlg': {
      'en': 'What is Nelway\'s Academy?',
      'fr': 'Qu\'est-ce que l\'Académie Nelway ?',
      'sw': 'Chuo cha Nelway ni nini?',
    },
    'ugu570dm': {
      'en':
          'Nelways\'s academy is an online learning platform where you can find courses on Ice cream making, infranstructure for creating at home and more.',
      'fr':
          'L\'académie Nelways est une plateforme d\'apprentissage en ligne où vous trouverez des cours sur la fabrication de crèmes glacées, les infrastructures pour les créer chez soi et bien plus encore.',
      'sw':
          'Chuo cha Nelways ni jukwaa la kujifunza mtandaoni ambapo unaweza kupata kozi kuhusu utengenezaji wa aiskrimu, miundombinu ya kutengeneza nyumbani na zaidi.',
    },
    '49uhacnr': {
      'en': 'How do I create an account?',
      'fr': 'Comment créer un compte ?',
      'sw': 'Ninawezaje kuunda akaunti?',
    },
    'tbqakmhs': {
      'en':
          'You can sign up using your email or social media accounts like Google or Facebook.',
      'fr': '',
      'sw': '',
    },
    'nl62lcfo': {
      'en': 'Is Nelway\'s Academy free to use?',
      'fr': 'L\'utilisation de Nelway\'s Academy est-elle gratuite ?',
      'sw': 'Je, Nelway\'s Academy ni bure kutumia?',
    },
    'it39nxva': {
      'en':
          'Nelway\'s Acedmy  offers both free and paid courses. Some courses require a one-time payment or a subscription.',
      'fr':
          'Nelway\'s Academy propose des cours gratuits et payants. Certains cours nécessitent un paiement unique ou un abonnement.',
      'sw':
          'Acedmy ya Nelway inatoa kozi za bure na za kulipia. Baadhi ya kozi zinahitaji malipo ya mara moja au usajili.',
    },
    '4mfwx7vm': {
      'en': 'How do I enroll in a course?',
      'fr': 'Comment puis-je m\'inscrire à un cours ?',
      'sw': 'Ninawezaje kujiandikisha katika kozi?',
    },
    'eflfo6zq': {
      'en':
          'Browse courses in the app, select one, and tap \"Enroll\" to start learning.',
      'fr':
          'Parcourez les cours dans l\'application, sélectionnez-en un et appuyez sur « S\'inscrire » pour commencer à apprendre.',
      'sw':
          'Vinjari kozi katika programu, chagua moja, na ubofye \"Jiandikishe\" ili kuanza kujifunza.',
    },
    'r94xfd4p': {
      'en': 'Can I download courses for offline viewing?',
      'fr': 'Puis-je télécharger des cours pour les consulter hors ligne ?',
      'sw': 'Je, ninaweza kupakua kozi kwa ajili ya kutazama nje ya mtandao?',
    },
    'ygyr9qo6': {
      'en':
          'Yes, some courses allow offline access. Check the course details for availability.',
      'fr':
          'Oui, certains cours permettent un accès hors ligne. Consultez les détails du cours pour connaître les disponibilités.',
      'sw':
          'Ndiyo, baadhi ya kozi huruhusu ufikiaji nje ya mtandao. Angalia maelezo ya kozi kwa upatikanaji.',
    },
    'xdn4i8be': {
      'en': 'Help Center',
      'fr': 'Centre d\'aide',
      'sw': 'Kituo cha Usaidizi',
    },
    'i9zymog2': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // AboutSkillBase
  {
    'iia4iy9i': {
      'en': 'Terms and Conditions',
      'fr': 'Termes et conditions',
      'sw': 'Sheria na Masharti',
    },
    'm6adssnr': {
      'en': 'Read the rules and terms for using SkillBase.',
      'fr':
          'Veuillez lire les règles et conditions d\'utilisation de SkillBase.',
      'sw': 'Soma sheria na masharti ya kutumia SkillBase.',
    },
    'bbey4ypf': {
      'en': 'Privacy Policy',
      'fr': 'politique de confidentialité',
      'sw': 'Sera ya Faragha',
    },
    'k7hx1vvl': {
      'en': 'Learn how we handle your data and protect your privacy.',
      'fr':
          'Découvrez comment nous traitons vos données et protégeons votre vie privée.',
      'sw':
          'Jifunze jinsi tunavyoshughulikia data yako na kulinda faragha yako.',
    },
    '3f5ql24g': {
      'en': 'Job Vacancy',
      'fr': 'Offre d\'emploi',
      'sw': 'Nafasi ya Kazi',
    },
    '4t6n8qbr': {
      'en': 'Want to join the Cookio team? See open positions.',
      'fr':
          'Vous souhaitez rejoindre l\'équipe Cookio ? Consultez les postes à pourvoir.',
      'sw': 'Unataka kujiunga na timu ya Cookio? Tazama nafasi zilizo wazi.',
    },
    'atse1r4x': {
      'en': 'Contact Us',
      'fr': 'Contactez-nous',
      'sw': 'Wasiliana Nasi',
    },
    'da9xr2sv': {
      'en': 'Need help or have suggestions? Reach out anytime.',
      'fr':
          'Besoin d\'aide ou de suggestions ? N\'hésitez pas à nous contacter.',
      'sw':
          'Unahitaji msaada au una mapendekezo? Wasiliana nasi wakati wowote.',
    },
    'kg63auef': {
      'en': 'Accessibility',
      'fr': 'Accessibilité',
      'sw': 'Ufikivu',
    },
    'kueyrtbf': {
      'en': 'We strive to make SkillBase accessible for everyone. Learn more.',
      'fr':
          'Nous nous efforçons de rendre SkillBase accessible à tous. En savoir plus.',
      'sw':
          'Tunajitahidi kufanya SkillBase ipatikane kwa kila mtu. Pata maelezo zaidi.',
    },
    '256dxpjt': {
      'en': 'About Nelway\'s Academy',
      'fr': 'À propos de SkillBase',
      'sw': 'Kuhusu SkillBase',
    },
    'wulyao7z': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // TermsandConditions
  {
    'zihl2hek': {
      'en': 'Terms and Conditions',
      'fr': 'Termes et conditions',
      'sw': 'Sheria na Masharti',
    },
    'f6ik6bqe': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // PrivacyPolicy
  {
    'itr7t9do': {
      'en':
          'Welcome to SkillBase! Your privacy is important to us. This Privacy Policy explains how we collect, use, and protect your personal data when you use our platform.\n\n1. Information We Collect\nWe collect the following types of information:\n\n1.1. Personal Information\nName, email address, and phone number (when you register).\n\nPayment details (processed securely through third-party services).\n\nProfile information, including preferences and enrolled courses.\n\n1.2. Usage Data\nDevice information (model, operating system, browser type).\n\nIP address and location data (if permitted by your settings).\n\nCourse progress, interactions, and engagement.\n\n1.3. Cookies & Tracking Technologies\nWe use cookies to enhance your experience, track analytics, and improve our services.\n\nYou can manage cookie settings in your browser.\n\n2. How We Use Your Information\nWe use your data for the following purposes:\n\nTo create and manage your SkillBase account.\n\nTo process payments and subscriptions.\n\nTo recommend courses based on your interests.\n\nTo send notifications, updates, and promotional content (you can opt-out anytime).\n\nTo improve our platform, security, and user experience.\n\n3. How We Share Your Information\nWe do not sell your personal data. However, we may share it with:\n\nService providers (payment processors, analytics tools, and hosting services).\n\nLegal authorities, if required by law or to protect our rights.\n\n4. Data Security\nWe take security seriously and use encryption, firewalls, and other measures to protect your data. However, no system is 100% secure, so we cannot guarantee absolute security.\n\n5. Your Rights & Choices\nYou have the right to:\n\nAccess, update, or delete your personal data.\n\nOpt-out of marketing emails.\n\nDisable cookies in your browser settings.\n\n6. Third-Party Links\nSkillBase may contain links to third-party websites. We are not responsible for their privacy practices.\n\n7. Children\'s Privacy\nSkillBase is not intended for users under 13 years old. We do not knowingly collect data from children.\n\n8. Changes to This Policy\nWe may update this Privacy Policy from time to time. If we make significant changes, we will notify you via email or in-app notifications.\n\n9. Contact Us\nIf you have any questions or concerns, contact us at support@skillbase.com.',
      'fr':
          'Bienvenue sur SkillBase ! Le respect de votre vie privée est primordial pour nous. Cette Politique de confidentialité explique comment nous collectons, utilisons et protégeons vos données personnelles lorsque vous utilisez notre plateforme.\n\n1. Informations collectées\nNous collectons les types d\'informations suivants :\n\n1.1. Informations personnelles\nNom, adresse e-mail et numéro de téléphone (lors de votre inscription).\n\nInformations de paiement (traitées de manière sécurisée par des services tiers).\n\nInformations de profil, notamment vos préférences et les cours auxquels vous êtes inscrit(e).\n\n1.2. Données d\'utilisation\nInformations sur votre appareil (modèle, système d\'exploitation, type de navigateur).\n\nAdresse IP et données de géolocalisation (si vos paramètres le permettent).\n\nProgression, interactions et engagement dans les cours.\n\n1.3. Cookies et technologies de suivi\nNous utilisons des cookies pour améliorer votre expérience, analyser les statistiques et optimiser nos services.\n\nVous pouvez gérer vos paramètres de cookies dans votre navigateur.\n\n2. Utilisation de vos informations\nNous utilisons vos données aux fins suivantes :\n\nCréer et gérer votre compte SkillBase.\n\nTraiter les paiements et les abonnements.\n\nPour vous recommander des cours en fonction de vos centres d\'intérêt.\n\nPour vous envoyer des notifications, des mises à jour et des contenus promotionnels (vous pouvez vous désabonner à tout moment).\n\nPour améliorer notre plateforme, sa sécurité et votre expérience utilisateur.\n\n3. Comment nous partageons vos informations\nNous ne vendons pas vos données personnelles. Cependant, nous pouvons les partager avec :\n\nNos prestataires de services (processeurs de paiement, outils d\'analyse et services d\'hébergement).\n\nLes autorités légales, si la loi l\'exige ou pour protéger nos droits.\n\n4. Sécurité des données\nNous prenons la sécurité très au sérieux et utilisons le chiffrement, des pare-feu et d\'autres mesures pour protéger vos données. Cependant, aucun système n\'est sûr à 100 %, nous ne pouvons donc pas garantir une sécurité absolue.\n\n5. Vos droits et vos choix\nVous avez le droit de :\n\nAccéder à vos données personnelles, les mettre à jour ou les supprimer.\n\nVous désabonner des e-mails marketing.\n\nDésactiver les cookies dans les paramètres de votre navigateur.\n\n6. Liens vers des sites tiers\nSkillBase peut contenir des liens vers des sites web tiers. Nous ne sommes pas responsables de leurs pratiques en matière de confidentialité.\n\n7. Protection de la vie privée des enfants\n\nSkillBase n\'est pas destiné aux utilisateurs de moins de 13 ans. Nous ne collectons pas sciemment de données auprès d\'enfants.\n\n8. Modifications de la présente politique\nNous pouvons être amenés à modifier la présente politique de confidentialité. En cas de modifications importantes, nous vous en informerons par e-mail ou via des notifications intégrées à l\'application.\n\n9. Nous contacter\nPour toute question ou préoccupation, veuillez nous contacter à l\'adresse support@skillbase.com.',
      'sw':
          'Karibu SkillBase! Faragha yako ni muhimu kwetu. Sera hii ya Faragha inaelezea jinsi tunavyokusanya, kutumia, na kulinda data yako binafsi unapotumia mfumo wetu.\n\n1. Taarifa Tunazokusanya\nTunakusanya aina zifuatazo za taarifa:\n\n1.1. Taarifa Binafsi\nJina, anwani ya barua pepe, na nambari ya simu (unapojisajili).\n\nMaelezo ya malipo (yanashughulikiwa kwa usalama kupitia huduma za wahusika wengine).\n\nTaarifa za wasifu, ikiwa ni pamoja na mapendeleo na kozi zilizosajiliwa.\n\n1.2. Data ya Matumizi\nTaarifa ya kifaa (modeli, mfumo endeshi, aina ya kivinjari).\n\nAnwani ya IP na data ya eneo (ikiwa inaruhusiwa na mipangilio yako).\n\nMaendeleo ya kozi, mwingiliano, na ushiriki.\n\n1.3. Teknolojia za Vidakuzi na Ufuatiliaji\nTunatumia vidakuzi ili kuboresha uzoefu wako, kufuatilia uchanganuzi, na kuboresha huduma zetu.\n\nUnaweza kudhibiti mipangilio ya vidakuzi kwenye kivinjari chako.\n\n2. Jinsi Tunavyotumia Taarifa Yako\nTunatumia data yako kwa madhumuni yafuatayo:\n\nKuunda na kudhibiti akaunti yako ya SkillBase.\n\nKuchakata malipo na usajili.\n\nKupendekeza kozi kulingana na mambo yanayokuvutia.\n\nKutuma arifa, masasisho, na maudhui ya matangazo (unaweza kujiondoa wakati wowote).\n\nKuboresha mfumo wetu, usalama, na uzoefu wa mtumiaji.\n\n3. Jinsi Tunavyoshiriki Taarifa Zako\nHatuuzi data yako binafsi. Hata hivyo, tunaweza kuishiriki na:\n\nWatoa huduma (wachakataji wa malipo, zana za uchanganuzi, na huduma za upangishaji).\n\nMamlaka za kisheria, ikiwa inahitajika na sheria au kulinda haki zetu.\n\n4. Usalama wa Data\nTunachukua usalama kwa uzito na tunatumia usimbaji fiche, ngome, na hatua zingine kulinda data yako. Hata hivyo, hakuna mfumo ulio salama 100%, kwa hivyo hatuwezi kuhakikisha usalama kamili.\n\n5. Haki na Chaguo Zako\nUna haki ya:\n\nKufikia, kusasisha, au kufuta data yako binafsi.\n\nKujiondoa kwenye barua pepe za uuzaji.\n\nKuzima vidakuzi katika mipangilio ya kivinjari chako.\n\n6. Viungo vya Watu Wengine\nSkillBase inaweza kuwa na viungo vya tovuti za watu wengine. Hatuwajibiki kwa desturi zao za faragha.\n\n7. Faragha ya Watoto\nSkillBase haikusudiwi kwa watumiaji walio chini ya umri wa miaka 13. Hatukusanyi data kutoka kwa watoto kimakusudi.\n\n8. Mabadiliko ya Sera Hii\nTunaweza kusasisha Sera hii ya Faragha mara kwa mara. Tukifanya mabadiliko makubwa, tutakuarifu kupitia barua pepe au arifa za ndani ya programu.\n\n9. Wasiliana Nasi\nIkiwa una maswali au wasiwasi wowote, wasiliana nasi kwa support@skillbase.com.',
    },
    'o534a833': {
      'en': 'Privacy Policy',
      'fr': 'politique de confidentialité',
      'sw': 'Sera ya Faragha',
    },
    '8s46vyul': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // CoursesByGroup
  {
    'vti4w31c': {
      'en': 'View Mode',
      'fr': 'Mode d\'affichage',
      'sw': 'Hali ya Kutazama',
    },
    '1pbz1iss': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // Notifications
  {
    'oo1t3t8t': {
      'en': 'Notifications',
      'fr': 'Notifications',
      'sw': 'Arifa',
    },
    'anaitjzf': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // Reviews
  {
    'qbvu5sm4': {
      'en': 'All',
      'fr': 'Tous',
      'sw': 'Zote',
    },
    '4i8zjg3u': {
      'en': 'Reviews',
      'fr': 'Avis',
      'sw': 'Mapitio',
    },
    'kj6j1cue': {
      'en': 'Reviews',
      'fr': 'Avis',
      'sw': 'Mapitio',
    },
    'wzuk20w3': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // WriteReview
  {
    'w9it0rn7': {
      'en': 'How was your course experience?',
      'fr': 'Comment s\'est déroulée votre formation ?',
      'sw': 'Uzoefu wako wa kozi ulikuwaje?',
    },
    'kaf4vgfr': {
      'en': 'Share your thoughts on “',
      'fr': 'Partagez vos réflexions sur «',
      'sw': 'Shiriki mawazo yako kuhusu “',
    },
    '49begkgd': {
      'en': '”.',
      'fr': '».',
      'sw': '\".',
    },
    '39ndnjbx': {
      'en':
          'Share your thoughts on “Mastering Figma: UI/UX Design and Prototyping”.',
      'fr':
          'Partagez vos impressions sur « Maîtriser Figma : Conception et prototypage d\'interfaces utilisateur/d\'expérience utilisateur ».',
      'sw':
          'Shiriki mawazo yako kuhusu \"Kujua Figma: Ubunifu na Uundaji wa Mfano wa UI/UX\".',
    },
    '1qx4napz': {
      'en': 'Comment',
      'fr': 'Commentaire',
      'sw': 'Maoni',
    },
    'dok3kwv5': {
      'en': 'Let us know what you think.',
      'fr': 'Dites-nous ce que vous en pensez.',
      'sw': 'Tujulishe unachofikiria.',
    },
    'snw7bm0t': {
      'en': 'Please enter a comment before submitting',
      'fr': 'Veuillez saisir un commentaire avant de soumettre.',
      'sw': 'Tafadhali weka maoni kabla ya kuwasilisha',
    },
    'r7h4ghb1': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
      'sw': 'Tafadhali chagua chaguo kutoka kwenye menyu kunjuzi',
    },
    'ptqxd4em': {
      'en': 'Submit',
      'fr': 'Soumettre',
      'sw': 'Wasilisha',
    },
    'houeoad7': {
      'en': 'Leave a review',
      'fr': 'Laissez un avis',
      'sw': 'Acha maoni',
    },
    'a9lyrv21': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // LessonPage
  {
    'z9uehmu1': {
      'en': 'Video duration: ',
      'fr': 'Durée de la vidéo :',
      'sw': 'Muda wa video:',
    },
    'vr2gn9p5': {
      'en': 'Video duration: 06:45',
      'fr': 'Durée de la vidéo : 06:45',
      'sw': 'Muda wa video: 06:45',
    },
    'ohmrf0dc': {
      'en': ' ',
      'fr': '',
      'sw': '',
    },
    'uvoru0jn': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // Checkout
  {
    'xb4bjx59': {
      'en': 'Order details',
      'fr': 'Détails de la commande',
      'sw': 'Maelezo ya agizo',
    },
    '6dpmpue2': {
      'en': 'Order Summary',
      'fr': 'Résumé de la commande',
      'sw': 'Muhtasari wa Agizo',
    },
    'z0s2vbg6': {
      'en': 'Price:',
      'fr': 'Prix:',
      'sw': 'Bei:',
    },
    'vl610zhd': {
      'en': 'Price:',
      'fr': 'Prix:',
      'sw': 'Bei:',
    },
    'fyn47d6u': {
      'en': 'By completing your purchase, you agree to our ',
      'fr':
          'En finalisant votre achat, vous acceptez nos conditions générales.',
      'sw': 'Kwa kukamilisha ununuzi wako, unakubali',
    },
    '6y8qk7ym': {
      'en': 'Terms of Use.',
      'fr': 'Conditions d\'utilisation.',
      'sw': 'Masharti ya Matumizi.',
    },
    'vkngd5cu': {
      'en': 'Hello World',
      'fr': 'Bonjour le monde',
      'sw': 'Habari Dunia',
    },
    'mg8vnp4x': {
      'en': '14-Day Money-Back Guarantee',
      'fr': 'Garantie de remboursement de 14 jours',
      'sw': 'Dhamana ya Kurejeshewa Pesa ya Siku 14',
    },
    'sqf0qmwa': {
      'en':
          'Not satisfied? Get a full refund within 14 days. No hassle, no stress!',
      'fr':
          'Pas satisfait(e) ? Obtenez un remboursement intégral sous 14 jours. Sans tracas, sans stress !',
      'sw':
          'Hujaridhika? Pata marejesho kamili ndani ya siku 14. Hakuna usumbufu, hakuna msongo wa mawazo!',
    },
    'z4zmg3m6': {
      'en': 'Checkout',
      'fr': 'Vérifier',
      'sw': 'Malipo',
    },
    '4sdf2ujd': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // PaymentMethod
  {
    'icx6jk3n': {
      'en': 'Confirm',
      'fr': 'Confirmer',
      'sw': 'Thibitisha',
    },
    'sw6qi9le': {
      'en': 'Done',
      'fr': 'Fait',
      'sw': 'Imekamilika',
    },
    'iw9mkyb2': {
      'en': 'Payment Method',
      'fr': 'Mode de paiement',
      'sw': 'Njia ya Malipo',
    },
    'hq2lmc4i': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // Learn
  {
    'yc9urnu1': {
      'en': 'Learn',
      'fr': 'Apprendre',
      'sw': 'Jifunze',
    },
    'v9otqmeq': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // MyPaymentMethods
  {
    '3vksamd3': {
      'en': 'Payment Method',
      'fr': 'Mode de paiement',
      'sw': 'Njia ya Malipo',
    },
    '2czuy4c5': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // AddCreditCard
  {
    '0u2xm6mn': {
      'en': 'Card number',
      'fr': 'Numéro de carte',
      'sw': 'Nambari ya kadi',
    },
    'i5rnkqnp': {
      'en': '0000 0000 0000 0000',
      'fr': '0000 0000 0000 0000',
      'sw': '0000 0000 0000 0000',
    },
    '8ehmp1ld': {
      'en': '4293 1891 0000 0008',
      'fr': '4293 1891 0000 0008',
      'sw': '4293 1891 0000 0008',
    },
    'eqbdae8j': {
      'en': 'Expire date',
      'fr': 'Date d\'expiration',
      'sw': 'Tarehe ya mwisho wa matumizi',
    },
    'om13g6nw': {
      'en': 'MM/YY',
      'fr': 'MM/AA',
      'sw': 'MM/YY',
    },
    'u9pem3k1': {
      'en': '03/21',
      'fr': '21/03',
      'sw': '03/21',
    },
    '86c5zwzz': {
      'en': 'CVC',
      'fr': 'CVC',
      'sw': 'CVC',
    },
    'q275ufqs': {
      'en': '000',
      'fr': '000',
      'sw': '000',
    },
    '442hwtlz': {
      'en': '123',
      'fr': '123',
      'sw': '123',
    },
    'mzhgucjg': {
      'en': 'Card holder',
      'fr': 'titulaire de carte',
      'sw': 'Mwenye kadi',
    },
    '3pcxf380': {
      'en': 'Holder name',
      'fr': 'Nom du titulaire',
      'sw': 'Jina la mmiliki',
    },
    '6jv2z4wl': {
      'en': 'Alex Johnson',
      'fr': 'Alex Johnson',
      'sw': 'Alex Johnson',
    },
    'rret0bz4': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
      'sw': 'Tafadhali chagua chaguo kutoka kwenye menyu kunjuzi',
    },
    'r5a1wvad': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
      'sw': 'Tafadhali chagua chaguo kutoka kwenye menyu kunjuzi',
    },
    'qd6z7onu': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
      'sw': 'Tafadhali chagua chaguo kutoka kwenye menyu kunjuzi',
    },
    'l6dcl2ls': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
      'sw': 'Tafadhali chagua chaguo kutoka kwenye menyu kunjuzi',
    },
    '7439lt0z': {
      'en': 'Invalid Card Number',
      'fr': 'Numéro de carte invalide',
      'sw': 'Nambari ya Kadi Si Sahihi',
    },
    'bhnbjli6': {
      'en':
          'The card number entered seems incorrect. Please verify and try again.',
      'fr':
          'Le numéro de carte saisi semble incorrect. Veuillez vérifier et réessayer.',
      'sw':
          'Nambari ya kadi iliyoingizwa inaonekana si sahihi. Tafadhali thibitisha na ujaribu tena.',
    },
    '8sip2x71': {
      'en': 'Add card',
      'fr': 'Ajouter une carte',
      'sw': 'Ongeza kadi',
    },
    'my4fah0u': {
      'en': 'Add New Credit Card',
      'fr': 'Ajouter une nouvelle carte de crédit',
      'sw': 'Ongeza Kadi Mpya ya Mkopo',
    },
    '58v9yqby': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // CreditCardPage
  {
    'qsllbniw': {
      'en': 'Expire date',
      'fr': 'Date d\'expiration',
      'sw': 'Tarehe ya mwisho wa matumizi',
    },
    '6x7ocd70': {
      'en': 'CVC',
      'fr': 'CVC',
      'sw': 'CVC',
    },
    'x4nre9xk': {
      'en': 'Card holder',
      'fr': 'titulaire de carte',
      'sw': 'Mwenye kadi',
    },
    '1cksd3x1': {
      'en': 'Card nickname (Optional)',
      'fr': 'Surnom de la carte (facultatif)',
      'sw': 'Jina la utani la kadi (Si lazima)',
    },
    'aywl39io': {
      'en': 'Card nickname',
      'fr': 'Surnom de la carte',
      'sw': 'Jina la utani la kadi',
    },
    'xsiss8s5': {
      'en': 'Default payment method',
      'fr': 'Mode de paiement par défaut',
      'sw': 'Njia chaguomsingi ya malipo',
    },
    'qn3ts8r0': {
      'en': 'Save',
      'fr': 'Sauvegarder',
      'sw': 'Hifadhi',
    },
    '0039xg1w': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // PurchaseHistory
  {
    '5bhwug57': {
      'en': 'Purchase History',
      'fr': 'Historique des achats',
      'sw': 'Historia ya Ununuzi',
    },
    'qp7aq0gz': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // WishList
  {
    's95n07ai': {
      'en': 'Wish List',
      'fr': 'Liste de souhaits',
      'sw': 'Orodha ya Matamanio',
    },
    '35r1cjmk': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // Subscriptions
  {
    'p9bpaq4o': {
      'en': 'Subscriptions',
      'fr': 'Abonnements',
      'sw': 'Usajili',
    },
    'sge1mns9': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // ActivityStatistics
  {
    'i7fykbtq': {
      'en': '10 hours',
      'fr': '10 heures',
      'sw': 'Saa 10',
    },
    'xhaf3ang': {
      'en': 'Your activity this week',
      'fr': 'Votre activité cette semaine',
      'sw': 'Shughuli yako wiki hii',
    },
    'alzurz8c': {
      'en': 'Mon',
      'fr': 'Lun',
      'sw': 'Jumatatu',
    },
    'wal6q87e': {
      'en': 'Tue',
      'fr': 'Mar',
      'sw': 'Jumanne',
    },
    'aw41ov2h': {
      'en': 'Wed',
      'fr': 'Épouser',
      'sw': 'Jumatano',
    },
    'rykdl3pm': {
      'en': 'Thu',
      'fr': 'Jeu',
      'sw': 'Alhamisi',
    },
    'k53vgi1d': {
      'en': 'Fri',
      'fr': 'Ven',
      'sw': 'Ijumaa',
    },
    'dqnboevk': {
      'en': 'Sat',
      'fr': 'Assis',
      'sw': 'Jumamosi',
    },
    '8ibw8b6n': {
      'en': 'Sun',
      'fr': 'Soleil',
      'sw': 'Jua',
    },
    '0uzjavtp': {
      'en':
          'Track your learning progress with weekly insights. See how much time you’ve spent on lessons each day and stay motivated to reach your goals!',
      'fr':
          'Suivez vos progrès d\'apprentissage grâce à des analyses hebdomadaires. Visualisez le temps consacré à vos leçons chaque jour et restez motivé(e) pour atteindre vos objectifs !',
      'sw':
          'Fuatilia maendeleo yako ya kujifunza kwa kutumia maarifa ya kila wiki. Tazama ni muda gani umetumia kwenye masomo kila siku na uendelee kuwa na motisha ya kufikia malengo yako!',
    },
    'p788ynah': {
      'en': 'Activity Statistics',
      'fr': 'Statistiques d\'activité',
      'sw': 'Takwimu za Shughuli',
    },
    'i2tce4bq': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // MyReviews
  {
    'fppmo2c5': {
      'en': 'Pending',
      'fr': 'En attente',
      'sw': 'Inasubiri',
    },
    '1q7t3gd6': {
      'en': 'Reviewed',
      'fr': 'Examiné',
      'sw': 'Imepitiwa',
    },
    '9mt5k8jx': {
      'en': 'My Reviews',
      'fr': 'Mes avis',
      'sw': 'Mapitio Yangu',
    },
    'k20njfcl': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // BecomeAnInstructor
  {
    'e5m3pp73': {
      'en': 'Welcome to Our Instructor Program!',
      'fr': 'Bienvenue dans notre programme de formation d\'instructeurs !',
      'sw': 'Karibu kwenye Programu Yetu ya Mwalimu!',
    },
    'pj6nxh8x': {
      'en':
          'Unlock new opportunities by becoming an instructor and sharing your expertise with a global audience. Our platform allows you to:',
      'fr':
          'Développez de nouvelles opportunités en devenant formateur et en partageant votre expertise avec un public international. Notre plateforme vous permet de :',
      'sw':
          'Fungua fursa mpya kwa kuwa mwalimu na kushiriki utaalamu wako na hadhira ya kimataifa. Jukwaa letu hukuruhusu:',
    },
    'a72eh15g': {
      'en': 'Continue',
      'fr': 'Continuer',
      'sw': 'Endelea',
    },
    'iisrjo7v': {
      'en': 'Read More',
      'fr': 'En savoir plus',
      'sw': 'Soma Zaidi',
    },
    '9iy2hul5': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // InstructorOnboarding
  {
    '1idohx76': {
      'en': 'Apply to Become an Instructor',
      'fr': 'Postulez pour devenir instructeur',
      'sw': 'Omba Kuwa Mwalimu',
    },
    't1vdw3bd': {
      'en':
          'Share your knowledge and start selling your courses online. Fill out the form below to apply as an instructor.',
      'fr':
          'Partagez votre savoir et commencez à vendre vos cours en ligne. Remplissez le formulaire ci-dessous pour devenir formateur.',
      'sw':
          'Shiriki maarifa yako na uanze kuuza kozi zako mtandaoni. Jaza fomu iliyo hapa chini ili kutuma maombi kama mwalimu.',
    },
    'xsbqdz21': {
      'en': 'Your Specialty',
      'fr': 'Votre spécialité',
      'sw': 'Utaalamu Wako',
    },
    '08ucs5vc': {
      'en': 'Your Specialty',
      'fr': 'Votre spécialité',
      'sw': 'Utaalamu Wako',
    },
    '9sv7qf01': {
      'en': 'e.g., Designer, Programmer, Language Teacher',
      'fr': 'Par exemple : concepteur, programmeur, professeur de langues',
      'sw': 'k.m., Mbuni, Mpangaji Programu, Mwalimu wa Lugha',
    },
    '1jkge3wc': {
      'en': 'About You',
      'fr': 'Au propos de vous',
      'sw': 'Kuhusu Wewe',
    },
    '9zlu2x9u': {
      'en': 'About You',
      'fr': 'Au propos de vous',
      'sw': 'Kuhusu Wewe',
    },
    '135hdfwm': {
      'en':
          'Graphic designer with 5 years of experience in branding and UI/UX. Passionate about creating clean and user-friendly designs.',
      'fr':
          'Graphiste avec 5 ans d\'expérience en branding et UI/UX. Passionnée par la création de designs épurés et intuitifs.',
      'sw':
          'Mbuni wa picha mwenye uzoefu wa miaka 5 katika chapa na UI/UX. Ana shauku ya kuunda miundo safi na rahisi kutumia.',
    },
    '1ca4sd6e': {
      'en': 'Education (Optional)',
      'fr': 'Éducation (facultatif)',
      'sw': 'Elimu (Si lazima)',
    },
    'x62i0tnm': {
      'en': 'Education ',
      'fr': 'Éducation',
      'sw': 'Elimu',
    },
    'szk09vh4': {
      'en': 'Add any relevant degrees or certifications',
      'fr': 'Ajoutez tous les diplômes ou certifications pertinents.',
      'sw': 'Ongeza shahada au vyeti vyovyote vinavyofaa',
    },
    'zidcs9fa': {
      'en': 'Submit',
      'fr': 'Soumettre',
      'sw': 'Wasilisha',
    },
    'nkilbe7k': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // UpdateRole
  {
    'z82t6lnt': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // Followers
  {
    'm8oic1k6': {
      'en': 'Followers',
      'fr': 'Abonnés',
      'sw': 'Wafuasi',
    },
    'b747i33q': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // CreatNewCourse
  {
    'a9p9imta': {
      'en': 'Cover Photo',
      'fr': 'Photo de couverture',
      'sw': 'Picha ya Jalada',
    },
    'shk7ppea': {
      'en': 'Change Image',
      'fr': 'Changer l\'image',
      'sw': 'Badilisha Picha',
    },
    '20f0su0i': {
      'en': 'Course Name',
      'fr': 'Nom du cours',
      'sw': 'Jina la Kozi',
    },
    'e2z0434l': {
      'en': 'Course Name',
      'fr': 'Nom du cours',
      'sw': 'Jina la Kozi',
    },
    'awosbeev': {
      'en': 'Description',
      'fr': 'Description',
      'sw': 'Maelezo',
    },
    '8tcahjab': {
      'en': 'Description',
      'fr': 'Description',
      'sw': 'Maelezo',
    },
    '3y5mk2nl': {
      'en': 'Preview',
      'fr': 'Aperçu',
      'sw': 'Hakikisho',
    },
    'bbe2zrqy': {
      'en': 'Change Video',
      'fr': 'Changer de vidéo',
      'sw': 'Badilisha Video',
    },
    'b9bfcpul': {
      'en': 'Category',
      'fr': 'Catégorie',
      'sw': 'Kategoria',
    },
    'e4wo9pli': {
      'en': 'Category',
      'fr': 'Catégorie',
      'sw': 'Kategoria',
    },
    'gfbgr6oh': {
      'en': 'Tags',
      'fr': 'Étiquettes',
      'sw': 'Lebo',
    },
    'w6xlbnz2': {
      'en': 'Add Tag',
      'fr': 'Ajouter une étiquette',
      'sw': 'Ongeza Lebo',
    },
    't380k73e': {
      'en': 'Course Audience',
      'fr': 'Public cible du cours',
      'sw': 'Hadhira ya Kozi',
    },
    'c3fa8wit': {
      'en': 'Course Audience',
      'fr': 'Public cible du cours',
      'sw': 'Hadhira ya Kozi',
    },
    '9dz2gqmv': {
      'en': 'Language',
      'fr': 'Langue',
      'sw': 'Lugha',
    },
    'xm02fme1': {
      'en': 'Language',
      'fr': 'Langue',
      'sw': 'Lugha',
    },
    'tdsd82yr': {
      'en': 'Total Lessons',
      'fr': 'Total des leçons',
      'sw': 'Jumla ya Masomo',
    },
    'dnykcefd': {
      'en': 'Total Lessons',
      'fr': 'Description',
      'sw': 'Maelezo',
    },
    'luh4t121': {
      'en': 'Total duration',
      'fr': 'Durée totale',
      'sw': 'Jumla ya muda',
    },
    'xhb7y55e': {
      'en': 'Total  duration',
      'fr': 'Description',
      'sw': 'Maelezo',
    },
    'hroimsws': {
      'en': 'Group',
      'fr': 'Groupe',
      'sw': 'Kundi',
    },
    '0fa4uqct': {
      'en': 'Select group',
      'fr': '',
      'sw': '',
    },
    'dxk37njq': {
      'en': 'Search...',
      'fr': '',
      'sw': '',
    },
    'savri3pr': {
      'en': 'New Courses',
      'fr': '',
      'sw': '',
    },
    'ttlydk1n': {
      'en': 'We Recommend',
      'fr': '',
      'sw': '',
    },
    '5ltb87bw': {
      'en': 'MontPrice',
      'fr': 'Prix',
      'sw': 'Bei',
    },
    'jd0jukpu': {
      'en': '0',
      'fr': '0',
      'sw': '0',
    },
    'aw8e6wj6': {
      'en': '0',
      'fr': '0',
      'sw': '0',
    },
    '3mcsfq0t': {
      'en': 'Yearly Price',
      'fr': 'Prix ​​annuel',
      'sw': 'Bei ya Mwaka',
    },
    'x4wcb2ml': {
      'en': '0',
      'fr': '0',
      'sw': '0',
    },
    'tw026xes': {
      'en': '0',
      'fr': '0',
      'sw': '0',
    },
    '7spwlmy0': {
      'en': 'Course name is required.',
      'fr': 'Le nom du cours est obligatoire.',
      'sw': 'Jina la kozi linahitajika.',
    },
    '8uvhxgoh': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
      'sw': 'Tafadhali chagua chaguo kutoka kwenye menyu kunjuzi',
    },
    'kossc090': {
      'en': 'Course description is required.',
      'fr': 'Une description du cours est requise.',
      'sw': 'Maelezo ya kozi yanahitajika.',
    },
    'dbpeu803': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
      'sw': 'Tafadhali chagua chaguo kutoka kwenye menyu kunjuzi',
    },
    '6kah78lf': {
      'en': 'Price is required.',
      'fr': 'Le prix est requis.',
      'sw': 'Bei inahitajika.',
    },
    'd5jqekyg': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
      'sw': 'Tafadhali chagua chaguo kutoka kwenye menyu kunjuzi',
    },
    'dkt5ks5s': {
      'en': 'Create Course',
      'fr': 'Créer un cours',
      'sw': 'Unda Kozi',
    },
    'y479otxk': {
      'en': 'New Course',
      'fr': 'Nouveau cours',
      'sw': 'Kozi Mpya',
    },
    'ih8gw758': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // Search
  {
    'nu9esllu': {
      'en': 'Search',
      'fr': 'Recherche',
      'sw': 'Tafuta',
    },
    'powpyqc9': {
      'en': 'Trending Now',
      'fr': 'Tendances actuelles',
      'sw': 'Inayovuma Sasa',
    },
    'o4jnpr47': {
      'en': 'Categories',
      'fr': 'Catégories',
      'sw': 'Aina',
    },
    '9xdsvfr6': {
      'en': 'More',
      'fr': 'Plus',
      'sw': 'Zaidi',
    },
    'tomhezr8': {
      'en': 'We Recommend',
      'fr': 'Nous recommandons',
      'sw': 'Tunapendekeza',
    },
    'vlxs3yf6': {
      'en': 'See All',
      'fr': 'Voir tout',
      'sw': 'Tazama Zote',
    },
    'dyoft13n': {
      'en': 'Search',
      'fr': 'Recherche',
      'sw': 'Tafuta',
    },
    'jdy6mkci': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // AllCategoriesPage
  {
    'q6adx29c': {
      'en': 'Categories',
      'fr': 'Catégories',
      'sw': 'Aina',
    },
    'w0e0s6gh': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // CoursesByCategory
  {
    '9btmnc75': {
      'en': 'View Mode',
      'fr': 'Mode d\'affichage',
      'sw': 'Hali ya Kutazama',
    },
    '5545xevu': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // CoursesByTags
  {
    'n8eae5vd': {
      'en': 'View Mode',
      'fr': 'Mode d\'affichage',
      'sw': 'Hali ya Kutazama',
    },
    '7zakay7i': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // Explore
  {
    'wbfca0rq': {
      'en': 'Search',
      'fr': 'Recherche',
      'sw': 'Tafuta',
    },
    'plk5zhrf': {
      'en': 'Trending Now',
      'fr': 'Tendances actuelles',
      'sw': 'Inayovuma Sasa',
    },
    '0hvtru6j': {
      'en': 'Categories',
      'fr': 'Catégories',
      'sw': 'Aina',
    },
    'rfrgt6g6': {
      'en': 'More',
      'fr': 'Plus',
      'sw': 'Zaidi',
    },
    'l0h9yrro': {
      'en': 'We Recommend',
      'fr': 'Nous recommandons',
      'sw': 'Tunapendekeza',
    },
    'qzjhn92k': {
      'en': 'See All',
      'fr': 'Voir tout',
      'sw': 'Tazama Zote',
    },
    'v1naw22g': {
      'en': 'Explore',
      'fr': 'Explorer',
      'sw': 'Gundua',
    },
    'lwit0sid': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // Courses
  {
    'vr9vrca6': {
      'en': 'Courses',
      'fr': 'Cours',
      'sw': 'Kozi',
    },
    '612ojph2': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // CreatNewLessson
  {
    '01wmb6ff': {
      'en': 'Video Lesson',
      'fr': 'Leçon vidéo',
      'sw': 'Somo la Video',
    },
    '1uojx7v2': {
      'en': 'Change Video',
      'fr': 'Changer de vidéo',
      'sw': 'Badilisha Video',
    },
    '9w9tp55z': {
      'en': 'Lesson No',
      'fr': 'Leçon n°',
      'sw': 'Nambari ya Somo',
    },
    'ly5rqpwe': {
      'en': '0',
      'fr': '0',
      'sw': '0',
    },
    'rdtcn6ch': {
      'en': '№',
      'fr': 'N°',
      'sw': 'Nambari',
    },
    'mo5l9fl8': {
      'en': 'Lesson Name',
      'fr': 'Nom de la leçon',
      'sw': 'Jina la Somo',
    },
    'c3d81qrc': {
      'en': 'Lesson Name',
      'fr': 'Nom de la leçon',
      'sw': 'Jina la Somo',
    },
    'zvvjgreq': {
      'en': 'Duration',
      'fr': 'Durée',
      'sw': 'Muda',
    },
    'qf3dvdwq': {
      'en': 'Durartion ',
      'fr': 'Durée',
      'sw': 'Muda',
    },
    'jax3m4ww': {
      'en': 'Description',
      'fr': 'Description',
      'sw': 'Maelezo',
    },
    'khlquc0u': {
      'en': 'Description',
      'fr': 'Description',
      'sw': 'Maelezo',
    },
    '4hyf9m11': {
      'en': 'Cover photo',
      'fr': 'Photo de couverture',
      'sw': 'Picha ya jalada',
    },
    '2acuwpyl': {
      'en': 'Change Image',
      'fr': 'Changer l\'image',
      'sw': 'Badilisha Picha',
    },
    'a49xmbrc': {
      'en': 'Course name is required.',
      'fr': 'Le nom du cours est obligatoire.',
      'sw': 'Jina la kozi linahitajika.',
    },
    '5bv6cmlq': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
      'sw': 'Tafadhali chagua chaguo kutoka kwenye menyu kunjuzi',
    },
    'd2afv4km': {
      'en': 'Course description is required.',
      'fr': 'Une description du cours est requise.',
      'sw': 'Maelezo ya kozi yanahitajika.',
    },
    '30zyuo2b': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
      'sw': 'Tafadhali chagua chaguo kutoka kwenye menyu kunjuzi',
    },
    '7kxjjsv0': {
      'en': 'Durartion  is required',
      'fr': 'La durée est requise',
      'sw': 'Muda unahitajika',
    },
    'dyugfrut': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
      'sw': 'Tafadhali chagua chaguo kutoka kwenye menyu kunjuzi',
    },
    'whyp0b77': {
      'en': 'Description is required',
      'fr': 'Une description est requise.',
      'sw': 'Maelezo yanahitajika',
    },
    'qzc49q1x': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
      'sw': 'Tafadhali chagua chaguo kutoka kwenye menyu kunjuzi',
    },
    'ma2q10fd': {
      'en': 'Create Lesson',
      'fr': 'Créer une leçon',
      'sw': 'Unda Somo',
    },
    'rm6kje02': {
      'en': 'New Lesson',
      'fr': 'Nouvelle leçon',
      'sw': 'Somo Jipya',
    },
    'fuz3v1bj': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // InstructorPage
  {
    'zghbc397': {
      'en': 'Lessons',
      'fr': 'Leçons',
      'sw': 'Masomo',
    },
    'el81gbhg': {
      'en': 'Students',
      'fr': 'Étudiants',
      'sw': 'Wanafunzi',
    },
    'u198o2wl': {
      'en': 'Followers',
      'fr': 'Abonnés',
      'sw': 'Wafuasi',
    },
    'bgm7zfru': {
      'en': 'Courses',
      'fr': 'Cours',
      'sw': 'Kozi',
    },
    'b2ihol02': {
      'en': 'See All',
      'fr': 'Voir tout',
      'sw': 'Tazama Zote',
    },
    'u3z6n8s2': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // LearnCoursesPage
  {
    'eagv4h2e': {
      'en': 'Language: ',
      'fr': 'Langue:',
      'sw': 'Lugha:',
    },
    'laen0qqa': {
      'en': 'Course Downloaders: ',
      'fr': 'Téléchargeurs de cours :',
      'sw': 'Wapakuaji wa Kozi:',
    },
    'i0877i3h': {
      'en': 'Lessons: ',
      'fr': 'Leçons :',
      'sw': 'Masomo:',
    },
    'w63pie22': {
      'en': 'For:',
      'fr': 'Pour:',
      'sw': 'Kwa:',
    },
    'sijgmqf9': {
      'en': ' ',
      'fr': '',
      'sw': '',
    },
    'sij6hz0r': {
      'en': 'Share',
      'fr': 'Partager',
      'sw': 'Shiriki',
    },
    'xpab1clm': {
      'en': 'Lessons',
      'fr': 'Leçons',
      'sw': 'Masomo',
    },
    'kekwj0iv': {
      'en': 'Video duration: ',
      'fr': 'Durée de la vidéo :',
      'sw': 'Muda wa video:',
    },
    'z2j7ebr0': {
      'en': 'Video duration: 06:45',
      'fr': 'Durée de la vidéo : 06:45',
      'sw': 'Muda wa video: 06:45',
    },
    'fhfv69qw': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // LearnLessonPage
  {
    '2hk9cr3q': {
      'en': 'Video duration: ',
      'fr': 'Durée de la vidéo :',
      'sw': 'Muda wa video:',
    },
    'n81ijyuq': {
      'en': 'Video duration: 06:45',
      'fr': 'Durée de la vidéo : 06:45',
      'sw': 'Muda wa video: 06:45',
    },
    'yhpsu6i8': {
      'en': ' ',
      'fr': '',
      'sw': '',
    },
    'ozvno0td': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // RequestaRefund
  {
    'fzhqt098': {
      'en': 'Reason for Refund',
      'fr': 'Motif du remboursement',
      'sw': 'Sababu ya Kurejeshewa Pesa',
    },
    'umdtpr6s': {
      'en':
          'Provide a brief explanation for why you’re requesting a refund. Your feedback is valuable to us.',
      'fr':
          'Veuillez expliquer brièvement les raisons de votre demande de remboursement. Votre avis nous est précieux.',
      'sw':
          'Toa maelezo mafupi kwa nini unaomba kurejeshewa pesa. Maoni yako ni muhimu kwetu.',
    },
    '8fufwo19': {
      'en': 'Upload screenshot (optional)',
      'fr': 'Télécharger une capture d\'écran (facultatif)',
      'sw': 'Pakia picha ya skrini (si lazima)',
    },
    'glezfwn3': {
      'en':
          'Provide a screenshot to help us better understand your issue. Visual proof can speed up the review process.',
      'fr':
          'Veuillez fournir une capture d\'écran pour nous aider à mieux comprendre votre problème. Une preuve visuelle peut accélérer le processus d\'examen.',
      'sw':
          'Toa picha ya skrini ili kutusaidia kuelewa vyema tatizo lako. Uthibitisho unaoonekana unaweza kuharakisha mchakato wa ukaguzi.',
    },
    'gtn89wxc': {
      'en': 'Change Image',
      'fr': 'Changer l\'image',
      'sw': 'Badilisha Picha',
    },
    'ffx8u1t9': {
      'en': 'Additional Comments (optional)',
      'fr': 'Commentaires supplémentaires (facultatif)',
      'sw': 'Maoni ya Ziada (si lazima)',
    },
    '9t4d5suv': {
      'en': 'Let us know more about your issue. This helps us improve.',
      'fr':
          'N\'hésitez pas à nous en dire plus sur votre problème. Cela nous aidera à nous améliorer.',
      'sw': 'Tujulishe zaidi kuhusu tatizo lako. Hii inatusaidia kuboresha.',
    },
    'ri35l98x': {
      'en': 'Let us know what you think...',
      'fr': 'Dites-nous ce que vous en pensez...',
      'sw': 'Tujulishe unachofikiria...',
    },
    'wro2j1ub': {
      'en': 'Submit Request',
      'fr': 'Soumettre une demande',
      'sw': 'Tuma Ombi',
    },
    'ctxoqr5w': {
      'en': 'Request a Refund',
      'fr': 'Demander un remboursement',
      'sw': 'Omba Kurejeshewa Pesa',
    },
    'emqokmyp': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // PaymentSetup
  {
    '14fivaev': {
      'en': 'Payment Setup ',
      'fr': 'Configuration du paiement',
      'sw': 'Usanidi wa Malipo',
    },
    'ttt86wte': {
      'en':
          'Choose how you’d like to receive payments. Secure and hassle-free transactions ensure you get paid on time, every time.',
      'fr':
          'Choisissez votre mode de paiement préféré. Des transactions sécurisées et sans tracas vous garantissent d\'être payé à temps, à chaque fois.',
      'sw':
          'Chagua jinsi ungependa kupokea malipo. Miamala salama na isiyo na usumbufu inahakikisha unalipwa kwa wakati, kila wakati.',
    },
    'hbed8fld': {
      'en': 'Account holder',
      'fr': 'titulaire du compte',
      'sw': 'Mwenye akaunti',
    },
    'bfk4ggat': {
      'en': 'Account holder',
      'fr': 'titulaire du compte',
      'sw': 'Mwenye akaunti',
    },
    'hs6rhpnr': {
      'en': 'Alex Johnson',
      'fr': 'Alex Johnson',
      'sw': 'Alex Johnson',
    },
    'i3ahqryq': {
      'en': 'Bank code',
      'fr': 'Code bancaire',
      'sw': 'Nambari ya benki',
    },
    'kxs99nix': {
      'en': 'AAAABBBBCCC',
      'fr': 'AAAABBBBCCC',
      'sw': 'AAAABBBBCCC',
    },
    'n7zr115c': {
      'en': 'AAAABBBBCCC',
      'fr': 'AAAABBBBCCC',
      'sw': 'AAAABBBBCCC',
    },
    'vdthgk17': {
      'en': 'Branch code',
      'fr': 'Code de succursale',
      'sw': 'Nambari ya tawi',
    },
    'ua5x04d5': {
      'en': '00000',
      'fr': '00000',
      'sw': '00000',
    },
    'iu1gz38d': {
      'en': '12345',
      'fr': '12345',
      'sw': '12345',
    },
    'tzjnlkve': {
      'en': 'Account #',
      'fr': 'Compte #',
      'sw': 'Nambari ya Akaunti',
    },
    'aekll1kx': {
      'en': '1234567890',
      'fr': '1234567890',
      'sw': '1234567890',
    },
    'rxhrqjkd': {
      'en': '1234567890',
      'fr': '1234567890',
      'sw': '1234567890',
    },
    'c0dqsczs': {
      'en': 'Confirm account #',
      'fr': 'Confirmer le numéro de compte',
      'sw': 'Thibitisha nambari ya akaunti',
    },
    'u8zwxfee': {
      'en': '1234567890',
      'fr': '1234567890',
      'sw': '1234567890',
    },
    '3np9g1er': {
      'en': '1234567890',
      'fr': '1234567890',
      'sw': '1234567890',
    },
    '3phexn04': {
      'en': 'Account holder is required',
      'fr': 'Le titulaire du compte est requis',
      'sw': 'Mwenye akaunti anahitajika',
    },
    'm5axw1s9': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
      'sw': 'Tafadhali chagua chaguo kutoka kwenye menyu kunjuzi',
    },
    'gxpm7lvr': {
      'en': 'AAAABBBBCCC is required',
      'fr': 'AAAABBBBCCC est requis',
      'sw': 'AAAABBBBCCC inahitajika',
    },
    '03q9s77u': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
      'sw': 'Tafadhali chagua chaguo kutoka kwenye menyu kunjuzi',
    },
    'cpkc5ngp': {
      'en': '00000 is required',
      'fr': '00000 est requis',
      'sw': '00000 inahitajika',
    },
    '9g1y9g4m': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
      'sw': 'Tafadhali chagua chaguo kutoka kwenye menyu kunjuzi',
    },
    'cyk8w7lo': {
      'en': '1234567890 is required',
      'fr': '1234567890 est requis',
      'sw': '1234567890 inahitajika',
    },
    'wsk0c3bh': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
      'sw': 'Tafadhali chagua chaguo kutoka kwenye menyu kunjuzi',
    },
    '8lelxe36': {
      'en': '1234567890 is required',
      'fr': '1234567890 est requis',
      'sw': '1234567890 inahitajika',
    },
    'sj71w3nu': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
      'sw': 'Tafadhali chagua chaguo kutoka kwenye menyu kunjuzi',
    },
    '6qed0j0o': {
      'en': 'PayPal email',
      'fr': 'Courriel PayPal',
      'sw': 'Barua pepe ya PayPal',
    },
    '3rb0vh8b': {
      'en': 'PayPal email',
      'fr': 'Courriel PayPal',
      'sw': 'Barua pepe ya PayPal',
    },
    'ta5alj13': {
      'en': 'PayPal email is required',
      'fr': 'L\'adresse e-mail PayPal est requise.',
      'sw': 'Barua pepe ya PayPal inahitajika',
    },
    '3sig1lhh': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
      'sw': 'Tafadhali chagua chaguo kutoka kwenye menyu kunjuzi',
    },
    '3jxkua10': {
      'en': 'Submit',
      'fr': 'Soumettre',
      'sw': 'Wasilisha',
    },
    'g1n7vxrn': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // Analytics
  {
    'h5lj1tg7': {
      'en': 'Today',
      'fr': 'Aujourd\'hui',
      'sw': 'Leo',
    },
    'cwu9imf2': {
      'en': 'Week',
      'fr': 'Semaine',
      'sw': 'Wiki',
    },
    's0uyerfv': {
      'en': 'Total',
      'fr': 'Total',
      'sw': 'Jumla',
    },
    'dooc71w2': {
      'en': 'Total Sales Volume',
      'fr': 'Volume total des ventes',
      'sw': 'Jumla ya Kiasi cha Mauzo',
    },
    'lbukgj2d': {
      'en': ' \$',
      'fr': '\$',
      'sw': '\$',
    },
    'e1xcr63p': {
      'en': '629.79 \$',
      'fr': '629,79 \$',
      'sw': '\$629.79',
    },
    'vistkj6a': {
      'en': 'Purchased',
      'fr': 'Acheté',
      'sw': 'Imenunuliwa',
    },
    'ww84ryct': {
      'en': '21',
      'fr': '21',
      'sw': '21',
    },
    'snzuyb20': {
      'en': 'Pending',
      'fr': 'En attente',
      'sw': 'Inasubiri',
    },
    'tlmoa2zz': {
      'en': '8',
      'fr': '8',
      'sw': '8',
    },
    'enjgkpxf': {
      'en': 'Canceled',
      'fr': 'Annulé',
      'sw': 'Imeghairiwa',
    },
    'fkv1bz82': {
      'en': '2',
      'fr': '2',
      'sw': '2',
    },
    '38yn0d54': {
      'en': 'Download Report',
      'fr': 'Télécharger le rapport',
      'sw': 'Pakua Ripoti',
    },
    '9vo9adjr': {
      'en': 'Weekly Course Visits',
      'fr': 'Visites hebdomadaires du cours',
      'sw': 'Ziara za Kozi za Kila Wiki',
    },
    'p7vef3h8': {
      'en': 'Shows how many users accessed this course over the past week.',
      'fr':
          'Indique le nombre d\'utilisateurs ayant accédé à ce cours au cours de la semaine écoulée.',
      'sw':
          'Inaonyesha ni watumiaji wangapi waliopata kozi hii katika wiki iliyopita.',
    },
    'otsiqyc0': {
      'en': 'Mon',
      'fr': 'Lun',
      'sw': 'Jumatatu',
    },
    'g65ci39b': {
      'en': 'Tue',
      'fr': 'Mar',
      'sw': 'Jumanne',
    },
    '0hisot9u': {
      'en': 'Wed',
      'fr': 'Épouser',
      'sw': 'Jumatano',
    },
    '3vu6q7tp': {
      'en': 'Thu',
      'fr': 'Jeu',
      'sw': 'Alhamisi',
    },
    'ze38yvvp': {
      'en': 'Fri',
      'fr': 'Ven',
      'sw': 'Ijumaa',
    },
    'i8r4jv12': {
      'en': 'Sat',
      'fr': 'Assis',
      'sw': 'Jumamosi',
    },
    'mocf317x': {
      'en': 'Sun',
      'fr': 'Soleil',
      'sw': 'Jua',
    },
    'eto9vtib': {
      'en': 'Top Downloading Countries',
      'fr': 'Principaux pays de téléchargement',
      'sw': 'Nchi Zinazopakuliwa Zaidi',
    },
    'yx5t76wm': {
      'en':
          'Shows the countries with the highest number of downloaded courses.',
      'fr':
          'Affiche les pays ayant enregistré le plus grand nombre de cours téléchargés.',
      'sw': 'Inaonyesha nchi zenye idadi kubwa zaidi ya kozi zilizopakuliwa.',
    },
    '6vjl6rv8': {
      'en': 'Portugal',
      'fr': 'Portugal',
      'sw': 'Ureno',
    },
    'zs70dkfd': {
      'en': 'Germany',
      'fr': 'Allemagne',
      'sw': 'Ujerumani',
    },
    'ryhklmzu': {
      'en': 'Russia',
      'fr': 'Russie',
      'sw': 'Urusi',
    },
    'z03gq3ko': {
      'en': 'Analytics',
      'fr': 'Analytique',
      'sw': 'Uchanganuzi',
    },
    '6637bamn': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // InstructorCourses
  {
    'mtb3chfn': {
      'en': 'View Mode',
      'fr': 'Mode d\'affichage',
      'sw': 'Hali ya Kutazama',
    },
    'x9qh5zri': {
      'en': 'Courses',
      'fr': 'Cours',
      'sw': 'Kozi',
    },
    'kz5vn1xd': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // CoursesByTopics
  {
    'fiorg8gw': {
      'en': 'View Mode',
      'fr': 'Mode d\'affichage',
      'sw': 'Hali ya Kutazama',
    },
    'b6ya7lxu': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // CoursesPageCopy
  {
    'jwnppf4e': {
      'en': 'Language: ',
      'fr': 'Langue:',
      'sw': 'Lugha:',
    },
    'ikgxyyr3': {
      'en': 'Course Downloaders: ',
      'fr': 'Téléchargeurs de cours :',
      'sw': 'Wapakuaji wa Kozi:',
    },
    '1xq12bks': {
      'en': 'Lessons: ',
      'fr': 'Leçons :',
      'sw': 'Masomo:',
    },
    'ietxei14': {
      'en': 'For:',
      'fr': 'Pour:',
      'sw': 'Kwa:',
    },
    'lh7odyqi': {
      'en': ' ',
      'fr': '',
      'sw': '',
    },
    '7es1fvn4': {
      'en': 'Share',
      'fr': 'Partager',
      'sw': 'Shiriki',
    },
    'yvf7fu0j': {
      'en': 'Lessons',
      'fr': 'Leçons',
      'sw': 'Masomo',
    },
    'tue9dice': {
      'en': 'Video duration: ',
      'fr': 'Durée de la vidéo :',
      'sw': 'Muda wa video:',
    },
    'z6yftu8p': {
      'en': 'Video duration: 06:45',
      'fr': 'Durée de la vidéo : 06:45',
      'sw': 'Muda wa video: 06:45',
    },
    'o2dyjqmy': {
      'en': 'Free',
      'fr': 'Gratuit',
      'sw': 'Bure',
    },
    '3xtt7j9v': {
      'en': 'Video duration: ',
      'fr': 'Durée de la vidéo :',
      'sw': 'Muda wa video:',
    },
    'oumyh5t0': {
      'en': 'Video duration: 06:45',
      'fr': 'Durée de la vidéo : 06:45',
      'sw': 'Muda wa video: 06:45',
    },
    't8crd1gh': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // CoursesPageCopyCopy
  {
    'u5ugvm5w': {
      'en': 'Language: ',
      'fr': 'Langue:',
      'sw': 'Lugha:',
    },
    'sr08swrp': {
      'en': 'Course Downloaders: ',
      'fr': 'Téléchargeurs de cours :',
      'sw': 'Wapakuaji wa Kozi:',
    },
    'whxvmgs5': {
      'en': 'Lessons: ',
      'fr': 'Leçons :',
      'sw': 'Masomo:',
    },
    'miypdwxo': {
      'en': 'For:',
      'fr': 'Pour:',
      'sw': 'Kwa:',
    },
    'sdk8bl7l': {
      'en': ' ',
      'fr': '',
      'sw': '',
    },
    'z1pmhg9c': {
      'en': 'Share',
      'fr': 'Partager',
      'sw': 'Shiriki',
    },
    'hiexrq0b': {
      'en': 'Lessons',
      'fr': 'Leçons',
      'sw': 'Masomo',
    },
    'saehnnj5': {
      'en': 'Select Package',
      'fr': 'Sélectionner le forfait',
      'sw': 'Chagua Kifurushi',
    },
    'ixc784n6': {
      'en': 'Monthly',
      'fr': 'Mensuel',
      'sw': 'Kila mwezi',
    },
    'q1l82ofd': {
      'en': 'Yearly',
      'fr': 'Annuel',
      'sw': 'Kila mwaka',
    },
    'en5egsg2': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // LearnCopy
  {
    'aw2k2izd': {
      'en': 'Learn',
      'fr': 'Apprendre',
      'sw': 'Jifunze',
    },
    '3h7iuj59': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // consultation
  {
    'f7dhjs0k': {
      'en': 'Request Appointment',
      'fr': 'Demander un rendez-vous',
      'sw': 'Omba Miadi',
    },
    '74n58sq1': {
      'en':
          'Please fill in the details below to schedule your appointment with our healthcare professional.',
      'fr':
          'Veuillez remplir les informations ci-dessous pour programmer votre rendez-vous avec notre professionnel de santé.',
      'sw':
          'Tafadhali jaza maelezo yaliyo hapa chini ili kupanga miadi yako na mtaalamu wetu wa afya.',
    },
    'if5dkkur': {
      'en': 'Personal Information',
      'fr': 'Informations personnelles',
      'sw': 'Taarifa Binafsi',
    },
    '5t4o2tds': {
      'en': 'Full Name',
      'fr': '',
      'sw': '',
    },
    '8yz3789n': {
      'en': 'Phone Number',
      'fr': '',
      'sw': '',
    },
    'u7ntalud': {
      'en': 'Email Address',
      'fr': '',
      'sw': '',
    },
    'o96pp4yb': {
      'en': 'Appointment Details',
      'fr': 'Détails du rendez-vous',
      'sw': 'Maelezo ya Miadi',
    },
    '91zwvx4p': {
      'en': 'Select Date',
      'fr': '',
      'sw': '',
    },
    '0urmkzx8': {
      'en': 'Select Department',
      'fr': '',
      'sw': '',
    },
    'r85bvox2': {
      'en': 'Nelway\'s Academy',
      'fr': '',
      'sw': '',
    },
    'vc9e5srm': {
      'en': 'Nelway\'s Ice cream',
      'fr': '',
      'sw': '',
    },
    '7luzw72i': {
      'en': 'Nelway\'s Gelato',
      'fr': '',
      'sw': '',
    },
    '8ridehqi': {
      'en': 'Nelway\'s Consultaion',
      'fr': '',
      'sw': '',
    },
    'h4kjt1q2': {
      'en': 'Reason for Visit',
      'fr': 'Motif de la visite',
      'sw': 'Sababu ya Kutembelea',
    },
    'yy45y5hc': {
      'en': 'Please describe your symptoms or reason for the appointment...',
      'fr': '',
      'sw': '',
    },
    'a0kv2p98': {
      'en': 'Important Note',
      'fr': 'Note importante',
      'sw': 'Dokezo Muhimu',
    },
    'y5hhfbf9': {
      'en':
          'Please arrive 15 minutes before your scheduled appointment time. Bring a valid ID and any relevant medical documents.',
      'fr':
          'Veuillez arriver 15 minutes avant l\'heure prévue de votre rendez-vous. Munissez-vous d\'une pièce d\'identité valide et de tout document médical pertinent.',
      'sw':
          'Tafadhali fika dakika 15 kabla ya muda uliopangwa wa miadi. Lete kitambulisho halali na hati zozote za matibabu zinazofaa.',
    },
    'ss38ptl7': {
      'en': 'Request Appointment',
      'fr': '',
      'sw': '',
    },
  },
  // consultationpage
  {
    'e5d46qc1': {
      'en': 'Manage your consultations',
      'fr': 'Gérez vos consultations',
      'sw': 'Dhibiti mashauriano yako',
    },
    '1zl626e7': {
      'en': 'Confirmed',
      'fr': '',
      'sw': '',
    },
    '5sl1drjq': {
      'en': 'View Details',
      'fr': '',
      'sw': '',
    },
    'r1yhudzr': {
      'en': 'Dr. Robert Chen',
      'fr': '',
      'sw': '',
    },
    '3eoyis09': {
      'en': 'Pending',
      'fr': '',
      'sw': '',
    },
    '7octx9up': {
      'en': 'Patient: Emma Davis',
      'fr': '',
      'sw': '',
    },
    '4nql5k44': {
      'en': 'Dermatology Check-up',
      'fr': '',
      'sw': '',
    },
    'k04sjoqm': {
      'en': '2:15 PM',
      'fr': '',
      'sw': '',
    },
    'lzdfywb2': {
      'en': 'Today',
      'fr': '',
      'sw': '',
    },
    'a9vjv9b7': {
      'en': 'View Details',
      'fr': '',
      'sw': '',
    },
    '526wwy7g': {
      'en': 'Dr. Lisa Martinez',
      'fr': '',
      'sw': '',
    },
    'veqhqcla': {
      'en': 'In Progress',
      'fr': '',
      'sw': '',
    },
    'eesitks9': {
      'en': 'Patient: James Wilson',
      'fr': '',
      'sw': '',
    },
    'cfbto7en': {
      'en': 'Orthopedic Consultation',
      'fr': '',
      'sw': '',
    },
    't4jc55tx': {
      'en': '4:45 PM',
      'fr': '',
      'sw': '',
    },
    '1iz4fmbo': {
      'en': 'Today',
      'fr': '',
      'sw': '',
    },
    '4xjio5l2': {
      'en': 'View Details',
      'fr': '',
      'sw': '',
    },
    'svm8j90o': {
      'en': 'Dr. Kevin Park',
      'fr': '',
      'sw': '',
    },
    '39rvzpmk': {
      'en': 'Cancelled',
      'fr': '',
      'sw': '',
    },
    'cm0ny9z9': {
      'en': 'Patient: Anna Rodriguez',
      'fr': '',
      'sw': '',
    },
    '8ot79ynu': {
      'en': 'Pediatric Check-up',
      'fr': '',
      'sw': '',
    },
    '4nf9vva8': {
      'en': '11:00 AM',
      'fr': '',
      'sw': '',
    },
    'rp9w5qch': {
      'en': 'Tomorrow',
      'fr': '',
      'sw': '',
    },
    '8utxoj8r': {
      'en': 'Reschedule',
      'fr': '',
      'sw': '',
    },
    'fli4qecp': {
      'en': 'Appointment \'s',
      'fr': 'Rendez-vous',
      'sw': 'Miadi ya',
    },
  },
  // TermsandConditionsCopy
  {
    'p3ikwswu': {
      'en':
          'Welcome to SkillBase! By using our platform, you agree to the following terms and conditions. Please read them carefully.\n\n1. Introduction\nSkillBase (\"we,\" \"our,\" or \"us\") provides an online learning platform that offers courses in various educational fields. By accessing or using SkillBase, you agree to comply with these Terms and Conditions.\n\n2. User Accounts\nYou must be at least 13 years old to use SkillBase.\n\nYou are responsible for maintaining the confidentiality of your account credentials.\n\nYou agree not to share your account with others or allow unauthorized access.\n\n3. Course Enrollment & Access\nSome courses are free, while others require a one-time payment or subscription.\n\nCourse access is granted for personal use only; redistribution or reselling is prohibited.\n\nInstructors retain ownership of course content, and you receive a limited, non-transferable license to view it.\n\n4. Payments & Refunds\nPayments can be made via credit/debit cards, PayPal, or other accepted methods.\n\nRefunds are available within 7 days of purchase, provided you have not completed more than 20% of the course.\n\nSubscription fees are non-refundable once charged.\n\n5. User Conduct\nBy using SkillBase, you agree to:\n\nNot post or distribute any harmful, abusive, or illegal content.\n\nNot attempt to hack, disrupt, or reverse-engineer the platform.\n\nRespect copyright laws and intellectual property rights.\n\nViolation of these rules may result in account suspension or termination.\n\n6. Intellectual Property\nAll content, including courses, videos, and materials, is protected by copyright laws.\n\nYou may not copy, distribute, or modify any content without permission.\n\n7. Termination & Account Deactivation\nWe reserve the right to suspend or terminate accounts that violate these Terms or engage in suspicious activities.\n\n8. Disclaimer & Limitation of Liability\nWe do not guarantee job placement, success, or specific learning outcomes.\n\nSkillBase is provided \"as is\" without warranties of any kind.\n\nWe are not liable for any direct, indirect, or incidental damages arising from the use of our platform.\n\n9. Changes to Terms\nWe may update these Terms from time to time. Any changes will be notified via email or in-app notifications.\n\n10. Contact Us\nIf you have any questions about these Terms, please contact us at support@skillbase.com.',
      'fr':
          'Bienvenue sur SkillBase ! En utilisant notre plateforme, vous acceptez les conditions générales suivantes. Veuillez les lire attentivement.\n\n1. Introduction\nSkillBase (« nous », « notre » ou « nos ») propose une plateforme d\'apprentissage en ligne offrant des cours dans divers domaines. En accédant à SkillBase ou en l\'utilisant, vous acceptez de respecter les présentes conditions générales.\n\n2. Comptes utilisateurs\nVous devez avoir au moins 13 ans pour utiliser SkillBase.\n\nVous êtes responsable de la confidentialité de vos identifiants de connexion.\n\nVous vous engagez à ne pas partager votre compte ni à autoriser un accès non autorisé.\n\n3. Inscription et accès aux cours\nCertains cours sont gratuits, tandis que d\'autres nécessitent un paiement unique ou un abonnement.\n\nL\'accès aux cours est réservé à un usage personnel ; toute redistribution ou revente est interdite.\n\nLes formateurs conservent la propriété du contenu des cours et vous bénéficiez d\'une licence limitée et non transférable vous permettant de le consulter.\n\n4. Paiements et remboursements\n\nLes paiements peuvent être effectués par carte bancaire (crédit/débit), PayPal ou tout autre moyen accepté.\n\nLes remboursements sont possibles dans les 7 jours suivant l\'achat, à condition de ne pas avoir suivi plus de 20 % du cours.\n\nLes frais d\'abonnement ne sont pas remboursables une fois facturés.\n\n5. Comportement de l\'utilisateur\n\nEn utilisant SkillBase, vous vous engagez à :\n\nNe pas publier ni diffuser de contenu nuisible, abusif ou illégal.\n\nNe pas tenter de pirater, perturber ou décompiler la plateforme.\n\nRespecter les lois sur le droit d\'auteur et les droits de propriété intellectuelle.\n\nTout manquement à ces règles peut entraîner la suspension ou la résiliation de votre compte.\n\n6. Propriété intellectuelle\nL\'ensemble du contenu, y compris les cours, les vidéos et les supports, est protégé par le droit d\'auteur.\n\nIl est interdit de copier, diffuser ou modifier tout contenu sans autorisation.\n\n7. Résiliation et désactivation de compte\nNous nous réservons le droit de suspendre ou de résilier les comptes qui enfreignent les présentes conditions d\'utilisation ou qui se livrent à des activités suspectes.\n\n8. Exclusion et limitation de responsabilité\n\nNous ne garantissons ni placement professionnel, ni réussite, ni résultats d\'apprentissage spécifiques.\n\nSkillBase est fourni « en l\'état », sans aucune garantie.\n\nNous déclinons toute responsabilité pour les dommages directs, indirects ou accessoires résultant de l\'utilisation de notre plateforme.\n\n9. Modifications des conditions d\'utilisation\nNous pouvons être amenés à modifier ces conditions d\'utilisation. Toute modification sera notifiée par e-mail ou via des notifications intégrées à l\'application.\n\n10. Nous contacter\nPour toute question concernant ces conditions d\'utilisation, veuillez nous contacter à l\'adresse support@skillbase.com.',
      'sw':
          'Karibu SkillBase! Kwa kutumia jukwaa letu, unakubali sheria na masharti yafuatayo. Tafadhali yasome kwa makini.\n\n1. Utangulizi\nSkillBase (\"sisi,\" \"yetu,\" au \"sisi\") hutoa jukwaa la kujifunza mtandaoni linalotoa kozi katika nyanja mbalimbali za kielimu. Kwa kufikia au kutumia SkillBase, unakubali kufuata Sheria na Masharti haya.\n\n2. Akaunti za Mtumiaji\nLazima uwe na umri wa angalau miaka 13 ili kutumia SkillBase.\n\nUnawajibika kudumisha usiri wa sifa za akaunti yako.\n\nUnakubali kutoshiriki akaunti yako na wengine au kuruhusu ufikiaji usioidhinishwa.\n\n3. Uandikishaji na Ufikiaji wa Kozi\nBaadhi ya kozi ni bure, huku zingine zikihitaji malipo ya mara moja au usajili.\n\nUfikiaji wa kozi unatolewa kwa matumizi ya kibinafsi pekee; usambazaji upya au uuzaji upya ni marufuku.\n\nWakufunzi huhifadhi umiliki wa maudhui ya kozi, na unapokea leseni ndogo, isiyoweza kuhamishwa ili kuiona.\n\n4. Malipo na Marejesho\nMalipo yanaweza kufanywa kupitia kadi za mkopo/debiti, PayPal, au njia zingine zinazokubalika.\n\nMarejesho yanapatikana ndani ya siku 7 baada ya ununuzi, mradi tu hujakamilisha zaidi ya 20% ya kozi.\n\nAda za usajili hazirejeshwi mara tu zinapotozwa.\n\n5. Maadili ya Mtumiaji\nKwa kutumia SkillBase, unakubali:\n\nKutochapisha au kusambaza maudhui yoyote yenye madhara, matusi, au haramu.\n\nKutojaribu kudukua, kuvuruga, au kubadilisha mfumo.\n\nKuheshimu sheria za hakimiliki na haki miliki miliki.\n\nUkiukaji wa sheria hizi unaweza kusababisha kusimamishwa au kusitishwa kwa akaunti.\n\n6. Mali Miliki\nMaudhui yote, ikiwa ni pamoja na kozi, video, na nyenzo, yanalindwa na sheria za hakimiliki.\n\nHuruhusiwi kunakili, kusambaza, au kurekebisha maudhui yoyote bila ruhusa.\n\n7. Kusitishwa na Kuzimwa kwa Akaunti\nTunahifadhi haki ya kusimamisha au kusitisha akaunti zinazokiuka Masharti haya au kushiriki katika shughuli zinazotiliwa shaka.\n\n8. Kanusho na Upungufu wa Dhima\nHatuhakikishi nafasi ya kazi, mafanikio, au matokeo maalum ya kujifunza.\n\nSkillBase hutolewa \"kama ilivyo\" bila dhamana ya aina yoyote.\n\nHatuwajibiki kwa uharibifu wowote wa moja kwa moja, usio wa moja kwa moja, au wa bahati mbaya unaotokana na matumizi ya mfumo wetu.\n\n9. Mabadiliko ya Masharti\nTunaweza kusasisha Masharti haya mara kwa mara. Mabadiliko yoyote yataarifiwa kupitia barua pepe au arifa za ndani ya programu.\n\n10. Wasiliana Nasi\nIkiwa una maswali yoyote kuhusu Masharti haya, tafadhali wasiliana nasi kwa support@skillbase.com.',
    },
    'papnmwz9': {
      'en': 'Terms and Conditions',
      'fr': 'Termes et conditions',
      'sw': 'Sheria na Masharti',
    },
    'h2py8dcm': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // MobileMoney
  {
    'vfv84ppm': {
      'en': 'Phone number',
      'fr': 'Numéro de téléphone',
      'sw': 'Nambari ya simu',
    },
    'k1cw0ra0': {
      'en': '0774222013',
      'fr': '0774222013',
      'sw': '0774222013',
    },
    'd87rgdvf': {
      'en': '',
      'fr': '',
      'sw': '',
    },
    'wutgiw3b': {
      'en': 'Mobile Money',
      'fr': 'Argent mobile',
      'sw': 'Pesa za Simu',
    },
    'm16epiuu': {
      'en': 'M-PESA',
      'fr': 'M-PESA',
      'sw': 'M-PESA',
    },
    'fclgcx03': {
      'en': 'MIXX BY YASS ',
      'fr': '',
      'sw': '',
    },
    'dh3sulte': {
      'en': 'HALOPESA',
      'fr': '',
      'sw': '',
    },
    'hro3y31t': {
      'en': 'AIRTEL MONEY',
      'fr': '',
      'sw': '',
    },
    'imw5wmsv': {
      'en': 'M-PESA',
      'fr': 'M-PESA',
      'sw': 'M-PESA',
    },
    'bf78xez7': {
      'en': 'Your Name',
      'fr': 'Votre nom',
      'sw': 'Jina Lako',
    },
    'iazjsvi8': {
      'en': 'Holder name',
      'fr': 'Nom du titulaire',
      'sw': 'Jina la mmiliki',
    },
    '4wa9xh8f': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
      'sw': 'Tafadhali chagua chaguo kutoka kwenye menyu kunjuzi',
    },
    'w2nvkdkw': {
      'en': 'Please choose an option from the dropdown',
      'fr': 'Veuillez choisir une option dans le menu déroulant.',
      'sw': 'Tafadhali chagua chaguo kutoka kwenye menyu kunjuzi',
    },
    'v1bp4hlp': {
      'en': 'Invalid Phone Number',
      'fr': 'Numéro de téléphone invalide',
      'sw': 'Nambari ya Simu Si Sahihi',
    },
    'hlj0gde0': {
      'en':
          'The phone number entered seems incorrect. Please verify and try again.',
      'fr':
          'Le numéro de téléphone saisi semble incorrect. Veuillez vérifier et réessayer.',
      'sw':
          'Nambari ya simu iliyoingizwa inaonekana si sahihi. Tafadhali thibitisha na ujaribu tena.',
    },
    '0mzz9fi8': {
      'en': 'Add card',
      'fr': 'Ajouter une carte',
      'sw': 'Ongeza kadi',
    },
    '41n7wcoi': {
      'en': 'Add  Mobile wallet',
      'fr': 'Ajouter un portefeuille mobile',
      'sw': 'Ongeza pochi ya simu',
    },
    '3agr1zii': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // CheckoutCopy
  {
    'i2av7knl': {
      'en': 'Order details',
      'fr': 'Détails de la commande',
      'sw': 'Maelezo ya agizo',
    },
    'kdoxxygl': {
      'en': 'Order Summary',
      'fr': 'Résumé de la commande',
      'sw': 'Muhtasari wa Agizo',
    },
    'it27b9t5': {
      'en': 'Price:',
      'fr': 'Prix:',
      'sw': 'Bei:',
    },
    'tc46tupc': {
      'en': 'Total:',
      'fr': 'Total:',
      'sw': 'Jumla:',
    },
    'iiytsw34': {
      'en': 'By completing your purchase, you agree to our ',
      'fr':
          'En finalisant votre achat, vous acceptez nos conditions générales.',
      'sw': 'Kwa kukamilisha ununuzi wako, unakubali',
    },
    'tsggf4o8': {
      'en': 'Terms of Use.',
      'fr': 'Conditions d\'utilisation.',
      'sw': 'Masharti ya Matumizi.',
    },
    '7q2m698t': {
      'en': 'Hello World',
      'fr': 'Bonjour le monde',
      'sw': 'Habari Dunia',
    },
    'n5vxo8fv': {
      'en': '14-Day Money-Back Guarantee',
      'fr': 'Garantie de remboursement de 14 jours',
      'sw': 'Dhamana ya Kurejeshewa Pesa ya Siku 14',
    },
    '9qyfusts': {
      'en':
          'Not satisfied? Get a full refund within 14 days. No hassle, no stress!',
      'fr':
          'Pas satisfait(e) ? Obtenez un remboursement intégral sous 14 jours. Sans tracas, sans stress !',
      'sw':
          'Hujaridhika? Pata marejesho kamili ndani ya siku 14. Hakuna usumbufu, hakuna msongo wa mawazo!',
    },
    '4nb1kiu7': {
      'en': 'Checkout',
      'fr': 'Vérifier',
      'sw': 'Malipo',
    },
    'iztj8vp5': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // OptionPage
  {
    '5xc1gl2m': {
      'en': 'Home',
      'fr': '',
      'sw': '',
    },
  },
  // consultationss
  {
    'f2jka884': {
      'en': 'Business Intensive',
      'fr': '',
      'sw': '',
    },
    '79jmlton': {
      'en': 'The Profitable Kitchen',
      'fr': '',
      'sw': '',
    },
    'thxks919': {
      'en': 'A Business Intensive with Madam Mercy Kitomari',
      'fr': '',
      'sw': '',
    },
    'nrxzvc9d': {
      'en': '3 sessions. Custom workbook. Pricing formula you keep forever.',
      'fr': '',
      'sw': '',
    },
    '88eh2is4': {
      'en': '3',
      'fr': '',
      'sw': '',
    },
    'ad4lm8au': {
      'en': 'Sessions',
      'fr': '',
      'sw': '',
    },
    '51aodrrd': {
      'en': '1:1',
      'fr': '',
      'sw': '',
    },
    'uguh33oc': {
      'en': 'Coaching',
      'fr': '',
      'sw': '',
    },
    'uks4nwyw': {
      'en': '∞',
      'fr': '',
      'sw': '',
    },
    't7gfi7gk': {
      'en': 'Formula Yours',
      'fr': '',
      'sw': '',
    },
    'km1vynv9': {
      'en': 'How It Works',
      'fr': '',
      'sw': '',
    },
    'ijc2xxbp': {
      'en': 'Three Sessions. One Transformation',
      'fr': '',
      'sw': '',
    },
    'l1a36l7i': {
      'en': '01',
      'fr': '',
      'sw': '',
    },
    'mybj7kw0': {
      'en': 'Discovery Session',
      'fr': '',
      'sw': '',
    },
    'wdnhj8ro': {
      'en':
          'We map your current pricing, costs, and business goals. Identify gaps and opportunities unique to your kitchen.',
      'fr': '',
      'sw': '',
    },
    'i8gkb8us': {
      'en': 'Session 1',
      'fr': '',
      'sw': '',
    },
    'd8x0u8pi': {
      'en': '02',
      'fr': '',
      'sw': '',
    },
    'wdm6hfpr': {
      'en': 'Working Through',
      'fr': '',
      'sw': '',
    },
    '1yskb1o4': {
      'en':
          'Build your custom workbook together. Craft your signature pricing formula tailored to your menu and market.',
      'fr': '',
      'sw': '',
    },
    'pljexw16': {
      'en': 'Session 2',
      'fr': '',
      'sw': '',
    },
    '9sn9geng': {
      'en': '03',
      'fr': '',
      'sw': '',
    },
    'yno3cqud': {
      'en': 'Assignment & Closing',
      'fr': '',
      'sw': '',
    },
    'wv1sw8ih': {
      'en':
          'Review your completed formula, finalize your workbook, and leave with a clear action plan to implement immediately.',
      'fr': '',
      'sw': '',
    },
    '6sz1fnp1': {
      'en': 'Session 3',
      'fr': '',
      'sw': '',
    },
    'v63hj92e': {
      'en': 'Choose Your Plan',
      'fr': '',
      'sw': '',
    },
    '4e2gi33w': {
      'en': 'Select what works for you',
      'fr': '',
      'sw': '',
    },
    '8mv5mhve': {
      'en': 'Virtual Plan',
      'fr': '',
      'sw': '',
    },
    'y02s66ht': {
      'en': '\$250',
      'fr': '',
      'sw': '',
    },
    '6mkn9qoa': {
      'en': 'per intensive',
      'fr': '',
      'sw': '',
    },
    'kspgvrm6': {
      'en': '3 virtual coaching sessions',
      'fr': '',
      'sw': '',
    },
    'n2e0rimd': {
      'en': 'Custom business workbook',
      'fr': '',
      'sw': '',
    },
    'ny4mvhp0': {
      'en': 'Signature pricing formula (yours forever)',
      'fr': '',
      'sw': '',
    },
    '4qe360vq': {
      'en': 'Video call via Zoom or Google Meet',
      'fr': '',
      'sw': '',
    },
    'xrjbgs4d': {
      'en': 'In-Person Plan',
      'fr': '',
      'sw': '',
    },
    'a8d9idsg': {
      'en': '\$750',
      'fr': '',
      'sw': '',
    },
    'thq53147': {
      'en': 'per intensive',
      'fr': '',
      'sw': '',
    },
    'pnawclb9': {
      'en': '3 in-person coaching sessions',
      'fr': '',
      'sw': '',
    },
    'uinxznp5': {
      'en': 'Hands-on kitchen & business walkthrough',
      'fr': '',
      'sw': '',
    },
    'kpossvaq': {
      'en': 'Custom workbook & pricing formula',
      'fr': '',
      'sw': '',
    },
    'a5hsserp': {
      'en': 'Location: Nairobi & surrounding areas',
      'fr': '',
      'sw': '',
    },
    'cq46z495': {
      'en': 'Proceed to Consultation',
      'fr': '',
      'sw': '',
    },
    'r8cnfe01': {
      'en': 'Secure booking · No hidden fees',
      'fr': '',
      'sw': '',
    },
    '93mc423x': {
      'en': 'Madam Mercy Kitomari',
      'fr': '',
      'sw': '',
    },
    '5p0agob1': {
      'en': 'Food Business Strategist & Pricing Expert',
      'fr': '',
      'sw': '',
    },
    'wigt7nbs': {
      'en': '50+ kitchens transformed',
      'fr': '',
      'sw': '',
    },
    'n336cqon': {
      'en': 'The Profitable Kitchen',
      'fr': '',
      'sw': '',
    },
    '3p1xx5hp': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
  },
  // PasswordReset
  {
    'jfz4tpoh': {
      'en': 'Reset Password Successful',
      'fr': 'Réinitialisation du mot de passe réussie',
      'sw': 'Urekebishaji wa Nenosiri Umefanikiwa',
    },
    'nxz3c85x': {
      'en': 'Please wait...\nRedirecting you to the homepage.',
      'fr': 'Veuillez patienter... Redirection vers la page d\'accueil.',
      'sw': 'Tafadhali subiri...\nInakuelekeza kwenye ukurasa wa nyumbani.',
    },
  },
  // SigninSuccessful
  {
    'woyia5be': {
      'en': 'Sign in Successful!',
      'fr': 'Connexion réussie !',
      'sw': 'Ingia Umefanikiwa!',
    },
    'ndbykalb': {
      'en': 'Please wait...\nRedirecting you to the homepage.',
      'fr': 'Veuillez patienter... Redirection vers la page d\'accueil.',
      'sw': 'Tafadhali subiri...\nInakuelekeza kwenye ukurasa wa nyumbani.',
    },
  },
  // SignUpSuccessful
  {
    'dz2hv2dd': {
      'en': 'You\'re All Set!',
      'fr': 'Tout est prêt !',
      'sw': 'Uko Tayari!',
    },
    'ufcyk3fh': {
      'en':
          'Your profile is complete. Start learning, sharing, and growing today!',
      'fr':
          'Votre profil est complet. Commencez dès aujourd\'hui à apprendre, à partager et à progresser !',
      'sw': 'Wasifu wako umekamilika. Anza kujifunza, kushiriki, na kukua leo!',
    },
  },
  // InterestsSuccessful
  {
    'uud00ck6': {
      'en': 'Thanks for sharing',
      'fr': 'Merci pour le partage',
      'sw': 'Asante kwa kushiriki',
    },
    'fg1hsdh4': {
      'en': 'We are personalizing your experience!',
      'fr': 'Nous personnalisons votre expérience !',
      'sw': 'Tunabinafsisha uzoefu wako!',
    },
  },
  // FAQ
  {
    'iot4k62r': {
      'en': '',
      'fr': '',
      'sw': '',
    },
  },
  // DeleteAccount
  {
    'y1ifi92t': {
      'en': 'Delete Your Account?',
      'fr': 'Supprimer votre compte ?',
      'sw': 'Futa Akaunti Yako?',
    },
    'apvn2jqh': {
      'en':
          'This action is permanent and will erase all your data. Are you sure you want to continue?',
      'fr':
          'Cette action est définitive et effacera toutes vos données. Êtes-vous sûr de vouloir continuer ?',
      'sw':
          'Kitendo hiki ni cha kudumu na kitafuta data yako yote. Una uhakika unataka kuendelea?',
    },
    'u48ydd0h': {
      'en': 'Cancel',
      'fr': 'Annuler',
      'sw': 'Ghairi',
    },
    '4q1exj0r': {
      'en': 'Delete',
      'fr': 'Supprimer',
      'sw': 'Futa',
    },
  },
  // NavBar
  {
    '1kf1kfmr': {
      'en': 'Home',
      'fr': 'Maison',
      'sw': 'Nyumbani',
    },
    'mju23fje': {
      'en': 'Explore',
      'fr': 'Explorer',
      'sw': 'Gundua',
    },
    '21mb8hg1': {
      'en': 'Courses',
      'fr': 'Cours',
      'sw': 'Kozi',
    },
    '2exbi9p1': {
      'en': 'Learn',
      'fr': 'Apprendre',
      'sw': 'Jifunze',
    },
    '32xxuwdc': {
      'en': 'Profile',
      'fr': 'Profil',
      'sw': 'Wasifu',
    },
  },
  // SignOut
  {
    'qd6x93vu': {
      'en': 'Sign Out?',
      'fr': 'Se déconnecter?',
      'sw': 'Toka?',
    },
    'gvhbtm7i': {
      'en':
          'Are you sure you want to sign out? You can always log back in anytime.',
      'fr':
          'Êtes-vous sûr de vouloir vous déconnecter ? Vous pouvez vous reconnecter à tout moment.',
      'sw': 'Una uhakika unataka kutoka? Unaweza kuingia tena wakati wowote.',
    },
    'racq8oap': {
      'en': 'Cancel',
      'fr': 'Annuler',
      'sw': 'Ghairi',
    },
    'ypqvjq5g': {
      'en': 'Sign Out',
      'fr': 'Se déconnecter',
      'sw': 'Toka',
    },
  },
  // Filter
  {
    'q9kqx46k': {
      'en': 'Rating',
      'fr': 'Notation',
      'sw': 'Ukadiriaji',
    },
    'wt7la5v6': {
      'en': '4.5+',
      'fr': '4,5+',
      'sw': '4.5+',
    },
    'w6ivq8s5': {
      'en': '4.0+',
      'fr': '4.0+',
      'sw': '4.0+',
    },
    '9lks2vdx': {
      'en': '3.5+',
      'fr': '3,5+',
      'sw': '3.5+',
    },
    '0rxxrhf4': {
      'en': 'Course Duration',
      'fr': 'Durée du cours',
      'sw': 'Muda wa Kozi',
    },
    'u16aa7gp': {
      'en': 'Less than 1 hour',
      'fr': 'Moins d\'une heure',
      'sw': 'Chini ya saa 1',
    },
    'cpgkvyem': {
      'en': '1–3 hours',
      'fr': '1 à 3 heures',
      'sw': 'Saa 1–3',
    },
    'yae4exfx': {
      'en': '3–10 hours',
      'fr': '3 à 10 heures',
      'sw': 'Saa 3–10',
    },
    '5n56512v': {
      'en': '10+ hours',
      'fr': 'Plus de 10 heures',
      'sw': 'Saa 10+',
    },
    'bmq2vqyh': {
      'en': 'Price',
      'fr': 'Prix',
      'sw': 'Bei',
    },
    'ytfw5n1r': {
      'en': 'Skill Level',
      'fr': 'Niveau de compétence',
      'sw': 'Kiwango cha Ustadi',
    },
    '1n4oozr1': {
      'en': 'Beginner',
      'fr': 'Débutant',
      'sw': 'Mwanzilishi',
    },
    'ho135q50': {
      'en': 'Intermediate',
      'fr': 'Intermédiaire',
      'sw': 'Kati',
    },
    's7n7rf6q': {
      'en': 'Advanced',
      'fr': 'Avancé',
      'sw': 'Kina',
    },
    'qewntrqw': {
      'en': 'Date Added',
      'fr': 'Date d\'ajout',
      'sw': 'Tarehe Iliyoongezwa',
    },
    '2tbtfkow': {
      'en': 'New (this week)',
      'fr': 'Nouveautés (cette semaine)',
      'sw': 'Mpya (wiki hii)',
    },
    'qpohanzm': {
      'en': 'This month',
      'fr': 'Ce mois-ci',
      'sw': 'Mwezi huu',
    },
    '3lgnz32f': {
      'en': 'Last year',
      'fr': 'L\'année dernière',
      'sw': 'Mwaka jana',
    },
    '2lo124vi': {
      'en': 'Skip',
      'fr': 'Sauter',
      'sw': 'Ruka',
    },
    'zxkffj13': {
      'en': 'Apply',
      'fr': 'Appliquer',
      'sw': 'Tuma maombi',
    },
  },
  // LessonsCard
  {
    '6p29jswc': {
      'en': 'Free',
      'fr': 'Gratuit',
      'sw': 'Bure',
    },
    'pgog3j6f': {
      'en': 'Video duration: ',
      'fr': 'Durée de la vidéo :',
      'sw': 'Muda wa video:',
    },
    'fvf8h9wo': {
      'en': 'Video duration: 06:45',
      'fr': 'Durée de la vidéo : 06:45',
      'sw': 'Muda wa video: 06:45',
    },
  },
  // Review
  {
    'wx1jv0tr': {
      'en': ' ',
      'fr': '',
      'sw': '',
    },
  },
  // Report
  {
    '3axlrydl': {
      'en': 'Report an Issue',
      'fr': 'Signaler un problème',
      'sw': 'Ripoti Tatizo',
    },
    'qf277srk': {
      'en':
          'Encountering a problem? Let us know, and we\'ll work to fix it as soon as possible.',
      'fr':
          'Vous rencontrez un problème ? Faites-le nous savoir et nous nous efforcerons de le résoudre au plus vite.',
      'sw':
          'Una tatizo? Tujulishe, nasi tutajitahidi kulitatua haraka iwezekanavyo.',
    },
  },
  // ReportComment
  {
    'jvcg8w9x': {
      'en': 'Please describe the issue in detail',
      'fr': 'Veuillez décrire le problème en détail',
      'sw': 'Tafadhali eleza tatizo kwa undani',
    },
    'ybalvcz0': {
      'en': 'Continue',
      'fr': 'Continuer',
      'sw': 'Endelea',
    },
  },
  // Reminder
  {
    'ku7gojbl': {
      'en': 'Reminder',
      'fr': 'Rappel',
      'sw': 'Kikumbusho',
    },
    '6pfl9ly7': {
      'en': 'Active',
      'fr': 'Actif',
      'sw': 'Inayotumika',
    },
    'a2c4qksu': {
      'en': 'Title',
      'fr': 'Titre',
      'sw': 'Kichwa',
    },
    'tpfjr66k': {
      'en': ':',
      'fr': ':',
      'sw': ':',
    },
    '9svi7kqw': {
      'en': 'Title',
      'fr': 'Titre',
      'sw': 'Kichwa',
    },
    'nj7p6959': {
      'en': 'Save',
      'fr': 'Sauvegarder',
      'sw': 'Hifadhi',
    },
  },
  // PaymentMethodsCard
  {
    'jfk3xk8f': {
      'en': 'Connected',
      'fr': 'Connecté',
      'sw': 'Imeunganishwa',
    },
  },
  // DeletePayment
  {
    '4apqdysu': {
      'en': 'Delete Your Account?',
      'fr': 'Supprimer votre compte ?',
      'sw': 'Futa Akaunti Yako?',
    },
    'k6l0ruxt': {
      'en':
          'This action is permanent and will erase all your data. Are you sure you want to continue?',
      'fr':
          'Cette action est définitive et effacera toutes vos données. Êtes-vous sûr de vouloir continuer ?',
      'sw':
          'Kitendo hiki ni cha kudumu na kitafuta data yako yote. Una uhakika unataka kuendelea?',
    },
    'o1r0rahz': {
      'en': 'Cancel',
      'fr': 'Annuler',
      'sw': 'Ghairi',
    },
    'q0jqdrj1': {
      'en': 'Delete',
      'fr': 'Supprimer',
      'sw': 'Futa',
    },
  },
  // AddPaymentMethod
  {
    '2u2v84dv': {
      'en': 'Add new payment method',
      'fr': 'Ajouter un nouveau mode de paiement',
      'sw': 'Ongeza njia mpya ya malipo',
    },
    '9w1fl7ro': {
      'en':
          'Securely add a new payment method to make purchases and receive payouts with ease.',
      'fr':
          'Ajoutez en toute sécurité un nouveau mode de paiement pour effectuer des achats et recevoir des paiements en toute simplicité.',
      'sw':
          'Ongeza njia mpya ya malipo kwa usalama ili kufanya manunuzi na kupokea malipo kwa urahisi.',
    },
    't1w7mc78': {
      'en': 'Add Credit Card',
      'fr': 'Ajouter une carte de crédit',
      'sw': 'Ongeza Kadi ya Mkopo',
    },
    '6w3p10d9': {
      'en': 'Mobile Money',
      'fr': 'Argent mobile',
      'sw': 'Pesa za Simu',
    },
    'h1u44m5g': {
      'en': 'PayPal',
      'fr': 'PayPal',
      'sw': 'PayPal',
    },
    '3rlo0ra5': {
      'en': 'Google Pay',
      'fr': 'Google Pay',
      'sw': 'Google Pay',
    },
    '4gdwrpfg': {
      'en': 'Apple Pay',
      'fr': 'Apple Pay',
      'sw': 'Apple Pay',
    },
  },
  // SubscriptionsCard
  {
    'l1cbp1mc': {
      'en': 'Visit',
      'fr': 'Visite',
      'sw': 'Tembelea',
    },
  },
  // PendingReview
  {
    'y3tteohn': {
      'en': 'Write review',
      'fr': 'Rédiger un avis',
      'sw': 'Andika ukaguzi',
    },
  },
  // ApplicationSubmitted
  {
    'seufvsny': {
      'en': 'Application Submitted!',
      'fr': 'Demande soumise !',
      'sw': 'Maombi Yamewasilishwa!',
    },
    'ivyl5nbh': {
      'en':
          'Your application to become an instructor has been successfully submitted. Our team will review it and get back to you soon.',
      'fr':
          'Votre candidature pour devenir instructeur a bien été soumise. Notre équipe l\'examinera et vous recontactera prochainement.',
      'sw':
          'Ombi lako la kuwa mwalimu limewasilishwa kwa mafanikio. Timu yetu italikagua na kukujibu hivi karibuni.',
    },
    'xeteppci': {
      'en': 'OK',
      'fr': 'D\'ACCORD',
      'sw': 'Sawa',
    },
  },
  // AccountRole
  {
    'pe676xeq': {
      'en': 'Switch Account Role',
      'fr': 'Changer de rôle de compte',
      'sw': 'Badilisha Jukumu la Akaunti',
    },
    'aeijf5jd': {
      'en':
          'Easily switch between your Instructor and Student views to manage courses or continue learning without logging out.',
      'fr':
          'Passez facilement du mode enseignant au mode étudiant pour gérer vos cours ou poursuivre votre apprentissage sans vous déconnecter.',
      'sw':
          'Badili kwa urahisi kati ya mitazamo ya Mwalimu wako na Mwanafunzi ili kudhibiti kozi au kuendelea kujifunza bila kuingia.',
    },
    'fd5plwjt': {
      'en': 'Learner',
      'fr': 'Apprenant',
      'sw': 'Mwanafunzi',
    },
    'g7xypdzh': {
      'en': 'Instructor',
      'fr': 'Instructeur',
      'sw': 'Mwalimu',
    },
  },
  // Category
  {
    'ets77p9y': {
      'en': 'Category',
      'fr': 'Catégorie',
      'sw': 'Kategoria',
    },
    'qa3hw65l': {
      'en': 'Search',
      'fr': 'Recherche',
      'sw': 'Tafuta',
    },
    '35uxv7qw': {
      'en': 'Custom Categories',
      'fr': 'Catégories personnalisées',
      'sw': 'Aina Maalum',
    },
    'ne1lrmwr': {
      'en': 'Main Categories',
      'fr': 'Catégories principales',
      'sw': 'Aina Kuu',
    },
    '00y3b8of': {
      'en': 'Done',
      'fr': 'Fait',
      'sw': 'Imekamilika',
    },
  },
  // AddNewCategory
  {
    'vj1vqqdc': {
      'en': 'Add New Category',
      'fr': 'Ajouter une nouvelle catégorie',
      'sw': 'Ongeza Kategoria Mpya',
    },
    '6wbfqkdw': {
      'en': 'Category Name',
      'fr': 'Nom de la catégorie',
      'sw': 'Jina la Kategoria',
    },
    'juf8w023': {
      'en': 'Category Name',
      'fr': 'Nom de la catégorie',
      'sw': 'Jina la Kategoria',
    },
    'yq0qwue5': {
      'en': 'Change Image',
      'fr': 'Changer l\'image',
      'sw': 'Badilisha Picha',
    },
    '3f83x3i0': {
      'en': 'Done',
      'fr': 'Fait',
      'sw': 'Imekamilika',
    },
  },
  // Tags
  {
    '2y517w2r': {
      'en': 'Tags',
      'fr': 'Étiquettes',
      'sw': 'Lebo',
    },
    '1978jtl1': {
      'en': 'Search',
      'fr': 'Recherche',
      'sw': 'Tafuta',
    },
    't5ccz4rl': {
      'en': 'Custom Tags',
      'fr': 'Étiquettes personnalisées',
      'sw': 'Lebo Maalum',
    },
    'wn5do6yl': {
      'en': 'Main Tags',
      'fr': 'Mots-clés principaux',
      'sw': 'Lebo Kuu',
    },
    'z094gi1n': {
      'en': 'Done',
      'fr': 'Fait',
      'sw': 'Imekamilika',
    },
  },
  // AddNewTag
  {
    'fs444a8c': {
      'en': 'Add New Tag',
      'fr': 'Ajouter une nouvelle balise',
      'sw': 'Ongeza Lebo Mpya',
    },
    '3jlpbrpa': {
      'en': 'New Tag',
      'fr': 'Nouvelle étiquette',
      'sw': 'Lebo Mpya',
    },
    'wv84fxxh': {
      'en': 'New Tag',
      'fr': 'Nouvelle étiquette',
      'sw': 'Lebo Mpya',
    },
    '6xqco549': {
      'en': 'Done',
      'fr': 'Fait',
      'sw': 'Imekamilika',
    },
  },
  // Audience
  {
    'lz8wunrj': {
      'en': 'Audience',
      'fr': 'Public',
      'sw': 'Hadhira',
    },
    'fdrei1lk': {
      'en': 'Search',
      'fr': 'Recherche',
      'sw': 'Tafuta',
    },
    '3au86uoz': {
      'en': 'Course Audience',
      'fr': 'Public cible du cours',
      'sw': 'Hadhira ya Kozi',
    },
    '9jzo7a6u': {
      'en': 'Done',
      'fr': 'Fait',
      'sw': 'Imekamilika',
    },
  },
  // Language1
  {
    'zvy7386n': {
      'en': 'Language',
      'fr': 'Langue',
      'sw': 'Lugha',
    },
    'xfx4umsv': {
      'en': 'Search',
      'fr': 'Recherche',
      'sw': 'Tafuta',
    },
    '7zbfoyxy': {
      'en': 'Done',
      'fr': 'Fait',
      'sw': 'Imekamilika',
    },
  },
  // InstructorSpecialty
  {
    '8beesnoy': {
      'en': 'Specialty',
      'fr': 'Spécialité',
      'sw': 'Utaalamu',
    },
    'vrkjnkq5': {
      'en': 'Search',
      'fr': 'Recherche',
      'sw': 'Tafuta',
    },
    '2we9k1l2': {
      'en': 'Done',
      'fr': 'Fait',
      'sw': 'Imekamilika',
    },
  },
  // Specialty
  {
    'e0j9gvjg': {
      'en': 'Specialty',
      'fr': 'Spécialité',
      'sw': 'Utaalamu',
    },
    'zjkh91t4': {
      'en': 'Search',
      'fr': 'Recherche',
      'sw': 'Tafuta',
    },
    '79nu86n7': {
      'en': 'Done',
      'fr': 'Fait',
      'sw': 'Imekamilika',
    },
  },
  // EmptyCourses
  {
    'i7yxawzt': {
      'en': 'You Haven’t Created Any Courses Yet',
      'fr': 'Vous n\'avez pas encore créé de cours',
      'sw': 'Bado Hujaunda Kozi Zozote',
    },
    '4eegc30h': {
      'en':
          'Share your knowledge with the world. Start by creating your first course and inspire learners everywhere.',
      'fr':
          'Partagez votre savoir avec le monde entier. Commencez par créer votre premier cours et inspirez les apprenants du monde entier.',
      'sw':
          'Shiriki maarifa yako na ulimwengu. Anza kwa kuunda kozi yako ya kwanza na uwape motisha wanafunzi kila mahali.',
    },
    'w0pzvzyw': {
      'en': 'Create Course',
      'fr': 'Créer un cours',
      'sw': 'Unda Kozi',
    },
  },
  // AddaNewLesson
  {
    'p4zejwhp': {
      'en': 'Add lessons from here',
      'fr': 'Ajoutez des leçons à partir d\'ici',
      'sw': 'Ongeza masomo kutoka hapa',
    },
    '3yqrjxl4': {
      'en': 'Create and add new lessons to your course.',
      'fr': 'Créez et ajoutez de nouvelles leçons à votre cours.',
      'sw': 'Unda na ongeza masomo mapya kwenye kozi yako.',
    },
    'ymb0n85s': {
      'en': 'OK',
      'fr': 'D\'ACCORD',
      'sw': 'Sawa',
    },
  },
  // DeleteCourses
  {
    '9bpg1pym': {
      'en': 'Delete course?',
      'fr': 'Supprimer le cours ?',
      'sw': 'Futa kozi?',
    },
    'afj4rrhf': {
      'en':
          'Once deleted, this course and its lessons will be permanently removed.',
      'fr':
          'Une fois supprimé, ce cours et ses leçons seront définitivement effacés.',
      'sw':
          'Mara tu baada ya kufutwa, kozi hii na masomo yake yataondolewa kabisa.',
    },
    'qw04ize0': {
      'en': 'Cancel',
      'fr': 'Annuler',
      'sw': 'Ghairi',
    },
    'egt80br1': {
      'en': 'Delete',
      'fr': 'Supprimer',
      'sw': 'Futa',
    },
  },
  // AddaNewCourse
  {
    '6k2da0w3': {
      'en': 'Add a New Course',
      'fr': 'Ajouter un nouveau cours',
      'sw': 'Ongeza Kozi Mpya',
    },
    '3qio9jur': {
      'en': 'Create a course to share your knowledge and engage with learners.',
      'fr':
          'Créez un cours pour partager vos connaissances et interagir avec les apprenants.',
      'sw': 'Unda kozi ya kushiriki maarifa yako na kuwashirikisha wanafunzi.',
    },
    'm98sa4my': {
      'en': 'OK',
      'fr': 'D\'ACCORD',
      'sw': 'Sawa',
    },
  },
  // EmptySalesReports
  {
    'v005ut4g': {
      'en': 'No Sales Reports Yet',
      'fr': 'Aucun rapport de vente pour le moment',
      'sw': 'Hakuna Ripoti za Mauzo Bado',
    },
    'je85qppp': {
      'en':
          'Sales reports will appear here as you start generating them. Track performance, insights, and more — all in one place.',
      'fr':
          'Les rapports de vente s\'afficheront ici au fur et à mesure de leur génération. Suivez les performances, les analyses et bien plus encore, le tout au même endroit.',
      'sw':
          'Ripoti za mauzo zitaonekana hapa unapoanza kuzizalisha. Fuatilia utendaji, maarifa, na zaidi — yote katika sehemu moja.',
    },
  },
  // EmptyPayment
  {
    'iofkdvm2': {
      'en': 'No Payment Methods',
      'fr': 'Aucun mode de paiement',
      'sw': 'Hakuna Njia za Malipo',
    },
    '0znll3z9': {
      'en':
          'You haven’t added any payment methods yet. Add one to start purchasing courses easily and securely.',
      'fr':
          'Vous n\'avez pas encore ajouté de mode de paiement. Ajoutez-en un pour commencer à acheter des cours facilement et en toute sécurité.',
      'sw':
          'Bado hujaongeza njia zozote za malipo. Ongeza moja ili kuanza kununua kozi kwa urahisi na kwa usalama.',
    },
  },
  // LearnLessonsCard
  {
    'r1277lln': {
      'en': 'Video duration: ',
      'fr': 'Durée de la vidéo :',
      'sw': 'Muda wa video:',
    },
    '9gay00cq': {
      'en': 'Video duration: 06:45',
      'fr': 'Durée de la vidéo : 06:45',
      'sw': 'Muda wa video: 06:45',
    },
  },
  // DeleteLearnCourses
  {
    'pk7x6kpj': {
      'en': 'Delete This Course?',
      'fr': 'Supprimer ce cours ?',
      'sw': 'Ungependa kufuta Kozi Hii?',
    },
    '5pwpv7dr': {
      'en':
          'This action will remove your access to the course. Are you sure you want to continue?',
      'fr':
          'Cette action vous supprimera l\'accès au cours. Êtes-vous sûr de vouloir continuer ?',
      'sw':
          'Kitendo hiki kitaondoa ufikiaji wako kwenye kozi. Una uhakika unataka kuendelea?',
    },
    '2t1bg2kf': {
      'en': 'Cancel',
      'fr': 'Annuler',
      'sw': 'Ghairi',
    },
    'd4ym904l': {
      'en': 'Delete',
      'fr': 'Supprimer',
      'sw': 'Futa',
    },
  },
  // Courses2
  {
    '6e3psnmw': {
      'en': 'Course Created Successfully',
      'fr': 'Cours créé avec succès',
      'sw': 'Kozi Imeundwa kwa Mafanikio',
    },
    '1xws0jai': {
      'en':
          'Your course has been published. Start adding lessons to bring your content to life and inspire learners.',
      'fr':
          'Votre cours a été publié. Commencez à ajouter des leçons pour donner vie à votre contenu et inspirer les apprenants.',
      'sw':
          'Kozi yako imechapishwa. Anza kuongeza masomo ili kuyafanya maudhui yako yawe hai na kuwatia moyo wanafunzi.',
    },
    'ppr2m7e5': {
      'en': 'OK',
      'fr': 'D\'ACCORD',
      'sw': 'Sawa',
    },
  },
  // OrderSuccessfully
  {
    'uv5fwexp': {
      'en': 'Purchase Successful!',
      'fr': 'Achat réussi !',
      'sw': 'Ununuzi Umefanikiwa!',
    },
    'gyybi4z4': {
      'en':
          'You\'ve successfully enrolled in the course. Get ready to start learning and growing your skills!',
      'fr':
          'Vous êtes inscrit(e) avec succès à ce cours. Préparez-vous à apprendre et à développer vos compétences !',
      'sw':
          'Umejiandikisha kwa mafanikio katika kozi hiyo. Jitayarishe kuanza kujifunza na kukuza ujuzi wako!',
    },
    'mo96svyb': {
      'en': 'OK',
      'fr': 'D\'ACCORD',
      'sw': 'Sawa',
    },
  },
  // EmptyNotifications
  {
    'gos71rr8': {
      'en': 'No Notifications Yet',
      'fr': 'Aucune notification pour le moment',
      'sw': 'Hakuna Arifa Bado',
    },
    'd6l3x9wa': {
      'en':
          'You\'re all caught up! Stay tuned for updates, offers, and important alerts.',
      'fr':
          'Vous êtes à jour ! Restez à l\'écoute pour les mises à jour, les offres et les alertes importantes.',
      'sw':
          'Nyote mmefahamu! Endelea kufuatilia masasisho, ofa, na arifa muhimu.',
    },
  },
  // EmptyLearn
  {
    '0cqz4ssp': {
      'en': 'No Courses Yet',
      'fr': 'Aucun cours pour le moment',
      'sw': 'Hakuna Kozi Bado',
    },
    'v7tbv57x': {
      'en':
          'Start learning by enrolling in your first course. Your purchased courses will appear here.',
      'fr':
          'Commencez votre apprentissage en vous inscrivant à votre premier cours. Vos cours achetés apparaîtront ici.',
      'sw':
          'Anza kujifunza kwa kujiandikisha katika kozi yako ya kwanza. Kozi ulizonunua zitaonekana hapa.',
    },
  },
  // PaymentSetup1
  {
    'gsc41bjx': {
      'en': 'Payment Method Added',
      'fr': 'Mode de paiement ajouté',
      'sw': 'Njia ya Malipo Imeongezwa',
    },
    'ketx3cg5': {
      'en':
          'Your payment method has been successfully set up. You\'re now ready to make purchases and access premium content with ease!',
      'fr':
          'Votre mode de paiement a été configuré avec succès. Vous pouvez désormais effectuer des achats et accéder au contenu premium en toute simplicité !',
      'sw':
          'Njia yako ya kulipa imewekwa kwa ufanisi. Sasa uko tayari kufanya manunuzi na kufikia maudhui ya malipo kwa urahisi!',
    },
    '1xq76zkk': {
      'en': 'OK',
      'fr': 'D\'ACCORD',
      'sw': 'Sawa',
    },
  },
  // EmptyPaymentAccount
  {
    'vhdnmlw8': {
      'en': 'No Payment Account',
      'fr': 'Aucun compte de paiement',
      'sw': 'Hakuna Akaunti ya Malipo',
    },
    'r8ksfrmw': {
      'en': 'Set up your payment account to receive earnings.',
      'fr': 'Configurez votre compte de paiement pour recevoir vos gains.',
      'sw': 'Sanidi akaunti yako ya malipo ili upokee mapato.',
    },
    'batx75iv': {
      'en': 'Create Account',
      'fr': 'Créer un compte',
      'sw': 'Fungua Akaunti',
    },
  },
  // EmptyLessons
  {
    'rscxyg5h': {
      'en': 'Add Your First Lesson',
      'fr': 'Ajoutez votre première leçon',
      'sw': 'Ongeza Somo Lako la Kwanza',
    },
  },
  // EmptyWishList
  {
    'yw8dgo5u': {
      'en': 'Your Wish List is Empty',
      'fr': 'Votre liste de souhaits est vide.',
      'sw': 'Orodha Yako ya Matamanio Haina Kitu',
    },
    '1233oxy3': {
      'en':
          'Start exploring and add courses you love to keep them close for later.',
      'fr':
          'Commencez à explorer et ajoutez les cours que vous aimez pour les retrouver facilement plus tard.',
      'sw':
          'Anza kuchunguza na ongeza kozi unazopenda ili kuziweka karibu kwa ajili ya baadaye.',
    },
    'mp49bom2': {
      'en': 'Discover Courses',
      'fr': 'Découvrez les cours',
      'sw': 'Kozi za Gundua',
    },
  },
  // EmptySubscriptions
  {
    'crieqtgp': {
      'en': 'No Subscriptions Yet',
      'fr': 'Aucun abonnement pour le moment',
      'sw': 'Hakuna Usajili Bado',
    },
    'nvmf8oq2': {
      'en':
          'You haven\'t subscribed to any courses yet. Browse our collection and start learning today!',
      'fr':
          'Vous n\'êtes inscrit à aucun cours. Parcourez notre catalogue et commencez à apprendre dès aujourd\'hui !',
      'sw':
          'Bado hujajisajili kwa kozi zozote. Vinjari mkusanyiko wetu na uanze kujifunza leo!',
    },
  },
  // Country
  {
    '6ozirmv6': {
      'en': 'Country',
      'fr': 'Pays',
      'sw': 'Nchi',
    },
    '8z1ub7vz': {
      'en': 'Search',
      'fr': 'Recherche',
      'sw': 'Tafuta',
    },
    '3h6zrdg0': {
      'en': 'Done',
      'fr': 'Fait',
      'sw': 'Imekamilika',
    },
  },
  // Topics
  {
    'eqt7g346': {
      'en': 'Nelway\'s Academy',
      'fr': 'Académie Nelway',
      'sw': 'Chuo cha Nelway',
    },
    'mn3uab7w': {
      'en': 'Nelway\'s Academy',
      'fr': 'Académie Nelway',
      'sw': 'Chuo cha Nelway',
    },
  },
  // EmptyPurchaseHistory
  {
    'yxtinhs8': {
      'en': 'No Purchases Yet',
      'fr': 'Aucun achat pour le moment',
      'sw': 'Hakuna Ununuzi Bado',
    },
    '1gz02mdz': {
      'en':
          'Your purchase history is currently empty. Once you buy a course, it will appear here for your reference.',
      'fr':
          'Votre historique d\'achats est actuellement vide. Une fois que vous aurez acheté un cours, il apparaîtra ici pour votre consultation.',
      'sw':
          'Historia yako ya ununuzi kwa sasa haina kitu. Ukishanunua kozi, itaonekana hapa kwa marejeleo yako.',
    },
  },
  // EmptyFollowers
  {
    '8wavfre1': {
      'en': 'No Followers Yet',
      'fr': 'Aucun abonné pour le moment',
      'sw': 'Hakuna Wafuasi Bado',
    },
    '86qa9hql': {
      'en':
          'Looks like no one is following this profile yet. Share valuable content to attract your first followers!',
      'fr':
          'Il semblerait que personne ne suive ce profil pour le moment. Partagez du contenu de qualité pour attirer vos premiers abonnés !',
      'sw':
          'Inaonekana hakuna mtu anayefuata wasifu huu bado. Shiriki maudhui muhimu ili kuvutia wafuasi wako wa kwanza!',
    },
  },
  // LoadingPaymentAccount
  {
    'svzq3gin': {
      'en': 'See All',
      'fr': 'Voir tout',
      'sw': 'Tazama Zote',
    },
  },
  // LoadingUser
  {
    'pqdylm32': {
      'en': 'Follow',
      'fr': 'Suivre',
      'sw': 'Fuata',
    },
  },
  // CategoryCopy
  {
    'qujmjrec': {
      'en': 'Category',
      'fr': 'Catégorie',
      'sw': 'Kategoria',
    },
    '0jipewdh': {
      'en': 'Search',
      'fr': 'Recherche',
      'sw': 'Tafuta',
    },
    'zj5nrvz8': {
      'en': 'Custom Categories',
      'fr': 'Catégories personnalisées',
      'sw': 'Aina Maalum',
    },
    '5ea1e4pm': {
      'en': 'Main Categories',
      'fr': 'Catégories principales',
      'sw': 'Aina Kuu',
    },
    'xm0hc0xt': {
      'en': 'Done',
      'fr': 'Fait',
      'sw': 'Imekamilika',
    },
  },
  // Appointment
  {
    'rdm1h4r1': {
      'en': 'Appointment  Created Successfully',
      'fr': 'Rendez-vous créé avec succès',
      'sw': 'Miadi Imeundwa kwa Ufanisi',
    },
    'vuop1o5l': {
      'en': 'Your appointment  has been created.  Please be on time',
      'fr': 'Votre rendez-vous a été créé. Veuillez être à l\'heure.',
      'sw': 'Miadi yako imeandaliwa. Tafadhali fika kwa wakati',
    },
    '7gbi2gdp': {
      'en': 'OK',
      'fr': 'D\'ACCORD',
      'sw': 'Sawa',
    },
  },
  // addpaymentMethod
  {
    'avmjied7': {
      'en': 'Add Payment Method',
      'fr': 'Ajouter un mode de paiement',
      'sw': 'Ongeza Njia ya Malipo',
    },
    'ra5ffno7': {
      'en': 'Select below the payment method Prefered',
      'fr': 'Veuillez sélectionner ci-dessous votre mode de paiement préféré.',
      'sw': 'Chagua hapa chini njia ya malipo Inayopendelewa',
    },
    'x3wyeo2f': {
      'en': 'OK',
      'fr': 'D\'ACCORD',
      'sw': 'Sawa',
    },
  },
  // optionComponent
  {
    'mfh4vkem': {
      'en': 'Build Your Ice Cream Business with Clarity',
      'fr': '',
      'sw': '',
    },
    '4uqiyqia': {
      'en': 'Learn the process, understand your margins, start making money.',
      'fr': '',
      'sw': '',
    },
    'aiqfher9': {
      'en': 'Start Learning',
      'fr': '',
      'sw': '',
    },
    'j1g9mzg7': {
      'en': 'Get Equipment',
      'fr': '',
      'sw': '',
    },
    'lps5c4zj': {
      'en': 'Work With Nelwa',
      'fr': '',
      'sw': '',
    },
  },
  // selection
  {
    '3whii6li': {
      'en': 'Business Intensive',
      'fr': '',
      'sw': '',
    },
    'u2tjzndu': {
      'en': 'The Profitable Kitchen',
      'fr': '',
      'sw': '',
    },
    '42uzt2hr': {
      'en': 'A Business Intensive with Madam Mercy Kitomari',
      'fr': '',
      'sw': '',
    },
    'b4581j3m': {
      'en': '3 sessions. Custom workbook. Pricing formula you keep forever.',
      'fr': '',
      'sw': '',
    },
    'ooc7wui3': {
      'en': '3',
      'fr': '',
      'sw': '',
    },
    'nehqtsya': {
      'en': 'Sessions',
      'fr': '',
      'sw': '',
    },
    'hzig0cft': {
      'en': '1:1',
      'fr': '',
      'sw': '',
    },
    'eeq2ln2d': {
      'en': 'Coaching',
      'fr': '',
      'sw': '',
    },
    '588ikrg9': {
      'en': '∞',
      'fr': '',
      'sw': '',
    },
    '8olhlwqd': {
      'en': 'Formula Yours',
      'fr': '',
      'sw': '',
    },
    'wngsfe9j': {
      'en': 'How It Works',
      'fr': '',
      'sw': '',
    },
    '6lm3nkd3': {
      'en': 'Three Sessions. One Transformation',
      'fr': '',
      'sw': '',
    },
    'wlijytas': {
      'en': '01',
      'fr': '',
      'sw': '',
    },
    '595zluvt': {
      'en': 'Discovery Session',
      'fr': '',
      'sw': '',
    },
    '063whw2r': {
      'en':
          'We map your current pricing, costs, and business goals. Identify gaps and opportunities unique to your kitchen.',
      'fr': '',
      'sw': '',
    },
    '95iinkvc': {
      'en': 'Session 1',
      'fr': '',
      'sw': '',
    },
    'occsft1h': {
      'en': '02',
      'fr': '',
      'sw': '',
    },
    'icn4q9af': {
      'en': 'Working Through',
      'fr': '',
      'sw': '',
    },
    '3z84qma1': {
      'en':
          'Build your custom workbook together. Craft your signature pricing formula tailored to your menu and market.',
      'fr': '',
      'sw': '',
    },
    'qjhej1x7': {
      'en': 'Session 2',
      'fr': '',
      'sw': '',
    },
    't2sfwgvq': {
      'en': '03',
      'fr': '',
      'sw': '',
    },
    'rxkq4edy': {
      'en': 'Assignment & Closing',
      'fr': '',
      'sw': '',
    },
    '6tam8tit': {
      'en':
          'Review your completed formula, finalize your workbook, and leave with a clear action plan to implement immediately.',
      'fr': '',
      'sw': '',
    },
    'v1xg6qs9': {
      'en': 'Session 3',
      'fr': '',
      'sw': '',
    },
    'uduynok3': {
      'en': 'Choose Your Plan',
      'fr': '',
      'sw': '',
    },
    'bxbsxuyz': {
      'en': 'Select what works for you',
      'fr': '',
      'sw': '',
    },
    'cjcuuyca': {
      'en': 'Virtual Plan',
      'fr': '',
      'sw': '',
    },
    'do7ayw7n': {
      'en': '\$250',
      'fr': '',
      'sw': '',
    },
    'vqc8ukm0': {
      'en': 'per intensive',
      'fr': '',
      'sw': '',
    },
    'mocsjawg': {
      'en': '3 virtual coaching sessions',
      'fr': '',
      'sw': '',
    },
    'vu0cr069': {
      'en': 'Custom business workbook',
      'fr': '',
      'sw': '',
    },
    'brje4ns9': {
      'en': 'Signature pricing formula (yours forever)',
      'fr': '',
      'sw': '',
    },
    '5992g3ua': {
      'en': 'Video call via Zoom or Google Meet',
      'fr': '',
      'sw': '',
    },
    'ictimk6e': {
      'en': 'In-Person Plan',
      'fr': '',
      'sw': '',
    },
    'dzlwc6vh': {
      'en': '\$750',
      'fr': '',
      'sw': '',
    },
    'sgm4j6z2': {
      'en': 'per intensive',
      'fr': '',
      'sw': '',
    },
    'g4gydg8j': {
      'en': '3 in-person coaching sessions',
      'fr': '',
      'sw': '',
    },
    'lwnlh8sx': {
      'en': 'Hands-on kitchen & business walkthrough',
      'fr': '',
      'sw': '',
    },
    '4bsift5p': {
      'en': 'Custom workbook & pricing formula',
      'fr': '',
      'sw': '',
    },
    'hov35sth': {
      'en': 'Location: Nairobi & surrounding areas',
      'fr': '',
      'sw': '',
    },
    'xjpe3nr0': {
      'en': 'Proceed to Consultation',
      'fr': '',
      'sw': '',
    },
    'l3n22hp8': {
      'en': 'Secure booking · No hidden fees',
      'fr': '',
      'sw': '',
    },
    'dlimw9y7': {
      'en': 'Madam Mercy Kitomari',
      'fr': '',
      'sw': '',
    },
    'iqmwebai': {
      'en': 'Food Business Strategist & Pricing Expert',
      'fr': '',
      'sw': '',
    },
    'krtl5h2o': {
      'en': '50+ kitchens transformed',
      'fr': '',
      'sw': '',
    },
  },
  // Miscellaneous
  {
    'h26lah7q': {
      'en': 'Continue',
      'fr': 'Continuer',
      'sw': 'Endelea',
    },
    'qmyb0nqt': {
      'en': 'TextField',
      'fr': 'Champ de texte',
      'sw': 'Sehemu ya Maandishi',
    },
    'euwhih59': {
      'en': 'In order to take Image or Video, This App Require Your Permission',
      'fr': '',
      'sw': '',
    },
    'frzsyvtt': {
      'en': '',
      'fr': '',
      'sw': '',
    },
    '1s2tffsu': {
      'en': '',
      'fr': '',
      'sw': '',
    },
    '4tfobnae': {
      'en': '',
      'fr': '',
      'sw': '',
    },
    '19quuvbm': {
      'en': '',
      'fr': '',
      'sw': '',
    },
    'aal11tki': {
      'en': '',
      'fr': '',
      'sw': '',
    },
    'tyd6e0a1': {
      'en': '',
      'fr': '',
      'sw': '',
    },
    'm4v3gghi': {
      'en': '',
      'fr': '',
      'sw': '',
    },
    'qvppn0lr': {
      'en': '',
      'fr': '',
      'sw': '',
    },
    'zmnvya6a': {
      'en': '',
      'fr': '',
      'sw': '',
    },
    'gc9zx7cy': {
      'en': '',
      'fr': '',
      'sw': '',
    },
    '3g5dvpcc': {
      'en': '',
      'fr': '',
      'sw': '',
    },
    'l2cdqjde': {
      'en': '',
      'fr': '',
      'sw': '',
    },
    'cov7z00z': {
      'en': '',
      'fr': '',
      'sw': '',
    },
    'mk8c37ui': {
      'en': '',
      'fr': '',
      'sw': '',
    },
    'rbo9z17r': {
      'en': '',
      'fr': '',
      'sw': '',
    },
    '3ny4g6vy': {
      'en': '',
      'fr': '',
      'sw': '',
    },
    'ru1msjmb': {
      'en': '',
      'fr': '',
      'sw': '',
    },
    'qnohhd11': {
      'en': '',
      'fr': '',
      'sw': '',
    },
    'h1qv1fp5': {
      'en': '',
      'fr': '',
      'sw': '',
    },
    'mi77evs4': {
      'en': '',
      'fr': '',
      'sw': '',
    },
    '1ozdadt6': {
      'en': '',
      'fr': '',
      'sw': '',
    },
    '21uwk44h': {
      'en': '',
      'fr': '',
      'sw': '',
    },
    'x9tel1k7': {
      'en': '',
      'fr': '',
      'sw': '',
    },
    'syw08043': {
      'en': '',
      'fr': '',
      'sw': '',
    },
    'yiekvpkk': {
      'en': '',
      'fr': '',
      'sw': '',
    },
    '7kd2p79t': {
      'en': '',
      'fr': '',
      'sw': '',
    },
    'j1v19eks': {
      'en': '',
      'fr': '',
      'sw': '',
    },
  },
].reduce((a, b) => a..addAll(b));
