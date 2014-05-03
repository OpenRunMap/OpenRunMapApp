//
//  RHViewController.m
//  OpenRunMap
//
//  Created by Robin Goos on 03/05/14.
//  Copyright (c) 2014 RunHackers. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "RHMapViewController.h"
#import "RHRoute.h"
#import "NSTimer+BlockAdditions.h"
#import <TheSidebarController/TheSidebarController.h>
#import <MBXMapKit/MBXMapKit.h>
#import <AVFoundation/AVFoundation.h>

static NSString * const RHUserPinIdentifier = @"com.runhackers.openrunmap.userpin";
static NSString * const RHMapKitMapIdentifier = @"petersongis.map-ogsoty39";
static NSString * const RHRouteTileTemplate = @"https://www.mapbox.com/v3/igorti.routes/{z}/{x}/{y}.png";

static NSString * const RHSpeechUtteranceStart = @"Have a nice run!";
static NSString * const RHSpeechUtteranceLeft = @"Take left at the next turn";
static NSString * const RHSpeechUtteranceForward = @"Continue straight forward at the next turn";
static NSString * const RHSpeechUtteranceRight = @"Take right at the next turn";
static NSString * const RHSpeechUtteranceFinish = @"You're almost finished, well done!";

@interface RHRouteStep (AnnotationAdditions)<MKAnnotation>
@end

@implementation RHRouteStep (AnnotationAdditions)

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D *coords = malloc(self.polyline.pointCount * sizeof(CLLocationCoordinate2D));
    [self.polyline getCoordinates:coords range:NSMakeRange(0, self.polyline.pointCount)];

    return coords[0];
}

@end

@interface RHFakeUserAnnotation : NSObject<MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end

@implementation RHFakeUserAnnotation

- (NSString *)title
{
    return @"";
}

- (NSString *)subtitle
{
    return @"";
}

@end

@interface RHMapViewController ()<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *mapContainerView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIButton *startRunningButton;
@property (strong, nonatomic) MBXMapView *mapView;

@property (strong, nonatomic) NSArray *routeStepAnnotations;
@property (strong, nonatomic) RHFakeUserAnnotation *fakeUserAnnotation;
@property (strong, nonatomic) NSTimer *fakeRunningTimer;
@property (assign, nonatomic) NSInteger fakeRunningIndex;
@property (assign, nonatomic) NSInteger fakeRunningStepIndex;

@property (strong, nonatomic) RHRoute *currentRoute;
@property (strong, nonatomic) AVSpeechSynthesizer *speechSynthesizer;


@end

@implementation RHMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.speechSynthesizer = [AVSpeechSynthesizer new];
    
    self.mapView = [[MBXMapView alloc] initWithFrame:self.mapContainerView.bounds mapID:RHMapKitMapIdentifier];
    self.mapView.delegate = self;
    
    MKTileOverlay *routesTileOverlay = [[MKTileOverlay alloc] initWithURLTemplate:RHRouteTileTemplate];
    
    [self.mapView addOverlay:routesTileOverlay level:MKOverlayLevelAboveLabels];
    
    [self.mapContainerView addSubview:self.mapView];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    self.toolbar.clipsToBounds = YES;
    MKUserTrackingBarButtonItem *trackingButton = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
    self.toolbar.items = @[trackingButton];
    
    self.startRunningButton.enabled = NO;
    self.fakeUserAnnotation = [RHFakeUserAnnotation new];
    [self.mapView addAnnotation:self.fakeUserAnnotation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeWasPickedNotification:) name:@"com.runhackers.openrunmap.routepicked" object:nil];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapBackground)];
    [self.view addGestureRecognizer:recognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)routeWasPickedNotification:(NSNotification *)notification
{
    [self.sidebarController dismissSidebarViewController];
    self.fakeRunningIndex = 0;
    self.fakeRunningStepIndex = 0;

    if (self.currentRoute) {
        [self.mapView removeOverlays:[self.currentRoute.steps valueForKey:@"polyline"]];
    }
    
    self.currentRoute = notification.object;

    for (RHRouteStep *step in self.currentRoute.steps) {
        [self.mapView addOverlay:[self.currentRoute polyline] level:MKOverlayLevelAboveLabels];
        [self.mapView addAnnotation:step];
    }
    
    MKPolyline *bigline = [self.currentRoute polyline];
    
    [self.mapView setVisibleMapRect:[bigline boundingMapRect] edgePadding:UIEdgeInsetsMake(110.0, 110.0, 110.0, 110.0) animated:YES];
    self.startRunningButton.enabled = YES;
    
    CLLocationCoordinate2D *coords = malloc(bigline.pointCount * sizeof(CLLocationCoordinate2D));
    [bigline getCoordinates:coords range:NSMakeRange(0, bigline.pointCount)];
    
    self.fakeUserAnnotation.coordinate = coords[0];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.currentRoute];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"com.runhackers.openrunmap.routepicked"];
    });
}

