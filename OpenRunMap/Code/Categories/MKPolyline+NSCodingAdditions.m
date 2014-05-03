//
//  MKPolyline+NSCodingAdditions.m
//  OpenRunMap
//
//  Created by Robin Goos on 03/05/14.
//  Copyright (c) 2014 RunHackers. All rights reserved.
//

#import "MKPolyline+NSCodingAdditions.h"

@implementation MKPolyline (NSCodingAdditions)

- (id)initWithCoder:(NSCoder *)decoder
{
    NSData *coordData = [decoder decodeObjectForKey:@"coordinates"];
    CLLocationCoordinate2D *coords = (CLLocationCoordinate2D *)[coordData bytes];
    NSUInteger len = sizeof(CLLocationCoordinate2D) / coordData.length;
    self = [MKPolyline polylineWithCoordinates:coords count:len];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    NSUInteger len = self.pointCount;
    CLLocationCoordinate2D coords[len];
    [self getCoordinates:coords range:NSMakeRange(0, len)];
    [encoder encodeObject:[NSData dataWithBytes:(void*)coords length:len] forKey:@"coordinates"];
}

@end
