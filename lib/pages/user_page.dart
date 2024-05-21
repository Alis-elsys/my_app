import 'package:flutter/material.dart';
import '../components/NFT_card.dart';
import '../components/nav_bar.dart';
import '../models/home_page_model.dart';
import 'my_nft_page.dart';


class UserPageWidget extends StatefulWidget {
  UserPageWidget({super.key});
  final HomePageModel model = HomePageModel();


  @override
  State<UserPageWidget> createState() => _UserPageWidgetState();
}

class _UserPageWidgetState extends State<UserPageWidget> with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isMounted = false;

  Future<void> initModel() async {
    widget.model.initState(context);
    await widget.model.initializeContract();
    if (mounted) {
      await widget.model.getMyNFTlist();
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    initModel();
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }


  @override
  Widget build (BuildContext context) {
    return Scaffold(
    backgroundColor: Color(0xFFF5F5F5),
     appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          'User',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body:Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                'About the used wallet ',
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold
                )
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 20),
              child: Column(
                children: [
                   Text('Wallet address: ${widget.model.myAddress}', style: const TextStyle(
              fontSize: 16, 
            ),),
            Text('Wallet balance: ${widget.model.balance}', style: const TextStyle(
              fontSize: 16, 
            ),),
                ],
              )
            ),
           
            const Divider(
              height: 8,
              thickness: 3,
              color: Color.fromARGB(255, 117, 127, 139),
            ),
            
           Padding(padding: EdgeInsets.only(bottom: 30)),

            const Text('My NFTs ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: ListView.builder(
                  itemCount: widget.model.myNfts.length,
                  itemBuilder: (context, index) => productCard(
                  context: context,
                    imageUrl: widget.model.myNfts[index].imageUrl,
                    productName: widget.model.myNfts[index].name,
                    price: widget.model.myNfts[index].price,
                    id: widget.model.myNfts[index].tokenId,
                    onPressed: (){
                      try{
                        widget.model.currentNftId = int.parse(widget.model.myNfts[index].tokenId.toString());
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => MyPageWidget(current: widget.model.currentNftId)
                          ),
                        );
                        print("button pushed");
                      }catch(e){
                        print("navigating to myInfo $e");
                      }
                    },
                  ),
                )
              )
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(),

    );
  }
}
