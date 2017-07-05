//
//  ViewController.m
//  LocationManagerDeadlock
//
//  Created by Demid Merzlyakov on 05/07/2017.
//  Copyright © 2017 DM. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, assign) BOOL goingDown;
@property (weak, nonatomic) IBOutlet UIView *viewBall;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBallY;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewBall.clipsToBounds = YES;
    self.viewBall.layer.cornerRadius = self.viewBall.frame.size.width / 2;
    
    [self throwTheBall];
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
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSThread sleepForTimeInterval:60];
    });
}

@end
