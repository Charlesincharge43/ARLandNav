//
//  ARViewManagerBridge.m
//  ARLandNav

// ARViewManagerBridge.m
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(ARViewManager, NSObject)

RCT_EXTERN_METHOD(addEvent:(NSString *)name location:(NSString *)location date:(nonnull NSNumber *)date)
RCT_EXTERN_METHOD(startARView:(NSArray *)checkpoints)
RCT_EXTERN_METHOD(stopARView)

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

@end