- (IBAction)startRunningButtonTapped:(id)sender
{
    if (self.fakeRunningTimer) {
        [self.fakeRunningTimer invalidate];
        self.fakeRunningTimer = nil;
        return;
    }
    
    __block void(^recurseBlock)();
    
    void(^completionBlock)() = ^{
        self.fakeRunningIndex = 0;
        if (++self.fakeRunningStepIndex < self.currentRoute.steps.count) {
            RHRouteStep *step = self.currentRoute.steps[self.fakeRunningStepIndex];
            [self startFakeRunningStep:step completion:recurseBlock];
        } else {
            self.fakeRunningStepIndex = 0;
        }
    };
    
    recurseBlock = completionBlock;
    [self startFakeRunningStep:self.currentRoute.steps[self.fakeRunningStepIndex] completion:recurseBlock];
}

- (void)startFakeRunningStep:(RHRouteStep *)step completion:(void (^)())completionBlock
{
    MKPolyline *polyline = [step polyline];
    CLLocationCoordinate2D *coords = malloc(polyline.pointCount * sizeof(CLLocationCoordinate2D));
    [polyline getCoordinates:coords range:NSMakeRange(0, polyline.pointCount)];
    
    self.fakeRunningTimer = [NSTimer setTimeout:1.0 callback:^{
        if (self.fakeRunningIndex == polyline.pointCount) {
            [self.fakeRunningTimer invalidate];
            self.fakeRunningTimer = nil;
            return completionBlock();
        } else if (self.fakeRunningIndex == polyline.pointCount - 1 && self.fakeRunningStepIndex != self.currentRoute.steps.count - 1) {
            RHRouteStep *nextStep = self.currentRoute.steps[self.fakeRunningStepIndex+1];
            [self.speechSynthesizer speakUtterance:[self speechUtteranceForRouteStepType:nextStep.type]];
        }
        
        self.fakeUserAnnotation.coordinate = coords[self.fakeRunningIndex++];
        [self.mapView setCenterCoordinate:self.fakeUserAnnotation.coordinate zoomLevel:15 animated:YES];
    } repeats:YES];
}

- (AVSpeechUtterance *)speechUtteranceForRouteStepType:(RHRouteStepType)stepType
{
    AVSpeechUtterance *utterance = nil;
    if (stepType == RHRouteStepTypeStart) {
        utterance = [[AVSpeechUtterance alloc] initWithString:RHSpeechUtteranceStart];
    } else if (stepType == RHRouteStepTypeLeftTurn) {
        utterance = [[AVSpeechUtterance alloc] initWithString:RHSpeechUtteranceLeft];
    } else if (stepType == RHRouteStepTypeRightTurn) {
        utterance = [[AVSpeechUtterance alloc] initWithString:RHSpeechUtteranceRight];
    } else if (stepType == RHRouteStepTypeForward) {
        utterance = [[AVSpeechUtterance alloc] initWithString:RHSpeechUtteranceForward];
    } else if (stepType == RHRouteStepTypeFinish) {
        utterance = [[AVSpeechUtterance alloc] initWithString:RHSpeechUtteranceFinish];
    }
    
    utterance.rate = 0.3;
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
    
    return utterance;
}


- (IBAction)menuButtonTapped:(id)sender
{
    if (self.sidebarController.sidebarIsPresenting) {
        [self.sidebarController dismissSidebarViewController];
    } else {
        [self.sidebarController presentLeftSidebarViewControllerWithStyle:SidebarTransitionStyleAirbnb];
    }
}

- (void)didTapBackground
{
    if (self.sidebarController.sidebarIsPresenting) {
        [self.sidebarController dismissSidebarViewController];
    }
}

#pragma mark - MKMapViewDelegate Protocol

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *polyline = (MKPolyline *)overlay;
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:polyline];
        renderer.fillColor = [UIColor cyanColor];
        renderer.strokeColor = [UIColor colorWithRed:0.0 green:129.0/255.0 blue:174.0/255.0 alpha:1.0];
        renderer.lineWidth = 3.0;
        
        return renderer;
    } else {
        return [[MKTileOverlayRenderer alloc] initWithOverlay:overlay];
    }
    return nil;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:RHUserPinIdentifier];
    if (!annotationView) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:RHUserPinIdentifier];
    }
    
    if ([annotation isKindOfClass:[RHFakeUserAnnotation class]]) {
        annotationView.image = [UIImage imageNamed:@"UserLocationPin"];
    } else if ([annotation isKindOfClass:[RHRouteStep class]]) {
        annotationView.image = [UIImage imageNamed:@"RouteStepPin"];
    }
    
    return annotationView;
}

@end
