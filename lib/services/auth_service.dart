import 'dart:convert';
import 'package:bank_sha/models/sign_in_form_model.dart';
import 'package:bank_sha/models/sign_up_form_model.dart';
import 'package:bank_sha/models/user_model.dart';
import 'package:bank_sha/shared/shared_values.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future checkEmail(String email) async {
    try {
      final res = await http
          .post(Uri.parse('$baseUrl/is-email-exist'), body: {'email': email});
      if (res.statusCode == 200) {
        return jsonDecode(res.body)['is_email_exist'];
      } else {
        throw jsonDecode(res.body)['errors']['email'][0];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModel> register(SignUpFormModel data) async {
    try {
      final res =
          await http.post(Uri.parse('$baseUrl/register'), body: data.toJson());
      if (res.statusCode == 200) {
        UserModel user = UserModel.fromJson(jsonDecode(res.body));
        user = user.copyWith(password: data.password);
        await storeCredentialToLocal(user);
        return user;
      } else {
        throw jsonDecode(res.body)['message'];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModel> login(SignInFormModel data) async {
    try {
      final res =
          await http.post(Uri.parse('$baseUrl/login'), body: data.toJson());
      if (res.statusCode == 200) {
        UserModel user = UserModel.fromJson(jsonDecode(res.body));
        user = user.copyWith(password: data.password);
        await storeCredentialToLocal(user);
        return user;
      } else {
        throw jsonDecode(res.body)['message'];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> logout() async {
    try {
      //Mengambil token terlebih dahulu
      final token = await getToken();
      final res = await http.post(Uri.parse('$baseUrl/logout'),
          headers: {'Authorization': token});
      if (res.statusCode == 200) {
        await clearLocalStorage();
      } else {
        throw jsonDecode(res.body)['message'];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> storeCredentialToLocal(UserModel user) async {
    try {
      const storage = FlutterSecureStorage();
      await storage.write(key: 'token', value: user.token);
      await storage.write(key: 'email', value: user.email);
      await storage.write(key: 'password', value: user.password);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<SignInFormModel> getCredentialFromLocal() async {
    try {
      const storage = FlutterSecureStorage();
      Map<String, String> values = await storage.readAll();

      if (values['email'] == null || values['password'] == null) {
        throw 'unauthenticated';
      } else {
        final SignInFormModel data = SignInFormModel(
          email: values['email'],
          password: values['password'],
        );

        return data;
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> getToken() async {
    String token = '';

    const storage = FlutterSecureStorage();
    String? value = await storage.read(key: 'token');

    if (value != null) {
      token = 'Bearer $value';
    }

    return token;
  }

  Future<void> clearLocalStorage() async {
    const storage = FlutterSecureStorage();
    await storage.deleteAll();
  }
}
