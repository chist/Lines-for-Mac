//
//  AppDelegate.m
//  Lines for Mac
//
//  Created by Ivan Chistyakov on 29.01.15.
//  Copyright (c) 2015 Ivan Chistyakov. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    for (int i = 0; i < 10; i++)
        records[i] = [[NSUserDefaults standardUserDefaults] integerForKey:
                     [NSString stringWithFormat: @"HighestScore%d", i]];
    [recordLabel setIntegerValue:records[0]];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
