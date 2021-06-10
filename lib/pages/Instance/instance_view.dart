import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mayonnaise/blocs/instance/instance_bloc.dart';
import 'package:mayonnaise/blocs/store/store_bloc.dart';
import 'package:mayonnaise/models/message.dart';
import 'package:mayonnaise/pages/Loading/Loading.dart';
import 'package:mayonnaise/utils/hive.dart';
import 'package:mayonnaise/widgets/MessageBubble.dart';

part 'message_view.dart';

class InstanceView extends StatelessWidget {
  InstanceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StoreBloc>(
      create: (context) => Get.find(),
      child: Material(
        child: BlocConsumer<StoreBloc, StoreState>(
          listener: (BuildContext context, StoreState state) {},
          builder: (BuildContext context, StoreState state) {
            if (state is StoreInitializing) {
              return Loading();
            }
            if (state is StoreReady) {
              final StoreBloc store = Get.find();
              return _DesktopView(instances: store.instances ?? const []);
            }
            return Loading();
          },
        ),
      ),
    );
  }
}

class _DesktopView extends StatelessWidget {
  const _DesktopView({Key? key, required this.instances}) : super(key: key);

  final List<InstanceBloc> instances;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: instances.length,
      child: Row(
        children: [
          Container(
            width: 240.0,
            child: Builder(
              builder: (context) {
                return ListView(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        final StoreBloc store = Get.find();
                        store.add(StoreInstanceCreate());
                      },
                      icon: Icon(Icons.add),
                      label: Text('add'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        final StoreBloc store = Get.find();
                        store.add(StoreClear());
                      },
                      icon: Icon(Icons.clear_all),
                      label: Text('clear'),
                    ),
                    for (var i = 0; i < instances.length; i++)
                      TextButton(
                        onPressed: () {
                          DefaultTabController.of(context)!.animateTo(i);
                        },
                        child: Text(instances[i].name),
                      ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: TabBarView(children: [
              for (final instance in instances) MessageView(instance: instance)
            ]),
          )
        ],
      ),
    );
  }
}
