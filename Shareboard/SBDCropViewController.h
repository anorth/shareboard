//
// Created by alex on 19/04/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface SBDCropViewController : UIViewController {

}

@property (weak, nonatomic) IBOutlet UIImageView *preview;

- (id)initWithImage:(NSData *)imageData;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;


@end