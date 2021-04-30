import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mayonnaise/layout/layout.dart';
import 'package:mayonnaise/models/message.dart';
import 'package:mayonnaise/utils/hive.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class InstancePage extends StatelessWidget {
  InstancePage({Key? key}) : super(key: key);
  final urlController = TextEditingController.fromValue(
    TextEditingValue(
      text:
          'ws://127.0.0.1:9096/vxdirect/ws/svr/info?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2MTk2ODgwNTUuMzAwMTk3MSwiaXNzIjoiVnhEaXIuQXV0aFN2ciIsInN1YiI6IkF1dGhlbnRpY2F0aW9uIiwiVXNlciI6eyJ1c2VyX2lkIjoxMDAwLCJ1c2VyX25hbWUiOiJhZG1pbiIsInV1aWQiOiIwYjA3MjRhNi0zNGRmLTRmNWMtOTUwMS1lNGVjMWM0MThmODIiLCJyb2xlX2lkcyI6WzEzMjYxMTI0ODE5MTAwMDAwMDIsMTMyNjExMjQ3OTcxMDAwMDAwMSwxMzI2MzM2ODg4MjEwMDAwMDAxXSwicGVybWlzc2lvbl9pZHMiOlsyMDAwMCwzMDAwMCw0MDAwMCw1MDAwMCw2MDAwMCw3MDAwMF19fQ.tFBoDUNKrRI2k4F31jJrHO5o3xpMMRrz6OAuThSibXw',
    ),
  );
  final box = Hive.openLazyBox<Message>("message");
  WebSocketChannel? instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LazyBox<Message>>(
      future: box,
      builder: (context, snapshot) {
        return Layout(
          title: Text('Instance'),
          builder: (context) {
            return [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 12,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 24.0,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      _buildForm(context),
                      SizedBox(
                        height: 12,
                      ),
                      _buildToolbar(context, snapshot.data!),
                    ],
                  ),
                ),
              ),
              if (snapshot.data != null)
                _buildSliverMessages(context, snapshot.data!),
              _buildSliverFooter(context),
            ];
          },
          error: snapshot.error?.toString(),
          loading: !snapshot.hasData && !snapshot.hasError,
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.chevron_right),
            onPressed: () {},
          ),
        );
      },
    );
  }

  Widget _buildForm(BuildContext context) {
    return TextFormField(
      controller: urlController,
      maxLines: 6,
      decoration: InputDecoration(
        isDense: true,
        labelText: 'WebSocket Url',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildToolbar(BuildContext context, LazyBox<Message> box) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          child: Text('Connect'),
          onPressed: () {
            if (instance != null) {
              instance!.sink.close();
            }
            instance = WebSocketChannel.connect(
              Uri.parse(urlController.text),
            );
            instance!.stream.listen(
              (event) {
                box.add(
                  Message(
                    time: DateTime.now(),
                    message: event.toString(),
                  ),
                );
              },
              cancelOnError: true,
              onError: (error) {
                box.add(
                  Message(
                    time: DateTime.now(),
                    message: error.toString(),
                  ),
                );
              },
              onDone: () {
                box.add(
                  Message(
                    time: DateTime.now(),
                    message: '${instance!.closeCode}: ${instance!.closeReason}',
                  ),
                );
              },
            );
          },
        ),
        SizedBox(
          width: 12,
        ),
        OutlinedButton(
          child: Text('Reset'),
          onPressed: () async {
            box.deleteAll(box.keys);
          },
        ),
      ],
    );
  }

  Widget _buildSliverMessages(BuildContext context, LazyBox<Message> box) {
    return ValueListenableBuilder<LazyBox<Message>>(
      valueListenable: box.listenable(),
      builder: (context, data, widget) {
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return FutureBuilder<Message?>(
                  future: data.getAt(index),
                  builder: (context, snapshot) {
                    return Entry(
                      delay: Duration(milliseconds: 5),
                      duration: Duration(milliseconds: 800),
                      xOffset: -150,
                      opacity: 0.1,
                      child: Container(
                        height: 100,
                        width: 100,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        padding: EdgeInsets.all(8),
                        color: Colors.lightGreen.withOpacity(0.5),
                        alignment: Alignment.center,
                        child: snapshot.hasData
                            ? Text(snapshot.data.toString())
                            : snapshot.hasError
                                ? Text(snapshot.error.toString())
                                : CircularProgressIndicator(),
                      ),
                    );
                  },
                );
              },
              childCount: data.length,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSliverFooter(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(bottom: 24),
        height: 36,
        alignment: Alignment.center,
        child: Text(
          'this is bottom ~',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
