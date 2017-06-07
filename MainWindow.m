#import "MainWindow.h"
#import "RecordsWindow.h"

#define BOTTOM_PANEL_HEIGHT 100
#define FIELD_HEIGHT 540

struct list {
    int x;
    int y;
    struct list *next;
};

@implementation MainWindow

- (void) mouseDown:(NSEvent*)theEvent {
    if (newGameIndicator == true) {
        CGPoint mouseLoc = [theEvent locationInWindow];
        if (mouseLoc.y > BOTTOM_PANEL_HEIGHT && mouseLoc.y < BOTTOM_PANEL_HEIGHT + FIELD_HEIGHT) {
            mouseLoc.y -= BOTTOM_PANEL_HEIGHT;
            int px = mouseLoc.x / 60, py = mouseLoc.y / 60;
            if (ballsArray[px][py] == nil && ballToMoveChosen == false) return;
            if (ballToMoveChosen == false) {
                ballToMoveX = mouseLoc.x / 60;
                ballToMoveY = mouseLoc.y / 60;
                ballToMoveChosen = true;
                offset = 0; offsetIncrease = true;
                jumpTimer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(jump) userInfo:nil repeats:YES];
                
                if ([soundButton state] == NSOnState) {
                    SystemSoundID SoundClickID;
                    NSString *soundFile1 = [[NSBundle mainBundle] pathForResource:@"Click" ofType:@"mp3"];
                    AudioServicesCreateSystemSoundID((__bridge CFURLRef) [NSURL fileURLWithPath:soundFile1], &SoundClickID);
                    AudioServicesPlaySystemSound(SoundClickID);
                }
                
            }
            else if ([self possibleToMove: px :py] == true) {
                [self check: true];
                ballToMoveChosen = false;
                [jumpTimer invalidate];
            }
        }
    }
}

- (IBAction) newGame:(NSButton *)sender {
    
    for (int i = 0; i < 9; i++) for (int j = 0; j < 9; j++) {
        if (ballsArray[i][j] != nil) [ballsArray[i][j] removeFromSuperview];
        ballsArray[i][j] = nil;
    }
    numberOfBalls = 0;
    [self prepareNext];
    [self placeRandom];
    [self prepareNext];
    newGameIndicator = true;
    [newGameButton setTitle:@"Replay"];
    [pointsLabel setStringValue:@"0"];
    [self saveScore:points];
    [recordsWindow updateRecordsList];
    points = 0;
}

- (IBAction) soundButtonPressed:(NSButton *)sender {
    if ([soundButton state] == NSOnState) soundButton.title = @"Sound: On";
    else soundButton.title = @"Sound: Off";
}

- (IBAction) recordButtonPressed:(NSButton *)sender {
    
    if (!recordsWindow) {
        recordsWindow = [[RecordsWindow alloc] initWithWindowNibName:@"RecordsWindow"];
    }
    [recordsWindow showWindow:self];
    
    [recordsWindow updateRecordsList];
    
}

- (IBAction) clearRecordsPressed:(NSMenuItem *)sender {
    [recordsWindow initRecordList];
    [recordsWindow updateRecordsList];
}

- (void) prepareNext {
    for (int i = 0; i < 3; i++) {
        nextBallsColours[i] = arc4random_uniform(7) + 1;
    }
    nextBallOne.image = [NSImage imageNamed: [NSString stringWithFormat:@"%d", nextBallsColours[0]]];
    nextBallTwo.image = [NSImage imageNamed: [NSString stringWithFormat:@"%d", nextBallsColours[1]]];
    nextBallThree.image = [NSImage imageNamed: [NSString stringWithFormat:@"%d", nextBallsColours[2]]];
}

- (void) placeRandom {
    for (int i = 0; i < 3; i++) {
        if (numberOfBalls < 81) {
            int x = arc4random_uniform(9);
            int y = arc4random_uniform(9);
            while (ballsArray[x][y] != nil) {
                x = arc4random_uniform(9);
                y = arc4random_uniform(9);
            }
            numberOfBalls++;
            NSImageView *imageView = [[NSImageView alloc] initWithFrame:CGRectMake(x * 60, y * 60, 60, 60)];
            imageView.image = [NSImage imageNamed: [NSString stringWithFormat:@"%d", nextBallsColours[i]]];
            [fieldView addSubview: imageView];
            ballsArray[x][y] = imageView;
            
            if (numberOfBalls == 81) {
                printf("a");
                if (i == 2) [self check: false];
                if (numberOfBalls == 81) {
                    [self saveScore:points];
                    [newGameButton setTitle:@"Try again!"];
                    
                    if ([soundButton state] == NSOnState) {
                        SystemSoundID SoundApplauseID;
                        NSString *soundFile2 = [[NSBundle mainBundle] pathForResource:@"Applause" ofType:@"mp3"];
                        AudioServicesCreateSystemSoundID((__bridge CFURLRef) [NSURL fileURLWithPath:soundFile2], &SoundApplauseID);
                        AudioServicesPlaySystemSound(SoundApplauseID);
                    }
                    
                    break;
                }
            }
        }
    }
}

