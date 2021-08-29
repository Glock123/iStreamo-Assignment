import 'package:flutter/material.dart';
import 'package:istreamo/model/repo.dart';

/// A custom list tile to show all the repositeries

class CustomListTile extends StatelessWidget {
  final Repository repo;
  const CustomListTile({Key? key, required this.repo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 150,
          child: Row(
            children: [
              const Expanded(
                flex: 1,
                child: Icon(
                  Icons.bookmark,
                  size: 70,
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          repo.name,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                          softWrap: true,
                          strutStyle: const StrutStyle(height: 1),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Text(
                        repo.description,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.left,
                        softWrap: true,
                        maxLines: 2,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (repo.language != 'NA')
                            Row(
                              children: [
                                const Icon(Icons.code),
                                Text(repo.language),
                                const SizedBox(
                                  width: 7,
                                ),
                              ],
                            ),
                          if (repo.bugs != -1)
                            Row(
                              children: [
                                const Icon(Icons.bug_report),
                                Text('${repo.bugs}'),
                                const SizedBox(
                                  width: 7,
                                ),
                              ],
                            ),
                          if (repo.seen != -1)
                            Row(
                              children: [
                                const Icon(Icons.person),
                                Text('${repo.seen}'),
                                const SizedBox(
                                  width: 7,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(
          thickness: 3,
        ),
      ],
    );
  }
}
