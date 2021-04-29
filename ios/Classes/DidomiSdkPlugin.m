#import "DidomiSdkPlugin.h"
#if __has_include(<didomi_sdk/didomi_sdk-Swift.h>)
#import <didomi_sdk/didomi_sdk-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "didomi_sdk-Swift.h"
#endif

@implementation DidomiSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDidomiSdkPlugin registerWithRegistrar:registrar];
}
@end
