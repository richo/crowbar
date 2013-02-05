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

#define LINE_SIZE 1024

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
    int tasks = 0;
    int errors = 0;
    FILE* fp = get_cron_file();
    char line[LINE_SIZE];
    if (fp) {
        while (fgets(line, sizeof(line), fp)) {
            if (parse_line(line)) {
                [statusMenu addItem:[[NSMenuItem alloc] initWithTitle:@"crowbar tasks" action:@selector(trolol) keyEquivalent:@""]];
                tasks++;
            } else {
                errors++;
            }
        }

    }
    if (tasks == 0) {
        [statusMenu addItem:[[NSMenuItem alloc] initWithTitle:@"No crowbar jobs defined" action:nil keyEquivalent:@""]];
    }
    fclose(fp);
}

-(void)trolol{

}
@end
