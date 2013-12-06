//
//  WhatsAtorViewController.h
//  WhatsAtor
//
//  Created by Mokhlas Hussein on 12/5/13.
//
//

#import <UIKit/UIKit.h>
//#import <SpringBoard/SpringBoard.h>
//#import <UIKit/UIWindow2.h>
#import <REComposeViewController/REComposeViewController.h>

@interface UIWindow (Private)
+(UIWindow *)keyWindow;
@end

@interface WhatsAtorViewController : UIViewController <REComposeViewControllerDelegate> {
    REComposeViewController *WhatsAtorComposeView;
}

+ (void)eventTriggered;
+ (void)dismiss;
@end
