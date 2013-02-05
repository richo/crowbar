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
        struct cronitem *item = malloc(sizeof(struct cronitem));
        while (fgets(line, sizeof(line), fp)) {
            if (parse_line(line, item)) {
                /*  Debugging */
                fprintf(stderr, "Loaded |%lu| cmd: %s\n", item->period, item->cmd);
                /* /Debugging */
                NSString *titleString = [[NSString alloc] initWithBytes:item->display_cmd
                                                                 length:strlen(item->display_cmd)
                                                               encoding:NSUTF8StringEncoding];

                [statusMenu addItem:[[NSMenuItem alloc]
                                  initWithTitle:titleString
                                         action:@selector(runTaskImmediately:)
                                  keyEquivalent:@""]];
                tasks++;
            } else {
                fprintf(stderr, "Failed |%lu| cmd: %s\n", item->period, item->cmd);
                errors++;
            }
        }

    }
    if (tasks == 0) {
        [statusMenu addItem:[[NSMenuItem alloc] initWithTitle:@"No crowbar jobs defined" action:nil keyEquivalent:@""]];
    }
    fclose(fp);
}

-(void)runTaskImmediately:(id)sender{

}
@end
