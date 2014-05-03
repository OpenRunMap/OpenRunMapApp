//
//  RHRouteTableViewCell.m
//  OpenRunMap
//
//  Created by Robin Goos on 03/05/14.
//  Copyright (c) 2014 RunHackers. All rights reserved.
//

#import "RHRouteTableViewCell.h"

@interface RHRouteTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *estimatedTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *groundTypeImageView;


@end

@implementation RHRouteTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setRoute:(RHRoute *)route
{
    [self willChangeValueForKey:@"route"];
    _route = route;
    self.nameLabel.text = route.name;
    self.estimatedTimeLabel.text = [self stringForEstimatedTimeInterval:route.estimatedTime];
    
    [self didChangeValueForKey:@"route"];
}

- (NSString *)stringForEstimatedTimeInterval:(NSTimeInterval)estimatedTime
{
    NSInteger minutes = estimatedTime / 60;
    NSInteger seconds = estimatedTime - minutes * 60;

    NSString *minutesString = (minutes < 10) ? @"0" : @"";
    minutesString = [NSString stringWithFormat:@"%@%ld", minutesString, (long)minutes];
    
    NSString *secondsString = (seconds < 10) ? @"0" : @"";
    secondsString = [NSString stringWithFormat:@"%@%ld", secondsString, (long)seconds];
    
    return [NSString stringWithFormat:@"Estimated time: %@:%@", minutesString, secondsString];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
