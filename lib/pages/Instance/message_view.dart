part of 'instance_view.dart';

class MessageView extends StatelessWidget {
  MessageView({Key? key, required this.instance}) : super(key: key) {
    urlController.text = instance.url;
  }

  final InstanceBloc instance;

  final urlController = TextEditingController();
  final senderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InstanceBloc, InstanceState>(
      bloc: instance,
      builder: (context, state) {
        if (state is InstanceInitializing) {
          return Loading();
        }
        return Column(
          children: [
            Expanded(
              child: CustomScrollView(
                shrinkWrap: true,
                slivers: [
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
                          SizedBox(height: 12),
                          _buildToolbar(context),
                        ],
                      ),
                    ),
                  ),
                  _buildSliverMessages(context),
                  _buildSliverFooter(context),
                ],
              ),
            ),
            _buildSender(context, state),
          ],
        );
      },
      listener: (context, state) {},
    );
  }

  SpeedDial _buildFA() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      children: [
        SpeedDialChild(
          child: Icon(Icons.accessibility),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          label: 'First',
          onTap: () => print("FIRST CHILD"),
        )
      ],
    );
  }

  Widget _buildSender(BuildContext context, InstanceState state) {
    final connected = state is InstanceConnected;
    if (state is! InstanceConnected) {
      return SizedBox();
    }
    return Material(
      elevation: 4,
      child: IntrinsicHeight(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          alignment: Alignment.bottomCenter,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height / 3,
          ),
          color: Colors.white,
          child: TextField(
            controller: senderController,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            maxLines: null,
            autofocus: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              suffix: ElevatedButton(
                onPressed: !connected
                    ? null
                    : () {
                        instance.add(
                          InstanceMessageSend(senderController.text),
                        );
                      },
                child: Text('Send'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return TextFormField(
      controller: urlController,
      minLines: 1,
      maxLines: 6,
      decoration: InputDecoration(
        isDense: true,
        labelText: 'WebSocket Url',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildToolbar(BuildContext context) {
    final box = instance.box;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          child: Text('Connect'),
          onPressed: () {
            instance.add(InstanceWebSocketConnect(urlController.text));
          },
        ),
        SizedBox(
          width: 12,
        ),
        OutlinedButton(
          child: Text('Reset'),
          onPressed: () {
            if (box != null) {
              box.deleteAll(box.keys);
            }
          },
        ),
      ],
    );
  }

  Widget _buildSliverMessages(BuildContext context) {
    return ValueListenableBuilder<LazyBox<Message>>(
      valueListenable: instance.box!.listenable(),
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
                      child: _buildReceivedMessage(context, snapshot),
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

  Widget _buildReceivedMessage(
    BuildContext context,
    AsyncSnapshot<Message?> snapshot,
  ) {
    late final Widget child;
    late final Color background;

    if (snapshot.hasData) {
      switch (snapshot.data!.type) {
        case MessageType.data:
          background = Colors.green;
          break;
        case MessageType.done:
          background = Colors.orange;
          break;
        case MessageType.error:
          background = Colors.red;
          break;
        default:
          background = Colors.grey;
      }
      child = SelectableText(
        snapshot.data.toString(),
        style: TextStyle(
          color: Colors.white,
        ),
      );
    } else if (snapshot.hasError) {
      background = Colors.red;
      child = SelectableText(
        snapshot.error.toString(),
        style: TextStyle(
          color: Colors.white,
        ),
      );
    } else {
      background = Colors.blue;
      child = SizedBox(
        height: 16,
        width: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: FractionallySizedBox(
        widthFactor: 0.8,
        alignment: Alignment.centerLeft,
        child: Align(
          alignment: Alignment.centerLeft,
          child: MessageBubble(
            child: child,
            background: background,
          ),
        ),
      ),
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
