//
//  RHContainerViewController.m
//  OpenRunMap
//
//  Created by Robin Goos on 03/05/14.
//  Copyright (c) 2014 RunHackers. All rights reserved.
//

#import "TheSidebarController.h"
#import "RHContainerViewController.h"
#import "RHMapViewController.h"
#import "RHSettingsMenuViewController.h"

@interface RHContainerViewController ()

@property (strong, nonatomic) TheSidebarController *sidebarController;

@end

@implementation RHContainerViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    RHMapViewController *contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
    RHSettingsMenuViewController *leftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsMenuViewController"];

    self.sidebarController = [[TheSidebarController alloc] initWithContentViewController:contentViewController leftSidebarViewController:leftViewController];
    
    self.sidebarController.view.frame = self.view.bounds;
    [self.view addSubview:self.sidebarController.view];
    self.sidebarController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self addChildViewController:self.sidebarController];
    [self.sidebarController didMoveToParentViewController:self];
    
    self.sidebarController.leftSidebarViewController.view.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.frame) - 66.0, CGRectGetHeight(self.view.frame));
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapBackground)];
    [self.view addGestureRecognizer:recognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didTapBackground
{
    if (self.sidebarController.sidebarIsPresenting) {
        [self.sidebarController dismissSidebarViewController];
    }
}

@end
