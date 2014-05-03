//
//  RHRouteStep.m
//  OpenRunMap
//
//  Created by Robin Goos on 03/05/14.
//  Copyright (c) 2014 RunHackers. All rights reserved.
//

#import "RHRouteStep.h"

@implementation RHRouteStep

+ (instancetype)fromJSON:(id)json
{
    RHRouteStepType type = (RHRouteStepType)[json[@"type"] integerValue];
    NSArray *jsonCoords = json[@"coordinates"];
    CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * jsonCoords.count);
    [jsonCoords enumerateObjectsUsingBlock:^(NSDictionary *jsonCoord, NSUInteger idx, BOOL *stop) {
        CLLocationDegrees lat = [jsonCoord[@"lat"] doubleValue];
        CLLocationDegrees lon = [jsonCoord[@"lon"] doubleValue];
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(lat, lon);
        coords[idx] = coord;
    }];
    
    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coords count:jsonCoords.count];

    return [[self alloc] initWithPolyline:polyline type:type];
}

- (id)initWithPolyline:(MKPolyline *)polyline type:(RHRouteStepType)type
{
    self = [super init];
    if (self) {
        self.polyline = polyline;
        self.type = type;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    MKPolyline *polyline = [aDecoder decodeObjectForKey:@"polyLine"];
    RHRouteStepType type = (RHRouteStepType)[aDecoder decodeIntegerForKey:@"type"];
    
    self = [self initWithPolyline:polyline type:type];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.polyline forKey:@"polyLine"];
    [aCoder encodeInteger:(NSInteger)self.type forKey:@"type"];
}

@end