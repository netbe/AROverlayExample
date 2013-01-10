#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>


@interface CaptureSessionManager : NSObject {

}

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) AVCaptureSession *captureSession;
- (void)addVideoPreviewLayer;
- (void)addVideoInput;

@end
