//
//  UIFont+OpenSans.m
//  OpenRunMap
//
//  Created by Robin Goos on 03/05/14.
//  Copyright (c) 2014 RunHackers. All rights reserved.
//

#import "UIFont+OpenSans.h"

@implementation UIFont (OpenSans)

+ (UIFont *)openSansLightFontOfSize:(CGFloat)size
{
    return [UIFont fontWithName:@"OpenSans-Light" size:size];
}

+ (UIFont *)openSansRegularFontOfSize:(CGFloat)size
{
    return [UIFont fontWithName:@"OpenSans" size:size];
}

+ (UIFont *)openSansSemiBoldFontOfSize:(CGFloat)size
{
        return [UIFont fontWithName:@"OpenSans-SemiBold" size:size];
}

+ (UIFont *)openSansBoldFontOfSize:(CGFloat)size
{
    return [UIFont fontWithName:@"OpenSans-Bold" size:size];
}

+ (UIFont *)openSansExtraBoldFontOfSize:(CGFloat)size
{
    return [UIFont fontWithName:@"OpenSans-ExtraBold" size:size];
}

@end

