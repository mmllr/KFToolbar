//
//  AppDelegate.m
//  KFToolbar
//
//  Created by Gunnar Herzog on 04.03.13.
//  Copyright (c) 2013 com.kf-interactive.toolbar. All rights reserved.
//

#import "AppDelegate.h"
#import "KFToolbar.h"

@interface AppDelegate ()

@property (weak) IBOutlet KFToolbar *toolbar;

@end


@implementation AppDelegate

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
	return YES;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    KFToolbarItem *addItem = [KFToolbarItem toolbarItemWithType:kKFToolbarItemTypeToggle
														  image:[NSImage imageNamed:NSImageNameAddTemplate]
														   text:@""
															tag:0
												  keyEquivalent:@"q"
														toolTip:@"Add"];

	KFToolbarItem *removeItem = [KFToolbarItem toolbarItemWithType:kKFToolbarItemTypePush
															 image:[NSImage imageNamed:NSImageNameRemoveTemplate] text:@""
															   tag:1
													 keyEquivalent:@""
														   toolTip:@"Remove"];

	KFToolbarItem *textItem = [KFToolbarItem pushToolbarItemWithText:@"Disable all"
																 tag:3];
    self.toolbar.leftItems = @[addItem, removeItem, textItem];
	self.toolbar.rightItems = @[[KFToolbarItem toggleToolbarItemWithText:@"Enable"
																	tag:4],
								[KFToolbarItem pushToolbarItemWithImage:[NSImage imageNamed:NSImageNameEnterFullScreenTemplate]
																	tag:5],
								[KFToolbarItem pushToolbarItemWithImage:[NSImage imageNamed:NSImageNameExitFullScreenTemplate]
																	tag:6]
								];
    [self.toolbar setItemSelectionHandler:^(KFToolbarItemSelectionType selectionType, KFToolbarItem *toolbarItem, NSInteger tag)
    {
        switch (tag)
        {
            case 0:
                break;
            
			case 1: {
				[self.toolbar setEnabled:NO forItem:0];
                break;
			}
            case 2: {
                [self setControlsEnabled:NO forView:self.toolbar.superview];
                double delayInSeconds = 2.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                {
                    [self setControlsEnabled:YES forView:self.toolbar];
                });
                break;
            }
                
            case 3: {
                self.toolbar.enabled = NO;
                double delayInSeconds = 2.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                {
                    self.toolbar.enabled = YES;
                });
                break;
            }
			case 4: {
				[self.toolbar setEnabled:YES forItem:0];
			}
            default:
                break;
        }
    }];
}


- (void)setControlsEnabled:(BOOL)enabled forView:(NSView *)view
{
    static NSMutableArray *previouslyDisabledControls;
    if (!previouslyDisabledControls || !enabled)
    {
        previouslyDisabledControls = [NSMutableArray new];
    }

    for (NSView *subview in view.subviews)
    {
        if ([subview respondsToSelector:@selector(setEnabled:)])
        {
            if (enabled)
            {
                if (![previouslyDisabledControls containsObject:subview])
                {
                    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[subview methodSignatureForSelector:@selector(setEnabled:)]];
                    [inv setSelector:@selector(setEnabled:)];
                    [inv setTarget:subview];
                    [inv setArgument:&enabled atIndex:2];
                    [inv performSelector:@selector(invoke) withObject:nil];
                }
            }
            else
            {
                if (![subview valueForKey:@"isEnabled"])
                {
                    [previouslyDisabledControls addObject:subview];
                }
                NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[subview methodSignatureForSelector:@selector(setEnabled:)]];
                [inv setSelector:@selector(setEnabled:)];
                [inv setTarget:subview];
                [inv setArgument:&enabled atIndex:2];
                [inv performSelector:@selector(invoke) withObject:nil];
            }
        }
    }
}

- (IBAction)toggleOverlappingItems:(id)sender
{
	self.toolbar.allowOverlappingItems = [sender state] == NSOnState;
}

@end
