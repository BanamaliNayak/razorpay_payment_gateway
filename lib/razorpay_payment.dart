import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPayPage extends StatefulWidget {
  const RazorPayPage({super.key});

  @override
  State<RazorPayPage> createState() => _RazorPayPageState();
}

class _RazorPayPageState extends State<RazorPayPage> {

  late Razorpay _razorpay;
  TextEditingController amtController = TextEditingController();

  void openCheckout(amount) async {
    amount = amount * 100; // Converting to smallest currency unit (paise)
    var options = {
      'key': 'rzp_test_1DP5mm0lF5G5ag',
      'amount': amount,
      'name': 'Zero',
      'prefill': {'contact': '1234567890', 'email': 'test@gmail.com'},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error opening Razorpay: $e');
      Fluttertoast.showToast(msg: "Error opening Razorpay: $e", toastLength: Toast.LENGTH_LONG);
    }
  }


  void handlePaymentSuccess(PaymentSuccessResponse response){
    Fluttertoast.showToast(msg: "Payment Successful ${response.paymentId!}",toastLength: Toast.LENGTH_SHORT);
  }

  void handlePaymentError(PaymentFailureResponse response){
    Fluttertoast.showToast(msg: "Payment Fail ${response.message!}",toastLength: Toast.LENGTH_SHORT);
  }

  void handleExternalWallet(ExternalWalletResponse response){
    Fluttertoast.showToast(msg: "External Wallet ${response.walletName!}",toastLength: Toast.LENGTH_SHORT);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [

            SizedBox(
              height: 100,
            ),

            Image.network('https://img.freepik.com/vetores-premium/modelos-de-design-de-logotipo-de-codigo-zero_24599-1297.jpg'),

            SizedBox(
              height: 10,
            ),

            Text('welcome to RazorPay Payment Gateway Integration',style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18
            ),
              textAlign: TextAlign.center,
            ),

            SizedBox(
              height: 30,
            ),

            Padding(padding: EdgeInsets.all(8.0),
              child: TextFormField(
                cursorColor: Colors.white,
                autofocus: false,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Enter Amount to be paid',
                  labelStyle: TextStyle(fontSize: 15.0,color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1.0,
                    )
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1.0
                    )
                  ),
                  errorStyle: TextStyle(color: Colors.red,fontSize: 15)
                ),
                controller: amtController,
                validator: (value){
                  if(value==null || value.isEmpty){
                    return 'Please enter Amount to be paid';
                  }
                  return null;
                },
              ),
            ),

            SizedBox(height: 30,),

            ElevatedButton(onPressed: (){
              if(amtController.text.toString().isNotEmpty){
                setState(() {
                  int amount = int.parse(amtController.text.toString());
                  openCheckout(amount);
                });
              }
            }, child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Make Payment',style: TextStyle(color: Colors.black),),
            ),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            )
          ],
        ),
      ),
    );
  }
}
