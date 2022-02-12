// import 'package:delivery_m/ui/components/error.dart';
// import 'package:delivery_m/ui/components/loading.dart';
// import 'package:delivery_m/ui/subscriptions/providers/wallet_transactions_provider.dart';
// import 'package:delivery_m/utils/formats.dart';
// import 'package:delivery_m/utils/labels.dart';
// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// class WalletTransactionsPage extends ConsumerWidget {
//   const WalletTransactionsPage(
//       {Key? key, required this.sId, required this.name})
//       : super(key: key);
//   final String name;
//   final String sId;
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final theme = Theme.of(context);
//     final style = theme.textTheme;

//     final transactionsStream = ref.watch(walletTransactionsProvider(sId));
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(name),
//       ),
//       body: transactionsStream.when(
//         data: (transactions) => ListView(
//           children: transactions
//               .map(
//                 (e) => Card(
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           Formats.monthDayTime(e.createdAt),
//                           style: style.caption,
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(4),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(4),
//                                   child: Text(
//                                     Formats.monthDayFromDate(e.date),
//                                     style: style.subtitle2,
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(4),
//                                   child: Text(
//                                     "${Labels.rupee} ${e.amount}",
//                                     style: style.subtitle1!.copyWith(
//                                         color: e.amount.isNegative
//                                             ? Colors.red
//                                             : Colors.green),
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(4),
//                                   child: Text(
//                                     '${e.quantity}',
//                                     style: style.subtitle1!.copyWith(
//                                       fontWeight: FontWeight.bold,
//                                         color: e.quantity.isNegative
//                                             ? Colors.red
//                                             : Colors.green),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               )
//               .toList(),
//         ),
//         error: (e, s) => DataError(e: e),
//         loading: () => const Loading(),
//       ),
//     );
//   }
// }
