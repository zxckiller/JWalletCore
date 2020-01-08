//所有KeyStore都需要实现此接口,为了上层使用方便，此接口会混合所有软硬操作的接口
import 'package:jwallet_core/JsonableObject.dart';

enum KeyStoreType { Blade, LocalDB}
abstract class JInterfaceKeyStore implements JsonableObject{
  KeyStoreType type();
  Future<bool> init();
  Future<String> getXprv();
  Future<String> getMnemonic(String password);
  Future<bool> verifyPin(int contextID, String password);
  Future<bool> modifyPin(int contextID, String oldPassword, String newPassword);
  String getDeviceMAC();
}