import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:jenny/jenny.dart';
import '../game/rescue_odyssey_game.dart';

/// Builds the dialogue's lines, text box, design, and tappable button progression for [DialogueBox].
class DialogueBuilder extends PositionComponent with DialogueView, HasGameRef<RescueOdysseyGame> {
  /// Invisible and tappable button on screen for next dialogue line.
  late final ButtonComponent nextLineButton;
  /// Text component that shows the dialogue line on screen.
  late final TextBoxComponent mainDialogueTextComponent;
  /// Checks if the dialogue is finished or not.
  bool isDialogueFinished = true;
  /// Gives the attributes for the text.
  final dialoguePaint = TextPaint(style: const TextStyle(backgroundColor: Colors.grey, fontFamily: 'Yoster', fontSize: 18));
  /// A class that completes the dialogue progression asynchronously.
  Completer<void> _dialogueCompleter = Completer();



  @override
  Future<void> onLoad() async {
    nextLineButton = ButtonComponent(
        button: PositionComponent(), size: gameRef.size, onPressed: () {
      if (!_dialogueCompleter.isCompleted) {
        _dialogueCompleter.complete();
      }
    });
    mainDialogueTextComponent = TextBoxComponent(textRenderer: dialoguePaint, text: '', position: Vector2(50, gameRef.size.y * .8), boxConfig: TextBoxConfig(timePerChar: 0.03, maxWidth: gameRef.size.x * .8));
    addAll([nextLineButton, mainDialogueTextComponent]);
  }


  @override
  FutureOr<bool> onLineStart(DialogueLine line) async{
    _dialogueCompleter = Completer();
    await _nextLine(line);
    return super.onLineStart(line);
  }

  Future<void> _nextLine(DialogueLine line) async {
    if (line.character == null){
      var dialogueLineText = line.text;
      mainDialogueTextComponent.text = dialogueLineText;
    } else{
      var characterName = line.character?.name ?? '';
      var dialogueLineText = '$characterName: ${line.text}';
      mainDialogueTextComponent.text = dialogueLineText;
    }
    return _dialogueCompleter.future;
  }


  @override
  FutureOr<void> onDialogueFinish() {
    remove(mainDialogueTextComponent);
    game.isDialogueFinished = true;
    debugPrint("Done");
    debugPrint("");
    debugPrint("isOnDialogue: ${game.isOnDialogue}");
    debugPrint("dialogueProperty: ${game.dialogueProperty}");
    debugPrint("isDialogueFinished: ${game.isDialogueFinished}");
    return super.onDialogueFinish();
  }
}