///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations implements BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final TranslationsAppEn app = TranslationsAppEn._(_root);
	late final TranslationsGameStateEn gameState = TranslationsGameStateEn._(_root);
	late final TranslationsGameErrorEn gameError = TranslationsGameErrorEn._(_root);
	late final TranslationsConnectionEn connection = TranslationsConnectionEn._(_root);
	late final TranslationsHomeEn home = TranslationsHomeEn._(_root);
	late final TranslationsSettingsEn settings = TranslationsSettingsEn._(_root);
}

// Path: app
class TranslationsAppEn {
	TranslationsAppEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Remote Rift'
	String get title => 'Remote Rift';
}

// Path: gameState
class TranslationsGameStateEn {
	TranslationsGameStateEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Pre game'
	String get preGameTitle => 'Pre game';

	/// en: 'Create a lobby to start queuing for a game.'
	String get preGameDescription => 'Create a lobby to start queuing for a game.';

	/// en: 'In lobby'
	String get lobbyIdleTitle => 'In lobby';

	/// en: 'Start matchmaking to search for a game.'
	String get lobbyIdleDescription => 'Start matchmaking to search for a game.';

	/// en: 'Searching game'
	String get lobbySearchingTitle => 'Searching game';

	/// en: 'Wait for matchmaking to find a suitable game.'
	String get lobbySearchingDescription => 'Wait for matchmaking to find a suitable game.';

	/// en: 'Game found'
	String get foundPendingTitle => 'Game found';

	/// en: 'Waiting for confirmation to join the game.'
	String get foundPendingDescription => 'Waiting for confirmation to join the game.';

	/// en: 'Game accepted'
	String get foundAcceptedTitle => 'Game accepted';

	/// en: 'Waiting for other players to join before starting the game.'
	String get foundAcceptedDescription => 'Waiting for other players to join before starting the game.';

	/// en: 'Game declined'
	String get foundDeclinedTitle => 'Game declined';

	/// en: 'Waiting for the game to cancel before returning to the lobby.'
	String get foundDeclinedDescription => 'Waiting for the game to cancel before returning to the lobby.';

	/// en: 'Game in progress'
	String get inGameTitle => 'Game in progress';

	/// en: 'Wait for the current game to finish before queueing again.'
	String get inGameDescription => 'Wait for the current game to finish before queueing again.';

	/// en: 'Unknown game state'
	String get unknownTitle => 'Unknown game state';

	/// en: 'The game is running, but its current state can't be identified. Try restarting the client and the app, or join a game manually this time around.'
	String get unknownDescription => 'The game is running, but its current state can\'t be identified.\nTry restarting the client and the app, or join a game manually this time around.';
}

// Path: gameError
class TranslationsGameErrorEn {
	TranslationsGameErrorEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Unable to connect'
	String get unableToConnectTitle => 'Unable to connect';

	/// en: 'The game client could not be reached. Make sure that it is running to interact with the game.'
	String get unableToConnectDescription => 'The game client could not be reached. Make sure that it is running to interact with the game.';

	/// en: 'Unknown game state'
	String get unknownTitle => 'Unknown game state';

	/// en: 'The game's state could not be accessed due to an unexpected error.'
	String get unknownDescription => 'The game\'s state could not be accessed due to an unexpected error.';
}

// Path: connection
class TranslationsConnectionEn {
	TranslationsConnectionEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Configuration required'
	String get configurationRequiredTitle => 'Configuration required';

	/// en: 'Setup game connection in the settings panel.'
	String get configurationRequiredDescription => 'Setup game connection in the settings panel.';

	/// en: 'Connecting...'
	String get connectingTitle => 'Connecting...';

	/// en: 'Initializing communication with the game client.'
	String get connectingDescription => 'Initializing communication with the game client.';

	/// en: 'Checking game state...'
	String get loadingTitle => 'Checking game state...';

	/// en: 'Awaiting details about the current game session.'
	String get loadingDescription => 'Awaiting details about the current game session.';

	/// en: 'Connection error'
	String get errorTitle => 'Connection error';

	/// en: 'Unable to connect to the game client.'
	String get errorDescription => 'Unable to connect to the game client.';

	/// en: 'Reconnect'
	String get errorRetry => 'Reconnect';
}

// Path: home
class TranslationsHomeEn {
	TranslationsHomeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Configure'
	String get configureButton => 'Configure';

