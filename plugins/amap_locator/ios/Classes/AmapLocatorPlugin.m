#import "AmapLocatorPlugin.h"
#if __has_include(<amap_locator/amap_locator-Swift.h>)
#import <amap_locator/amap_locator-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "amap_locator-Swift.h"
#endif

@implementation AmapLocatorPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAmapLocatorPlugin registerWithRegistrar:registrar];
}
@end
