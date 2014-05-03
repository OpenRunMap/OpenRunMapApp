//
//  RHRouteListTableViewController.m
//  OpenRunMap
//
//  Created by Robin Goos on 03/05/14.
//  Copyright (c) 2014 RunHackers. All rights reserved.
//

#import "RHRouteListTableViewController.h"
#import <TheSidebarController/TheSidebarController.h>
#import "RHRouteTableViewCell.h"
#import "RHRoute.h"

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RHRouteTableViewCell *cell = (RHRouteTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSNotification *routeNotification = [NSNotification notificationWithName:@"com.runhackers.openrunmap.routepicked" object:cell.route];
    [[NSNotificationCenter defaultCenter] postNotification:routeNotification];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Refreshing
- (void)updateTableViewWithRoutes:(NSArray *)routes
{
    [self.tableView beginUpdates];
    [self.routes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:idx inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    [self.routes removeAllObjects];
    
    [routes enumerateObjectsUsingBlock:^(RHRoute *route, NSUInteger idx, BOOL *stop) {
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:idx inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.routes addObject:route];
    }];
    
    [self.tableView endUpdates];
}

- (void)fetchLatestRoutes:(void (^)(NSArray *routes))completionBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"sample_route" ofType:@"json"];
        
        NSInputStream *jsonStream = [NSInputStream inputStreamWithFileAtPath:path];
        [jsonStream open];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithStream:jsonStream options:NSJSONReadingAllowFragments error:nil];
        
        RHRoute *route = [RHRoute fromJSON:json];
        [NSThread sleepForTimeInterval:0.6];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(@[route]);
        });
    });
}

- (IBAction)refreshControlValueChanged:(UIRefreshControl *)refreshControl
{
    [self fetchLatestRoutes:^(NSArray *routes) {
        [self updateTableViewWithRoutes:routes];
        [refreshControl endRefreshing];
    }];
}

@end
