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
	late final TranslationsGameQueueEn gameQueue = TranslationsGameQueueEn._(_root);
	late final TranslationsConnectionEn connection = TranslationsConnectionEn._(_root);
	late final TranslationsHomeEn home = TranslationsHomeEn._(_root);
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

	/// en: 'Time left'
	String get foundPendingTimeLeft => 'Time left';

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

	/// en: 'The game is running, but its current state can't be identified. Try restarting the client and the application, or join a game manually this time around.'
	String get unknownDescription => 'The game is running, but its current state can\'t be identified.\nTry restarting the client and the application, or join a game manually this time around.';
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

// Path: gameQueue
class TranslationsGameQueueEn {
	TranslationsGameQueueEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Unknown'
	String get unknownPlaceholder => 'Unknown';

	/// en: 'Select Game Queue'
	String get selectButton => 'Select Game Queue';

	/// en: 'Available Queues'
	String get selectionTitle => 'Available Queues';

	/// en: 'CO-OP vs. AI'
	String get selectionAiTitle => 'CO-OP vs. AI';

	late final TranslationsGameQueueGroupLabelEn groupLabel = TranslationsGameQueueGroupLabelEn._(_root);
}

// Path: connection
class TranslationsConnectionEn {
	TranslationsConnectionEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

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

	/// en: 'Unable to connect to the desktop application. Make sure it's running and that both devices are on the same network.'
	String get errorServiceNotFoundDescription => 'Unable to connect to the desktop application. Make sure it\'s running and that both devices are on the same network.';

	/// en: 'Unable to connect to the desktop application.'
	String get errorUnknownDescription => 'Unable to connect to the desktop application.';

	/// en: 'Reconnect'
	String get errorRetry => 'Reconnect';
}

// Path: home
class TranslationsHomeEn {
	TranslationsHomeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Game Mode'
	String get gameModeLabel => 'Game Mode';

	/// en: 'Game State'
	String get gameStateLabel => 'Game State';

	/// en: 'Create Lobby'
	String get createLobbyButton => 'Create Lobby';

	/// en: 'Search Game'
	String get searchGameButton => 'Search Game';

	/// en: 'Leave Lobby'
	String get leaveLobbyButton => 'Leave Lobby';

	/// en: 'Cancel Search'
	String get cancelSearchButton => 'Cancel Search';

	/// en: 'Accept Game'
	String get acceptGameButton => 'Accept Game';

	/// en: 'Decline Game'
	String get declineGameButton => 'Decline Game';
}

// Path: gameQueue.groupLabel
class TranslationsGameQueueGroupLabelEn {
	TranslationsGameQueueGroupLabelEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Summonter's Rift'
	String get summonersRift => 'Summonter\'s Rift';

	/// en: 'ARAM'
	String get aram => 'ARAM';

	/// en: 'Alternative'
	String get alternative => 'Alternative';

	/// en: 'Other'
	String get other => 'Other';
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
			case 'gameState.foundPendingTimeLeft': return 'Time left';
			case 'gameState.foundAcceptedTitle': return 'Game accepted';
			case 'gameState.foundAcceptedDescription': return 'Waiting for other players to join before starting the game.';
			case 'gameState.foundDeclinedTitle': return 'Game declined';
			case 'gameState.foundDeclinedDescription': return 'Waiting for the game to cancel before returning to the lobby.';
			case 'gameState.inGameTitle': return 'Game in progress';
			case 'gameState.inGameDescription': return 'Wait for the current game to finish before queueing again.';
			case 'gameState.unknownTitle': return 'Unknown game state';
			case 'gameState.unknownDescription': return 'The game is running, but its current state can\'t be identified.\nTry restarting the client and the application, or join a game manually this time around.';
			case 'gameError.unableToConnectTitle': return 'Unable to connect';
			case 'gameError.unableToConnectDescription': return 'The game client could not be reached. Make sure that it is running to interact with the game.';
			case 'gameError.unknownTitle': return 'Unknown game state';
			case 'gameError.unknownDescription': return 'The game\'s state could not be accessed due to an unexpected error.';
			case 'gameQueue.unknownPlaceholder': return 'Unknown';
			case 'gameQueue.selectButton': return 'Select Game Queue';
			case 'gameQueue.selectionTitle': return 'Available Queues';
			case 'gameQueue.selectionAiTitle': return 'CO-OP vs. AI';
			case 'gameQueue.groupLabel.summonersRift': return 'Summonter\'s Rift';
			case 'gameQueue.groupLabel.aram': return 'ARAM';
			case 'gameQueue.groupLabel.alternative': return 'Alternative';
			case 'gameQueue.groupLabel.other': return 'Other';
			case 'connection.connectingTitle': return 'Connecting...';
			case 'connection.connectingDescription': return 'Initializing communication with the game client.';
			case 'connection.loadingTitle': return 'Checking game state...';
			case 'connection.loadingDescription': return 'Awaiting details about the current game session.';
			case 'connection.errorTitle': return 'Connection error';
			case 'connection.errorServiceNotFoundDescription': return 'Unable to connect to the desktop application. Make sure it\'s running and that both devices are on the same network.';
			case 'connection.errorUnknownDescription': return 'Unable to connect to the desktop application.';
			case 'connection.errorRetry': return 'Reconnect';
			case 'home.gameModeLabel': return 'Game Mode';
			case 'home.gameStateLabel': return 'Game State';
			case 'home.createLobbyButton': return 'Create Lobby';
			case 'home.searchGameButton': return 'Search Game';
			case 'home.leaveLobbyButton': return 'Leave Lobby';
			case 'home.cancelSearchButton': return 'Cancel Search';
			case 'home.acceptGameButton': return 'Accept Game';
			case 'home.declineGameButton': return 'Decline Game';
			default: return null;
		}
	}
}

