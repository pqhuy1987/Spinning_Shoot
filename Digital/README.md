# Spinning Shots
This is a code sample to show how a simple game for iOS can be built and architectured.
The game is written in Swift, using the SpriteKit framework.

The goal of the game is to shoot at spinning targets; miss a shot and the game is over. 
For demo purposes, there is a stage-system in place: the game advances to the next & more difficult stage, once all targets are cleared.
_This demo-gameplay is work-in-progess and not yet fully implemented, leading to nearly impossible scenarios in later stages._

![](http://i.imgur.com/nlD4Lfb.gif)

# Architecture
The app contains one SKScene, in which the whole game takes place. Depending on the state the game is in (Menu, Playing, Game Over),
additional UI elements are placed on the scene using distinct SKNodes.

The core game logic is controlled by the scene itself and an instance of Game. The game informs the scene about important game events
using a delegate protocol. The game logic in the scene will be further refactored in the next development stages.

To get started, take a look at the Core/**Scene.swift** and Core/**Game.swift** classes.
