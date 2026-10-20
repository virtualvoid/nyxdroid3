// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get appName => 'nyxdroid';

  @override
  String get authorizationGetCode => 'Získat kód';

  @override
  String get authorizationFinished => 'Hotovo!';

  @override
  String get authorizationResultInstructions =>
      'Zadejte, prosím, své ID a stiskněte \'Získat kód\'…';

  @override
  String get authorizationResultNew =>
      'Žádost o kód byla úspěšná, nyní, prosím, navštivte OSOBNÍ / NASTAVENÍ / AUTORIZACE a kód zde zadejte.';

  @override
  String get authorizationResultExisting =>
      'Toto ID je již autorizováno, pokud potřebujete nový kód, navštivte, prosím, OSOBNÍ / NASTAVENÍ / AUTORIZACE a zrušte existující autorizaci. Poté si zažádejte o nový kód.';

  @override
  String get authorizationResultError =>
      'Neočekávaná chyba. Kontaktujte, prosím, autora pro další postup.';

  @override
  String get authorizationWaitTitle => 'Čekejte, prosím';

  @override
  String get authorizationWaitMessage => 'Připojuji se k serveru nyx.cz…';

  @override
  String get authorizationErrorMessage =>
      'Vaše autorizace je neplatná. Buď jste ji vymazali na NYXu, nebo jste řádne nedokončili autorizaci. Restartujte prosím aplikaci, autorizace proběhne opět.';

  @override
  String get warning => 'Upozornění';

  @override
  String get areYouSureAuthorizationIsComplete =>
      'Jste si jistí, že autorizace opravdu proběhla do konce ?';

  @override
  String get yes => 'Ano';

  @override
  String get no => 'Ne';

  @override
  String get menuMail => 'pošta';

  @override
  String get menuBookmarks => 'sledované';

  @override
  String get menuHistory => 'historie';

  @override
  String get menuNotifications => 'notifikace';

  @override
  String get menuLast => 'poslední';

  @override
  String get menuSettings => 'nastavení';

  @override
  String get menuAbout => 'o aplikaci';

  @override
  String get noData => 'Žádná data';

  @override
  String get refresh => 'Obnovit';

  @override
  String get bookmarksSearch => 'Hledat';

  @override
  String get historyShowUnread => 'Zobrazit jen nepřečtené diskuze';

  @override
  String get historyShowAll => 'Zobrazit celou historii';

  @override
  String get bookmarksShowAll => 'Zobrazit všechny sledované diskuze';

  @override
  String get reminders => 'upomínky';

  @override
  String get clearCredentials => 'Vymazat autorizaci';

  @override
  String get spoilerAlert =>
      'Zpráva obsahuje spoiler, chcete-li ji vidět, klepněte sem.';

  @override
  String get anonymousVoteWarning =>
      'Tento uživatel si nepřeje, aby bylo možné jeho příspěvky hodnotit negativně anonymně. Pokud si přejete hodnotit příspěvek neanonymně, klikněte Ano.';

  @override
  String get anonymousVoteWarningTitle => 'Potvrzení';

  @override
  String get positiveButton => 'Ano';

  @override
  String get negativeButton => 'Ne';

  @override
  String get noResponsesForThisWriteup =>
      'Na tenhle příspevěk neexistujou odpovědi';

  @override
  String get tabDiscussion => 'Diskuze';

  @override
  String get tabHeader => 'Záhlaví';

  @override
  String get tabBoard => 'Nástěnka';

  @override
  String relativeSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'před $count sekundami',
      one: 'před 1 sekundou',
    );
    return '$_temp0';
  }

  @override
  String relativeMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'před $count minutami',
      one: 'před 1 minutou',
    );
    return '$_temp0';
  }

  @override
  String relativeHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'před $count hodinami',
      one: 'před 1 hodinou',
    );
    return '$_temp0';
  }

  @override
  String relativeDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'před $count dny',
      one: 'před 1 dnem',
    );
    return '$_temp0';
  }

  @override
  String get cantOpenIt => 'Neumím to otevřít.';

  @override
  String get reply => 'Odpovědět';

  @override
  String get sendMail => 'Poslat zprávu';

  @override
  String get viewReplies => 'Zobrazit odpovědi';

  @override
  String get rating => 'Hodnocení';

  @override
  String get copy => 'Kopírovat';

  @override
  String get reminder => 'Upozornit';

  @override
  String get delete => 'Smazat';

  @override
  String get copyLink => 'Kopírovat propojení';

  @override
  String get enterYourMessage => 'Napište Vaši zprávu...';

  @override
  String get andWhatAboutMessage => 'A co text zprávy ?';

  @override
  String get somethingTerribleHappenedToNyx => 'Něco se NYXovi nepovedlo. Uhm.';

  @override
  String get sent => 'Odesláno';

  @override
  String get attachment => 'Příloha';

  @override
  String get thumbsUp => 'Palec nahoru';

  @override
  String get thumbsDown => 'Palec dolů';

  @override
  String get fileDoesntExistsOrCantRead => 'Soubor nelze najít nebo otevřít !';

  @override
  String get noOneAtThisTime => 'Prozatím nikdo';

  @override
  String get replyToMoreWriteups => 'Odpovědět na více příspěvků';

  @override
  String get newWriteup => 'Nový příspěvek';

  @override
  String get send => 'Odeslat';

  @override
  String get gallery => 'Galerie';

  @override
  String get mailNew => 'Nový';

  @override
  String get mailRefresh => 'Obnovit';

  @override
  String get enterRecipientNick => 'Jméno příjemce';

  @override
  String get andWhatAboutNick => 'A co příjemce ?';

  @override
  String get search => 'Hledat';

  @override
  String get galleryOpenBrowser => 'Otevřít';

  @override
  String get galleryBegin => 'Na začátek';

  @override
  String get galleryCurrent => 'Na aktuální';

  @override
  String get linkCopied => 'Zkopírováno';

  @override
  String get discussionDoesntContainImages =>
      'Diskuze neobsahuje žádné obrázky.';

  @override
  String get viewAsGallery => 'Zobrazit galerii';

  @override
  String get boardEmpty => 'Nástěnka je prázdná.';

  @override
  String get unspecifiedDataError =>
      'Nastala chyba v komunikaci. Možný důvod: nemáte přístup. Pro jistotu zašlete, prosím, log aplikace z menu Nastavení';

  @override
  String get addDiscussionToCategoryNoCategories => 'Nemáte žádné kategorie !';

  @override
  String get addDiscussionToCategoryTitle => 'Přidat do kategorie';

  @override
  String get bookTitleBook => 'Přidat do sledovaných';

  @override
  String get bookTitleUnbook => 'Odebrat ze sledovaných';

  @override
  String get settingsAppearance => 'Vzhled';

  @override
  String get settingsUnreadStyle => 'Styl nepřečtených příspěvků';

  @override
  String get settingsUnreadStyleSummary =>
      'Vyberte si barvu, nebo standardní nastavení';

  @override
  String get settingsRowPadding => 'Velikost řádků v sledovaných';

  @override
  String get settingsRowPaddingSummary =>
      'Vyberte si velikost řádků v sledovaných nebo historii';

  @override
  String get settingsDisplayRating => 'Zobrazovat hodnocení';

  @override
  String get settingsRatingOff => 'Nezobrazovat hodnocení ani hodnotíci prvky';

  @override
  String get settingsRatingOn => 'Vždy zobrazovat hodnocení a hodnotíci prvky';

  @override
  String get settingsMisc => 'Ostatní';

  @override
  String get settingsStartup => 'Zobrazit při spuštění';

  @override
  String get settingsStartupSummary =>
      'Vyberte si, která aktivita má být zobrazena po spuštění';

  @override
  String get settingsReadBookmarks => 'Přečtené sledované diskuze';

  @override
  String get settingsReadHistory => 'Přečtené v historii';

  @override
  String get settingsDontDisplay => 'Nezobrazovat';

  @override
  String get settingsAlwaysDisplay => 'Vždy zobrazovat';

  @override
  String get settingsBackButton => 'Tlačítko Zpět';

  @override
  String get settingsBackRegular => 'Používat regulérní';

  @override
  String get settingsBackWriteups => 'Používat k návratu na zdrojový příspevěk';

  @override
  String get settingsRefreshAfterSend =>
      'Znovu načíst diskusi po odeslání příspěvku';

  @override
  String get settingsNever => 'Nikdy';

  @override
  String get settingsAlways => 'Vždy';

  @override
  String get settingsReminders => 'Upomínky v sledovaných';

  @override
  String get settingsRemindersOn => 'Budou zobrazeny';

  @override
  String get settingsRemindersOff => 'Budou skryty';

  @override
  String get settingsNotifications => 'Notifikace';

  @override
  String get settingsNotificationsOff => 'Vlastní nastavení';

  @override
  String get settingsNotificationsOn => 'Standartní nastavení';

  @override
  String get clearCache => 'Vymazat mezipaměť';

  @override
  String get done => 'Hotovo !';

  @override
  String get settingsFontSize => 'Fontsize';

  @override
  String get unreadStyleStandard => 'Standartní';

  @override
  String get unreadStyleRed => 'Barevně: červená';

  @override
  String get unreadStyleOrange => 'Barevně: oranžová';

  @override
  String get unreadStyleYellow => 'Barevně: žlutá';

  @override
  String get unreadStyleGreen => 'Barevně: zelená';

  @override
  String get paddingStandard => 'Standartní (0dp)';

  @override
  String get paddingGreater => 'Větší (2dp)';

  @override
  String get paddingLarge => 'Velké (4dp)';

  @override
  String get paddingHuge => 'Obrovské (6dp)';

  @override
  String get paddingMega => 'Mega (8dp)';

  @override
  String get paddingShovel => 'Shovel (16dp)';

  @override
  String get shareToDiscussion => 'Sdílet do diskuse';

  @override
  String get reallyWannaShare => 'Opravdu sdílet ?';

  @override
  String areYouSureYouWannaShareThis(String name) {
    return 'Chcete pokračovat ve sdílení obsahu do diskuse: $name';
  }

  @override
  String get additionalMessage => 'Zpráva...';

  @override
  String get aboutBroughtBy => '...vám přináší...';

  @override
  String get aboutThanks => '...Poděkování...';

  @override
  String get aboutInformation => '...Informace...';

  @override
  String get aboutDisclaimer =>
      'Uživatelská data nejsou používána k jiným účelům než je zprostředkování funkcionality serveru nyx.cz. Autorizace aplikace nevyžaduje heslo, ale potvrzuje se na webovém rozhraní nyxu, kde je možné také autorizaci zrušit například v případě odcizení telefonu. Autor aplikace nenese odpovědnost za škody způsobené užíváním aplikace, byť se snaží jakékoliv problémy minimalizovat.';

  @override
  String get settingsLanguage => 'Jazyk';

  @override
  String get settingsLanguageSummary => 'Vyberte, prosím, jazyk aplikace.';

  @override
  String get languageSystem => 'Podle systému';

  @override
  String get authorizationStepRequest => 'Získejte kód';

  @override
  String get authorizationStepConfirm => 'Potvrďte na nyx.cz';

  @override
  String get authorizationNickLabel => 'Nick / ID';

  @override
  String get authorizationCodeLabel => 'Autorizační kód';

  @override
  String get authorizationCopyCode => 'Zkopírovat kód';

  @override
  String get authorizationCodeCopied => 'Kód zkopírován';

  @override
  String get historyToday => 'Dnes';

  @override
  String get historyYesterday => 'Včera';

  @override
  String get historyEarlier => 'Dříve';

  @override
  String replyBadge(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count odpovědí',
      few: '$count odpovědi',
      one: '1 odpověď',
    );
    return '$_temp0';
  }

  @override
  String get historyMarkRead => 'Označit jako přečtené';

  @override
  String get historyRemove => 'Odebrat z historie';

  @override
  String get historyMarkAllRead => 'Označit vše jako přečtené';

  @override
  String get aboutLinks => 'Odkazy';

  @override
  String get aboutSourceCode => 'Zdrojový kód';

  @override
  String get aboutLicenses => 'Licence open source';

  @override
  String get menuSearch => 'hledání';

  @override
  String get searchHelp =>
      'Zadejte výraz, nebo @nick pro příspěvky uživatele, například „@nick výraz“.';

  @override
  String get historyLoadMore => 'Načíst další';

  @override
  String get settingsTheme => 'Téma';

  @override
  String get settingsThemeSummary => 'Vyberte, prosím, vzhled aplikace.';

  @override
  String get themeSystem => 'Podle systému';

  @override
  String get themeDark => 'Tmavá';

  @override
  String get themeLight => 'Světlá';

  @override
  String get settingsPrivacy => 'Soukromí';

  @override
  String get settingsCrashReporting => 'Hlášení o pádech';

  @override
  String get settingsCrashReportingOn =>
      'Hlášení o pádech, včetně vašeho nicku, se odesílají a pomáhají opravovat chyby.';

  @override
  String get settingsCrashReportingOff => 'Hlášení o pádech se neodesílají.';

  @override
  String get settingsAnalytics => 'Statistiky používání';

  @override
  String get settingsAnalyticsOn =>
      'Odesílají se anonymní statistiky používání.';

  @override
  String get settingsAnalyticsOff => 'Statistiky používání se neodesílají.';

  @override
  String get errorLoading => 'Data se nepodařilo načíst.';

  @override
  String get tryAgain => 'Zkusit znovu';

  @override
  String get draftRestored => 'Rozepsaná zpráva obnovena';

  @override
  String get draftDiscard => 'Zahodit';

  @override
  String get settingsHistoryBooked => 'Sledované v historii';

  @override
  String get settingsHistoryBookedSummary =>
      'Vyberte, zda se sledované diskuze zobrazují v historii.';

  @override
  String get historyBookedDefault => 'Podle webu';

  @override
  String get historyBookedShow => 'Zobrazit';

  @override
  String get historyBookedHide => 'Skrýt';

  @override
  String get settingsDensity => 'Hustota zobrazení';

  @override
  String get settingsDensitySummary =>
      'Kompaktní zobrazení šetří místo na obrazovce v seznamech a příspěvcích.';

  @override
  String get densityCompact => 'Kompaktní';

  @override
  String get densityComfortable => 'Pohodlná';

  @override
  String get settingsHistoryTimes => 'Časy v historii';

  @override
  String get aboutUpdates => 'Aktualizace';

  @override
  String get updateCheckNow => 'Zkontrolovat aktualizace';

  @override
  String get updateChecking => 'Kontroluji…';

  @override
  String get updateUpToDate => 'Používáte nejnovější verzi.';

  @override
  String get updateCheckFailed => 'Aktualizace se nepodařilo zkontrolovat.';

  @override
  String updateAvailableTitle(String version) {
    return 'Nová verze $version';
  }

  @override
  String updateCurrentVersion(String version) {
    return 'Nainstalovaná verze: $version';
  }

  @override
  String get updateDownload => 'Stáhnout';

  @override
  String get updateLater => 'Později';

  @override
  String get updateSkip => 'Přeskočit tuto verzi';

  @override
  String get settingsUpdateCheck => 'Kontrolovat aktualizace';

  @override
  String get settingsUpdateCheckOn =>
      'Při spuštění aplikace se na GitHubu zkontroluje nová verze.';

  @override
  String get settingsUpdateCheckOff => 'Nové verze se nekontrolují.';

  @override
  String get settingsNotificationBulb => 'Žárovka s oznámeními';

  @override
  String get settingsNotificationBulbOn =>
      'V horní liště se zobrazuje žárovka s počtem nepřečtených oznámení.';

  @override
  String get settingsNotificationBulbOff => 'Žárovka se nezobrazuje.';

  @override
  String get undo => 'Vrátit zpět';

  @override
  String historyRemovedSnack(String name) {
    return 'Odebráno z historie: $name';
  }
}
