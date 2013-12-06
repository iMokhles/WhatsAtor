//
//  WhatsAtorListener.m
//  WhatsAtor
//
//  Created by Mokhlas Hussein on 12/5/13.
//
//

#import "WhatsAtorListener.h"
#import "WhatsAtorViewController.h"

static BOOL visible = NO;

@implementation WhatsAtorListener

+(void)load {
    if (![[LAActivator sharedInstance] hasSeenListenerWithName:@"com.imokhles.WhatsAtor"]) {
        [[LAActivator sharedInstance] assignEvent:[LAEvent eventWithName:@"libactivator.menu.press.triple"] toListenerWithName:@"com.imokhles.WhatsAtor"];
    }
    
    [[LAActivator sharedInstance] registerListener:[self new] forName:@"com.imokhles.WhatsAtor"];
}

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
	if (visible) {
		[self activator:activator abortEvent:event];
		return;
	}
    
	event.handled = YES;
	visible = YES;
    
	[WhatsAtorViewController eventTriggered];
}

- (void)activator:(LAActivator *)activator abortEvent:(LAEvent *)event {
	if (visible) {
		visible = NO;
		[WhatsAtorViewController dismiss];
	}
}
@end
