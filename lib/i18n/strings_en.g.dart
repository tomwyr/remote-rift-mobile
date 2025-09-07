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
	String get preGame => 'Pre game';

	/// en: 'Lobby'
	String get lobbyIdle => 'Lobby';

	/// en: 'Searching game'
	String get lobbySearching => 'Searching game';

	/// en: 'Game found'
	String get foundPending => 'Game found';

	/// en: 'Game accepted'
	String get foundAccepted => 'Game accepted';

	/// en: 'Game declined'
	String get foundDeclined => 'Game declined';

	/// en: 'In game'
	String get inGame => 'In game';

	/// en: 'Unknown'
	String get unknown => 'Unknown';
}

// Path: home
class TranslationsHomeEn {
	TranslationsHomeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

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

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'app.title': return 'Remote Rift';
			case 'gameState.preGame': return 'Pre game';
			case 'gameState.lobbyIdle': return 'Lobby';
			case 'gameState.lobbySearching': return 'Searching game';
			case 'gameState.foundPending': return 'Game found';
			case 'gameState.foundAccepted': return 'Game accepted';
			case 'gameState.foundDeclined': return 'Game declined';
			case 'gameState.inGame': return 'In game';
			case 'gameState.unknown': return 'Unknown';
			case 'home.createLobbyButton': return 'Create lobby';
			case 'home.searchGameButton': return 'Search game';
			case 'home.leaveLobbyButton': return 'Leave lobby';
			case 'home.cancelSearchButton': return 'Cancel search';
			case 'home.acceptGameButton': return 'Accept game';
			case 'home.declineGameButton': return 'Decline game';
			default: return null;
		}
	}
}

