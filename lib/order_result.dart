import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

String orderCollectionName = 'cafe-order';
var firestore = FirebaseFirestore.instance;

// 주문저장, 주문번호, 시간이 지나면 다시 메인으로 이동
class OrderResult extends StatefulWidget {
  Map<String, dynamic> orderResult;
  OrderResult({super.key, required this.orderResult});

  @override
  State<OrderResult> createState() => _OrderResultState();
}

class _OrderResultState extends State<OrderResult> {
  late Map<String, dynamic> orderResult;
  dynamic resultView = const Text('주문중입니다...');
  int duration = 5;

  Future<int> getOrderNumber() async {
    //가장 마지막 번호
    int number = 1;
    var now = DateTime.now(); // 2023 -- 11-28 / 00 : 00 : 00
    var s = DateTime(now.year, now.month, now.day); // 오늘의 00 : 00 : 00
    // firebase의 시간은 타임스탬프값 1970.01.01

    var today = Timestamp.fromDate(s);
    try {
      //개인적으로 이
      await firestore
          .collection(orderCollectionName)
          .where('orderTime', isGreaterThan: today)
          .orderBy('orderTime', descending: true)
          .limit(1)
          .get()
          .then((value) {
        // value는 마지막 결과 하나
        var data = value.docs;
        number = data[0]['orderNumber'] + 1;
      });
    } catch (e) {
      number = 1;
    }
    print(number);
    return number;
  }

  Future<void> setOrder() async {
    int number = await getOrderNumber();
    orderResult['orderNumber'] = number;
    orderResult['orderTime'] = Timestamp.fromDate(DateTime.now());
    orderResult['orderComplete'] = false;
    await firestore
        .collection(orderCollectionName)
        .add(orderResult)
        .then((value) {
      print('ok');
      //화면 꾸미기
      showResult(number);
    }).onError((error, stackTrace) {
      print('error');
    });
  }

  void showResult(int number) {
    setState(() {
      resultView = SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            const Text('주문이 완료되었습니다'),
            Text('주문번호 : $number'),
            Text('$duration초 후에 창이 닫힙니다'),
            CircularCountDownTimer(
              width: 300,
              height: 300,
              duration: duration,
              isReverse: true,
              fillColor: Colors.black,
              ringColor: Colors.grey,
              onComplete: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 결과 준비
    orderResult = widget.orderResult;

    // 현재 주문번호를 설정
    setOrder();
    // 오늘을 기준으로 여태까지 개수 10건 -> 11번, 만약 한 건도 없으면 1번

    //주문번호, 시간포함, 데이터 저장
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kkwabaegi Caffee'),
      ),
      body: resultView,
    );
  }
}
