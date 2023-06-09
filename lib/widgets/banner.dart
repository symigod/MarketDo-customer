import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:getwidget/getwidget.dart';
import 'package:marketdo_app/firebase.services.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({Key? key}) : super(key: key);

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  int scrollPosition = 0;
  final List _bannerImage = [];

  @override
  void initState() {
    getBanners();
    super.initState();
  }

  getBanners() =>
      homeBannerCollection.get().then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          setState(() => _bannerImage.add(doc['image']));
        }
      });

  @override
  Widget build(BuildContext context) => Column(children: [
        Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SizedBox(
                height: 20,
                width: MediaQuery.of(context).size.width,
                child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(children: [
                        Icon(IconlyLight.infoSquare, size: 12),
                        Text('100% Genuine',
                            style: TextStyle(color: Colors.white, fontSize: 12))
                      ]),
                      Row(children: [
                        Icon(IconlyLight.infoSquare, size: 12),
                        Text('2 - 3 days return',
                            style: TextStyle(color: Colors.white, fontSize: 12))
                      ]),
                      Row(children: [
                        Icon(IconlyLight.infoSquare, size: 12),
                        Text('Trusted Products',
                            style: TextStyle(color: Colors.white, fontSize: 12))
                      ])
                    ]))),
        Stack(children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: _bannerImage.isEmpty
                      ? GFShimmer(
                          showShimmerEffect: true,
                          mainColor: Colors.grey.shade500,
                          secondaryColor: Colors.grey.shade400,
                          child: Container(
                              color: Colors.grey.shade300,
                              height: 140,
                              width: MediaQuery.of(context).size.width))
                      : Container(
                          color: Colors.grey.shade200,
                          height: 140,
                          width: MediaQuery.of(context).size.width,
                          child: PageView.builder(
                              itemCount: _bannerImage.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  Image.network(_bannerImage[index],
                                      fit: BoxFit.cover),
                              onPageChanged: (val) =>
                                  setState(() => scrollPosition = val))))),
          _bannerImage.isEmpty
              ? Container()
              : Positioned(
                  bottom: 10.0,
                  child: DotsIndicatorWidget(
                      scrollPosition: scrollPosition, itemList: _bannerImage))
        ])
      ]);
}

class DotsIndicatorWidget extends StatelessWidget {
  const DotsIndicatorWidget(
      {super.key, required this.scrollPosition, required this.itemList});

  final int scrollPosition;
  final List itemList;

  @override
  Widget build(BuildContext context) => Row(children: [
        SizedBox(
            width: MediaQuery.of(context).size.width,
            child: DotsIndicator(
                position: scrollPosition,
                dotsCount: itemList.length,
                decorator: DotsDecorator(
                    activeColor: Colors.greenAccent,
                    spacing: const EdgeInsets.all(2),
                    size: const Size.square(6),
                    activeSize: const Size(12, 6),
                    activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)))))
      ]);
}
