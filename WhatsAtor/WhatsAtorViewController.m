//
//  WhatsAtorViewController.m
//  WhatsAtor
//
//  Created by Mokhlas Hussein on 12/5/13.
//
//

#import "WhatsAtorViewController.h"

static UIWindow *addWindow;
static UIWindow *previousKeyWindow;
static WhatsAtorViewController *sharedInstance;

@interface WhatsAtorViewController ()
-(void)dismiss;
@end

@implementation WhatsAtorViewController

+(void)eventTriggered {
    if (sharedInstance) {
        return;
    }
    
    sharedInstance = [[self alloc] init];
    
    addWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    addWindow.windowLevel = UIWindowLevelStatusBar + 2.f;
    
    previousKeyWindow = [UIWindow.keyWindow retain];
    [addWindow addSubview:sharedInstance.view];
    [addWindow makeKeyAndVisible];
}

-(void)loadView {
    [super loadView];
    
    WhatsAtorComposeView = [[REComposeViewController alloc] init];
    WhatsAtorComposeView.title = @"WhatsAtor";
    WhatsAtorComposeView.hasAttachment = NO;
    WhatsAtorComposeView.delegate = self;
    WhatsAtorComposeView.placeholderText = @"WhatsApp Message";
    NSString *imagePath = @"/Library/Activator/Listeners/com.imokhles.WhatsAtor/bg@2x.png";
    [WhatsAtorComposeView.navigationBar setBackgroundImage:[UIImage imageWithContentsOfFile:imagePath] forBarMetrics:UIBarMetricsDefault];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self presentViewController:WhatsAtorComposeView animated:YES completion:NULL];

    
}

-(void)dismiss {
    [sharedInstance dismissViewControllerAnimated:YES completion:^{
		[sharedInstance performSelector:@selector(_dismissCompleted) withObject:nil afterDelay:0.0f];
	}];
}

+ (void)dismiss {
	if (!sharedInstance) {
		return;
	}
    
	[sharedInstance dismiss];
}

- (void)_dismissCompleted {
	[previousKeyWindow makeKeyWindow];
	[previousKeyWindow release];
	previousKeyWindow = nil;
    
	[addWindow release];
	addWindow = nil;
    
	[sharedInstance release];
	sharedInstance = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(BOOL)interfaceOrientation {
	return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ? YES : interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (void)dealloc {
	[WhatsAtorComposeView release];
	[super dealloc];
}

#pragma mark -
#pragma mark REComposeViewControllerDelegate

- (void)composeViewController:(REComposeViewController *)composeViewController didFinishWithResult:(REComposeResult)result
{
    [composeViewController dismissViewControllerAnimated:YES completion:nil];
    
    if (result == REComposeResultCancelled) {
        NSLog(@"Cancelled");
        [sharedInstance dismiss];
    }
    
    if (result == REComposeResultPosted) {
        
        NSLog(@"Text: %@", composeViewController.text);
        
        // NSString *value = composeViewController.text;
        NSInteger textLength = [composeViewController.text length];
        
        if (textLength > 1) {
        NSString *whatsAppText = composeViewController.text;
        NSString *url = @"whatsapp://";
        url = [NSString stringWithFormat:@"%@send?text=%@",url,whatsAppText];
        
        NSURL *urlOpen = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[UIApplication sharedApplication] openURL:urlOpen];
        [sharedInstance dismiss];
        } else {
            UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Yout didn't write anything" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [error show];
            [error release];
            [sharedInstance dismiss];
        }
    }
}

@end
