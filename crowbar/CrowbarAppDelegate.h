//
//  CrowbarAppDelegate.h
//  crowbar
//
//  Created by Richo Healey on 4/02/13.
//  Copyright (c) 2013 Richo Healey. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CrowbarAppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet NSMenu *statusMenu;
    NSStatusItem * statusItem;
}

-(void)initMenu;
-(void)runTaskImmediately:(id)sender;

@property (assign) IBOutlet NSWindow *window;

@end
