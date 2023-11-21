import 'package:flutter/material.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_client/my_cafe.dart';
import 'firebase_options.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:intl/intl.dart';

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

  String toCurrency(int n) {
    return NumberFormat.currency(locale: 'ko_KR', symbol: '₩').format(n);
  }

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
              defaultSelected: 'toAll',
              elevation: 0,
              absoluteZeroSpacing: true,
              unSelectedColor: Theme.of(context).canvasColor,
              buttonLables: [
                '전체보기',
                for (var data in datas) data['categoryName']
              ],
              buttonValues: ['toAll', for (var data in datas) data.id],
              buttonTextStyle: const ButtonTextStyle(
                  selectedColor: Colors.white,
                  unSelectedColor: Colors.black,
                  textStyle: TextStyle(fontSize: 16)),
              radioButtonValue: (value) {
                showItems(value);
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
  Future<void> showItems(String value) async {
    setState(() {
      //value(카테고리 id를 갖고 있는 아이템들을 출력)
      itemList = FutureBuilder(
          future: value != 'toAll'
              ? db
                  .collection(itemCollectionName)
                  .where('categoryId', isEqualTo: value)
                  .get()
              : db.collection(itemCollectionName).get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var items = snapshot.data!.docs;
              if (items.isEmpty) {
                //아이템이 없는 경우
                return const Center(child: Text('empty!'));
              } else {
                List<Widget> lt = [];
                for (var item in items) {
                  lt.add(Container(
                    margin: const EdgeInsets.all(5),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.brown),
                        color: Colors.amber[100],
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(children: [
                      Text(item['itemName']),
                      Text(toCurrency(item['itemPrice']))
                    ]),
                  ));
                }
                return Wrap(
                  children: lt,
                );
              }
            } else {
              //아직 데이터 로드 중
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          });
    });
  }
  //장바구니 보기 기능

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showCategoryList();
    showItems('toAll');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ThemeData.light(useMaterial3: false).primaryColor,
          title: const Text("Kkwabaegi Caffee"),
          actions: [
            Transform.translate(
              offset: const Offset(-10, 5),
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //카테고리 목록
                categoryList,
                //아이템 목록
                Expanded(child: itemList),
              ],
            )));
  }
}
