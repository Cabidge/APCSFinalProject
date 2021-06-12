# About
Group Name
---
Puyo Poppers

Members
---
Wen Hao Dong, Tristan Pragnell

How To Run:
---
1. Open any of the .pde files with Processing
2. Download Processing's Sound library if you haven't
    1. Sketch > Import Library... > Add Library...
    2. Search for "Sound"
    3. Click on Sound by The Processing Foundation and click Install
3. Click the run button

Brief Description:
---
Puyo Puyo is a tile-matching puzzle game, similar to that of Tetris and Dr. Mario, and is played on a 6 by 12 board. Puyo fall in pairs, and can be moved left, right, down, and rotated clockwise or counter clockwise by the player. When there are four or more of the same colored Puyo adjacent to each other, they will pop. When Puyo pop, they cause Puyo above them to fall down as well. If this causes another group Puyo to pop, a “chain” will begin. In single player endless Puyo Puyo, the higher your chain count, the more points you receive.

Full Design Doc
---
https://docs.google.com/document/d/114oYsp2H10wIld0sRy-pdgXkgXjDXGaXQkoOZuJiFNY/edit?usp=sharing

# Development Log
## 5/24
### Wen Hao Dong
Created the skeletal code (all of the classes, methods, and necessary variables) and implemented the FallingState. (class time)

### Tristan Pragnell
Added basic visuals, grid, scoreboard, puyo color/displays, etc. (~30 minutes)

## 5/25
### Wen Hao Dong
Implemented the NewPuyoState. (~30 minutes)

### Tristan Pragnell
Continued visuals (shape, eyes, background, board, etc.) (~45 minutes)

## 5/26
### Wen Hao Dong
Implemented Puyo popping, failing, and made the Puyos easier to control. (~1 hour)

### Tristan Pragnell
Did some tweaking and minor improvements (~15 min)

## 5/27
### Wen Hao Dong
Made controlling Puyo more forgiving, implemented chaining, and updated visuals. (~1 hour)

## 5/28
### Wen Hao Dong
Visual improvements (next Puyo display, level display, Popping indicator, and small animations).
Made the game speed up as the player increases their level.
(~1 hour)

### Tristan Pragnell
Added control page, title screen, confirmation dialogue (~1.5 hours)
Added alternative keybinds

## 5/29
### Wen Hao Dong
Added ability to hard drop and drop hints.
Started on timer mode.
(~30 min)

## 5/30
### Wen Hao Dong
Balance changes and changed scoring system to match the official games'.
Finished implementing timer mode.
Smoothed out lateral movement animation for Puyo.
(~1 hour)

## 5/31
### Tristan Pragnell
Created backgrounds, board outline, and audio (~1.5 hours)

## 6/2
### Wen Hao Dong
Added sound effects and starting adding sprites from the actual game.
Added some animations and minor visual updates.
Implemented ledge climbing mechanic.
(~2.5 hours)
### Tristan Pragnell
Made some audio additions and improvements

## 6/7
### Wen Hao Dong
Updated visuals to look nicer and more akin to the actual game.
Added a motion blur to hard dropping and turned falling puyo into its own class so it isn't fixed to a grid.
(~2 hours)

## 6/8
### Wen Hao Dong
Very minor improvements.
(~20 min)

## 6/9
### Wen Hao Dong
Updated in-game ui to match that of the real game.
Updated the red X to use the game's sprites.
Updated the title screen to have the official game logo.
(~2 hours)

## 6/10
### Wen Hao Dong
Added a skin selection screen.
Added looping music from Puyo Puyo Tetris 2.
Did some minor improvements and bug fixes.
(~1.5 hours)

### Tristan Pragnell
Minor changes to control panel
