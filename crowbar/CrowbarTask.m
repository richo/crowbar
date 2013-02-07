#import <Cocoa/Cocoa.h>
#import "CrowbarTask.h"

@implementation CrowbarTask

+ (NSTask *)new:(NSString *)command {
  NSTask *task = [[NSTask alloc] init];
  [task setLaunchPath:@"/bin/sh"];
  [task setArguments:[[NSArray alloc] initWithObjects:@"-c", command, nil]];

  NSPipe *opipe, *ipipe;
  opipe = [NSPipe pipe];
  ipipe = [NSPipe pipe];

  [task setStandardOutput:opipe];
  [task setStandardInput:ipipe];

  NSFileHandle *file = [ipipe fileHandleForWriting];

  [file closeFile];
  return task;
}

@end
