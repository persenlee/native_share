//
//  UIImage+bundle.h
//  Runner
//
//  Created by Persen Lee on 2019/2/26.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (bundle)
+ (UIImage *)imageNamed:(NSString *)imageName inBundle:(NSString *)bundleName;
@end

NS_ASSUME_NONNULL_END
