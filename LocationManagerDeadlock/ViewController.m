//
//  ViewController.m
//  LocationManagerDeadlock
//
//  Created by Demid Merzlyakov on 05/07/2017.
//  Copyright © 2017 DM. All rights reserved.
//

#import "ViewController.h"
@import CoreLocation;

@interface ViewController ()

@property (nonatomic, assign) BOOL goingDown;
@property (weak, nonatomic) IBOutlet UIView *viewBall;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBallY;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.viewBall.clipsToBounds = YES;
    self.viewBall.layer.cornerRadius = self.viewBall.frame.size.width / 2;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self throwTheBall];
    });
}

- (void)throwTheBall {
    CGFloat newY = (self.goingDown ? 40 : 120);
    self.goingDown = !self.goingDown;
    [UIView animateWithDuration:0.5 animations:^{
        self.constraintBallY.constant = newY;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self throwTheBall];
    }];
}

- (IBAction)freezeTapped:(id)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSLog(@"background start");
        
        //If we used @synchronized(some_other_object) here, the app wouldn't freeze.
        @synchronized (self.locationManager) {
            NSLog(@"background sync start");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //There's no reason for this code block to freeze, since it is dispatched to another thread asynchronously and no synchronization primitives are mentioned at all.
                //Yet, it freezes to wait for the background thread to complete.
                //I assume, it is due to a @@synchronized(self) inside the CLLocationManager.
                //This is really an anti-pattern (example from a C# world: https://stackoverflow.com/questions/251391/why-is-lockthis-bad )
                NSLog(@"main start");
                [self.locationManager stopUpdatingLocation];
                NSLog(@"main end");
            });
            NSLog(@"background sync work for 5 seconds");
            [NSThread sleepForTimeInterval:5];
            
            NSLog(@"background sync end");
        }
        NSLog(@"background end");
    });
}

@end
