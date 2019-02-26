//
//  PLSaveImageActivity.m
//  Runner
//
//  Created by Persen Lee on 2019/2/25.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "PLSaveImageActivity.h"
#import "WTAuthorizationTool.h"
#import "MBProgressHUD.h"
#import "UIImage+bundle.h"

@interface PLSaveImageActivity()
{
    __block BOOL _galleryAuthorized;
}
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) MBProgressHUD *saveHud;
@property (nonatomic, strong) MBProgressHUD *completeHud;
@property (nonatomic, strong) MBProgressHUD *failHud;
@end


@implementation PLSaveImageActivity
- (UIActivityType)activityType
{
    return @"SaveImageToCameraRoll";
}


- (NSString *)activityTitle
{
    return  NSLocalizedString(@"Save Image", @"Save Image") ;
}


- (UIImage *)activityImage
{
   
    return [UIImage imageNamed:@"save" inBundle:@"native_share"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    for (id item in activityItems) {
        if ([item isKindOfClass:[UIImage class]]) {
            _image = item;
            return YES;
        }
    }
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    
    
}

- (void)performActivity
{
    [WTAuthorizationTool requestImagePickerAuthorization:^(WTAuthorizationStatus status) {
        if (status == WTAuthorizationStatusAuthorized) {
            [self.saveHud showAnimated:YES];
            UIImageWriteToSavedPhotosAlbum(self.image,
                                           self,
                                           @selector(image:didFinishSavingWithError:contextInfo:),
                                           NULL);
        } else {
            self.failHud.detailsLabel.text = @"Album Authorized Failed";
            [self.failHud hideAnimated:YES afterDelay:3];
        }
    }];
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
    [self.saveHud hideAnimated:YES];
    [self activityDidFinish:YES];
    if (error != nil) {
        self.failHud.detailsLabel.text = error.localizedDescription;
        [self.failHud hideAnimated:YES afterDelay:1];
    } else {
        [self.completeHud hideAnimated:YES afterDelay:1];
    }
}


- (MBProgressHUD *)saveHud
{
    if (!_saveHud) {
        _saveHud  = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
        _saveHud.mode = MBProgressHUDModeText;
        _saveHud.square = YES;
        _saveHud.label.text = NSLocalizedString(@"Saving", @"save");
    }
    return _saveHud;
}

- (MBProgressHUD *)completeHud
{
    if (!_completeHud) {
        _completeHud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
        _completeHud.mode = MBProgressHUDModeCustomView;
        _completeHud.square = YES;
        UIImage *image = [UIImage imageNamed:@"ok" inBundle:@"native_share"];
        _completeHud.customView = [[UIImageView alloc] initWithImage:image];
        _completeHud.label.text = NSLocalizedString(@"Done", @"comlete");
    }
    return _completeHud;
}

- (MBProgressHUD *)failHud
{
    if (!_failHud) {
        _failHud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
        _failHud.mode = MBProgressHUDModeCustomView;
        _failHud.square = YES;
        UIImage *image = [UIImage imageNamed:@"fail" inBundle:@"native_share"];
        _failHud.customView = [[UIImageView alloc] initWithImage:image];
        _failHud.label.text = NSLocalizedString(@"Fail", @"fail");
    }
    return _failHud;
}


@end
