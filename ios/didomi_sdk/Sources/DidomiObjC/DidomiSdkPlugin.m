#import "DidomiSdkPlugin.h"
#import <Flutter/Flutter.h>

// For CocoaPods/traditional builds
#if __has_include(<didomi_sdk/didomi_sdk-Swift.h>)
#import <didomi_sdk/didomi_sdk-Swift.h>
#else
// For SPM builds, import the Swift module directly
@import DidomiSwift;
#endif

@implementation DidomiSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDidomiSdkPlugin registerWithRegistrar:registrar];
}
@end
