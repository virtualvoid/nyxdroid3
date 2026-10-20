// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'nyxdroid';

  @override
  String get authorizationGetCode => 'Get code';

  @override
  String get authorizationFinished => 'Done!';

  @override
  String get authorizationResultInstructions =>
      'Please enter your Nick/ID and press \'Get code\'.';

  @override
  String get authorizationResultNew =>
      'Your request was successful, please go to PERSONAL / SETTINGS / AUTHORIZATION and enter code there.';

  @override
  String get authorizationResultExisting =>
      'This Nick/ID is already authorized, if you need new code, please go to PERSONAL / SETTINGS / AUTHORIZATION and cancel existing authorization. After that you can request new code.';

  @override
  String get authorizationResultError =>
      'Unexpected error, please contact author for further help.';

  @override
  String get authorizationWaitTitle => 'Please wait';

  @override
  String get authorizationWaitMessage => 'Connecting to nyx.cz…';

  @override
  String get authorizationErrorMessage =>
      'Your authorization is invalid. You probably cancelled it on NYX or you didn\'t correctly finished application authorization. Please restart application, authorization will start from beginning.';

  @override
  String get warning => 'Warning';

  @override
  String get areYouSureAuthorizationIsComplete =>
      'Are you sure you have completed authorization ?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get menuMail => 'mail';

  @override
  String get menuBookmarks => 'bookmarks';

  @override
  String get menuHistory => 'history';

  @override
  String get menuNotifications => 'notices';

  @override
  String get menuLast => 'last';

  @override
  String get menuSettings => 'settings';

  @override
  String get menuAbout => 'about';

  @override
  String get noData => 'It\'s empty here.';

  @override
  String get refresh => 'Refresh';

  @override
  String get bookmarksSearch => 'Search';

  @override
  String get historyShowUnread => 'Show only unread discussions';

  @override
  String get historyShowAll => 'Show all history';

  @override
  String get bookmarksShowAll => 'Show all followed discussions';

  @override
  String get reminders => 'reminders';

  @override
  String get clearCredentials => 'Clear authorization';

  @override
  String get spoilerAlert =>
      'Message contains spoiler, to view it, click here.';

  @override
  String get anonymousVoteWarning =>
      'This user chose that his posts can\'t be rated negatively anonymously. If you want to rate it visibly, click Yes.';

  @override
  String get anonymousVoteWarningTitle => 'Confirmation';

  @override
  String get positiveButton => 'Yes';

  @override
  String get negativeButton => 'No';

  @override
  String get noResponsesForThisWriteup => 'No replies for this write-up.';

  @override
  String get tabDiscussion => 'Discussion';

  @override
  String get tabHeader => 'Header';

  @override
  String get tabBoard => 'Noticeboard';

  @override
  String relativeSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seconds ago',
      one: '1 second ago',
    );
    return '$_temp0';
  }

  @override
  String relativeMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes ago',
      one: '1 minute ago',
    );
    return '$_temp0';
  }

  @override
  String relativeHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String relativeDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String get cantOpenIt => 'I can\'t open it.';

  @override
  String get reply => 'Reply';

  @override
  String get sendMail => 'Send mail';

  @override
  String get viewReplies => 'View replies';

  @override
  String get rating => 'Rating';

  @override
  String get copy => 'Copy';

  @override
  String get reminder => 'Reminder';

  @override
  String get delete => 'Delete';

  @override
  String get copyLink => 'Copy link';

  @override
  String get enterYourMessage => 'Enter your message...';

  @override
  String get andWhatAboutMessage => 'And what about message ?';

  @override
  String get somethingTerribleHappenedToNyx =>
      'Something terrible happened to NYX. Uhm.';

  @override
  String get sent => 'Sent';

  @override
  String get attachment => 'Attachment';

  @override
  String get thumbsUp => 'Thumbs up';

  @override
  String get thumbsDown => 'Thumbs down';

  @override
  String get fileDoesntExistsOrCantRead =>
      'File either doesn\'t exists or is unreadable !';

  @override
  String get noOneAtThisTime => 'No one';

  @override
  String get replyToMoreWriteups => 'Reply to more writeups';

  @override
  String get newWriteup => 'New';

  @override
  String get send => 'Send';

  @override
  String get gallery => 'Gallery';

  @override
  String get mailNew => 'New';

  @override
  String get mailRefresh => 'Refresh';

  @override
  String get enterRecipientNick => 'Recipient';

  @override
  String get andWhatAboutNick => 'And what about recipient ?';

  @override
  String get search => 'Search';

  @override
  String get galleryOpenBrowser => 'Open';

  @override
  String get galleryBegin => 'To beginning';

  @override
  String get galleryCurrent => 'To current';

  @override
  String get linkCopied => 'Link copied';

  @override
  String get discussionDoesntContainImages =>
      'Discussion doesn\'t contain images.';

  @override
  String get viewAsGallery => 'View as gallery';

  @override
  String get boardEmpty => 'The noticeboard is empty.';

  @override
  String get unspecifiedDataError =>
      'Communication error occurred. Possible reason: access denied. Please send application log from settings menu if you\'re not sure about it.';

  @override
  String get addDiscussionToCategoryNoCategories =>
      'You don\'t have any bookmark categories !';

  @override
  String get addDiscussionToCategoryTitle => 'Add discussion to category';

  @override
  String get bookTitleBook => 'Add to bookmarks';

  @override
  String get bookTitleUnbook => 'Remove from bookmarks';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsUnreadStyle => 'Unread write-up style';

  @override
  String get settingsUnreadStyleSummary =>
      'Please choose standard settings or colored.';

  @override
  String get settingsRowPadding => 'Row padding';

  @override
  String get settingsRowPaddingSummary =>
      'Please choose row-padding in bookmarks or history';

  @override
  String get settingsDisplayRating => 'Display rating';

  @override
  String get settingsRatingOff =>
      'Don\'t display rating controls or rating itself.';

  @override
  String get settingsRatingOn =>
      'Always display rating controls or rating itself.';

  @override
  String get settingsMisc => 'Misc.';

  @override
  String get settingsStartup => 'Startup activity';

  @override
  String get settingsStartupSummary =>
      'Please choose what activity will be started at launch.';

  @override
  String get settingsReadBookmarks => 'Read in bookmarks';

  @override
  String get settingsReadHistory => 'Read in history';

  @override
  String get settingsDontDisplay => 'Don\'t display';

  @override
  String get settingsAlwaysDisplay => 'Always display';

  @override
  String get settingsBackButton => 'Back button';

  @override
  String get settingsBackRegular => 'Use regular';

  @override
  String get settingsBackWriteups =>
      'Use to back-navigate between linked write-up(s)';

  @override
  String get settingsRefreshAfterSend => 'Refresh after sending writeup';

  @override
  String get settingsNever => 'Never';

  @override
  String get settingsAlways => 'Always';

  @override
  String get settingsReminders => 'Reminders in bookmarks';

  @override
  String get settingsRemindersOn => 'Are displayed';

  @override
  String get settingsRemindersOff => 'Wont be displayed';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsNotificationsOff => 'Custom notification settings';

  @override
  String get settingsNotificationsOn => 'Standard notification settings';

  @override
  String get clearCache => 'Clear cache';

  @override
  String get done => 'Done !';

  @override
  String get settingsFontSize => 'Fontsize';

  @override
  String get unreadStyleStandard => 'Standard';

  @override
  String get unreadStyleRed => 'Colored: red';

  @override
  String get unreadStyleOrange => 'Colored: orange';

  @override
  String get unreadStyleYellow => 'Colored: yellow';

  @override
  String get unreadStyleGreen => 'Colored: green';

  @override
  String get paddingStandard => 'Standard (0dp)';

  @override
  String get paddingGreater => 'Greater (2dp)';

  @override
  String get paddingLarge => 'Large (4dp)';

  @override
  String get paddingHuge => 'Huge (6dp)';

  @override
  String get paddingMega => 'Mega (8dp)';

  @override
  String get paddingShovel => 'Shovel (16dp)';

  @override
  String get shareToDiscussion => 'Share to discussion';

  @override
  String get reallyWannaShare => 'Really ?';

  @override
  String areYouSureYouWannaShareThis(String name) {
    return 'Are you sure you want to share into: $name';
  }

  @override
  String get additionalMessage => 'Additional message...';

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
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSummary => 'Please choose application language.';

  @override
  String get languageSystem => 'System default';

  @override
  String get authorizationStepRequest => 'Request a code';

  @override
  String get authorizationStepConfirm => 'Confirm on nyx.cz';

  @override
  String get authorizationNickLabel => 'Nick / ID';

  @override
  String get authorizationCodeLabel => 'Authorization code';

  @override
  String get authorizationCopyCode => 'Copy code';

  @override
  String get authorizationCodeCopied => 'Code copied';

  @override
  String get historyToday => 'Today';

  @override
  String get historyYesterday => 'Yesterday';

  @override
  String get historyEarlier => 'Earlier';

  @override
  String replyBadge(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count replies',
      one: '1 reply',
    );
    return '$_temp0';
  }

  @override
  String get historyMarkRead => 'Mark as read';

  @override
  String get historyRemove => 'Remove from history';

  @override
  String get historyMarkAllRead => 'Mark all as read';

  @override
  String get aboutLinks => 'Links';

  @override
  String get aboutSourceCode => 'Source code';

  @override
  String get aboutLicenses => 'Open-source licenses';

  @override
  String get menuSearch => 'search';

  @override
  String get searchHelp =>
      'Enter a phrase, or @nick to find posts written by a user, for example \"@nick phrase\".';

  @override
  String get historyLoadMore => 'Load more';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeSummary => 'Please choose the application theme.';

  @override
  String get themeSystem => 'System default';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeLight => 'Light';

  @override
  String get settingsPrivacy => 'Privacy';

  @override
  String get settingsCrashReporting => 'Crash reports';

  @override
  String get settingsCrashReportingOn =>
      'Crash reports, including your nick, are sent to help fix bugs.';

  @override
  String get settingsCrashReportingOff => 'Crash reports are not sent.';

  @override
  String get settingsAnalytics => 'Usage statistics';

  @override
  String get settingsAnalyticsOn => 'Anonymous usage statistics are sent.';

  @override
  String get settingsAnalyticsOff => 'Usage statistics are not sent.';

  @override
  String get errorLoading => 'Couldn\'t load the data.';

  @override
  String get tryAgain => 'Try again';

  @override
  String get draftRestored => 'Draft restored';

  @override
  String get draftDiscard => 'Discard';

  @override
  String get settingsHistoryBooked => 'Bookmarked in history';

  @override
  String get settingsHistoryBookedSummary =>
      'Please choose whether bookmarked discussions are shown in history.';

  @override
  String get historyBookedDefault => 'As on the website';

  @override
  String get historyBookedShow => 'Show';

  @override
  String get historyBookedHide => 'Hide';

  @override
  String get settingsDensity => 'Display density';

  @override
  String get settingsDensitySummary =>
      'Compact layout saves screen space in lists and posts.';

  @override
  String get densityCompact => 'Compact';

  @override
  String get densityComfortable => 'Comfortable';

  @override
  String get settingsHistoryTimes => 'Times in history';

  @override
  String get aboutUpdates => 'Updates';

  @override
  String get updateCheckNow => 'Check for updates';

  @override
  String get updateChecking => 'Checking…';

  @override
  String get updateUpToDate => 'You are on the latest version.';

  @override
  String get updateCheckFailed => 'Could not check for updates.';

  @override
  String updateAvailableTitle(String version) {
    return 'New version $version';
  }

  @override
  String updateCurrentVersion(String version) {
    return 'Installed version: $version';
  }

  @override
  String get updateDownload => 'Download';

  @override
  String get updateLater => 'Later';

  @override
  String get updateSkip => 'Skip this version';

  @override
  String get settingsUpdateCheck => 'Check for updates';

  @override
  String get settingsUpdateCheckOn =>
      'A new version is looked up on GitHub when the app starts.';

  @override
  String get settingsUpdateCheckOff => 'New versions are not checked.';

  @override
  String get settingsNotificationBulb => 'Notifications bulb';

  @override
  String get settingsNotificationBulbOn =>
      'A bulb with the unread count is shown in the top bar.';

  @override
  String get settingsNotificationBulbOff => 'The bulb is hidden.';

  @override
  String get undo => 'Undo';

  @override
  String historyRemovedSnack(String name) {
    return 'Removed from history: $name';
  }
}
