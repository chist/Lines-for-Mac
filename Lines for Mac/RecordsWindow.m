//
//  RecordsWindow.m
//  Lines for Mac
//
//  Created by Ivan Chistyakov on 30.01.15.
//  Copyright (c) 2015 Ivan Chistyakov. All rights reserved.
//

#import "RecordsWindow.h"

@interface RecordsWindow ()
@end

@implementation RecordsWindow

- (void)windowDidLoad {
    [super windowDidLoad];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void) initRecordList {
    for (int i = 0; i < 10; i++) {
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:[NSString stringWithFormat: @"HighestScore%d", i]];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:[NSString stringWithFormat: @"HighestScoreTime%d", i]];
    }
}

- (void) clearRecordList {
    for (int i = 0; i < 10; i++) {
        [recordLines[i] setStringValue:[NSString stringWithFormat:@""]];
        [timeLines[i] setStringValue:[NSString stringWithFormat:@""]];
    }
}

- (void) updateRecordsList {
    [self clearRecordList];
    
    NSInteger records[10];
    NSDate *time[10];
    NSString *dateString[10];
    
    for (int i = 0; i < 10; i++) {
        records[i] = [[NSUserDefaults standardUserDefaults] integerForKey: [NSString stringWithFormat: @"HighestScore%d", i]];
        time[i] = [[NSUserDefaults standardUserDefaults] objectForKey: [NSString stringWithFormat: @"HighestScoreTime%d", i]];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
        dateString[i] = [dateFormat stringFromDate: time[i]];
        if (! dateString[i]) dateString[i] = @"";
    }
    
    for (int i = 0; i < 10; i++) {
        recordLines[i] = [[NSTextField alloc] initWithFrame: CGRectMake(75, 220 - 25 * i + 5, 50, 20)];
        timeLines[i] = [[NSTextField alloc] initWithFrame: CGRectMake(150, 220 - 25 * i + 5, 200, 20)];
        if (records[i] == 0) [recordLines[i] setStringValue:[NSString stringWithFormat:@"—"]];
        else {
            [recordLines[i] setStringValue:[NSString stringWithFormat:@"%ld", records[i]]];
            [timeLines[i] setStringValue:[NSString stringWithFormat:@"%@", dateString[i]]];
        }
        [recordLines[i] setEditable:NO];
        [recordLines[i] setBordered:NO];
        [recordLines[i] setBackgroundColor: [NSColor clearColor]];
        [recordsListView addSubview:recordLines[i]];
        [timeLines[i] setEditable:NO];
        [timeLines[i] setBordered:NO];
        [timeLines[i] setBackgroundColor: [NSColor clearColor]];
        [recordsListView addSubview:timeLines[i]];
        
    }
}

@end
