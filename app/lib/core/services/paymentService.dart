import 'package:stripe_payment/stripe_payment.dart';

class PaymentService {
  void init(){
    StripePayment.setOptions(
      StripeOptions(
        publishableKey: "pk_test_51HV1zSC82Ctcvm8k73wZ0kegkcH7JXB5Chpw2exXngG3GAuklbNj9wZSM2jkCUxZQX6mdUriD57iu02lue4rROjX00tJ2cREuE"
      )
    );
  }

  Future<String> proceedPayment(CreditCard creditCard) async{
    try{

      /* Source source = await StripePayment.createSourceWithParams(
        SourceParams(
          returnURL: "example://stripe-redirect",
          amount: (total * 100).toInt(),
          currency: 'USD', 
          type: 'ideal',
          card: testCard,
        )
      );  */

      Token token = await StripePayment.createTokenWithCard(creditCard);
      print(token.tokenId);
      return token.tokenId;

    }catch (e){
      print(e.toString());
      return null;
    }
  }
}