import 'package:socket_io_client/socket_io_client.dart';

import '../utilities/credentials_manager.dart';

class WebsocketService {
  static late Socket socket;

  WebsocketService();

  // Connect to websocket
  static void connect(url) {
    socket = io(url, <String, dynamic> {
      "transports": ["websocket"],
      "autoConnect": false,
    });
  }

  void authenticate(token) {
    socket.emit("authenticate", token);

    socket.on("authenticated", (data) {
      print("Authenticated");
    });
  }

  void joinChatroom(chatroomId) {
    socket.emit("subscribe", chatroomId);
  }

  void leaveChatroom(chatroomId) {
    socket.emit("unsubscribe", chatroomId);
  }

  void sendMessage(chatroomId, message) {
    socket.emit("message", {
      "chatroom": chatroomId,
      "message": message
    });
  }

  // WebRTC Signaling
  void sendOffer(chatroomId, offer) {
    socket.emit("offer", {
      "chatroom": chatroomId,
      "offer": offer
    });
  }

  void sendAnswer(chatroomId, answer) {
    socket.emit("answer", {
      "chatroom": chatroomId,
      "answer": answer
    });
  }

  void sendIceCandidate(chatroomId, candidate) {
    socket.emit("ice-candidate", {
      "chatroom": chatroomId,
      "candidate": candidate
    });
  }
}