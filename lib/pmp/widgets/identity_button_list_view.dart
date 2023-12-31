import 'package:flutter/material.dart';
import 'package:pmp/db/identity.dart';
import 'package:pmp/pmp/app.dart';

class IdentityButtonListView extends StatelessWidget {
  final List<Identity> identities;
  final bool shouldSort;
  final void Function(Identity identity)? onPressed;

  const IdentityButtonListView({
    Key? key,
    required this.identities,
    this.shouldSort = false,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (shouldSort) Sort.sortIdentities(identities);
    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      children: [
        for (Identity identity in identities)
          PmpPadding(IdentityButton(
            identity: identity,
            onPressed: () => onPressed?.call(identity),
          )),
      ],
    );
  }
}
