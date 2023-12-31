import 'package:flutter/material.dart';
import 'package:pmp/common/common.dart';
import 'package:pmp/db/custom_field.dart';
import 'package:pmp/db/loaded_account.dart';
import 'package:pmp/db/payment_card.dart';
import 'package:pmp/Pmp/widgets/widgets.dart';
import 'package:pmp/pmp/theme.dart';

import 'main_screen.dart';
import 'edit_payment_card_screen.dart';
import 'payment_cards_screen.dart';

class PaymentCardScreen extends StatefulWidget {
  const PaymentCardScreen({Key? key}) : super(key: key);

  static const routeName = '/paymentCard';

  @override
  State<StatefulWidget> createState() => _PaymentCardScreen();
}

class _PaymentCardScreen extends State<PaymentCardScreen> {
  void _onRemovePressed(PaymentCard paymentCard) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            shape: PmpTheme.dialogShape,
            title: const Text('Remove payment card'),
            content:
                const Text('Payment cards can only be restored from a backup.'),
            actions: [
              TextButton(
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Color.fromARGB(255, 232, 235, 236)),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text(
                  'Remove',
                  style: TextStyle(color: Color.fromARGB(255, 231, 231, 231)),
                ),
                onPressed: () {
                  LoadedAccount account = data.loadedAccount!;
                  account.removePaymentCard(paymentCard.key);
                  Navigator.popUntil(
                      context, (r) => r.settings.name == MainScreen.routeName);
                  account.savePaymentCards().whenComplete(() =>
                      Navigator.pushNamed(
                          context, PaymentCardsScreen.routeName));
                },
              )
            ],
          );
        });
  }

  void _onEditPressed(PaymentCard paymentCard) {
    Navigator.pushNamed(
      context,
      EditPaymentCardScreen.routeName,
      arguments: paymentCard,
    );
  }

  @override
  Widget build(BuildContext context) {
    final PaymentCard paymentCard =
        ModalRoute.of(context)!.settings.arguments as PaymentCard;
    return Scaffold(
      appBar: EntryScreenAppBar(
        title: const Center(
            child: Text('Payment Card',
                style: TextStyle(
                  color: Color.fromARGB(255, 250, 250, 250),
                ))),
        onRemovePressed: () => _onRemovePressed(paymentCard),
        onEditPressed: () => _onEditPressed(paymentCard),
      ),
      body: ListView(children: [
        PaymentCardButton(
          paymentCard: paymentCard,
          obscureCardNumber: false,
          obscureCardCvv: false,
          isSwipeGestureEnabled: false,
        ),
        if (paymentCard.nickname != '')
          PmpPadding(RecordButton(
            title: 'Nickname',
            value: paymentCard.nickname,
          )),
        if (paymentCard.cardNumber != '')
          PmpPadding(RecordButton(
            title: 'Card number',
            value: paymentCard.cardNumber,
          )),
        if (paymentCard.cardholderName != '')
          PmpPadding(RecordButton(
            title: 'Card holder name',
            value: paymentCard.cardholderName,
          )),
        if (paymentCard.exp != '')
          PmpPadding(RecordButton(
            title: 'Expiration date',
            value: paymentCard.exp,
          )),
        if (paymentCard.cvv != '')
          PmpPadding(RecordButton(
            title: 'CVV',
            value: paymentCard.cvv,
          )),
        for (CustomField customField in paymentCard.customFields)
          PmpPadding(CustomFieldButton(customField: customField)),
        if (paymentCard.additionalInfo != '')
          PmpPadding(RecordButton(
            title: 'Additional info',
            value: paymentCard.additionalInfo,
          )),
      ]),
    );
  }
}
