import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';

@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    required String email,
    required String name,
    String? avatarUrl,
    required DateTime memberSince,
    @Default(false) bool isPremium,
  }) = _UserEntity;
}
