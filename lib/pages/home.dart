import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:istreamo/api/shared_pref_api.dart';
import 'package:istreamo/model/repo.dart';
import 'package:istreamo/widgets/custom_list_tile.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Repository> repositoryStore = [];
  int cur_page = 1;
  bool _newDataLoading = false,
      _initLoading = true,
      _reachedEnd = false,
      _online = true;
  final ScrollController _scrollController = ScrollController();

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://api.github.com/users/JakeWharton/repos?page=${cur_page}&per_page=15'));
    final decoded = await json.decode(response.body);

    if (decoded.length == 0) {
      setState(() {
        _reachedEnd = true;
        _newDataLoading = false;
      });
      return;
    }

    for (int i = 0; i < decoded.length; i++) {
      Repository repo = Repository(
        name: decoded[i]['name'] ?? 'No Name',
        description: decoded[i]['description'] ?? 'No description',
        bugs: decoded[i]['open_issues_count'] ?? -1,
        seen: decoded[i]['watchers_count'] ?? -1,
        language: decoded[i]['language'] ?? 'NA',
      );

      repositoryStore.add(repo);
    }
    await SharedPrefApi.updateList(
        repositoryStore,
        ((repositoryStore.length) - (decoded.length)) as int,
        repositoryStore.length - 1);
    cur_page++;
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await fetchData();
    setState(() {
      _initLoading = false;
    });
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_reachedEnd) {
        setState(() {
          _newDataLoading = true;
        });
        await fetchData();
        setState(() {
          _newDataLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jake's Git"),
        actions: [
          TextButton(
            onPressed: () async {
              if (!_online) {
                _online = !_online;
                setState(() {
                  cur_page = 1;
                  _newDataLoading = true;
                  _initLoading = true;
                  _reachedEnd = false;
                  repositoryStore.clear();
                });
                await fetchData();
                setState(() {
                  _initLoading = false;
                  _newDataLoading = false;
                });
              } else {
                setState(() {
                  _online = !_online;
                  cur_page = 1;
                });
              }
            },
            child: Text(
              _online ? 'Go Offline' : 'Go Online',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: _online
          ? _initLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemBuilder: (_, idx) {
                          return CustomListTile(repo: repositoryStore[idx]);
                        },
                        itemCount: repositoryStore.length,
                      ),
                    ),
                    if (_newDataLoading)
                      Column(
                        children: const [
                          SizedBox(
                            height: 10,
                          ),
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                  ],
                )
          : FutureBuilder(
              future: SharedPrefApi.getList(),
              builder: (ctx, ss) =>
                  ss.connectionState == ConnectionState.waiting
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemBuilder: (_, idx) => CustomListTile(
                            repo: (ss.data! as List<Repository>)[idx],
                          ),
                          itemCount: (ss.data! as List<Repository>).length,
                        ),
            ),
    );
  }
}
