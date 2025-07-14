// ignore_for_file: no_leading_underscores_for_local_identifiers, unnecessary_null_comparison, constant_identifier_names, depend_on_referenced_packages, implementation_imports

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/src/media_type.dart';
import 'package:norsk_tolk/common/toast.dart';
import 'package:norsk_tolk/utils/app_constns.dart';

class ApiClient {
  final int timeoutInSeconds = 30;

  final Map<String, String> _mainHeaders = {
    "Content-Type": "application/json",
    'Accept': 'application/json',
  };

  Future<http.Response?> getData(String uri,
      {Map<String, String>? headers, bool dismis = true, bool uriOnly = false}) async {
    try {
      final String url = uriOnly ? uri : AppConstns.gptToke + uri;
      debugPrint('====> API Call: $url\nHeader: $_mainHeaders');
      http.Response response =
          await http.get(Uri.parse(url), headers: headers ?? _mainHeaders).timeout(Duration(seconds: timeoutInSeconds));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      } else {
        if (kDebugMode) {
          log('Response: ${response.body}');
        }
        return handleError(response.body, response.statusCode, url: url);
      }
    } catch (e) {
      socketException(e, AppConstns.gptToke + uri);
      return null;
    }
  }

  Future<http.Response?> postData(
    String uri,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    try {
      debugPrint('====> API Call: ${AppConstns.gptToke + uri}\nHeader:  ${headers ?? _mainHeaders}');
      debugPrint('====> API Body: $body');
      http.Response response = await http
          .post(
            Uri.parse(AppConstns.gptToke + uri),
            body: jsonEncode(body),
            headers: headers ?? _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        dismiss();
        return response;
      } else {
        if (kDebugMode) {
          log('Response: ${response.body}');
        }
        return handleError(response.body, response.statusCode);
      }
    } catch (e) {
      log(e.toString());
      dismiss();
      socketException(e, AppConstns.gptToke + uri);
      return null;
    }
  }

  socketException(Object e, String url) {
    if (e is SocketException) {
      showToast('check_internet_connection');
    } else {
      log("Error Url: $url,\n");
      showToast('something_went_wrong');
    }
  }

  handleError(String body, int statusCode, {String? url}) {
    debugPrint("Here is body $statusCode $body");
    if (statusCode == 401) {
      return null;
    }
    String message = '';
    // try {
    //   ErrorResponse errorResponse = ErrorResponse.fromJson(jsonDecode(body));
    //   message = errorResponse.errors[0].message;
    // } catch (e) {
    //   message = jsonDecode(body)['message'];
    // }
    dismiss();
    showToast(message);
    return null;
  }

  MediaType _handleContentType(String? mimeType) {
    if (mimeType == null || mimeType.isEmpty) {
      throw Exception('MIME type is null or empty');
    }

    switch (mimeType.toLowerCase()) {
      // Image file types
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');
      case 'gif':
        return MediaType('image', 'gif');
      case 'bmp':
        return MediaType('image', 'bmp');
      case 'webp':
        return MediaType('image', 'webp');

      // Document file types
      case 'pdf':
        return MediaType('application', 'pdf');
      case 'doc':
        return MediaType('application', 'msword');
      case 'docx':
        return MediaType('application', 'vnd.openxmlformats-officedocument.wordprocessingml.document');
      case 'xls':
        return MediaType('application', 'vnd.ms-excel');
      case 'xlsx':
        return MediaType('application', 'vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      case 'ppt':
        return MediaType('application', 'vnd.ms-powerpoint');
      case 'pptx':
        return MediaType('application', 'vnd.openxmlformats-officedocument.presentationml.presentation');
      case 'txt':
        return MediaType('text', 'plain');
      case 'csv':
        return MediaType('text', 'csv');

      // Audio file types
      case 'mp3':
        return MediaType('audio', 'mpeg');
      case 'wav':
        return MediaType('audio', 'wav');
      case 'ogg':
        return MediaType('audio', 'ogg');
      case 'm4a':
        return MediaType('audio', 'mp4');

      // Video file types
      case 'mp4':
        return MediaType('video', 'mp4');
      case 'mov':
        return MediaType('video', 'quicktime');
      case 'avi':
        return MediaType('video', 'x-msvideo');
      case 'wmv':
        return MediaType('video', 'x-ms-wmv');
      case 'mkv':
        return MediaType('video', 'x-matroska');

      // Default case for unhandled types
      default:
        throw Exception('Unsupported MIME type: $mimeType');
    }
  }
}
