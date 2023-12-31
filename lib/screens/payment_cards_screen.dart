import 'package:flutter/material.dart';
import 'package:pmp/common/common.dart';
import 'package:pmp/db/loaded_account.dart';
import 'package:pmp/db/payment_card.dart';
import 'package:pmp/Pmp/widgets/widgets.dart';

import 'edit_payment_card_screen.dart';
import 'main_screen.dart';
import 'search_screen.dart';
import 'payment_card_screen.dart';

class PaymentCardsScreen extends StatefulWidget {
  const PaymentCardsScreen({Key? key}) : super(key: key);

  static const routeName = '${MainScreen.routeName}/paymentCards';

  @override
  State<StatefulWidget> createState() => _PaymentCardsScreen();
}

class _PaymentCardsScreen extends State<PaymentCardsScreen> {
  final LoadedAccount _account = data.loadedAccount!;

  void _onSearchPressed() {
    Navigator.pushNamed(
      context,
      SearchScreen.routeName,
      arguments: (String terms) {
        final List<PaymentCard> found = [];
        // ignore: no_leading_underscores_for_local_identifiers
        final List<String> _terms = terms.trim().toLowerCase().split(' ');
        for (PaymentCard paymentCard in data.loadedAccount!.paymentCards) {
          {
            bool testPaymentCard(PaymentCard value) =>
                paymentCard.key == value.key;

            if (found.any(testPaymentCard)) continue;
          }
          {
            int positiveCount = 0;
            for (String term in _terms) {
              if (paymentCard.cardholderName.toLowerCase().contains(term)) {
                positiveCount++;
                continue;
              }
              if (paymentCard.nickname.toLowerCase().contains(term)) {
                positiveCount++;
                continue;
              }
              if (paymentCard.exp.toLowerCase().contains(term)) {
                positiveCount++;
                continue;
              }
            }
            if (positiveCount == _terms.length) {
              found.add(paymentCard);
            }
          }
        }
        return PaymentCardButtonListView(
          paymentCards: found,
          shouldSort: true,
          onPressed: (paymentCard) => {
            Navigator.pushNamed(context, PaymentCardScreen.routeName,
                arguments: paymentCard),
          },
        );
      },
    );
  }

  void _onAddPressed() =>
      Navigator.pushNamed(context, EditPaymentCardScreen.routeName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EntriesScreenAppBar(
        title: const Text('Payment cards',
            style: TextStyle(
              color: Color.fromARGB(255, 250, 250, 250),
            )),
        onAddPressed: _onAddPressed,
        onSearchPressed: _onSearchPressed,
      ),
      body: _account.paymentCards.isEmpty
          ? CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  child: Column(
                    children: [
                      const Spacer(flex: 7),
                      const Text(
                        'No payment cards',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      FloatingActionButton(
                          child: const Icon(Icons.add_rounded,
                              color: Colors.white),
                          onPressed: () => Navigator.pushNamed(
                              context, EditPaymentCardScreen.routeName)),
                      const Spacer(flex: 7),
                    ],
                  ),
                ),
              ],
            )
          : PaymentCardButtonListView(
              paymentCards: _account.paymentCards.toList(),
              shouldSort: true,
              onPressed: (paymentCard) => {
                Navigator.pushNamed(context, PaymentCardScreen.routeName,
                    arguments: paymentCard),
              },
            ),
    );
  }
}
