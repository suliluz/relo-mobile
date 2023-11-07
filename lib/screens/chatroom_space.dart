import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart' as foundation;
import '../business_logic/enums/message_type.dart';
import '../business_logic/models/chat_message.dart';
import '../business_logic/utilities/credentials_manager.dart';

class ChatroomSpace extends StatefulWidget {
  const ChatroomSpace({super.key, required this.chatroomId});

  final String chatroomId;

  @override
  State<ChatroomSpace> createState() => _ChatroomSpaceState();
}

class _ChatroomSpaceState extends State<ChatroomSpace> {
  final TextEditingController _messageController = TextEditingController();

  bool _emojiLayout = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Primary color
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Row(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage('https://example.com/profile_image.jpg'),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Chat Title', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),
                Text('Online', style: TextStyle(fontSize: 14, color: Colors.white)),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.white,),
            onPressed: () {
              // Handle video call action
            },
          ),
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white,),
            onPressed: () {
              // Handle voice call action
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white,),
            onPressed: () {
              // Handle more action
            },
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                _chatBubble(message: 'Hello', timestamp: DateTime.now(), isMe: true),
                _chatBubble(message: 'Hi', timestamp: DateTime.now()),
                // Lorem 20
                _chatBubble(message: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec euismod, nisl eget aliquam ultricies, nunc nisl aliquet nunc, quis aliquam nisl nunc quis nisl. Donec euismod, nisl eget aliquam ultricies, nunc nisl aliquet nunc, quis aliquam nisl nunc quis nisl.', timestamp: DateTime.now(), isMe: true),
              ],
            )
          ),
          _chatBox(),
          Visibility(
            visible: _emojiLayout,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 300,
              child: EmojiPicker(
                textEditingController: _messageController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                config: Config(
                  columns: 7,
                  emojiSizeMax: 32 * (foundation.defaultTargetPlatform == TargetPlatform.iOS ? 1.30 : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
                  verticalSpacing: 0,
                  horizontalSpacing: 0,
                  gridPadding: EdgeInsets.zero,
                  initCategory: Category.RECENT,
                  bgColor: const Color(0xFFF2F2F2),
                  indicatorColor: Colors.blue,
                  iconColor: Colors.grey,
                  iconColorSelected: Colors.blue,
                  backspaceColor: Colors.blue,
                  skinToneDialogBgColor: Colors.white,
                  skinToneIndicatorColor: Colors.grey,
                  enableSkinTones: true,
                  recentTabBehavior: RecentTabBehavior.RECENT,
                  recentsLimit: 28,
                  noRecents: const Text(
                    'No Recents',
                    style: TextStyle(fontSize: 20, color: Colors.black26),
                    textAlign: TextAlign.center,
                  ), // Needs to be const Widget
                  loadingIndicator: const SizedBox.shrink(), // Needs to be const Widget
                  tabIndicatorAnimDuration: kTabScrollDuration,
                  categoryIcons: const CategoryIcons(),
                  buttonMode: ButtonMode.MATERIAL,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // Chatbox widget similar to WhatsApp
  Widget _chatBox() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 70,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                IconButton(
                  icon: Icon(Icons.insert_emoticon, color: !_emojiLayout? Colors.grey : Theme.of(context).primaryColor,),
                  onPressed: () {
                    // Handle emoji action
                    setState(() {
                      _emojiLayout = !_emojiLayout;
                    });
                  },
                ),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                      border: InputBorder.none,
                    ),
                    controller: _messageController,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.attach_file, color: Colors.grey,),
                  onPressed: () {
                    // Handle attach file action
                  },
                ),
              ],
            ),
          ),
          // Send button
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              radius: 25,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white,),
                onPressed: () {
                  // Handle send message action
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Chat bubble widget similar to WhatsApp
  Widget _chatBubble({
    required String message,
    required DateTime timestamp,
    bool isMe = false,
  }) {
    // Get a 24 hour format time from timestamp
    var time = '${timestamp.hour}:${timestamp.minute}';


    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 250),
          decoration: BoxDecoration(
            color: isMe ? Theme.of(context).primaryColor : Colors.grey[200],
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(child: Text(message, style: TextStyle(color: isMe ? Colors.white : Colors.black))),
              const SizedBox(width: 5),
              Text(time, style: TextStyle(color: isMe ? Colors.white : Colors.black, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

  _sendMessage() async {
    try {
      // Get from credentials manager
      var userInfo = await CredentialsManager.userInformation();

      if(userInfo == null) {
        throw Exception('Failed to send message');
      }

      // Generate random id
      var uuid = const Uuid().v4();

      // Create chat message
      var chatMessage = ChatMessage(
        id: uuid,
        sender: userInfo.accountId,
        media: Media(
          type: MessageTypeItem.text,
          body: _messageController.text,
        ),
        timestamp: DateTime.now(),
      );

      // Send message to chatroom

    } catch (e) {
      print(e);

      // Snackbar failed to send message
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send message'),),
        );
      }
    }
  }
}
