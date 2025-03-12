import 'package:nilean/blocs/chat/chat_event.dart';
import 'package:nilean/blocs/chat/chat_state.dart';
import 'package:nilean/models/chat_content_model.dart';
import 'package:nilean/models/chat_model.dart';
import 'package:nilean/services/ai_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final gemini = Gemini.instance;

  ChatModel? chat;

  ChatBloc() : super(ChatInitial()) {
    on<SendPromptEvent>(_sendPrompt);
    on<SendImagePromptEvent>(_sendImagePrompt);
    on<ResetChatEvent>(resetChat);
    on<LoadChatEvent>(loadChat);
  }

  Future<void> loadChat(
    LoadChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    chat = event.chat;
    emit(ChatLoaded(chat: chat!));
  }

  Future _sendPrompt(
    SendPromptEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());

    try {
      late String? trsPrompt;

      if (event.language == 'en') {
        trsPrompt = event.prompt;
      }

      if (event.language != "en") {
        var translate = await AiServices.translateText(
          from: event.language,
          to: 'en',
          text: event.prompt,
        );

        trsPrompt = translate.translatedText;
      }

      chat ??= ChatModel(
        title: event.prompt,
        chatcontent: [],
        date: DateTime.now(),
        id: Uuid().v4(),
      );

      final List<Content> chats = [];

      for (var chat in chat!.chatcontent) {
        chats.add(
          Content(parts: [
            Part.text(
              chat.enChat ?? '',
            )
          ], role: 'user'),
        );
        chats.add(
          Content(role: 'model', parts: [
            Part.text(
              chat.enResponse ?? '',
            )
          ]),
        );
      }

      chats.add(
        Content(
          role: 'user',
          parts: [Part.text(trsPrompt ?? '')],
        ),
      );

      final res = await gemini.chat(chats);

      if (event.language == 'en') {
        chat?.chatcontent.add(
          ChatContentModel(
            date: DateTime.now(),
            chat: event.prompt,
            enChat: event.prompt,
            response: res?.output,
            enResponse: res?.output,
          ),
        );
      }

      if (event.language != 'en') {
        var trsResponse = await AiServices.translateText(
          from: 'en',
          to: event.language,
          text: res?.output ?? '',
        );
        chat?.chatcontent.add(
          ChatContentModel(
            date: DateTime.now(),
            chat: event.prompt,
            enChat: trsPrompt,
            response: trsResponse.translatedText,
            enResponse: res?.output,
          ),
        );
      }

      saveChat(chat!);

      emit(ChatLoaded(chat: chat!));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> saveChat(ChatModel chat) async {
    final chatBox = await Hive.openBox<ChatModel>('chats');
    await chatBox.put(chat.id, chat);
  }

  Future _sendImagePrompt(
    SendImagePromptEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    chat = ChatModel(
      title: '',
      chatcontent: [],
      date: DateTime.now(),
      id: Uuid().v4(),
    );
    Future.delayed(const Duration(seconds: 3)).then((x) {
      emit(ChatLoaded(chat: chat!));
    });
  }

  Future<void> resetChat(
    ResetChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    chat = null;
    emit(ChatInitial());
  }
}
