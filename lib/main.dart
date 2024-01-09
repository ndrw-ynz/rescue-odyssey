import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game/rescue_odyssey_game.dart';

void main() {
  final game = RescueOdysseyGame();
  runApp(
    GameWidget(game: game)
  );
}