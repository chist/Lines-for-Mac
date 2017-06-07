//
//  RecordsWindow.h
//  Lines for Mac
//
//  Created by Ivan Chistyakov on 30.01.15.
//  Copyright (c) 2015 Ivan Chistyakov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RecordsWindow : NSWindowController {
    NSTextField *recordLines[10];
    NSTextField *timeLines[10];
    
    IBOutlet NSView *recordsListView;
}

- (void) initRecordList;
- (void) clearRecordList;
- (void) updateRecordsList;


@end
