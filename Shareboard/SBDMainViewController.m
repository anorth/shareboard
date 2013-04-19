//
//  SBDViewController.m
//  Shareboard
//
//  Created by Alex on 19/04/13.
//  Copyright (c) 2013 Alex. All rights reserved.
//

#import "SBDMainViewController.h"
#import "SBDCameraViewController.h"

@interface SBDMainViewController() <SBDCameraViewControllerDelegate>

@end

@implementation SBDMainViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
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
}

@end
