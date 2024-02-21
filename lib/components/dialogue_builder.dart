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
  /// The parent class for all text/non-text components.
  ///
  /// Background that displays the dialogue text and the name of the character.
  late SpriteComponent textBackgroundComponent;
  /// Background that displays the name of the character. Is a child of [textBackgroundComponent].
  late SpriteComponent nameBoxComponent;
  /// Text component that shows the dialogue line text on screen. Is a child of [textBackgroundComponent].
  late TextBoxComponent dialogueTextComponent;
  /// Text component that shows the name text on screen. Is a child of [nameBoxComponent].
  late TextBoxComponent nameBoxTextComponent;
  /// Checks if the dialogue is finished or not.
  bool isDialogueFinished = true;
  /// Assigns text renderer values for the dialogue text.
  final dialoguePaint = TextPaint(style: const TextStyle(fontFamily: 'Yoster', fontSize: 18));
  /// Assigns text renderer values for the choices text.
  final choicePaint = TextPaint(style: const TextStyle(fontFamily: 'Yoster', fontSize: 15, color: Colors.white));
  /// A class that completes the dialogue progression asynchronously.
  Completer<void> _dialogueCompleter = Completer();
  /// A class that completes the choices progression asynchronously.
  Completer<int> _choiceCompleter = Completer<int>();
  /// A list that stores all choices available for later display.
  List<ButtonComponent> optionList = [];


  @override
  Future<void> onLoad() async {
    game.canMove = false;
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
    // nameBoxComponent = SpriteComponent.fromImage(smallWoodenBox, position: Vector2(textBackgroundComponent.size.x * .1, -textBackgroundComponent.size.y * 0.25), size: Vector2(200, 50));
    // await Future.delayed(const Duration(milliseconds: 50));
    // debugPrint(gameRef.size.x.toString());
    // debugPrint(gameRef.size.y.toString());
    return super.onDialogueStart();
  }

  @override
  FutureOr<bool> onLineStart(DialogueLine line) async{
    debugPrint("Main Dialogue Component Added");
    if (line.text == "My purpose is to load the dialogue box for optimization."){
      await Future.delayed(const Duration(milliseconds: 1000));
      debugPrint("WAITED 2s");
      onDialogueFinish();
      // onDialogueFinish();
    }

    _dialogueCompleter = Completer();
    await _nextLine(line);
    return super.onLineStart(line);
  }

  @override
  FutureOr<int?> onChoiceStart(DialogueChoice choice) async{
    _choiceCompleter = Completer<int>();
    nextLineButton.removeFromParent();
    double space = 100;
    for (int i = 0; i<choice.options.length; i++){
      debugPrint(choice.options[i].text.toString().length.toString());
      optionList.add(ButtonComponent(
          position: Vector2(30, i * 50 + space),
          // size: Vector2(400, 50),
          // gameRef.size.x * .67
          // button: TextBoxComponent(textRenderer: choicePaint,  size: Vector2(400, 50), text: 'Choice ${i+1}: ${choice.options[i].text}'),
          button: TextBoxComponent(align: Anchor.centerLeft, size: Vector2(400, 50), textRenderer: choicePaint, text: 'Choice: ${choice.options[i].text}'),
          onPressed: (){
            if (!_choiceCompleter.isCompleted){
              _choiceCompleter.complete(i);
            }
          }
        ),
      );
      space += 10;
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

  @override
  FutureOr<void> onDialogueFinish() {
    removeAll([textBackgroundComponent,nextLineButton]);
    game.isDialogueFinished = true;
    game.canMove = true;
    // debugPrint("Done");
    // debugPrint("");
    // debugPrint("isOnDialogue: ${game.isOnDialogue}");
    // debugPrint("dialogueProperty: ${game.dialogueProperty}");
    // debugPrint("isDialogueFinished: ${game.isDialogueFinished}");
    return super.onDialogueFinish();
  }

  /// Returns a future of the choices to be presented on screen.
  Future<void> _getChoice(DialogueChoice choice) async {
    return _dialogueCompleter.future;
  }
  /// Returns a future of the next line to be displayed on screen.
  Future<void> _nextLine(DialogueLine line) async {
    if (characterIsSpeaking(line)){
      setNameBoxText(line);
      resetDialogueText(line);
    } else{
      if(nameBoxIsAdded(line)){
        nameBoxComponent.removeFromParent();
      }
      resetDialogueText(line);
    }
    return _dialogueCompleter.future;
  }

  /// This method initializes wooden background for the text dialogue to be displayed.
  ///
  /// Additionally, creates the dialogue text component to be added to the background parent class.
  void _initDialogue()  async{
    final largeWoodenBox = await Flame.images.load('dialogue_box/wooden_box.png');
    textBackgroundComponent = SpriteComponent.fromImage(largeWoodenBox, position: Vector2(gameRef.size.x * .001, gameRef.size.y * .6), size: Vector2(gameRef.size.x, 150));
    add(textBackgroundComponent);

    dialogueTextComponent = TextBoxComponent(textRenderer: dialoguePaint, text: '', position: Vector2(textBackgroundComponent.size.x * .09,20), boxConfig: TextBoxConfig(maxWidth: gameRef.size.x * .8, timePerChar: 0.01));
    textBackgroundComponent.add(dialogueTextComponent);
  }
  /// This method initializes small sub wooden background for the name text to be displayed.
  ///
  /// Additionally, creates the name text component to be added to the background parent class.
  void _initDialogueName() async{
    final smallWoodenBox = await Flame.images.load('dialogue_box/wooden_box.png');
    nameBoxComponent = SpriteComponent.fromImage(smallWoodenBox, position: Vector2(textBackgroundComponent.size.x * .1, -textBackgroundComponent.size.y * 0.21), size: Vector2(200, 50));
    nameBoxTextComponent = TextBoxComponent(textRenderer: dialoguePaint, align: Anchor.center,text: '', position: Vector2(14,7), boxConfig: TextBoxConfig(maxWidth: nameBoxComponent.size.x * .778));
    nameBoxComponent.add(nameBoxTextComponent);
  }
  /// Resets the dialogue text component's type effect and adds the text from the new line.
  void resetDialogueText(DialogueLine line){
    dialogueTextComponent.removeFromParent();
    var dialogueLineText = line.text;
    dialogueTextComponent = TextBoxComponent(textRenderer: dialoguePaint, text: dialogueLineText, position: Vector2(textBackgroundComponent.size.x * .09,20), boxConfig: TextBoxConfig(maxWidth: gameRef.size.x * .8, timePerChar: 0.01));
    textBackgroundComponent.add(dialogueTextComponent);
    debugPrint(dialogueTextComponent.totalCharTime.toString());
  }
  /// Sets the name text for the name box and add the name box component to the background parent class.
  void setNameBoxText(DialogueLine line){
    var characterName = line.character?.name ?? '';
    nameBoxTextComponent.text = characterName;
    textBackgroundComponent.add(nameBoxComponent);
  }
  /// Checks if a character is speaking.
  bool characterIsSpeaking(DialogueLine line) {
    return line.character != null ? true : false;
  }
  /// Checks if the name box is present on the screen.
  bool nameBoxIsAdded(DialogueLine line){
    return textBackgroundComponent.contains(nameBoxComponent) ? true : false;
  }

}
