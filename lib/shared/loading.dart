import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class StoreItemLoading extends StatelessWidget {
  const StoreItemLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        /*border: Border.all(
          color: Colors.grey,
        ),*/
        boxShadow: [BoxShadow(color: Colors.black)],
      ),
      width: MediaQuery.of(context).size.width - 20,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            height: 40,
            width: double.infinity,
            child: Shimmer.fromColors(
              child: const Card(),
              baseColor: const Color.fromARGB(255, 49, 47, 47).withOpacity(.8),
              highlightColor: Colors.grey.shade700,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            height: 110,
            width: double.infinity,
            child: Shimmer.fromColors(
              child: const Card(),
              baseColor: const Color.fromARGB(255, 49, 47, 47).withOpacity(.8),
              highlightColor: Colors.grey.shade700,
            ),
          ),
          Row(
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(5),
                height: 40,
                width: 150,
                child: Shimmer.fromColors(
                  child: const Card(),
                  baseColor:
                      const Color.fromARGB(255, 49, 47, 47).withOpacity(.8),
                  highlightColor: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BasicItemLoader extends StatelessWidget {
  const BasicItemLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width - 20,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade700,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Shimmer.fromColors(
            child: SizedBox(
              height: 25,
              width: 400,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            baseColor: const Color.fromARGB(255, 77, 77, 77).withOpacity(.8),
            highlightColor: Colors.grey,
          ),
          const SizedBox(
            height: 10,
          ),
          Shimmer.fromColors(
            child: SizedBox(
              height: 90,
              width: 400,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            baseColor: const Color.fromARGB(255, 77, 77, 77).withOpacity(.8),
            highlightColor: Colors.grey,
          ),
        ],
      ),
    );
  }
}
