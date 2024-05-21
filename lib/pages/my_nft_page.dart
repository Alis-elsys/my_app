import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/models/home_page_model.dart';
import 'package:expandable/expandable.dart';

class MyPageWidget extends StatefulWidget {
  final int current;
  MyPageWidget({super.key, required this.current});
  late HomePageModel _model;

  @override
  State<MyPageWidget> createState() => _MyPageWidgetState();
}

class _MyPageWidgetState extends State<MyPageWidget> {
  late String NFTname;
  late String NFTimage;
  late String NFTcreator;
  late String NFTdescription;
  late BigInt NFTprice;
  
  final scaffoldKey = GlobalKey<ScaffoldState>();


  Future<void> buyNft(int tokenId) async {
    try {
      await widget._model.transaction('mint', []);
    } catch (e) {
      print("Error buying NFT: $e");
    }
  }
  
  Future<void> initModel() async{
    widget._model = HomePageModel();
    widget._model.initState(context);
    widget._model.initializeContract();

    await widget._model.getNFTlist();

    setState(() {
      NFTname = widget._model.allNfts[widget.current].name;
      NFTimage = widget._model.allNfts[widget.current].imageUrl;
      NFTprice = widget._model.allNfts[widget.current].price;
      NFTcreator = widget._model.allNfts[widget.current].owner.toString();
      NFTdescription = widget._model.allNfts[widget.current].description;
    });
  }


  @override
  void initState()  {
    super.initState();
    NFTname = '';
    NFTimage = '';
    NFTcreator = '';
    NFTdescription = '';
    NFTprice = BigInt.from(0);
    initModel();   
  }

  @override
  void dispose() {
    widget._model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          'NFT full info',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                              child: Text(
                                NFTname,
                                style: const TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: Color(0xFF101213),
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                              child: Container(
                                width: double.infinity,
                                height: 310,
                                child: Padding(
                                  padding: EdgeInsets.all(2),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      NFTimage,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                              child: 
                                Text(
                                  'URI of the token: $NFTimage',
                                  style:const TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    color: Color.fromARGB(255, 66, 75, 82),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                        child: Container(
                          width: double.infinity,
                          color: Colors.white,
                          child: ExpandableNotifier(
                            controller: widget._model.isExpanded,
                            child: ExpandablePanel(
                              header: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                                child: Text(
                                  'description',
                                  style: const TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        color: Color(0xFF101213),
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                              collapsed: Container(
                                width: MediaQuery.sizeOf(context).width,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: const Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 8, 0, 0),
                                  child: Text(
                                    'Click for the full description ',
                                    style: TextStyle(
                                          fontFamily: 'Plus Jakarta Sans',
                                          color: Color(0xFF57636C),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ),
                              ),
                              expanded: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 8, 0, 12),
                                    child: Text(
                                      NFTdescription,
                                      style: const TextStyle(
                                            fontFamily: 'Plus Jakarta Sans',
                                            color: Color(0xFF57636C),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              theme: const ExpandableThemeData(
                                tapHeaderToExpand: true,
                                tapBodyToExpand: true,
                                tapBodyToCollapse: true,
                                headerAlignment:
                                    ExpandablePanelHeaderAlignment.center,
                                hasIcon: false,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        height: 12,
                        thickness: 1,
                        color: Color(0xFFE0E3E7),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Opacity(
                                opacity: 0.9,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16, 8, 0, 0),
                                      child: Text(
                                        'Best price',
                                        style: TextStyle(
                                              fontFamily: 'Plus Jakarta Sans',
                                              color: Color(0xFF101213),
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16, 0, 0, 0),
                                      child: Text(
                                        '\$ ${NFTprice.toString()}',
                                        style: const TextStyle(
                                              fontFamily: 'Plus Jakarta Sans',
                                              color: Color(0xFF57636C),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Align(
                              alignment: AlignmentDirectional(1, 0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16, 26, 16, 24),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
