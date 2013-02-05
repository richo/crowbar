//
//  CrowbarAppDelegate.m
//  crowbar
//
//  Created by Richo Healey on 4/02/13.
//  Copyright (c) 2013 Richo Healey. All rights reserved.
//

#import "CrowbarAppDelegate.h"
#include <stdio.h>
#include "cronitem.h"

@implementation CrowbarAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}
-(void)awakeFromNib{
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:statusMenu];
    [statusItem setTitle:@"Crowbar"];
    [statusItem setHighlightMode:YES];

    [self initMenu];
}

-(void)initMenu{
    FILE* fp = get_cron_file();
    if (fp) {
        [statusMenu addItem:[[NSMenuItem alloc] initWithTitle:@"crowbar tasks" action:@selector(trolol) keyEquivalent:@""]];
    } else {
        [statusMenu addItem:[[NSMenuItem alloc] initWithTitle:@"No crowbar jobs defined" action:nil keyEquivalent:@""]];
    }
}

-(void)trolol{

}
@end
