import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class StoreItemLoading extends StatelessWidget {
  const StoreItemLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width - 20,
      child: Shimmer.fromColors(
        child: Card(
          elevation: 2,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Shimmer.fromColors(
                      child: SizedBox(),
                      baseColor: Colors.red,
                      highlightColor: Colors.red,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 100,
              ),
              Row(),
            ],
          ),
        ),
        baseColor: const Color.fromARGB(255, 77, 77, 77).withOpacity(.8),
        highlightColor: Colors.grey,
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
