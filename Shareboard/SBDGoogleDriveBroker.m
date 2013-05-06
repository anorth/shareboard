//
// Created by alex on 25/04/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBDGoogleDriveBroker.h"

#import "GTLDrive.h"
#import "GTMOAuth2ViewControllerTouch.h"

static NSString *kKeychainItemName = @"Shareboard";
static NSString *kClientId = @"32922142780.apps.googleusercontent.com";
static NSString *kClientSecret = @"U2HLyC2AwqO4pgkJSwBC7XOv";
static const CGFloat JPG_QUALITY = 0.7f;

@interface SBDGoogleDriveBroker ()

@property (nonatomic, retain) GTLServiceDrive *driveService;

// Handle completion of the authorization process, and updates the Drive service
// with the new credentials.
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)authResult
                 error:(NSError *)error;

// Helper for showing a wait indicator in a popup
- (UIAlertView*)showWaitIndicator:(NSString *)title;

- (void)showAlert:(NSString *)title message:(NSString *)message;
@end


@implementation SBDGoogleDriveBroker {
}

- (id)init {
  self = [super init];
  if (self) {
    self.driveService = [GTLServiceDrive new];
    self.driveService.authorizer = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                                                         clientID:kClientId
                                                                                     clientSecret:kClientSecret];
  }
  return self;
}

- (BOOL)isAuthorised {
  return [((GTMOAuth2Authentication *)self.driveService.authorizer) canAuthorize];
}

- (void)deauthorise {
  [GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:kKeychainItemName];
  [[self driveService] setAuthorizer:nil];
}

- (UIViewController *)createAuthController {
  GTMOAuth2ViewControllerTouch *authController;
  authController = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:kGTLAuthScopeDriveFile
                                                              clientID:kClientId
                                                          clientSecret:kClientSecret
                                                      keychainItemName:kKeychainItemName
                                                              delegate:self
                                                      finishedSelector:@selector(viewController:finishedWithAuth:error:)];
  return authController;
}

- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)authResult error:(NSError *)error {
  [viewController dismissViewControllerAnimated:YES completion:nil];
  if (error != nil) {
    [self showAlert:@"Authentication Error" message:error.localizedDescription];
    self.driveService.authorizer = nil;
  } else {
    self.driveService.authorizer = authResult;
  }
}

- (void)uploadPhoto:(UIImage*)image
{
  NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
  [dateFormat setDateFormat:@"'Quickstart Uploaded File ('EEEE MMMM d, YYYY h:mm a, zzz')"];

  GTLDriveFile *file = [GTLDriveFile object];
  file.title = [dateFormat stringFromDate:[NSDate date]];
  file.descriptionProperty = @"Uploaded from the Google Drive iOS Quickstart";
  file.mimeType = @"image/jpg";

  NSData *data = UIImageJPEGRepresentation(image, JPG_QUALITY);
  GTLUploadParameters *uploadParameters = [GTLUploadParameters uploadParametersWithData:data MIMEType:file.mimeType];
  GTLQueryDrive *query = [GTLQueryDrive queryForFilesInsertWithObject:file
                                                     uploadParameters:uploadParameters];

  UIAlertView *waitIndicator = [self showWaitIndicator:@"Uploading to Google Drive"];

  [self.driveService executeQuery:query
                completionHandler:^(GTLServiceTicket *ticket, GTLDriveFile *insertedFile, NSError *error) {
                  [waitIndicator dismissWithClickedButtonIndex:0 animated:YES];
                  if (error == nil) {
                    NSLog(@"File ID: %@", insertedFile.identifier);
                    [self showAlert:@"Google Drive" message:@"File saved!"];
                  } else {
                    NSLog(@"An error occurred: %@", error);
                    [self showAlert:@"Google Drive" message:@"Sorry, an error occurred!"];
                  }
                }];
}

- (UIAlertView*)showWaitIndicator:(NSString *)title {
  UIAlertView *progressAlert;
  progressAlert = [[UIAlertView alloc] initWithTitle:title
                                             message:@"Please wait..."
                                            delegate:nil
                                   cancelButtonTitle:nil
                                   otherButtonTitles:nil];
  [progressAlert show];

  UIActivityIndicatorView *activityView;
  activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
  activityView.center = CGPointMake(progressAlert.bounds.size.width / 2,
      progressAlert.bounds.size.height - 45);

  [progressAlert addSubview:activityView];
  [activityView startAnimating];
  return progressAlert;
}

- (void)showAlert:(NSString *)title message:(NSString *)message
{
  UIAlertView *alert;
  alert = [[UIAlertView alloc] initWithTitle: title
                                     message: message
                                    delegate: nil
                           cancelButtonTitle: @"OK"
                           otherButtonTitles: nil];
  [alert show];
}



@end