// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sigma_track/core/theme/theme_provider.dart';

// class AppScaffold extends ConsumerWidget {
//   final PreferredSizeWidget? appBar;
//   final Widget body;
//   final Widget? floatingActionButton;
//   final FloatingActionButtonLocation? floatingActionButtonLocation;
//   final Widget? endDrawer;
//   final Widget? bottomSheet;
//   final Widget? bottomNavigationBar;
//   final Color? backgroundColor;

//   const AppScaffold({
//     super.key,
//     required this.body,
//     this.appBar,
//     this.floatingActionButton,
//     this.floatingActionButtonLocation,
//     this.endDrawer,
//     this.bottomSheet,
//     this.bottomNavigationBar,
//     this.backgroundColor,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isIOS = ref.watch(isIOSThemeProvider);

//     if (isIOS) {
//       return CupertinoPageScaffold(
//         navigationBar: appBar is ObstructingPreferredSizeWidget ? appBar : null,
//         backgroundColor: backgroundColor,
//         child: body,
//       );
//     } else {
//       return Scaffold(
//         appBar: appBar,
//         body: body,
//         backgroundColor: backgroundColor,
//         endDrawer: endDrawer,
//         floatingActionButton: floatingActionButton,
//         floatingActionButtonLocation: floatingActionButtonLocation,
//         bottomSheet: bottomSheet,
//         bottomNavigationBar: bottomNavigationBar,
//       );
//     }
//   }
// }
