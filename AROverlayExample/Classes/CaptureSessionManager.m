#import "CaptureSessionManager.h"

@interface CaptureSessionManager ()

- (void)addVideoPreviewLayer;
- (void)addVideoInput;
- (void)addAudioInput;

@end

@implementation CaptureSessionManager


#pragma mark Capture Session Configuration

- (id)init
{
    self = [super init];
	if (self) {
		_captureSession = [[AVCaptureSession alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[self.captureSession stopRunning];
}

#pragma mark - 

- (void)prepare
{
	[self addVideoInput];
    [self addAudioInput];
	[self addVideoPreviewLayer];
}

- (void)addVideoPreviewLayer
{
	self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
	self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
}

- (void)addVideoInput
{
   [self addInput:AVMediaTypeVideo];
}

- (void)addAudioInput
{
    [self addInput:AVMediaTypeAudio];
}

- (void)addInput:(NSString*)mediaType
{
	AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:mediaType];
	if (captureDevice) {
		NSError *error;
		AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
		if (!error) {
			if ([self.captureSession canAddInput:deviceInput])
				[self.captureSession addInput:deviceInput];
			else
				NSLog(@"Couldn't add %@ input", mediaType);
		}
		else
			NSLog(@"Couldn't create %@ input", mediaType);
	}
	else
		NSLog(@"Couldn't create capture device for %@", mediaType);
}

- (void)startVideo
{
    if (self.baseFilename == nil) {
        self.baseFilename = @"default_video";
    }
    if (self.movie ==nil) {
        self.movie = [[AVCaptureMovieFileOutput alloc] init];
        [self.captureSession addOutput:self.movie];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *newVideoPath = [[basePath stringByAppendingPathComponent:self.baseFilename] stringByAppendingPathExtension:@"mov"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:newVideoPath]) {
        NSLog(@"Erasing previous file!");
        NSError* error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:newVideoPath error:&error];
        if (error) {
            NSLog(@"error %@", [error description]);
            return;
        }
    }
    [self.movie startRecordingToOutputFileURL:[NSURL fileURLWithPath:newVideoPath]
                        recordingDelegate:self];

}

- (void)stopVideo
{
    [self.movie stopRecording];
}

#pragma mark - AVCaptureFileOutputRecordingDelegate

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput
didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
      fromConnections:(NSArray *)connections error:(NSError *)error
{
    NSLog(@"error %@", [error description]);
    NSLog(@"url %@", outputFileURL);
}



@end
