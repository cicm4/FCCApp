import 'package:fccapp/services/Level_0/database_service.dart';
import 'package:fccapp/services/Level_0/user_service.dart';

class HelpService {
  static Future<bool> makeRequest(
      Help help, String message, UserService us, DBService dbs) async {
    //get UID
    String? uid = us.user?.uid.toString();

    if (uid == null) {
      throw Exception('User not logged in');
    }

    //get email
    String? email = us.user?.email.toString();

    if (email == null) {
      throw Exception('User not logged in');
    }

    try {
      Map<String, String> data = {
        'uid': uid,
        'email': email,
        'message': message,
        'help': help.toString(),
        'time': DateTime.now().toString()
      };

      String name = uid + DateTime.now().toString() + help.toString();

      await dbs.addEntryToDBWithName(
          path: 'adminNotification', entry: data, name: name);

      return true;
    } catch (e) {
      return false;
    }
  }
}

enum Help {
  zapato,
  dermatologico,
  oftamologico,
  calamidad,
}
