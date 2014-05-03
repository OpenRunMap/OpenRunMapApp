//
//  RHRouteStep.h
//  OpenRunMap
//
//  Created by Robin Goos on 03/05/14.
//  Copyright (c) 2014 RunHackers. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit.MKPolyline;
#import "MKPolyline+NSCodingAdditions.h"

typedef enum {
    RHRouteStepTypeLeftTurn,
    RHRouteStepTypeForward,
    RHRouteStepTypeRightTurn
} RHRouteStepType;

@interface RHRouteStep : NSObject <NSCoding>

@property (strong, nonatomic) MKPolyline *polyline;
@property (assign, nonatomic) RHRouteStepType type;

- (id)initWithPolyline:(MKPolyline *)polyline type:(RHRouteStepType)type;

@end
