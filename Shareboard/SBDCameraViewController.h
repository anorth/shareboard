//
// Created by alex on 19/04/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@protocol SBDCameraViewControllerDelegate

- (void)imageCaptured:(UIImage *)image;

@end

@interface SBDCameraViewController : UIViewController

@property id<SBDCameraViewControllerDelegate> delegate;

- (IBAction)cancelCapture:(id)sender;
- (IBAction)capture:(id)sender;

@end