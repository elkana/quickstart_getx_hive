import 'package:get/get.dart';
import '../models/user_model.dart';
import '../providers/api.dart';
import '../routes/app_routes.dart';
import '../utils/screen_util.dart';
import 'pref_controller.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  var user = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    // user = Rx<User?>(FirebaseAuth.instance.currentUser);
    // user.bindStream(FirebaseAuth.instance.userChanges());
    // user.value = FirebaseAuth.instance.currentUser?.toUserModel();
    ever<UserModel?>(user, (_) {
      print('ever-> $_');
      if (_ == null) {
        Get.offAllNamed(Routes.login);
      } else {
        Get.offAllNamed(Routes.home);
      }
    });
  }

  /// tidak mengatur reroute disini, hanya authentication secara online.
  ///
  /// login offline tidak diperlukan diatur di class ini karena sudah diatur di LoginController.
  Future<UserModel?> loginWithEmail(String userId, String pwd, bool rememberMe) async {
    var userModel = await Api.instance.login(userId, pwd);
    userModel?.rememberMe = rememberMe;
    // Optional inject password, because server might hide it
    userModel?.userPassword = pwd;
    PrefController.instance.setLoggedUser(userModel);
    user.value = userModel;
    return userModel;
  }

  /// must be called before route to login
  logout() async {
    try {
      if (PrefController.instance.hasLoggedUser()) {
        var user = PrefController.instance.getLoggedUser();
        if (user!.rememberMe != true) {
          await PrefController.instance.cleanLoggedUserData();
        }
      }
    } catch (e, s) {
      ScreenUtil.showError(e, stacktrace: s);
    } finally {
      user(null);
    }
  }

  Future<UserModel?> createUserWithEmailAndPassword(String fullName, String userId, String password) async {
    var newUsr = await Api.instance.signUp(fullName, userId, password);
    PrefController.instance.setLoggedUser(newUsr);
    user.value = newUsr;
    return newUsr;
  }
}
