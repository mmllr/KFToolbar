#A Toolbar for NSWindows

An easy to setup and use toolbar that can contain KFToolbarItems (what is actually a wrapper for NSButtons).

![<Display Name>](<http://dl.dropbox.com/u/18869578/Screenshots/11lh8w2d~22s.png>)

##Usage
Actions are handled inside a block.
An exhaustive example is included.


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

    
##Licence
This code is licenced under MIT.