- (bool) possibleToMove: (int)px :(int)py {
    if (ballsArray[px][py] == nil) {
        
        if ([soundButton state] == NSOnState) {
            SystemSoundID SoundClickID;
            NSString *soundFile1 = [[NSBundle mainBundle] pathForResource:@"Click" ofType:@"mp3"];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef) [NSURL fileURLWithPath:soundFile1], &SoundClickID);
            AudioServicesPlaySystemSound(SoundClickID);
        }
        
        int board[9][9];
        
        for (int i = 0; i < 9; i++) for (int j = 0; j < 9; j++) {
            if (ballsArray[i][j] == nil) board[i][j] = 0;
            else board[i][j] = -1;
        }
        
        int time = 1;
        board[ballToMoveX][ballToMoveY] = time;
        
        while (board[px][py] == 0) {
            bool timeIsWasted = true;
            for (int i = 0; i < 9; i++) for (int j = 0; j < 9; j++) {
                if (board[i][j] == time) {
                    if (i > 0 && board[i - 1][j] == 0) {
                        board[i - 1][j] = time + 1;
                        timeIsWasted = false;
                    }
                    if (j < 8 && board[i][j + 1] == 0) {
                        board[i][j + 1] = time + 1;
                        timeIsWasted = false;
                    }
                    if (i < 8 && board[i + 1][j] == 0) {
                        board[i + 1][j] = time + 1;
                        timeIsWasted = false;
                    }
                    if (j > 0 && board[i][j - 1] == 0) {
                        board[i][j - 1] = time + 1;
                        timeIsWasted = false;
                    }
                }
            }
            if (timeIsWasted == true) return false;
            time++;
        }
        
        
        struct list *last = malloc(sizeof(struct list)), *start = last;
        last->x = px; last->y = py;
        last->next = NULL;
        while (time > 0) {
            time--;
            if (px > 0 && board[px - 1][py] == time) {
                struct list *q = malloc(sizeof(struct list));
                q->next = start;
                q->x = px - 1; q->y = py;
                px = q-> x; py = q->y;
                start = q;
            }
            else if (py < 8 && board[px][py + 1] == time) {
                struct list *q = malloc(sizeof(struct list));
                q->next = start;
                q->x = px; q->y = py + 1;
                px = q-> x; py = q->y;
                start = q;
            }
            else if (px < 8 && board[px + 1][py] == time) {
                struct list *q = malloc(sizeof(struct list));
                q->next = start;
                q->x = px + 1; q->y = py;
                px = q-> x; py = q->y;
                start = q;
            }
            else if (py > 0 && board[px][py - 1] == time) {
                struct list *q = malloc(sizeof(struct list));
                q->next = start;
                q->x = px; q->y = py - 1;
                px = q-> x; py = q->y;
                start = q;
            }
        }
        
        //animationTimer = nil;
        while (start->next != NULL) {
            switch ((start->next->x - start->x) * 10 + start->next->y - start->y) {
                case 10:  { direction = 4; break; }
                case -10: { direction = 2; break; }
                case 1:   { direction = 1; break; }
                case -1:  { direction = 3; break; }
                default: direction = 0;
            }
            
            for (animationTime = 0; animationTime <= 10; animationTime++) {
                int a = animationTime;
                switch (direction) {
                    case 1:  { ballsArray[start->x][start->y].frame = CGRectMake(start->x * 60, start->y * 60 + 6 * a, 60, 60);
                        break; }
                    case 2:  { ballsArray[start->x][start->y].frame = CGRectMake(start->x * 60 - 6 * a, start->y * 60, 60, 60);
                        break; }
                    case 3:  { ballsArray[start->x][start->y].frame = CGRectMake(start->x * 60, start->y * 60 - 6 * a, 60, 60);
                        break; }
                    case 4:  { ballsArray[start->x][start->y].frame = CGRectMake(start->x * 60 + 6 * a, start->y * 60, 60, 60);
                        break; }
                    default: direction = 0;
                }
                [ballsArray[start->x][start->y] display];
            }
            
            ballsArray[start->next->x][start->next->y] = ballsArray[start->x][start->y];
            ballsArray[start->x][start->y] = nil;
            
            start = start->next;
        }
        
        return true;
    }
    else {
        ballsArray[ballToMoveX][ballToMoveY].frame = CGRectMake(ballToMoveX * 60, ballToMoveY * 60, 60, 60);
        ballToMoveX = px;
        ballToMoveY = py;
        
        if ([soundButton state] == NSOnState) {
            SystemSoundID SoundClickID;
            NSString *soundFile1 = [[NSBundle mainBundle] pathForResource:@"Click" ofType:@"mp3"];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef) [NSURL fileURLWithPath:soundFile1], &SoundClickID);
            AudioServicesPlaySystemSound(SoundClickID);
        }
        return false;
    }
}

