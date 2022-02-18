import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

import 'package:crypto/crypto.dart';
import 'package:hex/hex.dart';

///数据解析回调
typedef T JsonParse<T>(dynamic data);

class FlutterTencentOcr {
  /// 发起请求
  /// findProxy是否开启抓包代理
  static Future<T> ocrRequest<T>(
    String secretId,
    String secretKey,
    String action,
    requestDataJson, {
    JsonParse<T> jsonParse,
    String service = "ocr",
    String host = "ocr.tencentcloudapi.com",
    String algorithm = "TC3-HMAC-SHA256",
    String contentType = "application/json; charset=utf-8",
    String version = "2018-11-19",
    String region = "ap-guangzhou",
    String findProxy,
  }) async {
    DateTime nowTime = DateTime.now();
    String date =
        "${nowTime.year}-${nowTime.month.toString().padLeft(2, '0')}-${nowTime.day.toString().padLeft(2, '0')}";
    String timestamp = "${nowTime.millisecondsSinceEpoch ~/ 1000}";

    // ************* 步骤 1：拼接规范请求串 *************
    String httpRequestMethod = "POST";
    String canonicalUri = "/";
    String canonicalQueryString = "";
    String canonicalHeaders = "content-type:$contentType\nhost:$host\n";

    String signedHeaders = "content-type;host";

    String payloadJson = requestDataJson;
    // print("payloadJson :  $payloadJson\n\n");

    var payload = sha256.convert(utf8.encode(payloadJson));

    String hashedRequestPayload = payload.toString();

    String canonicalRequest = httpRequestMethod +
        '\n' +
        canonicalUri +
        '\n' +
        canonicalQueryString +
        '\n' +
        canonicalHeaders +
        '\n' +
        signedHeaders +
        '\n' +
        hashedRequestPayload;

    // print("canonicalRequest : $canonicalRequest \n\n");

    // ************* 步骤 2：拼接待签名字符串 *************
    String credentialScope = "$date/$service/tc3_request";

    var hashedCanonicalRequest = sha256.convert(utf8.encode(canonicalRequest));

    String stringToSign = algorithm +
        "\n" +
        timestamp +
        "\n" +
        credentialScope +
        "\n" +
        hashedCanonicalRequest.toString();

    // print("stringToSign : $stringToSign \n\n");

    // ************* 步骤 3：计算签名 *************

    var secretDate = hmac256(utf8.encode("TC3$secretKey"), date);
    var secretService = hmac256(secretDate, service);
    var secretSigning = hmac256(secretService, "tc3_request");

    String signature =
        HEX.encode(hmac256(secretSigning, stringToSign)).toLowerCase();

    // print("signature : $signature \n\n");

    // ************* 步骤 4：拼接 Authorization *************
    String authorization = algorithm +
        " " +
        "Credential=" +
        secretId +
        "/" +
        credentialScope +
        ", " +
        "SignedHeaders=" +
        signedHeaders +
        ", " +
        "Signature=" +
        signature;

    // print("authorization : $authorization");

    var headers = {
      'Host': host,
      'X-TC-Action': action,
      'X-TC-Timestamp': timestamp,
      'X-TC-Version': version,
      'X-TC-Region': region,
      'X-TC-Language': 'zh-CN',
      'Content-Type': contentType,
      'Authorization': authorization,
    };

    try {
      Dio dio = Dio();

      if (findProxy != null) {
        (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
            (client) {
          client.findProxy = (uri) {
            return "PROXY $findProxy";
          };
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) {
            return true;
          };
        };
      }

      Response<Map<String, dynamic>> response = await dio.post('https://$host/',
          options: Options(
            headers: headers,
            method: "POST",
          ),
          data: payloadJson);

      if (response.data["Response"] != null) {
        if (jsonParse != null) {
          return jsonParse(response.data["Response"]);
        } else {
          return response.data["Response"];
        }
      } else {
        throw (Future.error(
            DioError(error: "腾讯OCR数据下发格式异常", requestOptions: null)));
      }
    } on DioError catch (e) {
      throw (Future.error(e));
    } catch (e) {
      throw (Future.error(e));
    }
  }

  static String sha256Hex(String s) {
    var bytes = utf8.encode(s);

    var digest = sha256.convert(bytes);
    return HEX.encode(digest.bytes).toLowerCase();
  }

  static List<int> hmac256(List<int> key, String msgStr) {
    var bytes = utf8.encode(msgStr);

    var hmacSha256 = new Hmac(sha256, key);
    var digest = hmacSha256.convert(bytes);

    return digest.bytes;
  }
}
