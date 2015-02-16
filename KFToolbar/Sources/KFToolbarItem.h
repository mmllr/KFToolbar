//
//  KFToolbarItem.h
//  KFJSON
//
//  Created by rick on 25.02.13.
//  Copyright (c) 2013 KF Interactive. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#ifndef NS_DESIGNATED_INITIALIZER
#define NS_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
#endif

#import "KFToolbarItemType.h"

@interface KFToolbarItem : NSObject

+ (instancetype)toolbarItemWithType:(KFToolbarItemType)type image:(NSImage *)iconImage text:(NSString*)text tag:(NSInteger)itemTag keyEquivalent:(NSString*)keyEquivalent toolTip:(NSString*)toolTip;
+ (instancetype)toggleToolbarItemWithImage:(NSImage*)image tag:(NSInteger)tag;
+ (instancetype)toggleToolbarItemWithText:(NSString*)text tag:(NSInteger)tag;
+ (instancetype)pushToolbarItemWithImage:(NSImage*)image tag:(NSInteger)tag;
+ (instancetype)pushToolbarItemWithText:(NSString*)text tag:(NSInteger)tag;

- (instancetype)initWithType:(KFToolbarItemType)type image:(NSImage *)iconImage text:(NSString*)text tag:(NSInteger)itemTag keyEquivalent:(NSString*)keyEquivalent toolTip:(NSString*)toolTip NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) KFToolbarItemType type;
@property (nonatomic, readonly) NSString *text;
@property (nonatomic, readonly) NSString *keyEquivalent;
@property (nonatomic, readonly) NSString *toolTip;
@property (nonatomic, readonly) NSImage *image;
@property (nonatomic, readonly) NSInteger tag;

@end
