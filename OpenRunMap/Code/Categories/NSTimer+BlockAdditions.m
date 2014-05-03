//
//  NSTimer+BlockAdditions.m
//  Sandbox
//
//  Created by Robin Goos on 4/21/13.
//  Copyright (c) 2013 Goos. All rights reserved.
//

#import "NSTimer+BlockAdditions.h"

typedef void(^AnonymousBlock)();

@interface TimeoutTarget : NSObject

@property (nonatomic, copy) AnonymousBlock callback;
@property (nonatomic) BOOL repeats;

- (void)performCallbackForTimer:(NSTimer *)timer;

@end

@implementation TimeoutTarget

- (void)performCallbackForTimer:(NSTimer *)timer
{
    if (timer.isValid) {
        self.callback();
        if (!self.repeats) {
            [timer invalidate];
        }
    }
}


@end

@implementation NSTimer (BlockAdditions)

+ (NSTimer *)setTimeout:(NSTimeInterval)timeout callback:(void(^)())callback repeats:(BOOL)repeats
{
    TimeoutTarget *target = [[TimeoutTarget alloc] init];
    target.callback = callback;
    target.repeats = repeats;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:timeout target:target selector:@selector(performCallbackForTimer:) userInfo:nil repeats:repeats];
    return timer;
}

@end
