//
// Created by alex on 25/04/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface SBDGoogleDriveBroker : NSObject

- (id)init;

- (BOOL)isAuthorised;

- (void)deauthorise;

// Creates the auth controller for authorizing access to Google Drive.
- (UIViewController *)createAuthController;

// Uploads a photo to Drive.
- (void)uploadPhoto:(UIImage*)image;
@end