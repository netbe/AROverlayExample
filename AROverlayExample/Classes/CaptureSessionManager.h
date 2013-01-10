#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>


@interface CaptureSessionManager : NSObject<AVCaptureFileOutputRecordingDelegate>

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureMovieFileOutput* movie;

/**
 name of the file, will be stored in documents directory
*/
@property (nonatomic, strong) NSString* baseFilename;

- (void)prepare;

- (void)startVideo;
- (void)stopVideo;
@end
