//
// Created by alex on 19/04/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@interface SBDCameraViewController : UIViewController {

}

@property (weak, nonatomic) IBOutlet UIView *preview;

- (IBAction)cancelCapture:(id)sender;
- (IBAction)capture:(id)sender;

@end