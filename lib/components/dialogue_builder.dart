import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:jenny/jenny.dart';
import '../game/rescue_odyssey_game.dart';

/// Builds the dialogue's lines, text box, design, and tappable button progression for [DialogueBox].
class DialogueBuilder extends PositionComponent with DialogueView, HasGameRef<RescueOdysseyGame> {
  /// Invisible and tappable button on screen for next dialogue line.
  late final ButtonComponent nextLineButton;
  /// Text component that shows the dialogue line on screen.
  late final TextBoxComponent mainDialogueTextComponent; //dialogueTextComponent
  /// Checks if the dialogue is finished or not.
  bool isDialogueFinished = true;
  /// Gives the attributes for the text.
  final dialoguePaint = TextPaint(style: const TextStyle(fontFamily: 'Yoster', fontSize: 18));
  final choicePaint = TextPaint(style: const TextStyle(fontFamily: 'Yoster', fontSize: 12, color: Colors.white));
  /// A class that completes the dialogue progression asynchronously.
  Completer<void> _dialogueCompleter = Completer();
  Completer<int> _choiceCompleter = Completer<int>();

  late SpriteComponent textBackgroundComponent;

  late SpriteComponent leftNameBoxComponent;
  late SpriteComponent rightNameBoxComponent;

  late TextBoxComponent nameTextComponent;

  List<ButtonComponent> optionList = [];

  @override
  Future<void> onLoad() async {
    nextLineButton = ButtonComponent(
        button: PositionComponent(), size: gameRef.size, onPressed: () {
      if (!_dialogueCompleter.isCompleted) {
        _dialogueCompleter.complete();
      }
    });
    add(nextLineButton);
  }

  @override
  FutureOr<void> onDialogueStart() async{
    _initDialogue();
    _initDialogueName();
    // leftNameBoxComponent = SpriteComponent.fromImage(smallWoodenBox, position: Vector2(textBackgroundComponent.size.x * .1, -textBackgroundComponent.size.y * 0.25), size: Vector2(200, 50));
    // await Future.delayed(const Duration(milliseconds: 50));
    // debugPrint(gameRef.size.x.toString());
    // debugPrint(gameRef.size.y.toString());
    return super.onDialogueStart();
  }

  @override
  FutureOr<bool> onLineStart(DialogueLine line) async{
    debugPrint("Main Dialogue Component Added");
    // mainDialogueTextComponent = TextBoxComponent(textRenderer: dialoguePaint, text: '', position: Vector2(50, gameRef.size.y * .8), boxConfig: TextBoxConfig(timePerChar: 0.02, maxWidth: gameRef.size.x * .8));
    _dialogueCompleter = Completer();
    await _nextLine(line);
    return super.onLineStart(line);
  }

  @override
  FutureOr<int?> onChoiceStart(DialogueChoice choice) async{
    _choiceCompleter = Completer<int>();
    nextLineButton.removeFromParent();
    double space = 120;
    for (int i = 0; i<choice.options.length; i++){
      debugPrint(choice.options[i].text.toString().length.toString());
      optionList.add(ButtonComponent(
          position: Vector2(30, i * 50 + space),
          size: Vector2(400, 50),
          // gameRef.size.x * .67
          // button: TextBoxComponent(textRenderer: choicePaint, text: 'Choice ${i+1}: ${choice.options[i].text}'),
          button: TextBoxComponent(align: Anchor.centerLeft,size: Vector2(400, 50), textRenderer: choicePaint, text: 'Choice: ${choice.options[i].text}'),
          onPressed: (){
            if (!_choiceCompleter.isCompleted){
              _choiceCompleter.complete(i);
            }
          }
        ),
      );
      space += 20;
    }
    debugPrint(optionList.toString());
    addAll(optionList);
    await _getChoice(choice);
    return _choiceCompleter.future;
  }

  @override
  FutureOr<void> onChoiceFinish(DialogueOption option) {
    removeAll(optionList);
    optionList = [];
    add(nextLineButton);
    return super.onChoiceFinish(option);
  }

  Future<void> _getChoice(DialogueChoice choice) async {
    return _dialogueCompleter.future;
  }

  Future<void> _nextLine(DialogueLine line) async {
    bool characterIsSpeaking() {
      return line.character != null ? true : false;
    }
    if (characterIsSpeaking()){
      var characterName = line.character?.name ?? '';
      var dialogueLineText = line.text;

      mainDialogueTextComponent.text = dialogueLineText;
      nameTextComponent.text = characterName;
      textBackgroundComponent.add(leftNameBoxComponent);
    } else{
      if(textBackgroundComponent.contains(leftNameBoxComponent)){
        textBackgroundComponent.remove(leftNameBoxComponent);
      }
      var dialogueLineText = line.text;
      mainDialogueTextComponent.text = dialogueLineText;
    }
    return _dialogueCompleter.future;
  }

  @override
  FutureOr<void> onDialogueFinish() {
    remove(textBackgroundComponent);
    game.isDialogueFinished = true;
    debugPrint("Done");
    debugPrint("");
    debugPrint("isOnDialogue: ${game.isOnDialogue}");
    debugPrint("dialogueProperty: ${game.dialogueProperty}");
    debugPrint("isDialogueFinished: ${game.isDialogueFinished}");
    return super.onDialogueFinish();
  }


  void _initDialogue()  async{
    final largeWoodenBox = await Flame.images.load('dialogue_box/wooden_box.png');
    textBackgroundComponent = SpriteComponent.fromImage(largeWoodenBox, position: Vector2(gameRef.size.x * .001, gameRef.size.y * .75), size: Vector2(gameRef.size.x, 150));
    add(textBackgroundComponent);

    mainDialogueTextComponent = TextBoxComponent(textRenderer: dialoguePaint, text: '', position: Vector2(textBackgroundComponent.size.x * .09,20), boxConfig: TextBoxConfig(maxWidth: gameRef.size.x * .8));
    textBackgroundComponent.add(mainDialogueTextComponent);
  }

  void _initDialogueName() async{
    final smallWoodenBox = await Flame.images.load('dialogue_box/wooden_box.png');
    leftNameBoxComponent = SpriteComponent.fromImage(smallWoodenBox, position: Vector2(textBackgroundComponent.size.x * .1, -textBackgroundComponent.size.y * 0.21), size: Vector2(200, 50));
    nameTextComponent = TextBoxComponent(textRenderer: dialoguePaint, align: Anchor.center,text: '', position: Vector2(14,7), boxConfig: TextBoxConfig(maxWidth: leftNameBoxComponent.size.x * .778));
    leftNameBoxComponent.add(nameTextComponent);
  }

}