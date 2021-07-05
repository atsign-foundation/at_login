import 'package:at_login_mobile/providers/basic_provider.dart';
import 'package:at_login_mobile/services/sdk_service.dart';
import 'package:at_utils/at_logger.dart';

class LoginFromWebProvider extends BasicProvider {
  static final LoginFromWebProvider _singleton =
      LoginFromWebProvider._internal();
  LoginFromWebProvider._internal();

  factory LoginFromWebProvider() {
    return _singleton;
  }

  final SDKService _sdkService = SDKService();
  var _logger = AtSignLogger('Follow From Web Provider');

  List<String> deviceAtsigns = [];

  Future getDeviceAtsigns() async {
    try {
      setPageState(PageState.loading);
      deviceAtsigns = await _sdkService.getAtsignList();
      setPageState(PageState.done);
    } catch (error) {
      _logger.severe('Fetching device atsigns throws $error');
      setPageState(PageState.error);
    }
  }
}

class DeviceAtsign {
  bool isSelected;
  String atsign;
  DeviceAtsign({this.isSelected = false, this.atsign});
}
