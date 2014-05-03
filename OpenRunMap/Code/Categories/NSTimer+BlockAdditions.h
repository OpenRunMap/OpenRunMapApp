//
//  NSTimer+BlockAdditions.h
//  Sandbox
//
//  Created by Robin Goos on 4/21/13.
//  Copyright (c) 2013 Goos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (BlockAdditions)

+ (NSTimer *)setTimeout:(NSTimeInterval)timeout callback:(void(^)())callback repeats:(BOOL)repeats;

@end
