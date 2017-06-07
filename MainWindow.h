//
//  Board.h
//  Hello
//
//  Created by Ivan Chistyakov on 27.01.15.
//  Copyright (c) 2015 Ivan Chistyakov. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AudioToolbox/AudioToolbox.h>

@class RecordsWindow;

@interface MainWindow : NSWindow <NSWindowDelegate>
{
    IBOutlet NSTextField *pointsLabel;
    IBOutlet NSTextField *recordLabel;
    IBOutlet NSButton *newGameButton;
    IBOutlet NSView *fieldView;
    int nextBallsColours[3];
    IBOutlet NSImageView *nextBallOne;
    IBOutlet NSImageView *nextBallTwo;
    IBOutlet NSImageView *nextBallThree;
    NSImageView *ballsArray[9][9];
    
    IBOutlet NSButton *soundButton;
    
    bool newGameIndicator;
    int numberOfBalls;
    int ballToMoveX, ballToMoveY;
    int offset;
    bool offsetIncrease;
    bool ballToMoveChosen;
    int points;
    NSTimer *jumpTimer;
    int animationTime;
    int direction;
    
    RecordsWindow *recordsWindow;
}

- (IBAction)newGame:(NSButton *)sender;
- (IBAction)soundButtonPressed:(NSButton *)sender;
- (IBAction)recordButtonPressed:(NSButton *)sender;
- (IBAction)clearRecordsPressed:(NSMenuItem *)sender;

- (void) prepareNext;
- (void) placeRandom;
- (bool) possibleToMove: (int)px :(int)py;
- (void) check: (bool)putNewBalls;
- (void) saveScore: (int)score;
- (void) jump;

@end