- (void) jump {
    if (offset == 8) offsetIncrease = false;
    if (offset == 0) offsetIncrease = true;
    if (offsetIncrease == true) offset++;
    else offset--;
    ballsArray[ballToMoveX][ballToMoveY].frame = CGRectMake(ballToMoveX * 60, ballToMoveY * 60 + offset, 60, 60);
}

- (void) check: (bool)putNewBalls {
    bool ballsToDelete[9][9];
    for (int i = 0; i < 9; i++) for (int j = 0; j < 9; j++) ballsToDelete[i][j] = false;
    bool ballWasDeleted = false;
    int i = 0, j = 0;
    
    // поиск вертикальных линий
    for (i = 0; i < 9; i++) for (j = 0; j < 5; j++) {
        int count = 1;
        if (ballsArray[i][j] != nil) {
            while (j + count < 9 && ballsArray[i][j + count] != nil) {
                if (ballsArray[i][j + count].image == ballsArray[i][j].image) count++;
                else break;
            }
            if (count >= 5) while (--count >= 0) ballsToDelete[i][j + count] = true;
        }
    }
    
    // поиск горизонталных линий
    for (i = 0; i < 5; i++) for (j = 0; j < 9; j++) {
        int count = 1;
        if (ballsArray[i][j] != nil) {
            while (i + count < 9 && ballsArray[i + count][j] != nil) {
                if (ballsArray[i + count][j].image == ballsArray[i][j].image) count++;
                else break;
            }
            if (count >= 5) while (--count >= 0) ballsToDelete[i + count][j] = true;
        }
    }
    
    // поиск верхних диагональных
    for (i = 0; i < 5; i++) for (j = 0; j < 5; j++) {
        int count = 1;
        if (ballsArray[i][j] != nil) {
            while (j + count < 9 && i + count < 9 && ballsArray[i + count][j + count]) {
                if (ballsArray[i + count][j + count].image == ballsArray[i][j].image) count++;
                else break;
            }
            if (count >= 5) while (--count >= 0) ballsToDelete[i + count][j + count] = true;
        }
    }
    
    // поиск нижних диагональных
    for (i = 4; i < 9; i++) for (j = 0; j < 5; j++) {
        int count = 1;
        if (ballsArray[i][j] != nil) {
            while (j + count < 9 && i - count >= 0 && ballsArray[i - count][j + count]) {
                if (ballsArray[i - count][j + count].image == ballsArray[i][j].image) count++;
                else break;
            }
            if (count >= 5) while (--count >= 0) ballsToDelete[i - count][j + count] = true;
        }
    }
    
    // удаление шаров
    for (i = 0; i < 9; i++) for (j = 0; j < 9; j++) {
        if (ballsToDelete[i][j] == true) {
            [ballsArray[i][j] removeFromSuperview];
            ballsArray[i][j] = nil;
            ballWasDeleted = true;
            numberOfBalls--;
            points++;
            [pointsLabel setStringValue:[NSString stringWithFormat:@"%d", points]];
        }
    }
    
    if (ballWasDeleted == false) {
        if (putNewBalls == true) {
            [self placeRandom];
            [self prepareNext];
            [self check: false];
        }
    }
    else {
        if ([soundButton state] == NSOnState) {
            SystemSoundID SoundBlastID;
            NSString *soundFile = [[NSBundle mainBundle] pathForResource:@"Blast" ofType:@"mp3"];
            
            AudioServicesCreateSystemSoundID((__bridge CFURLRef) [NSURL fileURLWithPath:soundFile], &SoundBlastID);
            AudioServicesPlaySystemSound(SoundBlastID);
        }
    }
}

- (void) saveScore: (int)score {
    
    NSInteger records[10];
    for (int i = 0; i < 10; i++) records[i] = [[NSUserDefaults standardUserDefaults] integerForKey: [NSString stringWithFormat: @"HighestScore%d", i]];
    
    for (int i = 0; i < 10; i++) {
        if (score > records[i]) {
            int j = 10;
            while (j-- > i) {
                [[NSUserDefaults standardUserDefaults] setInteger:records[j - 1] forKey:[NSString stringWithFormat:@"HighestScore%d", j]];
                
                NSDate *time = [[NSUserDefaults standardUserDefaults] objectForKey: [NSString stringWithFormat: @"HighestScoreTime%d", j - 1]];

                [[NSUserDefaults standardUserDefaults] setObject:time forKey:[NSString stringWithFormat:@"HighestScoreTime%d", j]];
            }
            [[NSUserDefaults standardUserDefaults] setInteger: score forKey:[NSString stringWithFormat:@"HighestScore%d", i]];
            [[NSUserDefaults standardUserDefaults] setObject: [NSDate date] forKey:[NSString stringWithFormat:@"HighestScoreTime%d", i]];
            break;
        }
    }
    [recordLabel setIntegerValue: [[NSUserDefaults standardUserDefaults] integerForKey: [NSString stringWithFormat: @"HighestScore%d", 0]]];
    [recordsWindow updateRecordsList];
    points = 0;
    
}

@end
