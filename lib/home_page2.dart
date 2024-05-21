import 'dart:math';
import 'models/home_page_model.dart';
import 'components/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'home_page2.dart';
export 'home_page2.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
 }

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;

  @override
  void initState() {
    super.initState();
   // _model = createModel(context, () => HomePageModel());
    _model = HomePageModel();
    _model.initState(context);
  }
  final scaffoldKey = GlobalKey<ScaffoldState>();
  
  // @override
  // Widget build(BuildContext context) {
  //   // TODO: implement build
  //   throw UnimplementedError();
  // }


  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xF1F4F8),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 35),
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height * 0.09,
              decoration: const BoxDecoration(
                color: Color(0xFFF1F4F8),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Color(0x1A57636C),
                    offset: Offset(0, 10),
                    spreadRadius: 0.1,
                  )
                ],
              ),
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height * 0.07,
                child: const Stack(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Align(
                             // alignment: AlignmentDirectional(-1.00, -1.00),
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                child: BackButton(
                                  style: ButtonStyle(
                                    side: MaterialStatePropertyAll(
                                      BorderSide(
                                        color: Colors.transparent,
                                        width: 1
                                      )
                                    ),
                                    iconSize: MaterialStatePropertyAll(30), 
                                    iconColor: MaterialStatePropertyAll(Color(0xFF101213))
                                  ), 
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(22, 0, 0, 0),
                              child: Text(
                                'Home',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  color: Color(0xFF101213),
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                    child: Container(
                      width: MediaQuery.sizeOf(context).width * 0.02,
                      child: TextFormField(
                        controller: _model.textController,
                        focusNode: _model.textFieldFocusNode,
                        autofocus: true,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Search',
                          labelStyle:Theme.of(context).textTheme.bodyMedium,
                          alignLabelWithHint: false,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xffe0e3e7),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xff4b39ef),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xffff5963),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xffff5963),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        // validator:
                        //     _model.textControllerValidator(context, _model.textController?.text), 
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    print('IconButton pressed ...');
                  },
                  icon: const Icon(
                    Icons.search_sharp,
                    color: Color(0xff14181f),
                    size: 24,
                  ),
                  style: ButtonStyle(
                    side: const MaterialStatePropertyAll(
                      BorderSide(
                        color: Colors.black87,
                        width: 1
                      )
                    ),
                    fixedSize: const MaterialStatePropertyAll(Size.fromWidth(40)),
                    backgroundColor: MaterialStatePropertyAll(Colors.indigo.shade800),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(
                        color: Colors.black87,
                        width: 1
                      )
                    )),
                    elevation: const MaterialStatePropertyAll(0),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView (
              padding: EdgeInsets.zero,
              //shrinkWrap: true,
              scrollDirection: Axis.vertical,
              child:Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(4, 12, 4, 0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 2,
                                color: Colors.black87,
                                offset: Offset(0, 1),
                              )
                            ],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(12),
                                  top: Radius.circular(0),
                                ),
                                child: Image.network(
                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS8d2GaM9vp206kfNlnBUKdLFUNQMpy4SmWZxYssaNy1MVWtaJp9P4AJ9FngBRMQiWfj2c&usqp=CAU',
                                  width: MediaQuery.sizeOf(context).width,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(6, 5, 6, 0),
                                child: Text(
                                  'Ordered on Feb 15, 2022', 
                                  style: TextStyle(fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 14, 
                                    fontWeight: FontWeight.w500, 
                                    color: Color(0xFF57636C)
                                  )
                                ),
                              ),
                              const Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(6, 0, 6, 4),
                                child: Text(
                                  'Vitsoe 1982',
                                  style: TextStyle(fontFamily: 'Outfit',
                                    fontSize: 18, 
                                    fontWeight: FontWeight.w500, 
                                    color: Color(0xFF101213)
                                  )
                                ),
                              ),
                              const Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(6, 16, 6, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      '\$126.20',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 20, 
                                        fontWeight: FontWeight.bold, 
                                        color: Color(0xFF101213)
                                      )
                                    ),
                                    TextButton(
                                      onPressed: null,
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStatePropertyAll(Colors.transparent),
                                        padding: MaterialStatePropertyAll(EdgeInsetsDirectional.fromSTEB(8, 0, 4, 0)),
                                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))))
                                      ),
                                      child: 
                                        Text('Buy', 
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
                        )
                        //TODO ).animateOnPageLoad(
                        //     animationsMap['containerOnPageLoadAnimation1']!),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(4, 12, 4, 0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 2,
                                color: Colors.black87,
                                offset: Offset(0, 1),
                              )
                            ],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(12),
                                  top: Radius.circular(0),
                                ),
                                
                                child:Image.network(
                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS8d2GaM9vp206kfNlnBUKdLFUNQMpy4SmWZxYssaNy1MVWtaJp9P4AJ9FngBRMQiWfj2c&usqp=CAU',
                                  width: MediaQuery.sizeOf(context).width,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(6, 5, 6, 0),
                                child: Text(
                                  'Ordered on Feb 15, 2022',
                                  style: TextStyle(fontFamily: 'Plus Jakarta Sans',
                                   fontSize: 14, 
                                   fontWeight: FontWeight.w500, 
                                   color: Color(0xFF57636C)
                                  )
                                ),
                              ),
                              const Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(6, 0, 6, 4),
                                child: Text(
                                  'Vitsoe 1982',
                                  style: TextStyle(
                                    fontFamily: 'Outfit',
                                    color: Color(0xFF101213),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(6, 16, 6, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    const Text(
                                      '\$126.20',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        color: Color(0xFF101213),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        print('Button pressed ...');
                                      }, 
                                      style: ButtonStyle(
                                        backgroundColor: const MaterialStatePropertyAll(Colors.transparent),
                                        padding: const MaterialStatePropertyAll(EdgeInsetsDirectional.fromSTEB(8, 0, 4, 0)),
                                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))
                                      ), 
                                      child: const Text('Buy', style: TextStyle(
                                        fontFamily: 'Readex Pro',
                                        color: Color(0xff4b39ef),
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )//TODO .animate(...)
                      ),
                    ),
                  ],
                ),
            ),
          ),
          Wrap(
            key: _model.navBarModel.key,
            direction: Axis.horizontal,
            children: [NavBar()]
          ),
          // wrapWithModel(
          //   model: _model.navBarModel,
          //   updateCallback: () => setState(() {}),
          //   child: NavBarWidget(),
          // ),
        ],
      ),
    );
  }
}