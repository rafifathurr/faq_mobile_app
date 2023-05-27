import 'package:dio/dio.dart';
import 'package:test_code/global/variable.dart';

Future<Response<dynamic>?> post_login(String email, String password) async {
  try {
    response = await dio.post(
      baseUrl + "auth/login",
      data: {
        'nip': email,
        'password': password,
      },
    );
    return response;
  } catch (e) {
    logger.e(e);
  }
}

Future<Response<dynamic>?> post_faq(
    String token, String pertanyaan, String jawaban, bool stat) async {
  try {
    response = await dio.post(
      baseUrl + "superadmin/faq",
      data: {
        'pertanyaan': pertanyaan,
        'jawaban': jawaban,
        'status_publish': stat,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
    return response;
  } catch (e) {
    logger.e(e);
  }
}

Future<Response<dynamic>?> detail_faq(String token, int faq) async {
  try {
    response = await dio.get(
      baseUrl + "superadmin/faq/$faq",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
    return response;
  } catch (e) {
    logger.e(e);
  }
}

Future<Response<dynamic>?> edit_faq(
    String token, int faq, String pertanyaan, String jawaban, bool stat) async {
  try {
    response = await dio.post(
      baseUrl + "superadmin/faq/$faq",
      data: {
        'pertanyaan': pertanyaan,
        'jawaban': jawaban,
        'status_publish': stat,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
    return response;
  } catch (e) {
    logger.e(e);
  }
}

Future<Response<dynamic>?> delete_faq(String token, int faq) async {
  try {
    response = await dio.delete(
      baseUrl + "superadmin/faq/$faq",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
    return response;
  } catch (e) {
    logger.e(e);
  }
}

Future<Response<dynamic>?> post_logout(String token) async {
  try {
    response = await dio.post(
      baseUrl + "auth/logout",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
    return response;
  } catch (e) {
    logger.e(e);
  }
}
