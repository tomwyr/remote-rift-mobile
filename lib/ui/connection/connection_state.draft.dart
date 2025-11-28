// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark, must_be_immutable

part of 'connection_state.dart';

// **************************************************************************
// DraftGenerator
// **************************************************************************

class ConnectionErrorDraft implements ConnectionError {
  // Mutable fields
  bool reconnectTriggered;

  // Getters and setters for nested draftable fields

  ConnectionErrorDraft({required this.reconnectTriggered});

  ConnectionError save() =>
      ConnectionError(reconnectTriggered: reconnectTriggered);
}

extension ConnectionErrorDraftExtension on ConnectionError {
  ConnectionErrorDraft draft() =>
      ConnectionErrorDraft(reconnectTriggered: this.reconnectTriggered);
  ConnectionError produce(void Function(ConnectionErrorDraft draft) producer) {
    final draft = this.draft();
    producer(draft);
    return draft.save();
  }
}
