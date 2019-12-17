import './JKeyStroe/interface/JInterfaceKeyStore.dart';
import './JxManager.dart';
import './JWallet/JWalletBase.dart';
import './JWallet/JWalletFactory.dart';
import 'dart:convert';
import './Error.dart';


class JWalletManager with JPresistManager{

  //创建一个新钱包
  Future<String> newWalletFromParm(String name,String mainPath,String endPoint,WalletType wType,
      KeyStoreType kType,{String mnemonic,String passphase = '',String password,String deviceMAC})
  async{
    JWalletBase wallet = JWalletFactory.fromParam(name,mainPath,endPoint, wType, kType,mnemonic:mnemonic,passphase:passphase,password:password,deviceMAC:deviceMAC);
    return addWallet(wallet); 
  }

  Future<String> newWalletFromKeyStore(String name,String mainPath,String endPoint,WalletType wType,JInterfaceKeyStore keystore)
  async{
    JWalletBase wallet = JWalletFactory.fromKeyStore(name,mainPath,endPoint, wType, keystore);
    return addWallet(wallet); 
  }

  //添加一个钱包
  Future<String> addWallet(JWalletBase wallet){
    return addOne(json.encode(wallet.toJsonKey()),wallet.toJson());  
  }

  //更新一个钱包
  Future<String> updateWallet(JWalletBase wallet){
    return updateOne(json.encode(wallet.toJsonKey()),wallet.toJson());  
  }

  //获取某一个钱包
  Future<T> getWallet<T>(String key) async{
    var jsonObj = await getOne(key);
    JWalletBase p = JWalletFactory.fromJson(jsonObj);
    return Future<T>.value(p as T); 
  }

  void removeWallet(String key) async{
    await deleteOne(key);
  }

  //通过钱包类型枚举钱包
  Future<Set<String>> enumWalletsByWalletType([WalletType wType]) async{
    Set<String> allWallts = await enumAll();
    Set<String> tagetWallets = new Set<String>();
    allWallts.forEach((key){
      try {
          Map<String,dynamic> _j = json.decode(key);
          if(_j["wType"] == wType.index)
          tagetWallets.add(key);
      } catch (e) {}
    });

    return Future<Set<String>>.value(tagetWallets);
  }

  //通过keystore类型枚举钱包
  Future<Set<String>> enumWalletsByKeyStoreType([KeyStoreType kType]) async{
    Set<String> allWallts = await enumAll();
    Set<String> tagetWallets = new Set<String>();
    allWallts.forEach((key){
      try {
          Map<String,dynamic> _j = json.decode(key);
          if(_j["keyStore"]["kType"] == kType.index)
          tagetWallets.add(key);
      } catch (e) {}
    });

    return Future<Set<String>>.value(tagetWallets);
  }

  // Future<String> newWalletFromJson(Map<String, dynamic> jsonObj) async{
  //   JWalletBase wallet = JWalletFactory.fromJson(jsonObj);
  //   return addOne(wallet.toJson(),json.encode(wallet.toJsonKey())); 
  // }

}