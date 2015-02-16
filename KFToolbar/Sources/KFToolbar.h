//
//  KFToolbar.h
//  KFJSON
//
//  Created by rick on 25.02.13.
//  Copyright (c) 2013 KF Interactive. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KFToolbarItem.h"

typedef NS_ENUM(NSUInteger, KFToolbarItemSelectionType)
{
    KFToolbarItemSelectionTypeWillSelect,
    KFToolbarItemSelectionTypeDidSelect
};

typedef void (^KFToolbarEventsHandler)(KFToolbarItemSelectionType selectionType, KFToolbarItem *targetToolbarItem, NSInteger tag);

@interface KFToolbar : NSView

@property (nonatomic, copy) NSArray *leftItems;
@property (nonatomic, copy) NSArray *rightItems;
@property (nonatomic, getter = isEnabled) BOOL enabled;
@property (nonatomic, readonly) NSUInteger selectedIndex;
@property (nonatomic) BOOL allowOverlappingItems;
@property (nonatomic, copy) KFToolbarEventsHandler itemSelectionHandler;

- (void)setEnabled:(BOOL)enabled forItem:(NSUInteger)itemIndex;

@end
