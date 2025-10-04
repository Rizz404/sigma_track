import 'package:sigma_track/feature/user/data/models/user_model.dart';

/// Contoh penggunaan Model Parsing Extension (Versi Simple & Natural)
void main() {
  print('\n========== Contoh 1: Data Valid ==========');
  final validData = {
    'id': '123',
    'name': 'john_doe',
    'email': 'john@example.com',
    'fullName': 'John Doe',
    'role': 'Employee',
    'employeeId': 'EMP001',
    'preferredLang': 'en',
    'isActive': true,
    'avatarUrl': 'https://example.com/avatar.jpg',
    'FCMToken': 'fcm_token_123',
    'createdAt': '2024-01-01T00:00:00.000Z',
    'updatedAt': '2024-01-02T00:00:00.000Z',
  };

  final user1 = UserModel.fromMap(validData);
  print('✓ Result: ${user1.name}');

  print('\n========== Contoh 2: Type Mismatch (isActive) ==========');
  final typeMismatchData = {
    'id': '124',
    'name': 'jane_doe',
    'email': 'jane@example.com',
    'fullName': 'Jane Doe',
    'role': 'Admin',
    'preferredLang': 'id',
    'isActive': 'true', // * String instead of bool - akan error
    'createdAt': '2024-01-01T00:00:00.000Z',
    'updatedAt': '2024-01-02T00:00:00.000Z',
  };

  try {
    final user2 = UserModel.fromMap(typeMismatchData);
    print('✓ Result: ${user2.name}');
  } catch (e) {
    print('❌ Parsing failed as expected: $e');
  }

  print('\n========== Contoh 3: Missing Required Field ==========');
  final missingFieldsData = {
    'id': '125',
    'name': 'bob',
    'email': 'bob@example.com',
    'fullName': 'Bob Smith',
    'role': 'Staff',
    // * preferredLang missing - akan error karena required
    'isActive': true,
    'createdAt': '2024-01-01T00:00:00.000Z',
    'updatedAt': '2024-01-02T00:00:00.000Z',
  };

  try {
    final user3 = UserModel.fromMap(missingFieldsData);
    print('✓ Result: ${user3.name}');
  } catch (e) {
    print('❌ Parsing failed as expected: $e');
  }

  print('\n========== Contoh 4: Missing Nullable Field (OK) ==========');
  final missingNullableData = {
    'id': '126',
    'name': 'alice',
    'email': 'alice@example.com',
    'fullName': 'Alice Wonder',
    'role': 'Employee',
    'preferredLang': 'ja',
    'isActive': true,
    // * avatarUrl & employeeId missing - OK karena nullable
    'createdAt': '2024-01-01T00:00:00.000Z',
    'updatedAt': '2024-01-02T00:00:00.000Z',
  };

  final user4 = UserModel.fromMap(missingNullableData);
  print('✓ Result: ${user4.name}, avatar: ${user4.avatarUrl}');

  print('\n========== Contoh 5: DateTime Formats ==========');
  final dateTimeData = {
    'id': '127',
    'name': 'charlie',
    'email': 'charlie@example.com',
    'fullName': 'Charlie Brown',
    'role': 'Employee',
    'preferredLang': 'en',
    'isActive': true,
    'createdAt': 1704067200000, // * Milliseconds timestamp
    'updatedAt': '2024-01-02T00:00:00.000Z', // * ISO string
  };

  final user5 = UserModel.fromMap(dateTimeData);
  print('✓ Result: ${user5.name}, created: ${user5.createdAt}');

  print('\n========== Contoh 6: Invalid DateTime Format ==========');
  final invalidDateData = {
    'id': '128',
    'name': 'david',
    'email': 'david@example.com',
    'fullName': 'David Lee',
    'role': 'Employee',
    'preferredLang': 'en',
    'isActive': true,
    'createdAt': 'invalid-date-format', // * Invalid date
    'updatedAt': '2024-01-02T00:00:00.000Z',
  };

  try {
    final user6 = UserModel.fromMap(invalidDateData);
    print('✓ Result: ${user6.name}');
  } catch (e) {
    print('❌ Parsing failed as expected: $e');
  }

  print('\n========== Selesai ==========');
  print('Extension akan otomatis log error detail ke console/logger');
}
