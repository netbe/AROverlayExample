#import <UIKit/UIKit.h>
#import "CaptureSessionManager.h"

@interface AROverlayViewController : UIViewController 

@property (nonatomic, strong) CaptureSessionManager *captureManager;
@property (nonatomic, strong) UILabel *scanningLabel;

@end
