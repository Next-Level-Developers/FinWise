import '../entities/profile_info.dart';

abstract class ProfileRepository {
  Future<ProfileInfo> getProfileInfo();
}
