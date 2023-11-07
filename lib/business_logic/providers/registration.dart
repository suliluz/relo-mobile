import 'package:relo/business_logic/providers/upload.dart';

import '../models/agent_verification_object.dart';
import '../models/relo_response.dart';
import '../models/sign_up_object.dart';
import '../utilities/relo_http_client.dart';

class Registration {
  static Future<ReloResponse?> register(SignUpObject details) async {
    try {
      return ReloHTTPServer.post(path: "/register", body: {
          "first_name": details.firstName,
          "last_name": details.lastName,
          "date_of_birth": details.dateOfBirth.toIso8601String(),
          "country": details.country,
          "accountId": details.accountId,
          "email": details.email,
          "password": details.password,
          "opt_marketing": details.optMarketing
        });
    } catch(e) {
      rethrow;
    }
  }

  static Future<ReloResponse?> registerAsAgent(AgentVerificationObject details) async {
    try {
      // Do get nonce
      String? nonce = await Upload.generateNonce(5);
      if(nonce == null) return null;

      // After getting nonce, upload with nonce and the 5 files
      ReloResponse? uploadResponse = await Upload.uploadMultiple(nonce, [
        details.frontIc,
        details.backIc,
        details.selfieWithIc,
        details.passport,
        details.drivingLicense
      ]);

      return await ReloHTTPServer.post(
        path: "/agent-verify",
        body: {
          "identification_number": details.identificationNumber,
          "bank_number": details.bankNumber,
          "upload_token": nonce
        },
        authentication: true
      );
    } catch (e) {
      rethrow;
    }
  }
}