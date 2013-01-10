#import "AROverlayViewController.h"

@implementation AROverlayViewController

- (void)viewDidLoad
{
	self.captureManager = [[CaptureSessionManager alloc] init];
    
	[self.captureManager addVideoInput];
	[self.captureManager addVideoPreviewLayer];
	CGRect layerRect = [[[self view] layer] bounds];
	self.captureManager.previewLayer.bounds = layerRect;
	self.captureManager.previewLayer.position = CGPointMake(CGRectGetMidX(layerRect),
                                                                  CGRectGetMidY(layerRect));
	[self.view.layer addSublayer:[[self captureManager] previewLayer]];
    
    UIImageView *overlayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlaygraphic.png"]];
    overlayImageView.frame = CGRectMake(30, 100, 260, 200);
    [self.view addSubview:overlayImageView];
    
    UIButton *overlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [overlayButton setImage:[UIImage imageNamed:@"scanbutton.png"] forState:UIControlStateNormal];
    overlayButton.frame = CGRectMake(130, 320, 60, 30);
    [overlayButton addTarget:self action:@selector(scanButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:overlayButton];
    
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 120, 30)];
    self.scanningLabel = tempLabel;
    
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
	[self performSelector:@selector(hideLabel:) withObject:self.scanningLabel afterDelay:2];
}

- (void)hideLabel:(UILabel *)label
{
	label.hidden = YES;
}

@end

