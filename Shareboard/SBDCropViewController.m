//
// Created by alex on 19/04/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBDCropViewController.h"

@interface SBDCropViewController()

@property (strong, nonatomic) NSData *imageData;

@end

@implementation SBDCropViewController

- (id)initWithImage:(NSData *)imageData {
  self = [super initWithNibName:@"SBDCropView_iPad" bundle:nil];
  self.imageData = imageData;
  return self;
}

- (void)viewDidUnload {
  [self setPreview:nil];
  [super viewDidUnload];
}

- (IBAction)cancel:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)done:(id)sender {
}
@end