import 'dart:convert';

import 'package:istreamo/model/repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefApi {
  static final Future<SharedPreferences> _pref =
      SharedPreferences.getInstance();
  static String KEY = 'key_for_offline_storage1';

  // Object -> json (toJson)
  // json -> string (json.encode)
  // string -> json (json.decode)
  // json -> object (fromJson)

  // Function to retrieve offline stored list
  static Future<List<Repository>> getList() async {
    final SharedPreferences pref = await _pref;
    List<String> _jsonString = pref.getStringList(KEY) ?? [];

    var _jsonList = [];
    for (int i = 0; i < _jsonString.length; ++i) {
      _jsonList.add(json.decode(_jsonString[i]));
    }
    List<Repository> _repoList = [];
    for (int i = 0; i < _jsonList.length; ++i) {
      _repoList.add(Repository.fromJson(_jsonList[i]));
    }
    return _repoList;
  }

  // Function to store the current offline list in device
  static Future<void> storeList(List<Repository> repo) async {
    final SharedPreferences pref = await _pref;
    List<String> store = [];
    for (int i = 0; i < repo.length; ++i) {
      store.add(json.encode(Repository.toJson(repo[i])));
    }
    pref.setStringList(
      KEY,
      store,
    );
  }

  // Function to update the offline stored list with online values
  static Future<void> updateList(List<Repository> repo, int st, int ed) async {
    List<Repository> stored = await getList();
    if (repo.length >= stored.length) {
      stored = repo;
    } else {
      for (int i = st; i <= ed; ++i) {
        stored[i] = repo[i];
      }
    }
    await storeList(stored);
  }
}
