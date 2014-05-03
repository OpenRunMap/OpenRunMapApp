//
//  RHRoute.h
//  OpenRunMap
//
//  Created by Robin Goos on 03/05/14.
//  Copyright (c) 2014 RunHackers. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    RHRouteGroundTypeGravel,
    RHRouteGroundTypeDirt,
    RHRouteGroundTypeAsphalt
} RHRouteGroundType;

@interface RHRoute : NSObject <NSCoding>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *steps;
@property (assign, nonatomic) RHRouteGroundType groundType;
@property (assign, nonatomic) NSTimeInterval estimatedTime;

- (id)initWithName:(NSString *)name routeSteps:(NSArray *)routeSteps groundType:(RHRouteGroundType)groundType estimatedTime:(NSTimeInterval)estimatedTime;


@end
