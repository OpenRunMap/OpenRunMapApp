//
//  RHSettingsMenuViewController.m
//  OpenRunMap
//
//  Created by Robin Goos on 03/05/14.
//  Copyright (c) 2014 RunHackers. All rights reserved.
//

#import "RHSettingsMenuViewController.h"
#import "RHRouteListTableViewController.h"

@interface RHSettingsMenuViewController ()

@property (weak, nonatomic) RHRouteListTableViewController *routeListController;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@end

@implementation RHSettingsMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.profileImageView.layer.cornerRadius = 40.0;
    self.profileImageView.layer.masksToBounds = YES;
    // Do any additional setup after loading the view.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EmbedRouteListViewControllerSegue"]) {
        self.routeListController = segue.destinationViewController;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
