//
//  RHViewController.m
//  OpenRunMap
//
//  Created by Robin Goos on 03/05/14.
//  Copyright (c) 2014 RunHackers. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "RHMapViewController.h"
#import <TheSidebarController/TheSidebarController.h>

@interface RHMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIButton *startRunningButton;

@end

@implementation RHMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.startRunningButton.enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)locationButtonTapped:(id)sender
{
    self.mapView.showsUserLocation = !self.mapView.showsUserLocation;
}

- (IBAction)startRunningButtonTapped:(id)sender
{
    
}

- (IBAction)menuButtonTapped:(id)sender
{
    if (self.sidebarController.sidebarIsPresenting) {
        [self.sidebarController dismissSidebarViewController];
    } else {
        [self.sidebarController presentLeftSidebarViewControllerWithStyle:SidebarTransitionStyleAirbnb];
    }
}

@end
