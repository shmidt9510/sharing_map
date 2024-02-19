import 'package:sharing_map/controllers/common_controller.dart';
import 'package:sharing_map/controllers/item_controller.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/path.dart';
import 'package:sharing_map/utils/shared.dart';

Future<String> checkInitPath(
    UserController _usersController, CommonController _commonController) async {
  // var hasInternet = await _commonController.checkInternet();
  // if (!hasInternet) {
  //   return SMPath.noNetwork;
  // }
  if (SharedPrefs().isFirstRun) {
    SharedPrefs().isFirstRun = false;
    return SMPath.onboard;
  }
  var isAuhtorized = await _usersController.CheckAuthorization();
  isAuhtorized |= (await _usersController.CheckAuthorization());
  if (!isAuhtorized) {
    return SMPath.start;
  }
  return SMPath.home;
}
