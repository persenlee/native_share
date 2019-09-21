#import "NativeSharePlugin.h"
#import "PLSaveImageActivity.h"

@implementation NativeSharePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"plugin.persenlee.com/native_share"
            binaryMessenger:[registrar messenger]];
  NativeSharePlugin* instance = [[NativeSharePlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if([@"share" isEqualToString:call.method]) {
      [self share:call.arguments result: result];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)share:(NSDictionary *)params result:(FlutterResult) result {
    if(params == nil) {
      return;
    }
    NSString *title = params[@"title"];
    NSString *urlStr = params[@"url"];
    NSString *imagePath = params[@"image"];
    NSMutableArray *activityItems = [NSMutableArray new];
    if (title) {
        [activityItems addObject:title];
    }
    if (urlStr) {
        NSURL *url = [NSURL URLWithString:urlStr];
        if (url) {
            [activityItems addObject:url];
        }
        [activityItems addObject:url];
    }
    UIImage *image = nil;
    if (imagePath) {
        NSURL *imageUrl = [NSURL URLWithString:imagePath];
        if (TARGET_IPHONE_SIMULATOR) {
            if (imageUrl.scheme) {
                NSError *error;
                NSData *data = [NSData dataWithContentsOfURL:imageUrl options:NSDataReadingMappedIfSafe error:&error];
                if (data) {
                    image = [UIImage imageWithData:data];
                }
            } else {
                image = [UIImage imageWithContentsOfFile:imagePath];
            }
            
        } else {
            if ([imageUrl.scheme isEqualToString:@"file"]) {
                image = [UIImage imageWithContentsOfFile:imagePath];
            } else {
                NSError *error;
                NSData *data = [NSData dataWithContentsOfURL:imageUrl options:NSDataReadingMappedIfSafe error:&error];
                if (data) {
                    image = [UIImage imageWithData:data];
                }
            }
        }
        
    }
    if (!image) {
        image = [UIImage imageNamed:@"AppIcon"];
    }
    if (image) {
        [activityItems addObject:image];
    }
    
    PLSaveImageActivity *saveImageActivity = [PLSaveImageActivity new];
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                      applicationActivities:@[saveImageActivity]];
    activityViewController.excludedActivityTypes = @[UIActivityTypeSaveToCameraRoll];
    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    activityViewController.popoverPresentationController.sourceView = controller.view;

    activityViewController.completionWithItemsHandler = ^(NSString *activityType,
                                                          BOOL completed,
                                                          NSArray *returnedItems,
                                                          NSError *error) {
        
        if (error) {
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"Error %ld", error.code]
            message:error.domain
            details:error.localizedDescription]);
        } else if (completed) {
            // user shared an item
            result(@0);
        } else {
            // user cancelled
            result(@-1);
        }
    };

    [controller presentViewController:activityViewController animated:YES completion:nil];
}

@end
