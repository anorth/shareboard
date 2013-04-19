//
// Created by alex on 19/04/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <AVFoundation/AVFoundation.h>

#import "SBDCameraViewController.h"
#import "SBDCropViewController.h"
#import "HFImageEditorViewController.h"

@interface SBDCameraViewController()

@property (weak, nonatomic) IBOutlet UIView *preview;

@end

@implementation SBDCameraViewController {
  AVCaptureDeviceInput *captureInput;
  AVCaptureStillImageOutput *captureOutput;
  AVCaptureSession *session;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

  // Initialise camera input
  AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
  NSError *error = nil;
  captureInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
  if (!captureInput) {
    // Handle the error appropriately.
    NSLog(@"ERROR: trying to open camera: %@", error);
    return nil;
  }

  // Initialise image output
  captureOutput = [AVCaptureStillImageOutput new];
//  NSDictionary *outputSettings = [NSDictionary
//      dictionaryWithObject:[NSNumber numberWithUnsignedInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]
//                    forKey:(NSString *) kCVPixelBufferPixelFormatTypeKey];
//  output.outputSettings = outputSettings;

  return self;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  // Establish preview
  session = [[AVCaptureSession alloc] init];
  session.sessionPreset = AVCaptureSessionPresetPhoto;

  CALayer *viewLayer = self.preview.layer;
  NSLog(@"viewLayer = %@", viewLayer);

  AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
  captureVideoPreviewLayer.frame = self.preview.bounds;
  captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
  // FIXME set orientation

  [self.preview.layer addSublayer:captureVideoPreviewLayer];

  [session addInput:captureInput];
  [session addOutput:captureOutput];

  [session startRunning];
}

- (void)viewDidDisappear:(BOOL)animated {
  if (session) {
    [session removeInput:captureInput];
    [session removeOutput:captureOutput];
    [session stopRunning];
    session = nil;
  }
}

- (void)viewDidUnload {
  [self setPreview:nil];
  [super viewDidUnload];
}
- (IBAction)cancelCapture:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)capture:(id)sender {
  AVCaptureConnection *connection = [captureOutput connectionWithMediaType:AVMediaTypeVideo];
  [captureOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
    NSData *jpgData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
//    SBDCropViewController *cropViewController = [[SBDCropViewController alloc] initWithImage:jpgData];
//    [self presentViewController:cropViewController animated:NO completion:nil];
    HFImageEditorViewController *cropViewController = [[HFImageEditorViewController alloc] initWithNibName:@"HFImageEditor" bundle:nil];
    UIImage *image = [UIImage imageWithData:jpgData];
    cropViewController.sourceImage = image;
    [self presentViewController:cropViewController animated:NO completion:nil]; // Flip view?

    cropViewController.doneCallback = ^(UIImage *image, BOOL canceled) {
      if (!canceled && self.delegate) {
        [self.delegate imageCaptured:image];
        [cropViewController dismissViewControllerAnimated:NO completion:^{
          [self dismissViewControllerAnimated:YES completion:nil];
        }];
      } else {
        [cropViewController dismissViewControllerAnimated:NO completion:nil];
      }
    };
  }];
}

@end