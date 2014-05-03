//
//  RHRoute.m
//  OpenRunMap
//
//  Created by Robin Goos on 03/05/14.
//  Copyright (c) 2014 RunHackers. All rights reserved.
//

#import "RHRoute.h"

@implementation RHRoute

- (id)initWithName:(NSString *)name routeSteps:(NSArray *)routeSteps groundType:(RHRouteGroundType)groundType estimatedTime:(NSTimeInterval)estimatedTime
{
    self = [super init];
    if (self) {
        self.name = name;
        self.steps = routeSteps;
        self.groundType = groundType;
        self.estimatedTime = estimatedTime;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSString *name = [aDecoder decodeObjectForKey:@"name"];
    NSArray *steps = [aDecoder decodeObjectForKey:@"steps"];
    RHRouteGroundType groundType = (RHRouteGroundType)[aDecoder decodeIntegerForKey:@"groundType"];
    NSTimeInterval estimatedTime = [aDecoder decodeDoubleForKey:@"estimatedTime"];
    
    self = [self initWithName:name routeSteps:steps groundType:groundType estimatedTime:estimatedTime];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.steps forKey:@"steps"];
    [aCoder encodeInteger:self.groundType forKey:@"groundType"];
    [aCoder encodeDouble:self.estimatedTime forKey:@"estimatedTime"];
}

@end
