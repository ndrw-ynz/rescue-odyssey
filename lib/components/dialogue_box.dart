import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:jenny/jenny.dart';
import 'package:rescue_odyssey/components/dialogue_builder.dart';
import '../game/rescue_odyssey_game.dart';

/// [DialogueBox] is a component that builds the dialogue box for the game.
class DialogueBox extends PositionComponent with DialogueView, HasGameRef<RescueOdysseyGame>{

  /// Creates a connection and parses yarn files.
  YarnProject yarnProject = YarnProject();
  /// Builds the dialogue for the dialogue box text.
  DialogueBuilder dialogueBuilder = DialogueBuilder();
  /// Stores the dialogue property of the interacted block.
  String dialogueProperty;
  DialogueBox({required this.dialogueProperty}) : super(priority: 2);


  @override
  Future<void> onLoad() async {
    String startDialogueData = await rootBundle.loadString('assets/yarn/object_dialogues.yarn');
    yarnProject.parse(startDialogueData);
    var dialogueRunner = DialogueRunner(yarnProject: yarnProject, dialogueViews: [dialogueBuilder]);
    dialogueRunner.startDialogue(dialogueProperty);
    add(dialogueBuilder);
  }
}