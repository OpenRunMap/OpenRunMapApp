//
//  RHRouteListTableViewController.m
//  OpenRunMap
//
//  Created by Robin Goos on 03/05/14.
//  Copyright (c) 2014 RunHackers. All rights reserved.
//

#import "RHRouteListTableViewController.h"
#import "RHRouteTableViewCell.h"

static NSString * const kRouteTableViewCellIdentifier = @"RHRouteCell";

@interface RHRouteListTableViewController ()

@property (strong, nonatomic) NSMutableArray *routes;

@end

@implementation RHRouteListTableViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.routes = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 0.01)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 0.01)];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    RHRoute *sampleRoute = [[RHRoute alloc] initWithName:@"Sample route" routeSteps:nil groundType:RHRouteGroundTypeDirt estimatedTime:1231];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.routes addObject:sampleRoute];
    [self.tableView endUpdates];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.routes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RHRouteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRouteTableViewCellIdentifier];
    cell.route = self.routes[indexPath.row];
    
    return cell;
}

@end
