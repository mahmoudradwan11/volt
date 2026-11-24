import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volt/core/barrel/barrel_network.dart';
import 'package:volt/core/constants/app_values.dart';
import 'package:volt/core/constants/toast.dart';
import 'package:volt/features/profile/controllers/chat_states.dart';
import 'package:volt/features/profile/models/chat_message_model.dart';

/// The customer's support chat with the app. One thread per user:
/// messages between the user's nationalId and the fixed support id
/// (ApiConstants.supportNationalId), same per-user keying as cart and
/// favorites. An admin view can later read the other side of each thread.
class ChatCubit extends Cubit<ChatStates> {
  /// [peerNationalId]: the other side of the thread. Null on the user side
  /// (peer = the support account). The admin thread screen passes the
  /// customer's nationalId, so the admin (logged in with the support id)
  /// reads and replies to that user's thread.
  ChatCubit({this.peerNationalId}) : super(ChatInitialState());

  final String? peerNationalId;

  static ChatCubit get(context) => BlocProvider.of(context);

  List<ChatMessageModel> messages = [];
  bool sending = false;

  String get myNationalId =>
      (CacheHelper.getData(key: 'userId') ?? nationalId)?.toString() ?? '';

  String get _myId => myNationalId;

  String get _peerId => peerNationalId ?? ApiConstants.supportNationalId;

  /// GET /chat with the two ids in the request body (backend reads body
  /// on GET, same as the other GET endpoints in this API).
  Future<void> getMessages() async {
    emit(ChatLoadingState());
    try {
      final value = await DioHelperStore.getData(
        url: ApiConstants.chatApi,
        data: {
          'senderNationalId': _myId,
          'receiverNationalId': _peerId,
        },
      );
      messages = [];
      final list = value.data['messages'];
      if (list is List) {
        for (final item in list) {
          if (item is Map<String, dynamic>) {
            messages.add(ChatMessageModel.fromJson(item));
          }
        }
      }
      emit(ChatSuccessState());
    } catch (error) {
      print(error.toString());
      emit(ChatErrorState());
    }
  }

  /// POST /chat - optimistic: the bubble appears instantly and is
  /// replaced by the server copy when the refresh completes.
  Future<void> sendMessage(String content) async {
    final text = content.trim();
    if (text.isEmpty || sending) return;
    sending = true;
    emit(ChatSendingState());

    messages.add(ChatMessageModel(
      senderNationalId: _myId,
      receiverNationalId: _peerId,
      content: text,
      timestamp: DateTime.now(),
    ));
    emit(ChatSuccessState());

    try {
      await DioHelperStore.postData(
        url: ApiConstants.chatApi,
        data: {
          'senderNationalId': _myId,
          'receiverNationalId': _peerId,
          'content': text,
        },
      );
      await getMessages();
    } catch (error) {
      print(error.toString());
      messages.removeWhere((m) => m.id == null && m.content == text);
      showToast('Message not sent', ToastStates.ERROR);
      emit(ChatErrorState());
    }
    sending = false;
  }
}
