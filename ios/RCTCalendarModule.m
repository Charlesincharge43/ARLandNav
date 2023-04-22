// RCTCalendarModule.m
#import "RCTCalendarModule.h"
#import <React/RCTLog.h>

@implementation RCTCalendarModule

// To export a module named RCTCalendarModule
RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(createCalendarEvent:(NSString *)name location:(NSString *)location callback:(RCTResponseSenderBlock)callback)
{
  RCTLogInfo(@"Prrretendinggg to create an event %@ at %@", name, location);
  NSNumber *eventId = [NSNumber numberWithInt:arc4random_uniform(100000)];
  callback(@[[NSNull null], eventId]);
}
@end
