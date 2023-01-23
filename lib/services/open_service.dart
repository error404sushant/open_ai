//happy
import 'package:open_ai/model/open_ai_response.dart';
import 'package:open_ai/services/http_service.dart';
import 'package:open_ai/util/app_constants.dart';

class OpenAiServices {
  // region Common Variables
  late HttpService httpService;

  // endregion

  // region | Constructor |
  OpenAiServices() {
    httpService = HttpService();
  }

  // endregion


  // region Get result
  Future<OpenAiResponse>getResults({required String value}) async {
    // get body [for POST request]
    var body =
    {
      "model": "text-davinci-003",
      "prompt": value,
      "temperature": 0,
      "max_tokens": 100
    }
    ;
    print(body);
    // endregion
    Map<String, dynamic> response;
    var url = AppConstants.baseUrl;
    print(url);
    //#region Region - Execute Request
    response = await httpService.postApiCall(body, url,token: AppConstants.token);
    // return response;
    return OpenAiResponse.fromJson(response);
  }
// endregion

}
