import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:taojuwu/application.dart';
import 'package:taojuwu/config/net_config.dart';

// import 'package:taojuwu/constants/constants.dart';
import 'package:taojuwu/utils/toast_kit.dart';

// import 'package:taojuwu/repository/user/user_info_model.dart';

class Xhr {
  static Xhr xhr = Xhr._internal();

  static Dio dio = Dio(BaseOptions(
      headers: NetConfig.headers,
      queryParameters: NetConfig.queryParameters,
      sendTimeout: NetConfig.TIME_OUT,
      receiveTimeout: NetConfig.TIME_OUT,
      connectTimeout: NetConfig.TIME_OUT,
      baseUrl: NetConfig.baseUrl))
    ..interceptors.addAll([
      InterceptorsWrapper(onRequest: (RequestOptions options) {
        // Do something before request is sent

        return options; //continue
      }, onResponse: (Response response) {
        // bool flag = response != null &&
        //     response.data is Map &&
        //     response.data["code"] == "-999";

        // if (response != null &&
        //     response.data is Map &&
        //     response.data["code"] == "-999") {
        //   RouteHandler.goLoginPage(Application.context);
        //   return;
        // }
        response.data = jsonDecode(response.toString());
      }),
    ]);
  // 添加缓存

  Xhr._internal();
  static Xhr get instance {
    return xhr;
  }

  get(
    context,
    url, {
    params,
    options,
    extra,
    cancelToken,
    bool isShowLoading = true,
  }) async {
    try {
      dio.options.queryParameters['token'] = Application.sp.getString('token');
      return await dio.get(
        url,
        queryParameters: params,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioError catch (e) {
      formatError(e);
      if (e == null) {
        return Future.error(Response(data: -1));
      } else if (e.response is Map) {
        return Future.value(e.response);
      } else {
        return Future.error(0);
      }
    }
  }

  /*
   * post请求
   */
  post(
    url, {
    data,
    formdata,
    options,
    cancelToken,
    bool isShowLoading = true,
  }) async {
    Response response;

    try {
      // ToastKit.showLoading();
      dio.options.queryParameters['token'] = Application.sp.getString('token');

      response = await dio.post(url,
          queryParameters: data,
          data: formdata,
          options: options,
          cancelToken: cancelToken);

      // Navigator.of(context).pop(1)
    } on DioError catch (e) {
      ToastKit.showError();
      formatError(e);
    }
    return response;
  }

  /*
   * 下载文件
   */
  downloadFile(urlPath, savePath) async {
    Response response;
    try {
      response = await dio.download(urlPath, savePath,
          onReceiveProgress: (int count, int total) {
        //进度
      });
    } on DioError catch (e) {
      formatError(e);
    }
    return response.data;
  }

  /*
   * 取消请求
   *
   * 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。
   * 所以参数可选
   */
  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }

  /*
   * error统一处理
   */
  void formatError(DioError e) {
    if (e.type == DioErrorType.CONNECT_TIMEOUT) {
      // It occurs when url is opened timeout.
      print("连接超时");
      ToastKit.showErrorInfo('连接超时');
    } else if (e.type == DioErrorType.SEND_TIMEOUT) {
      // It occurs when url is sent timeout.
      print("请求超时");
      ToastKit.showErrorInfo('连接超时');
    } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
      //It occurs when receiving timeout
      print("响应超时");
    } else if (e.type == DioErrorType.RESPONSE) {
      // When the server response, but with a incorrect status, such as 404, 503...
      print("出现异常");
      ToastKit.showErrorInfo('出现异常');
    } else if (e.type == DioErrorType.CANCEL) {
      // When the request is cancelled, dio will throw a error with this type.
      print("请求取消");
    } else {
      //DEFAULT Default error type, Some other Error. In this case, you can read the DioError.error if it is not null.
      print("未知错误");
      print(e);
    }
  }

  static void refreshToken() {
    dio.options.queryParameters['token'] = Application.token;
  }

  static void clearToken() {
    dio.options.queryParameters.remove('token');
  }
}
