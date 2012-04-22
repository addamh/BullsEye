//
//  BullsEyeViewController.m
//  BullsEye
//
//  Created by Addam on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BullsEyeViewController.h"
#import "AboutViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation BullsEyeViewController {
	int currentValue;
	int targetValue;
	int score;
	int currentRound;
}

@synthesize slider;
@synthesize targetLabel;
@synthesize scoreLabel;
@synthesize roundLabel;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	UIImage *thumbImageNormal = [UIImage imageNamed:@"SliderThumb-Normal"];
	[self.slider setThumbImage:thumbImageNormal forState:UIControlStateNormal];
	
	UIImage *thumbImageHighlighted = [UIImage imageNamed:@"SliderThumb-Highlighted"];
	[self.slider setThumbImage:thumbImageHighlighted forState:UIControlStateHighlighted];
	
	UIImage *trackLeftImage = [[UIImage imageNamed:@"SliderTrackLeft"] stretchableImageWithLeftCapWidth:14 topCapHeight:0];
	[self.slider setMinimumTrackImage:trackLeftImage forState:UIControlStateNormal];
	
	UIImage *trackRightImage = [[UIImage imageNamed:@"SliderTrackRight"] stretchableImageWithLeftCapWidth:14 topCapHeight:0];
	[self.slider setMaximumTrackImage:trackRightImage forState:UIControlStateNormal];
	
	[self startNewGame];
	[self updateLabels];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	self.slider = nil;
	self.targetLabel = nil;
	self.scoreLabel = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)startOver
{
	CATransition *transition = [CATransition animation];
	transition.type = kCATransitionFade;
	transition.duration = 1;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	
	[self startNewGame];
	[self updateLabels];
	
	[self.view.layer addAnimation:transition forKey:nil];
}

- (IBAction)showInfo
{
	AboutViewController *controller = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentViewController:controller animated:YES completion:nil];
}

- (void)startNewGame
{
	score = 0;
	currentRound = 0;
	currentValue = 50;
	[self startNewRound];
}

- (IBAction)showAlert
{
	int difference = abs(targetValue - currentValue);
	int points = 100 - difference;
	
	currentRound++;
	
	NSString *title;
	if (difference == 0) {
		title = @"Perfect!";
		points += 100;
	} else if (difference < 5) {
		if (difference == 1) {
			points += 50;
		}
		title = @"You almost had it!";
	} else if (difference < 10) {
		title = @"Pretty good!";
	} else {
		title = @"Not even close...";
	}
	
	score += points;
	
	NSString *message = [NSString stringWithFormat:
											 @"You hit: %d\nYou scored %d points",
											 currentValue, points];
	
	UIAlertView *alertView = [[UIAlertView alloc]
														initWithTitle:title
														message:message
														delegate:self
														cancelButtonTitle:@"OK"
														otherButtonTitles:nil];
	
	[alertView show];

}

- (void)startNewRound
{
	targetValue = 1 + (arc4random() % 100);
	self.slider.value = currentValue;
}

- (IBAction)sliderMoved:(UISlider *)sender
{
	currentValue = lroundf(sender.value);
}

- (void)updateLabels
{
	self.targetLabel.text = [NSString stringWithFormat:@"%d", targetValue];
	self.scoreLabel.text = [NSString stringWithFormat:@"%d", score];
	self.roundLabel.text = [NSString stringWithFormat:@"%d", currentRound];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	[self startNewRound];
	[self updateLabels];
}

@end
