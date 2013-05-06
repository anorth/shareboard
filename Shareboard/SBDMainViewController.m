//
//  SBDViewController.m
//  Shareboard
//
//  Created by Alex on 19/04/13.
//  Copyright (c) 2013 Alex. All rights reserved.
//

#import "SBDMainViewController.h"
#import "SBDCameraViewController.h"
#import "SBDGoogleDriveBroker.h"

@interface SBDMainViewController() <SBDCameraViewControllerDelegate>

@property (nonatomic, strong) SBDGoogleDriveBroker *driveBroker;

@end

@implementation SBDMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.driveBroker = [[SBDGoogleDriveBroker alloc] init];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.

//  [self.driveBroker deauthorise];
}

- (void)viewDidAppear:(BOOL)animated {
  // Ask for upfront auth. FIXME delay until user tries to use Drive.
  if (![self.driveBroker isAuthorised]) {
    UIViewController *authController = [self.driveBroker createAuthController];
    [self presentViewController:authController animated:YES completion:nil];
  }
}

- (IBAction)snapPressed:(id)sender {
  NSLog(@"Pressed");
  SBDCameraViewController *cameraController = [[SBDCameraViewController alloc] initWithNibName:@"SBDCameraView_iPad" bundle:nil];
  cameraController.delegate = self;
  [self presentViewController:cameraController animated:YES completion:nil];
}

// SBDCameraViewControllerDelegate
- (void)imageCaptured:(UIImage *)image {
  NSLog(@"Captured");
//  [self.driveBroker uploadPhoto:image];
}

@end
