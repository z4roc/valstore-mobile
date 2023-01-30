import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:valstore/services/riot_service.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key, required this.accessToken});

  final String accessToken;
  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  @override
  Widget build(BuildContext context) {
    String token = widget.accessToken.split('=')[1].split('&')[0];
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          padding: const EdgeInsets.all(10),
          height: double.infinity,
          width: double.infinity,
          child: FutureBuilder(
            future: RiotService().getStore(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: 200,
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(snapshot.data![index]['displayName']),
                            Image(
                              image: NetworkImage(
                                snapshot.data![index]['displayIcon'],
                              ),
                              height: 125,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: Column(
                    children: const [
                      Text('Loading Store'),
                      CircularProgressIndicator()
                    ],
                  ),
                );
              }
            },
          ),
        ));
  }
}
