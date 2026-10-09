import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_cs.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('cs'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'nyxdroid'**
  String get appName;

  /// No description provided for @authorizationGetCode.
  ///
  /// In en, this message translates to:
  /// **'Get code'**
  String get authorizationGetCode;

  /// No description provided for @authorizationFinished.
  ///
  /// In en, this message translates to:
  /// **'Done!'**
  String get authorizationFinished;

  /// No description provided for @authorizationResultInstructions.
  ///
  /// In en, this message translates to:
  /// **'Please enter your Nick/ID and press \'Get code\'.'**
  String get authorizationResultInstructions;

  /// No description provided for @authorizationResultNew.
  ///
  /// In en, this message translates to:
  /// **'Your request was successful, please go to PERSONAL / SETTINGS / AUTHORIZATION and enter code there.'**
  String get authorizationResultNew;

  /// No description provided for @authorizationResultExisting.
  ///
  /// In en, this message translates to:
  /// **'This Nick/ID is already authorized, if you need new code, please go to PERSONAL / SETTINGS / AUTHORIZATION and cancel existing authorization. After that you can request new code.'**
  String get authorizationResultExisting;

  /// No description provided for @authorizationResultError.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error, please contact author for further help.'**
  String get authorizationResultError;

  /// No description provided for @authorizationWaitTitle.
  ///
  /// In en, this message translates to:
  /// **'Please wait'**
  String get authorizationWaitTitle;

  /// No description provided for @authorizationWaitMessage.
  ///
  /// In en, this message translates to:
  /// **'Connecting to nyx.cz…'**
  String get authorizationWaitMessage;

  /// No description provided for @authorizationErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Your authorization is invalid. You probably cancelled it on NYX or you didn\'t correctly finished application authorization. Please restart application, authorization will start from beginning.'**
  String get authorizationErrorMessage;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @areYouSureAuthorizationIsComplete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you have completed authorization ?'**
  String get areYouSureAuthorizationIsComplete;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @menuMail.
  ///
  /// In en, this message translates to:
  /// **'mail'**
  String get menuMail;

  /// No description provided for @menuBookmarks.
  ///
  /// In en, this message translates to:
  /// **'bookmarks'**
  String get menuBookmarks;

  /// No description provided for @menuHistory.
  ///
  /// In en, this message translates to:
  /// **'history'**
  String get menuHistory;

  /// No description provided for @menuNotifications.
  ///
  /// In en, this message translates to:
  /// **'notices'**
  String get menuNotifications;

  /// No description provided for @menuLast.
  ///
  /// In en, this message translates to:
  /// **'last'**
  String get menuLast;

  /// No description provided for @menuSettings.
  ///
  /// In en, this message translates to:
  /// **'settings'**
  String get menuSettings;

  /// No description provided for @menuAbout.
  ///
  /// In en, this message translates to:
  /// **'about'**
  String get menuAbout;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'It\'s empty here.'**
  String get noData;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @bookmarksSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get bookmarksSearch;

  /// No description provided for @historyShowUnread.
  ///
  /// In en, this message translates to:
  /// **'Show only unread discussions'**
  String get historyShowUnread;

  /// No description provided for @historyShowAll.
  ///
  /// In en, this message translates to:
  /// **'Show all history'**
  String get historyShowAll;

  /// No description provided for @bookmarksShowAll.
  ///
  /// In en, this message translates to:
  /// **'Show all followed discussions'**
  String get bookmarksShowAll;

  /// No description provided for @reminders.
  ///
  /// In en, this message translates to:
  /// **'reminders'**
  String get reminders;

  /// No description provided for @clearCredentials.
  ///
  /// In en, this message translates to:
  /// **'Clear authorization'**
  String get clearCredentials;

  /// No description provided for @spoilerAlert.
  ///
  /// In en, this message translates to:
  /// **'Message contains spoiler, to view it, click here.'**
  String get spoilerAlert;

  /// No description provided for @anonymousVoteWarning.
  ///
  /// In en, this message translates to:
  /// **'This user chose that his posts can\'t be rated negatively anonymously. If you want to rate it visibly, click Yes.'**
  String get anonymousVoteWarning;

  /// No description provided for @anonymousVoteWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirmation'**
  String get anonymousVoteWarningTitle;

  /// No description provided for @positiveButton.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get positiveButton;

  /// No description provided for @negativeButton.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get negativeButton;

  /// No description provided for @noResponsesForThisWriteup.
  ///
  /// In en, this message translates to:
  /// **'No replies for this write-up.'**
  String get noResponsesForThisWriteup;

  /// No description provided for @tabDiscussion.
  ///
  /// In en, this message translates to:
  /// **'Discussion'**
  String get tabDiscussion;

  /// No description provided for @tabHeader.
  ///
  /// In en, this message translates to:
  /// **'Header'**
  String get tabHeader;

  /// No description provided for @tabBoard.
  ///
  /// In en, this message translates to:
  /// **'Noticeboard'**
  String get tabBoard;

  /// No description provided for @relativeSeconds.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 second ago} other{{count} seconds ago}}'**
  String relativeSeconds(int count);

  /// No description provided for @relativeMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 minute ago} other{{count} minutes ago}}'**
  String relativeMinutes(int count);

  /// No description provided for @relativeHours.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour ago} other{{count} hours ago}}'**
  String relativeHours(int count);

  /// No description provided for @relativeDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day ago} other{{count} days ago}}'**
  String relativeDays(int count);

  /// No description provided for @cantOpenIt.
  ///
  /// In en, this message translates to:
  /// **'I can\'t open it.'**
  String get cantOpenIt;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @sendMail.
  ///
  /// In en, this message translates to:
  /// **'Send mail'**
  String get sendMail;

  /// No description provided for @viewReplies.
  ///
  /// In en, this message translates to:
  /// **'View replies'**
  String get viewReplies;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @reminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get reminder;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @copyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get copyLink;

  /// No description provided for @enterYourMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter your message...'**
  String get enterYourMessage;

  /// No description provided for @andWhatAboutMessage.
  ///
  /// In en, this message translates to:
  /// **'And what about message ?'**
  String get andWhatAboutMessage;

  /// No description provided for @somethingTerribleHappenedToNyx.
  ///
  /// In en, this message translates to:
  /// **'Something terrible happened to NYX. Uhm.'**
  String get somethingTerribleHappenedToNyx;

  /// No description provided for @sent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get sent;

  /// No description provided for @attachment.
  ///
  /// In en, this message translates to:
  /// **'Attachment'**
  String get attachment;

  /// No description provided for @thumbsUp.
  ///
  /// In en, this message translates to:
  /// **'Thumbs up'**
  String get thumbsUp;

  /// No description provided for @thumbsDown.
  ///
  /// In en, this message translates to:
  /// **'Thumbs down'**
  String get thumbsDown;

  /// No description provided for @fileDoesntExistsOrCantRead.
  ///
  /// In en, this message translates to:
  /// **'File either doesn\'t exists or is unreadable !'**
  String get fileDoesntExistsOrCantRead;

  /// No description provided for @noOneAtThisTime.
  ///
  /// In en, this message translates to:
  /// **'No one'**
  String get noOneAtThisTime;

  /// No description provided for @replyToMoreWriteups.
  ///
  /// In en, this message translates to:
  /// **'Reply to more writeups'**
  String get replyToMoreWriteups;

  /// No description provided for @newWriteup.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newWriteup;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @mailNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get mailNew;

  /// No description provided for @mailRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get mailRefresh;

  /// No description provided for @enterRecipientNick.
  ///
  /// In en, this message translates to:
  /// **'Recipient'**
  String get enterRecipientNick;

  /// No description provided for @andWhatAboutNick.
  ///
  /// In en, this message translates to:
  /// **'And what about recipient ?'**
  String get andWhatAboutNick;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @galleryOpenBrowser.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get galleryOpenBrowser;

  /// No description provided for @galleryBegin.
  ///
  /// In en, this message translates to:
  /// **'To beginning'**
  String get galleryBegin;

  /// No description provided for @galleryCurrent.
  ///
  /// In en, this message translates to:
  /// **'To current'**
  String get galleryCurrent;

  /// No description provided for @linkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied'**
  String get linkCopied;

  /// No description provided for @discussionDoesntContainImages.
  ///
  /// In en, this message translates to:
  /// **'Discussion doesn\'t contain images.'**
  String get discussionDoesntContainImages;

  /// No description provided for @viewAsGallery.
  ///
  /// In en, this message translates to:
  /// **'View as gallery'**
  String get viewAsGallery;

  /// No description provided for @boardEmpty.
  ///
  /// In en, this message translates to:
  /// **'The noticeboard is empty.'**
  String get boardEmpty;

  /// No description provided for @unspecifiedDataError.
  ///
  /// In en, this message translates to:
  /// **'Communication error occurred. Possible reason: access denied. Please send application log from settings menu if you\'re not sure about it.'**
  String get unspecifiedDataError;

  /// No description provided for @addDiscussionToCategoryNoCategories.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any bookmark categories !'**
  String get addDiscussionToCategoryNoCategories;

  /// No description provided for @addDiscussionToCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Add discussion to category'**
  String get addDiscussionToCategoryTitle;

  /// No description provided for @bookTitleBook.
  ///
  /// In en, this message translates to:
  /// **'Add to bookmarks'**
  String get bookTitleBook;

  /// No description provided for @bookTitleUnbook.
  ///
  /// In en, this message translates to:
  /// **'Remove from bookmarks'**
  String get bookTitleUnbook;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsUnreadStyle.
  ///
  /// In en, this message translates to:
  /// **'Unread write-up style'**
  String get settingsUnreadStyle;

  /// No description provided for @settingsUnreadStyleSummary.
  ///
  /// In en, this message translates to:
  /// **'Please choose standard settings or colored.'**
  String get settingsUnreadStyleSummary;

  /// No description provided for @settingsRowPadding.
  ///
  /// In en, this message translates to:
  /// **'Row padding'**
  String get settingsRowPadding;

  /// No description provided for @settingsRowPaddingSummary.
  ///
  /// In en, this message translates to:
  /// **'Please choose row-padding in bookmarks or history'**
  String get settingsRowPaddingSummary;

  /// No description provided for @settingsDisplayRating.
  ///
  /// In en, this message translates to:
  /// **'Display rating'**
  String get settingsDisplayRating;

  /// No description provided for @settingsRatingOff.
  ///
  /// In en, this message translates to:
  /// **'Don\'t display rating controls or rating itself.'**
  String get settingsRatingOff;

  /// No description provided for @settingsRatingOn.
  ///
  /// In en, this message translates to:
  /// **'Always display rating controls or rating itself.'**
  String get settingsRatingOn;

  /// No description provided for @settingsMisc.
  ///
  /// In en, this message translates to:
  /// **'Misc.'**
  String get settingsMisc;

  /// No description provided for @settingsStartup.
  ///
  /// In en, this message translates to:
  /// **'Startup activity'**
  String get settingsStartup;

  /// No description provided for @settingsStartupSummary.
  ///
  /// In en, this message translates to:
  /// **'Please choose what activity will be started at launch.'**
  String get settingsStartupSummary;

  /// No description provided for @settingsReadBookmarks.
  ///
  /// In en, this message translates to:
  /// **'Read in bookmarks'**
  String get settingsReadBookmarks;

  /// No description provided for @settingsReadHistory.
  ///
  /// In en, this message translates to:
  /// **'Read in history'**
  String get settingsReadHistory;

  /// No description provided for @settingsDontDisplay.
  ///
  /// In en, this message translates to:
  /// **'Don\'t display'**
  String get settingsDontDisplay;

  /// No description provided for @settingsAlwaysDisplay.
  ///
  /// In en, this message translates to:
  /// **'Always display'**
  String get settingsAlwaysDisplay;

  /// No description provided for @settingsBackButton.
  ///
  /// In en, this message translates to:
  /// **'Back button'**
  String get settingsBackButton;

  /// No description provided for @settingsBackRegular.
  ///
  /// In en, this message translates to:
  /// **'Use regular'**
  String get settingsBackRegular;

  /// No description provided for @settingsBackWriteups.
  ///
  /// In en, this message translates to:
  /// **'Use to back-navigate between linked write-up(s)'**
  String get settingsBackWriteups;

  /// No description provided for @settingsRefreshAfterSend.
  ///
  /// In en, this message translates to:
  /// **'Refresh after sending writeup'**
  String get settingsRefreshAfterSend;

  /// No description provided for @settingsNever.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get settingsNever;

  /// No description provided for @settingsAlways.
  ///
  /// In en, this message translates to:
  /// **'Always'**
  String get settingsAlways;

  /// No description provided for @settingsReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders in bookmarks'**
  String get settingsReminders;

  /// No description provided for @settingsRemindersOn.
  ///
  /// In en, this message translates to:
  /// **'Are displayed'**
  String get settingsRemindersOn;

  /// No description provided for @settingsRemindersOff.
  ///
  /// In en, this message translates to:
  /// **'Wont be displayed'**
  String get settingsRemindersOff;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsNotificationsOff.
  ///
  /// In en, this message translates to:
  /// **'Custom notification settings'**
  String get settingsNotificationsOff;

  /// No description provided for @settingsNotificationsOn.
  ///
  /// In en, this message translates to:
  /// **'Standard notification settings'**
  String get settingsNotificationsOn;

  /// No description provided for @clearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear cache'**
  String get clearCache;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done !'**
  String get done;

  /// No description provided for @settingsFontSize.
  ///
  /// In en, this message translates to:
  /// **'Fontsize'**
  String get settingsFontSize;

  /// No description provided for @unreadStyleStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get unreadStyleStandard;

  /// No description provided for @unreadStyleRed.
  ///
  /// In en, this message translates to:
  /// **'Colored: red'**
  String get unreadStyleRed;

  /// No description provided for @unreadStyleOrange.
  ///
  /// In en, this message translates to:
  /// **'Colored: orange'**
  String get unreadStyleOrange;

  /// No description provided for @unreadStyleYellow.
  ///
  /// In en, this message translates to:
  /// **'Colored: yellow'**
  String get unreadStyleYellow;

  /// No description provided for @unreadStyleGreen.
  ///
  /// In en, this message translates to:
  /// **'Colored: green'**
  String get unreadStyleGreen;

  /// No description provided for @paddingStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard (0dp)'**
  String get paddingStandard;

  /// No description provided for @paddingGreater.
  ///
  /// In en, this message translates to:
  /// **'Greater (2dp)'**
  String get paddingGreater;

  /// No description provided for @paddingLarge.
  ///
  /// In en, this message translates to:
  /// **'Large (4dp)'**
  String get paddingLarge;

  /// No description provided for @paddingHuge.
  ///
  /// In en, this message translates to:
  /// **'Huge (6dp)'**
  String get paddingHuge;

  /// No description provided for @paddingMega.
  ///
  /// In en, this message translates to:
  /// **'Mega (8dp)'**
  String get paddingMega;

  /// No description provided for @paddingShovel.
  ///
  /// In en, this message translates to:
  /// **'Shovel (16dp)'**
  String get paddingShovel;

  /// No description provided for @shareToDiscussion.
  ///
  /// In en, this message translates to:
  /// **'Share to discussion'**
  String get shareToDiscussion;

  /// No description provided for @reallyWannaShare.
  ///
  /// In en, this message translates to:
  /// **'Really ?'**
  String get reallyWannaShare;

  /// No description provided for @areYouSureYouWannaShareThis.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to share into: {name}'**
  String areYouSureYouWannaShareThis(String name);

  /// No description provided for @additionalMessage.
  ///
  /// In en, this message translates to:
  /// **'Additional message...'**
  String get additionalMessage;

  /// No description provided for @aboutBroughtBy.
  ///
  /// In en, this message translates to:
  /// **'...vám přináší...'**
  String get aboutBroughtBy;

  /// No description provided for @aboutThanks.
  ///
  /// In en, this message translates to:
  /// **'...Poděkování...'**
  String get aboutThanks;

  /// No description provided for @aboutInformation.
  ///
  /// In en, this message translates to:
  /// **'...Informace...'**
  String get aboutInformation;

  /// No description provided for @aboutDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Uživatelská data nejsou používána k jiným účelům než je zprostředkování funkcionality serveru nyx.cz. Autorizace aplikace nevyžaduje heslo, ale potvrzuje se na webovém rozhraní nyxu, kde je možné také autorizaci zrušit například v případě odcizení telefonu. Autor aplikace nenese odpovědnost za škody způsobené užíváním aplikace, byť se snaží jakékoliv problémy minimalizovat.'**
  String get aboutDisclaimer;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSummary.
  ///
  /// In en, this message translates to:
  /// **'Please choose application language.'**
  String get settingsLanguageSummary;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// No description provided for @authorizationStepRequest.
  ///
  /// In en, this message translates to:
  /// **'Request a code'**
  String get authorizationStepRequest;

  /// No description provided for @authorizationStepConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm on nyx.cz'**
  String get authorizationStepConfirm;

  /// No description provided for @authorizationNickLabel.
  ///
  /// In en, this message translates to:
  /// **'Nick / ID'**
  String get authorizationNickLabel;

  /// No description provided for @authorizationCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Authorization code'**
  String get authorizationCodeLabel;

  /// No description provided for @authorizationCopyCode.
  ///
  /// In en, this message translates to:
  /// **'Copy code'**
  String get authorizationCopyCode;

  /// No description provided for @authorizationCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Code copied'**
  String get authorizationCodeCopied;

  /// No description provided for @historyToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get historyToday;

  /// No description provided for @historyYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get historyYesterday;

  /// No description provided for @historyEarlier.
  ///
  /// In en, this message translates to:
  /// **'Earlier'**
  String get historyEarlier;

  /// No description provided for @replyBadge.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 reply} other{{count} replies}}'**
  String replyBadge(int count);

  /// No description provided for @historyMarkRead.
  ///
  /// In en, this message translates to:
  /// **'Mark as read'**
  String get historyMarkRead;

  /// No description provided for @historyRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove from history'**
  String get historyRemove;

  /// No description provided for @historyMarkAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get historyMarkAllRead;

  /// No description provided for @aboutLinks.
  ///
  /// In en, this message translates to:
  /// **'Links'**
  String get aboutLinks;

  /// No description provided for @aboutSourceCode.
  ///
  /// In en, this message translates to:
  /// **'Source code'**
  String get aboutSourceCode;

  /// No description provided for @aboutLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open-source licenses'**
  String get aboutLicenses;

  /// No description provided for @menuSearch.
  ///
  /// In en, this message translates to:
  /// **'search'**
  String get menuSearch;

  /// No description provided for @searchHelp.
  ///
  /// In en, this message translates to:
  /// **'Enter a phrase, or @nick to find posts written by a user, for example \"@nick phrase\".'**
  String get searchHelp;

  /// No description provided for @historyLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get historyLoadMore;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeSummary.
  ///
  /// In en, this message translates to:
  /// **'Please choose the application theme.'**
  String get settingsThemeSummary;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get themeSystem;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsPrivacy;

  /// No description provided for @settingsCrashReporting.
  ///
  /// In en, this message translates to:
  /// **'Crash reports'**
  String get settingsCrashReporting;

  /// No description provided for @settingsCrashReportingOn.
  ///
  /// In en, this message translates to:
  /// **'Crash reports, including your nick, are sent to help fix bugs.'**
  String get settingsCrashReportingOn;

  /// No description provided for @settingsCrashReportingOff.
  ///
  /// In en, this message translates to:
  /// **'Crash reports are not sent.'**
  String get settingsCrashReportingOff;

  /// No description provided for @settingsAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Usage statistics'**
  String get settingsAnalytics;

  /// No description provided for @settingsAnalyticsOn.
  ///
  /// In en, this message translates to:
  /// **'Anonymous usage statistics are sent.'**
  String get settingsAnalyticsOn;

  /// No description provided for @settingsAnalyticsOff.
  ///
  /// In en, this message translates to:
  /// **'Usage statistics are not sent.'**
  String get settingsAnalyticsOff;

  /// No description provided for @errorLoading.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the data.'**
  String get errorLoading;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @draftRestored.
  ///
  /// In en, this message translates to:
  /// **'Draft restored'**
  String get draftRestored;

  /// No description provided for @draftDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get draftDiscard;

  /// No description provided for @settingsHistoryBooked.
  ///
  /// In en, this message translates to:
  /// **'Bookmarked in history'**
  String get settingsHistoryBooked;

  /// No description provided for @settingsHistoryBookedSummary.
  ///
  /// In en, this message translates to:
  /// **'Please choose whether bookmarked discussions are shown in history.'**
  String get settingsHistoryBookedSummary;

  /// No description provided for @historyBookedDefault.
  ///
  /// In en, this message translates to:
  /// **'As on the website'**
  String get historyBookedDefault;

  /// No description provided for @historyBookedShow.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get historyBookedShow;

  /// No description provided for @historyBookedHide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get historyBookedHide;

  /// No description provided for @settingsDensity.
  ///
  /// In en, this message translates to:
  /// **'Display density'**
  String get settingsDensity;

  /// No description provided for @settingsDensitySummary.
  ///
  /// In en, this message translates to:
  /// **'Compact layout saves screen space in lists and posts.'**
  String get settingsDensitySummary;

  /// No description provided for @densityCompact.
  ///
  /// In en, this message translates to:
  /// **'Compact'**
  String get densityCompact;

  /// No description provided for @densityComfortable.
  ///
  /// In en, this message translates to:
  /// **'Comfortable'**
  String get densityComfortable;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['cs', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'cs':
      return AppLocalizationsCs();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
