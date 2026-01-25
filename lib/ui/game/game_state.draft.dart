// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark, must_be_immutable

part of 'game_state.dart';

// **************************************************************************
// DraftGenerator
// **************************************************************************

class DataDraft implements Data {
  // Mutable fields
  String? queueName;
  RemoteRiftState state;
  bool loading;

  // Getters and setters for nested draftable fields

  DataDraft({
    required this.queueName,
    required this.state,
    required this.loading,
  });

  Data save() => Data(queueName: queueName, state: state, loading: loading);

  @override
  List<Object?> get props => save().props;
  @override
  bool? get stringify => save().stringify;
  @override
  int get hashCode => save().hashCode;

  @override
  String toString() => save().toString();
}

extension DataDraftExtension on Data {
  DataDraft draft() => DataDraft(
    queueName: this.queueName,
    state: this.state,
    loading: this.loading,
  );
  Data produce(void Function(DataDraft draft) producer) {
    final draft = this.draft();
    producer(draft);
    return draft.save();
  }
}
