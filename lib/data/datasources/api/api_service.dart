import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile_lms/config/constant/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio dio = Dio();

  Future<Response?> login(
      {required String username, required String password}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Response<dynamic>? res;

    try {
      FormData data = FormData.fromMap({"user": username, "pass": password});

      var response = await dio.post(
        baseUrl,
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            'Accept': 'application/json',
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! <= 500;
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = Map<String, dynamic>.from(jsonDecode(response.data));
        prefs.setString('token', data['token']);

        res = response;
      }
    } on DioError catch (e) {
      if (e.response != null) {
        debugPrint('Dio error!');
        debugPrint('STATUS: ${e.response?.statusCode}');
      } else {
        // Error due to setting up or sending the request
        debugPrint('Error sending request!');
        debugPrint(e.message);
      }
    }
    return res;
  }
}
