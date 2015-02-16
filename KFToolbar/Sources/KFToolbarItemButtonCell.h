//
//  KFToolbarItemButtonCell.h
//  KFToolbar
//
//  Created by Markus Müller on 08.02.14.
//  Copyright (c) 2014 com.kf-interactive.toolbar. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "KFToolbarItemType.h"

@interface KFToolbarItemButtonCell : NSButtonCell

@property (nonatomic) KFToolbarItemType itemType;
@property (nonatomic, assign) BOOL showLeftShadow;
@property (nonatomic, assign) BOOL showRightShadow;

@end
