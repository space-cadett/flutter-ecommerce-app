import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flame/const/AppColors.dart';

// ignore: must_be_immutable
class ProductDetails extends StatefulWidget {
  var _product;
  ProductDetails(this._product);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  Future addToCart() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users-cart-items");
    return _collectionRef
        .doc(currentUser!.email)
        .collection("items")
        .doc()
        .set({
      "name": widget._product["product-name"],
      "price": widget._product["product-price"],
      "images": widget._product["product-img"],
    }).then((value) => print("Added to cart"));
  }

  Future addToFavourite() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users-favourite-items");
    return _collectionRef
        .doc(currentUser!.email)
        .collection("items")
        .doc()
        .set({
      "name": widget._product["product-name"],
      "price": widget._product["product-price"],
      "images": widget._product["product-img"],
    }).then((value) => print("Added to Favourite"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: AppColors.deep_orange,
              child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
            ),
          ),
          actions: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users-favourite-items")
                    .doc(FirebaseAuth.instance.currentUser!.email)
                    .collection("items")
                    .where("name", isEqualTo: widget._product['product-name'])
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data == null) {
                    return Text("");
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: AppColors.deep_orange,
                      child: IconButton(
                          onPressed: () => addToFavourite(),
                          icon: Icon(
                            Icons.favorite_outline,
                            color: Colors.white,
                          )),
                    ),
                  );
                }),
          ],
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 3.5,
                child: CarouselSlider(
                    items: widget._product['product-img']
                        .map<Widget>((item) => Padding(
                              padding: const EdgeInsets.only(
                                  left: 3, right: 3, top: 1),
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(item),
                                        fit: BoxFit.fitWidth)),
                              ),
                            ))
                        .toList(),
                    options: CarouselOptions(
                        autoPlay: false,
                        enlargeCenterPage: true,
                        viewportFraction: 0.8,
                        enlargeStrategy: CenterPageEnlargeStrategy.height,
                        onPageChanged: (val, carouselPageChangedReason) {
                          setState(() {});
                        })),
              ),
              Text(
                widget._product['product-name'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              Text(
                widget._product['product-description'],
              ),
              Text(
                "\$ ${widget._product['product-price'].toString()}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.black),
              ),
              SizedBox(
                width: 1.sw,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: () => addToCart(),
                  child: Text(
                    "ADD TO CART",
                    style: TextStyle(color: Colors.white, fontSize: 18.sp),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.deep_orange,
                    elevation: 3,
                  ),
                ),
              )
            ],
          ),
        )));
  }
}
