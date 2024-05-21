//import 'dart:js';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../models/home_page_model.dart';
import '../pages/info_page.dart';
import 'package:image_network/image_network.dart';

HomePageModel _model = HomePageModel();

Widget productCard({
  required BuildContext context, 
  required String imageUrl,
  required String productName,
  required BigInt price,
  required BigInt id,                    //podavah tova na functia ili nesho takova koqto she pokazva
  required VoidCallback onPressed,
}) {
  return Padding(
    padding: EdgeInsetsDirectional.fromSTEB(40, 12, 40, 0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container( 
        color : Colors.white,
        child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(              
              width: MediaQuery.of(context).size.width / 2.5, // Fixed width
              height: MediaQuery.of(context).size.width / 2.5, // Fixed height
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover, // Cover the entire container
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(6, 0, 6, 4),
            child: Text( 
              // ignore: unnecessary_string_interpolations
              productName,
              style: TextStyle(
                fontFamily: 'Outfit',
                color: Color(0xFF101213),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(6, 16, 6, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '\$ $price',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    color: Color(0xFF101213),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: onPressed,
                  style: ButtonStyle(
                    backgroundColor:
                        const MaterialStatePropertyAll(Colors.transparent),
                    padding:
                        const MaterialStatePropertyAll(EdgeInsetsDirectional.fromSTEB(8, 0, 4, 0)),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                  ),
                  child: const Text(
                    'View more',
                    style: TextStyle(
                      fontFamily: 'Readex Pro',
                      color: Color(0xff4b39ef),
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    ),
  );
}
