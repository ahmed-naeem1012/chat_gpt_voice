// ignore_for_file: unnecessary_string_interpolations, avoid_print
import 'dart:convert';
import 'package:http/http.dart' as http;



class ApiServices {
  static var url = Uri.https("api.openai.com", "/v1/completions");
  static String baseurl = "https://api.openai.com/v1/completions";

  static Map<String, String> header = {
    // 'Content-Type': 'application/json',
    // 'Authorization': 'Bearer $apikey'

    'Content-Type': 'application/json',
    // "Authorization": "Bearer $apikey"
  };
  static sendMessage(String? message) async {
    var res = await http.post(url,
        headers: header,
        body: jsonEncode({
          "model": "text-davinci-003",
          "prompt": message,
          "temprature": 0,
          "max_tokens": 2000,
          "top_p": 1,
          "frequency_penalty": 0.0,
          "presence_penalty": 0.0,
          "stop": [" Human:", " AI:"]
        }));

    if (res.statusCode == 200) {
      var data = jsonDecode(res.body.toString());
      var msg = data['choices'][0]['text'];
      return msg;
    } else {
      print("Failed to fetch data");
    }
  }

  static Future<String> generateResponse(String prompt) async {
    // const apiKey = apiSecretKey;

    var url = Uri.https("api.openai.com", "/v1/completions");
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        // "Authorization": "Bearer $apikey"
      },
      body: json.encode({
        "model": "text-davinci-003",
        "prompt": prompt,
        'temperature': 0,
        'max_tokens': 2000,
        'top_p': 1,
        'frequency_penalty': 0.0,
        'presence_penalty': 0.0,
      }),
    );

    // Do something with the response
    Map<String, dynamic> newresponse = jsonDecode(response.body);

    return newresponse['choices'][0]['text'];
  }
}
