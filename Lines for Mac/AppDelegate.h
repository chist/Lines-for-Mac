//
//  AppDelegate.h
//  Lines for Mac
//
//  Created by Ivan Chistyakov on 29.01.15.
//  Copyright (c) 2015 Ivan Chistyakov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    
    IBOutlet NSTextField *recordLabel;
    NSInteger record;
    
    //IBOutlet NSTextField *recordsList;
    NSInteger records[10];
}


@end

