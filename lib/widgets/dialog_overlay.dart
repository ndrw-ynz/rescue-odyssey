import 'dart:ui';

import 'package:flame/components.dart';
import 'package:rescue_odyssey/game/rescue_odyssey_game.dart';

class DialogBox extends TextBoxComponent{
  final RescueOdysseyGame game;
  DialogBox({required String text, required this.game}) : super(
    text: text,
    position: Vector2(50, game.size.y * .8),
    boxConfig: TextBoxConfig(dismissDelay: 5.0, maxWidth: game.size.x * .5, timePerChar: 0.3,)
  ){
  }

  @override
  void drawBackground(Canvas c){
    Rect rect = Rect.fromLTWH(0, 0, width, height);
    c.drawRect(rect, Paint()..color = const Color(0x8f37474f));
  }

  @override
  void update(double dt){
    super.update(dt);
    if (finished) {
      game.remove(this);
    }
  }
}