	/// en: 'Create lobby'
	String get createLobbyButton => 'Create lobby';

	/// en: 'Search game'
	String get searchGameButton => 'Search game';

	/// en: 'Leave lobby'
	String get leaveLobbyButton => 'Leave lobby';

	/// en: 'Cancel search'
	String get cancelSearchButton => 'Cancel search';

	/// en: 'Accept game'
	String get acceptGameButton => 'Accept game';

	/// en: 'Decline game'
	String get declineGameButton => 'Decline game';
}

// Path: settings
class TranslationsSettingsEn {
	TranslationsSettingsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get title => 'Settings';

	/// en: 'Save'
	String get saveButton => 'Save';

	/// en: 'Undo'
	String get undoButton => 'Undo';

	/// en: 'Api address'
	String get apiAddressTitle => 'Api address';

	/// en: 'Enter the IP address and port of the Remote Rift desktop app running on your computer.'
	String get apiAddressDescription => 'Enter the IP address and port of the Remote Rift desktop app running on your computer.';

	/// en: 'IP:Port'
	String get apiAddressHint => 'IP:Port';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return _flatMapFunction$0(path);
	}

	dynamic _flatMapFunction$0(String path) {
		switch (path) {
			case 'app.title': return 'Remote Rift';
			case 'gameState.preGameTitle': return 'Pre game';
			case 'gameState.preGameDescription': return 'Create a lobby to start queuing for a game.';
			case 'gameState.lobbyIdleTitle': return 'In lobby';
			case 'gameState.lobbyIdleDescription': return 'Start matchmaking to search for a game.';
			case 'gameState.lobbySearchingTitle': return 'Searching game';
			case 'gameState.lobbySearchingDescription': return 'Wait for matchmaking to find a suitable game.';
			case 'gameState.foundPendingTitle': return 'Game found';
			case 'gameState.foundPendingDescription': return 'Waiting for confirmation to join the game.';
			case 'gameState.foundAcceptedTitle': return 'Game accepted';
			case 'gameState.foundAcceptedDescription': return 'Waiting for other players to join before starting the game.';
			case 'gameState.foundDeclinedTitle': return 'Game declined';
			case 'gameState.foundDeclinedDescription': return 'Waiting for the game to cancel before returning to the lobby.';
			case 'gameState.inGameTitle': return 'Game in progress';
			case 'gameState.inGameDescription': return 'Wait for the current game to finish before queueing again.';
			case 'gameState.unknownTitle': return 'Unknown game state';
			case 'gameState.unknownDescription': return 'The game is running, but its current state can\'t be identified.\nTry restarting the client and the app, or join a game manually this time around.';
			case 'gameError.unableToConnectTitle': return 'Unable to connect';
			case 'gameError.unableToConnectDescription': return 'The game client could not be reached. Make sure that it is running to interact with the game.';
			case 'gameError.unknownTitle': return 'Unknown game state';
			case 'gameError.unknownDescription': return 'The game\'s state could not be accessed due to an unexpected error.';
			case 'connection.configurationRequiredTitle': return 'Configuration required';
			case 'connection.configurationRequiredDescription': return 'Setup game connection in the settings panel.';
			case 'connection.connectingTitle': return 'Connecting...';
			case 'connection.connectingDescription': return 'Initializing communication with the game client.';
			case 'connection.loadingTitle': return 'Checking game state...';
			case 'connection.loadingDescription': return 'Awaiting details about the current game session.';
			case 'connection.errorTitle': return 'Connection error';
			case 'connection.errorDescription': return 'Unable to connect to the game client.';
			case 'connection.errorRetry': return 'Reconnect';
			case 'home.configureButton': return 'Configure';
			case 'home.createLobbyButton': return 'Create lobby';
			case 'home.searchGameButton': return 'Search game';
			case 'home.leaveLobbyButton': return 'Leave lobby';
			case 'home.cancelSearchButton': return 'Cancel search';
			case 'home.acceptGameButton': return 'Accept game';
			case 'home.declineGameButton': return 'Decline game';
			case 'settings.title': return 'Settings';
			case 'settings.saveButton': return 'Save';
			case 'settings.undoButton': return 'Undo';
			case 'settings.apiAddressTitle': return 'Api address';
			case 'settings.apiAddressDescription': return 'Enter the IP address and port of the Remote Rift desktop app running on your computer.';
			case 'settings.apiAddressHint': return 'IP:Port';
			default: return null;
		}
	}
}

