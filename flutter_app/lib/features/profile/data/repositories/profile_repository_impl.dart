import '../../domain/entities/profile_info.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  @override
  Future<ProfileInfo> getProfileInfo() async {
    return const ProfileInfo(
      name: 'Terry Melton',
      email: 'melton89@gmail.com',
      phone: '+1 201 555-0123',
      address: '70 Rainey Street, Apartment 146, Austin TX 78701',
    );
  }
}
