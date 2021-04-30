import 'package:flutter/material.dart';

part 'drawer.dart';

class Layout extends StatelessWidget {
  /// Responsive Layout
  ///
  /// [builder] must be a sliver.
  Layout({
    Key? key,
    this.loading,
    this.error,
    this.floatingActionButton,
    this.title,
    required this.builder,
  }) : super(key: key);

  final String? error;
  final bool? loading;
  final Widget? title;
  final List<Widget> Function(BuildContext context)? builder;
  final Widget? floatingActionButton;
  final Widget drawer = Drawer(
    elevation: 4,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Row(
          children: [
            PersistedDrawer(
              drawer: drawer,
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    title: title,
                  ),
                  if (loading == true)
                    SliverFillViewport(
                      delegate: SliverChildListDelegate([
                        CircularProgressIndicator(),
                      ]),
                    ),
                  if (loading != true && builder != null) ...builder!(context)
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
