


import 'dart:convert';
import 'dart:io';

import 'package:courier_management_system/data/app_exceptions.dart';
import 'package:courier_management_system/data/network/baseApiServices.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
class NetworkApiServices extends BaseApiServices{



  @override
  Future getGetApiResponse(String url) async {
    dynamic responseJson;
    try {
      final response = await http.get(Uri.parse(url)).timeout(Duration(seconds: 10));
      print(url.toString());
      print(response.toString());
       responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }




  @override
  Future getPostApiResponse(String url, dynamic data) async{
    dynamic responseJson;
    try {
     Response response =await post(
       Uri.parse(url),
       body: data
     ).timeout(Duration(seconds: 20));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }



    dynamic returnResponse(http.Response response){
    switch(response.statusCode){
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;

      case 400:
        throw BadRequestException(response.body.toString());
      case 404:
        throw UnauthorizedtException(response.body.toString());
      default:
        throw FetchDataException('Error occured while communicating with server'+ 'with status code'+
            response.statusCode.toString());
    }

    }

  }



