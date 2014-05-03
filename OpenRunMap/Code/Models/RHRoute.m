//
//  RHRoute.m
//  OpenRunMap
//
//  Created by Robin Goos on 03/05/14.
//  Copyright (c) 2014 RunHackers. All rights reserved.
//

#import "RHRoute.h"

@implementation RHRoute

+ (instancetype)fromJSON:(id)json
{
    NSString *name = json[@"name"];
    NSTimeInterval estimate = [json[@"estimated_time"] doubleValue];
    RHRouteGroundType groundType = (RHRouteGroundType)[json[@"ground_type"] integerValue];
    NSArray *jsonSteps = json[@"steps"];
    
    NSMutableArray *steps = [NSMutableArray array];
    for (NSDictionary *jsonStep in jsonSteps) {
        [steps addObject:[RHRouteStep fromJSON:jsonStep]];
    }
    return [[self alloc] initWithName:name routeSteps:steps groundType:groundType estimatedTime:estimate];
}

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

- (MKPolyline *)polyline
{
    NSNumber *pointCount = [self valueForKeyPath:@"steps.polyline.@sum.pointCount"];
    CLLocationCoordinate2D *coords = malloc(pointCount.integerValue * sizeof(CLLocationCoordinate2D));
    
    __block NSInteger pointCounter = 0;
    [self.steps enumerateObjectsUsingBlock:^(RHRouteStep *step, NSUInteger idx, BOOL *stop) {
        CLLocationCoordinate2D *lineCoords = malloc(sizeof(CLLocationCoordinate2D) * step.polyline.pointCount);
        [step.polyline getCoordinates:lineCoords range:NSMakeRange(0, step.polyline.pointCount)];
        for (int i = 0; i < step.polyline.pointCount; i++) {
            coords[pointCounter + i] = lineCoords[i];
        }
        pointCounter += step.polyline.pointCount;
        free(lineCoords);
    }];
    
    MKPolyline *sumLine = [MKPolyline polylineWithCoordinates:coords count:pointCount.integerValue];
    free(coords);
    
    return sumLine;
}

- (MKMapRect)boundingMapRect
{
    return [[self polyline] boundingMapRect];
}

@end
