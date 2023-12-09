import 'dart:convert';
import 'dart:io';
import 'package:sharing_map/services/photo_service.dart';

import 'package:sharing_map/utils/constants.dart';
import 'interceptors.dart';

import 'package:sharing_map/models/item.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:dio/dio.dart';

class SMClient {
  factory SMClient() {
    return SMClient();
  }
}
