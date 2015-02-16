//
//  KFToolbarItem.m
//  KFJSON
//
//  Created by rick on 25.02.13.
//  Copyright (c) 2013 KF Interactive. All rights reserved.
//

#import "KFToolbarItem.h"

@implementation KFToolbarItem

+ (instancetype)toolbarItemWithType:(KFToolbarItemType)type image:(NSImage *)iconImage text:(NSString*)text tag:(NSInteger)itemTag keyEquivalent:(NSString*)keyEquivalent toolTip:(NSString*)toolTip {
	return [[self alloc] initWithType:type
								image:iconImage
								 text:text
								  tag:itemTag
						keyEquivalent:keyEquivalent
							  toolTip:toolTip];
}

+ (instancetype)toggleToolbarItemWithImage:(NSImage*)image tag:(NSInteger)tag {
	return [self toolbarItemWithType:kKFToolbarItemTypeToggle
							   image:image
								text:@""
								 tag:tag
					   keyEquivalent:@""
							 toolTip:@""];
}

+ (instancetype)toggleToolbarItemWithText:(NSString*)text tag:(NSInteger)tag {
	return [self toolbarItemWithType:kKFToolbarItemTypeToggle
							   image:nil
								text:text
								 tag:tag
					   keyEquivalent:@""
							 toolTip:@""];
}

+ (instancetype)pushToolbarItemWithImage:(NSImage*)image tag:(NSInteger)tag {
	return [self toolbarItemWithType:kKFToolbarItemTypePush
							   image:image
								text:@""
								 tag:tag
					   keyEquivalent:@""
							 toolTip:@""];
}

+ (instancetype)pushToolbarItemWithText:(NSString*)text tag:(NSInteger)tag {
	return [self toolbarItemWithType:kKFToolbarItemTypePush
							   image:nil
								text:text
								 tag:tag
					   keyEquivalent:@""
							 toolTip:@""];
}

- (instancetype)initWithType:(KFToolbarItemType)type image:(NSImage *)iconImage text:(NSString *)text tag:(NSInteger)itemTag keyEquivalent:(NSString *)keyEquivalent toolTip:(NSString *)toolTip {
	self = [super init];
	if (self) {
		_type = type;
		_image = iconImage;
		_tag = itemTag;
		_text = [text copy];
		_keyEquivalent = [keyEquivalent copy];
		_toolTip = [toolTip copy];
	}
	return self;
}

@end
