import 'package:app_usage/app_usage.dart';
import 'package:get/get.dart';

class StepsController extends GetxController {
  RxBool permisionUsageIsComplete = false.obs;

  // @override
  // void onInit() async {
  //   super.onInit();
  // }

  Future<void> askForPermision() async {
    // permisionUsageIsComplete.value = await verifyPermisions();
    verifyPermisions().then(
      (value) {
        permisionUsageIsComplete.value = value;
      },
    );
    print(' - -------- ${permisionUsageIsComplete.value}');
  }

  Future<bool> verifyPermisions() async {
    print('--------6');
    List<AppUsageInfo> _list = await getUsageStats();
    print('--------7');
    if (_list.isNotEmpty) {
      print('--------8');
      return true;
    }
    print('--------9');
    return false;
  }

  Future<List<AppUsageInfo>> getUsageStats() async {
    try {
      print('--------1');
      DateTime endDate = DateTime.now();
      print('--------2');
      DateTime startDate = endDate.subtract(Duration(hours: 1));
      print('--------3');
      List<AppUsageInfo> infoList =
          await AppUsage().getAppUsage(startDate, endDate);
      print('--------4');

      // setState(() => _infos = infoList);

      for (var info in infoList) {
        print(info.toString());
      }
      print('--------5');
      return (infoList);
    } on AppUsageException catch (exception) {
      print(' ====== > $exception');
      // throw exception;
      return [];
    }
  }
}
