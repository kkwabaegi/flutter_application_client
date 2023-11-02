import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_client/my_cafe.dart';
import 'firebase_options.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

var db = FirebaseFirestore.instance;
String categoryCollectionName = 'cafe-category';
String itemCollectionName = 'cafe-item';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({
    super.key,
  });

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  dynamic categoryList = const Text('category');
  dynamic itemList = const Text('item');
  //장바구니 컨트롤러
  PanelController panelController = PanelController();

  //카테고리 보기 기능
  Future<void> showCategoryList() async {
    var result = db.collection(categoryCollectionName).get();
    categoryList = FutureBuilder(
      future: result,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var datas = snapshot.data!.docs;
          if (datas.isEmpty) {
            return const Text('nothing');
          } else {
            return CustomRadioButton(
              elevation: 0,
              absoluteZeroSpacing: true,
              unSelectedColor: Theme.of(context).canvasColor,
              buttonLables: [for (var data in datas) data['categoryName']],
              buttonValues: [for (var data in datas) data.id],
              buttonTextStyle: const ButtonTextStyle(
                  selectedColor: Colors.white,
                  unSelectedColor: Colors.black,
                  textStyle: TextStyle(fontSize: 16)),
              radioButtonValue: (value) {
                print(value);
              },
              selectedColor: Theme.of(context).colorScheme.secondary,
            );
          }
        } else {
          return const Text('Loding...');
        }
      },
    );
  }

  //아이템 보기 기능

  //장바구니 보기 기능

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showCategoryList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Kkwabaegi Caffee"),
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Badge(
                  label: const Text('1'),
                  child: IconButton(
                      onPressed: () {
                        if (panelController.isPanelClosed) {
                          panelController.open();
                        } else {
                          panelController.close();
                        }
                      },
                      icon: const Icon(Icons.shopping_cart)),
                ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (panelController.isPanelClosed) {
              panelController.open();
            } else {
              panelController.close();
            }
          },
          child: const Icon(Icons.upload),
        ),
        body: SlidingUpPanel(
            controller: panelController,
            minHeight: 50,
            maxHeight: 300,

            //장바구니 슬라이딩
            panel: const Center(
              child: Text("This is the sliding Widget"),
            ),
            body: Column(
              children: [
                //카테고리 목록
                categoryList,
                //아이템 목록
                itemList,
              ],
            )));
  }
}
