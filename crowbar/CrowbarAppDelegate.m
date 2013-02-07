//
//  CrowbarAppDelegate.m
//  crowbar
//
//  Created by Richo Healey on 4/02/13.
//  Copyright (c) 2013 Richo Healey. All rights reserved.
//

#import "CrowbarAppDelegate.h"
#import "CrowbarTask.h"
#include <stdio.h>
#include "cronitem.h"

#define LINE_SIZE 1024

struct cronlist *itemList = NULL, *itemHead = NULL;

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
    struct cronitem *item;
    if (fp) {
        while (fgets(line, sizeof(line), fp)) {
            item = malloc(sizeof(struct cronitem));
            if (parse_line(line, item)) {
                /*  Debugging */
                fprintf(stderr, "Loaded |%lu| cmd: %s\n", item->period, item->cmd);
                /* /Debugging */
                NSString *titleString = [[NSString alloc] initWithBytes:item->display_cmd
                                                                 length:strnlen(item->display_cmd, MAX_CMD_DISPLAY_SIZE + 1)
                                                               encoding:NSUTF8StringEncoding];

                NSMenuItem *menuItem = [[NSMenuItem alloc]
                                  initWithTitle:titleString
                                         action:@selector(runTaskImmediately:)
                                  keyEquivalent:@""];

                NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:item->period
                                                 target:self
                                               selector:@selector(runTaskImmediately:)
                                               userInfo:nil
                                                repeats:YES];

                struct cronlist *cs_item = malloc(sizeof(struct cronlist));
                cs_item->next = NULL;
                cs_item->cronitem = item;
                cs_item->menuItem = (__bridge void*)menuItem;
                cs_item->timer = (__bridge void*)timer;

                if (itemList == NULL) {
                    itemHead = itemList = cs_item;
                } else {
                    itemHead->next = cs_item;
                    itemHead = cs_item;
                }

                //menuItem->_extraData = (__bridge id)(item);
                [statusMenu addItem:menuItem];
                tasks++;
            } else {
                fprintf(stderr, "Failed to parse: %s", line);
                free(item);
                errors++;
            }
        }

    }
    if (tasks == 0) {
        [statusMenu addItem:[[NSMenuItem alloc] initWithTitle:@"No crowbar jobs defined" action:nil keyEquivalent:@""]];
    }
    fclose(fp);
}

-(void)runTaskImmediately:(NSMenuItem*)sender{
    struct cronlist* i_list = itemList;

    while (i_list) {
        if ((__bridge void*)sender == i_list->menuItem || ((__bridge void*)sender == i_list->timer)) {
            NSString *cmdString = [[NSString alloc] initWithBytes:i_list->cronitem->cmd
                                                           length:strlen(i_list->cronitem->cmd)
                                                         encoding:NSUTF8StringEncoding];
            NSTask *task = [CrowbarTask new:cmdString];
            task.terminationHandler = ^(NSTask *task) {
                NSUserNotification *note =  [[NSUserNotification alloc] init];
                note.title = [[NSString alloc] initWithBytes:i_list->cronitem->display_cmd
                                                      length:strlen(i_list->cronitem->display_cmd)
                                                    encoding:NSUTF8StringEncoding];
                fprintf(stderr, "Command exited. Output:\n");
                NSData *data = [[[task standardOutput] fileHandleForReading] readDataToEndOfFile];
                NSString *taskOutput = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
                note.informativeText = taskOutput;
                NSLog(@"%@", taskOutput);
                [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification: note];
            };
            [task launch];
            fprintf(stderr, "Executing: %s\n", i_list->cronitem->cmd);
            break;
        }
        i_list = i_list->next;
    }
    if (i_list == NULL) {
        fprintf(stderr, "Item not found");
    }
}
@end
