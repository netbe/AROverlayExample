#import "AROverlayViewController.h"

@implementation AROverlayViewController

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleCaptureManagerStatus:)
                                                 name:kCaptureSessionManagerWarningNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleCaptureManagerStatus:)
                                                 name:kCaptureSessionManagerFileSavedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleCaptureManagerStatus:)
                                                 name:kCaptureSessionManagerErrorNotification
                                               object:nil];
    
	self.captureManager = [[CaptureSessionManager alloc] init];
    
    [self.captureManager prepare];
	
	CGRect layerRect = [[[self view] layer] bounds];
	self.captureManager.previewLayer.bounds = layerRect;
	self.captureManager.previewLayer.position = CGPointMake(CGRectGetMidX(layerRect),
                                                                  CGRectGetMidY(layerRect));
	[self.view.layer addSublayer:[[self captureManager] previewLayer]];
    
    UIImageView *overlayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlaygraphic.png"]];
    overlayImageView.frame = CGRectMake(30, 100, 260, 200);
    [self.view addSubview:overlayImageView];
    
    UIButton *overlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [overlayButton setImage:[UIImage imageNamed:@"scanbutton.png"]
                   forState:UIControlStateNormal];
    overlayButton.frame = CGRectMake(130, 320, 60, 30);
    [overlayButton addTarget:self
                      action:@selector(scanButtonPressed)
            forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:overlayButton];
    
    self.scanningLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 120, 30)];
    self.scanningLabel.backgroundColor = [UIColor clearColor];
    self.scanningLabel.font = [UIFont fontWithName:@"Courier" size: 18.0];
    self.scanningLabel.textColor = [UIColor redColor];
    self.scanningLabel.text = @"Scanning...";
    self.scanningLabel.hidden = YES;
    [self.view addSubview:self.scanningLabel];
    
    [self.captureManager.captureSession startRunning];
}

- (void)scanButtonPressed
{
	self.scanningLabel.hidden = NO;
	[self performSelector:@selector(hideLabel:) withObject:self.scanningLabel afterDelay:10];
    [self.captureManager startVideo];
}

- (void)hideLabel:(UILabel *)label
{
	label.hidden = YES;
    [self.captureManager stopVideo];
}


- (void)handleCaptureManagerStatus:(NSNotification*)notification
{
    NSString* message = nil;
    if ([notification.name isEqualToString:kCaptureSessionManagerFileSavedNotification]) {
        NSURL* fileUrl =  notification.object;
        message = [NSString stringWithFormat:@"video saved at %@", fileUrl];

    }else if ([notification.name isEqualToString:kCaptureSessionManagerErrorNotification]) {
        NSError* error =  notification.object;
        message = error.localizedDescription;
    }else{
        message = notification.object;
    }
        
    
    [[[UIAlertView alloc] initWithTitle:nil
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil,
      nil] show];

}
@end

