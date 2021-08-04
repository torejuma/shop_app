import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:magazin_app/models/http_exception.dart';

class Auth with ChangeNotifier {
   String? _token;
   DateTime? _expiryDate;
   String? _userId;

  bool get isAuth {
      return token != null;
  }

  String? get token {
    if ( _expiryDate != null &&
         _expiryDate!.isAfter(DateTime.now()) &&
         _token != null ) {
       return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  _authenticate(String email, String password, urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDVU0gG9sY4w9oyR_sc1JDgb_Qo-U8VN4Q';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        print(responseData['error']['message']);
        throw HttpException(message: responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
          Duration(
              seconds: int.parse(responseData['expiresIn']),
          ),
      );
      notifyListeners();
    }catch (error){
      throw error;
    }
  }

  signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
