import 'package:get_storage/get_storage.dart';

class LocalStorageService {
  static final _storage = GetStorage('Netvetta');

  static String get phoneNumber => _storage.read('phoneNumber') ?? '';

  static set phoneNumber(String value) => _storage.write('phoneNumber', value);

  static String get password => _storage.read('password') ?? '';

  static set password(String value) => _storage.write('password', value);

  static bool get isLoggedIn => _storage.read('isLoggedIn') ?? false;

  static set isLoggedIn(bool value) => _storage.write('isLoggedIn', value);
}
