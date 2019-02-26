//
//  UIImage+bundle.m
//  Runner
//
//  Created by Persen Lee on 2019/2/26.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "UIImage+bundle.h"

@implementation UIImage (bundle)
+ (UIImage *)imageNamed:(NSString *)imageName inBundle:(NSString *)bundleName
{
    if (bundleName) {
        imageName = [NSString stringWithFormat:@"%@.bundle/%@", bundleName, imageName];
    }
    return [UIImage imageNamed:imageName inBundle:nil compatibleWithTraitCollection:nil];
}
@end
