import 'package:remote_rift_core/remote_rift_core.dart';

import '../i18n/strings.g.dart';

extension RemoteRiftErrorStrings on RemoteRiftError {
  String get title => switch (this) {
    .unableToConnect => t.gameError.unableToConnectTitle,
    .unknown => t.gameError.unknownTitle,
  };

  String get description => switch (this) {
    .unableToConnect => t.gameError.unableToConnectDescription,
    .unknown => t.gameError.unknownDescription,
  };
}

extension GameQueueGroupStrings on GameQueueGroup {
  String get displayName => switch (this) {
    .summonersRift => t.gameQueue.groupLabel.summonersRift,
    .aram => t.gameQueue.groupLabel.aram,
    .alternative => t.gameQueue.groupLabel.alternative,
    .other => t.gameQueue.groupLabel.other,
  };
}
