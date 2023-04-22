// SwiftModuleTestBridge.m
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(SwiftModuleTest, NSObject)

RCT_EXTERN_METHOD(addEvent:(NSString *)name location:(NSString *)location date:(nonnull NSNumber *)date)

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

@end
