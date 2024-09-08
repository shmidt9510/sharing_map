import 'package:get/get.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/path.dart';
import 'package:sharing_map/utils/shared.dart';

Future<String> checkInitPath() async {
  // final CommonController _commonController = Get.find<CommonController>();
  final UserController _usersController = Get.find<UserController>();
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
  if (SharedPrefs().chosenCity == -1) {
    return SMPath.chooseCity;
  }
  if (!isAuhtorized) {
    return SMPath.start;
  }
  if (SharedPrefs().chosenCity == -1) {
    return SMPath.chooseCity;
  }
  return SMPath.home;
}
