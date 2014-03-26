//
//  KFToolbarItem.h
//  KFJSON
//
//  Created by rick on 25.02.13.
//  Copyright (c) 2013 KF Interactive. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface KFToolbarItem : NSButton

+ (instancetype)toolbarItemWithType:(NSButtonType)type icon:(NSImage *)iconImage tag:(NSInteger)itemTag;
+ (instancetype)toolbarItemWithIcon:(NSImage *)iconImage tag:(NSInteger)itemTag;

- (id)initWithButtonType:(NSButtonType)type icon:(NSImage *)iconImage tag:(NSInteger)itemTag;
- (id)initWithIcon:(NSImage *)iconImage tag:(NSInteger)itemTag;
- (id)initWithTitle:(NSString*)title tag:(NSInteger)itemTag;

- (void)hideLeftShadow;
- (void)hideRightShadow;

@end
