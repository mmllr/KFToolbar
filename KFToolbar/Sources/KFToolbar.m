//
//  KFToolbar.m
//
//  Created by rick on 25.02.13.
//  Copyright (c) 2013 KF Interactive. All rights reserved.
//

#import "KFToolbar.h"
#import "KFToolbarItem.h"
#import "NSArray+KFIAdditions.h"
#import "KFToolbarItemButtonCell.h"
#import "KFToolBarConstraintBuilder.h"

typedef NS_ENUM(NSUInteger, KFToolbarVisibilityTransitionState)
{
	kKFToolbarVisibilityTransitionStateNone = 0,
	kKFToolbarVisibilityTransitionStateFadeOut,
	kKFToolbarVisibilityTransitionStateFadeIn
};

@interface KFToolbar ()

@property KFToolbarVisibilityTransitionState visibilityTransitionState;
@property (nonatomic, strong) NSArray *leftViews;
@property (nonatomic, strong) NSArray *rightViews;
@property (nonatomic, strong) NSArray *buttonConstraints;
@property (nonatomic, readonly) NSArray *leftButtonConstraints;
@property (nonatomic, readonly) NSArray *rightButtonConstraints;
@property (nonatomic, readwrite) NSUInteger selectedIndex;

@end

@implementation KFToolbar

#pragma mark class methods

+ (BOOL)requiresConstraintBasedLayout
{
	return YES;
}

#pragma mark init/cleanup

- (id)initWithFrame:(NSRect)frameRect
{
	self = [super initWithFrame:frameRect];
    if (self) {
		_leftItems = @[];
		_rightItems = @[];
        [self setupDefaults];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
    if (self) {
		_leftItems = @[];
		_rightItems = @[];
        [self setupDefaults];
    }
    return self;
}

- (void)setupDefaults
{
	self.allowOverlappingItems = YES;
	self.enabled = YES;
	[self setTranslatesAutoresizingMaskIntoConstraints:NO];
}

#pragma mark - NSView overrides

- (void)viewWillMoveToWindow:(NSWindow *)newWindow
{
	BOOL inWindow = [self window] != nil;
	BOOL willBeInWindow = newWindow != nil;
	
	if (willBeInWindow && !inWindow) {
		[newWindow setContentBorderThickness:NSHeight([self bounds])
									 forEdge:NSMinYEdge];
	}
	[super viewWillMoveToWindow:newWindow];
}

- (void)updateConstraints
{
	if (self.buttonConstraints) {
		[self removeConstraints:self.buttonConstraints];
	}
	self.buttonConstraints = [[self horizontalButtonConstraints] arrayByAddingObjectsFromArray:[self verticalButtonConstraints]];
	[self addConstraints:self.buttonConstraints];
	[super updateConstraints];
}


- (void)fadeOut
{
	if (self.visibilityTransitionState == kKFToolbarVisibilityTransitionStateFadeOut) {
		return;
	}
	[NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
		self.visibilityTransitionState = kKFToolbarVisibilityTransitionStateFadeOut;
		[[self animator] setAlphaValue:0];
	} completionHandler:^{
		[self setHidden:YES];
		self.visibilityTransitionState = kKFToolbarVisibilityTransitionStateNone;
	}];
}

- (void)fadeIn
{
	if (self.visibilityTransitionState == kKFToolbarVisibilityTransitionStateFadeIn) {
		return;
	}
	[NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
		self.visibilityTransitionState = kKFToolbarVisibilityTransitionStateFadeIn;
		[[self animator] setAlphaValue:1];
		[self setHidden:NO];
	} completionHandler:^{
		self.visibilityTransitionState = kKFToolbarVisibilityTransitionStateNone;
	}];
}

- (void)updateItemVisibility
{
    NSButton *lastLeftItem = self.leftViews.lastObject;
    NSButton *firstRightItem = self.rightViews.firstObject;
	
	if (!lastLeftItem && !firstRightItem) {
		return;
	}
	BOOL intersecting = CGRectIntersectsRect(lastLeftItem.frame, firstRightItem.frame);
	
	if (intersecting && ![self isHidden]) {
		[self fadeOut];
	}
	else if (!intersecting && [self isHidden]) {
		[self fadeIn];
	}
}

- (void)layout {
	[super layout];
	[self updateItemVisibility];
}

#pragma mark - items

- (void)setLeftItems:(NSArray *)leftItems {
	if (leftItems != _leftItems) {
		_leftItems = [leftItems copy];
		
		[self.leftViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
		self.leftViews = [self createButtonsFromItems:leftItems];
		[self.leftViews enumerateObjectsUsingBlock:^(NSView *view, NSUInteger idx, BOOL *stop) {
			[self addSubview:view];
		}];
		self.needsUpdateConstraints = YES;
	}
}

- (void)setRightItems:(NSArray *)rightItems {
	if (rightItems != _rightItems) {
		_rightItems = [rightItems copy];
		
		[self.rightViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
		self.rightViews = [self createButtonsFromItems:rightItems];
		[self.rightViews enumerateObjectsUsingBlock:^(NSView *view, NSUInteger idx, BOOL *stop) {
			[self addSubview:view];
		}];
		self.needsUpdateConstraints = YES;
	}
}

- (void)setAllowOverlappingItems:(BOOL)allowOverlappingItems {
	_allowOverlappingItems = allowOverlappingItems;
	self.needsUpdateConstraints = YES;
}

- (void)setEnabled:(BOOL)enabled
{
	_enabled = enabled;
	[self.subviews enumerateObjectsUsingBlock:^(NSButton* button, NSUInteger idx, BOOL *stop) {
		button.enabled = enabled;
	}];
}

- (void)setEnabled:(BOOL)enabled forItem:(NSUInteger)itemIndex {
	if (itemIndex >= self.subviews.count) {
		return;
	}
	NSButton *button = self.subviews[itemIndex];
	button.enabled = enabled;
}

- (void)selectToolbarItem:(id)sender
{
	NSParameterAssert([sender isKindOfClass:[NSButton class]]);

	KFToolbarItem *item = [self itemForButton:sender];
	_selectedIndex = [self.subviews indexOfObject:sender];
    if (self.itemSelectionHandler) {
        self.itemSelectionHandler(KFToolbarItemSelectionTypeWillSelect, item, item.tag);
    }
}

- (KFToolbarItem*)itemForButton:(NSButton*)sender {
	NSUInteger itemIndex = [self.subviews indexOfObject:sender];

	if (itemIndex < self.leftItems.count) {
		return self.leftItems[itemIndex];
	}
	itemIndex -= self.leftItems.count;
	if (itemIndex < self.rightItems.count) {
		return self.rightItems[itemIndex];
	}
	return nil;
}

- (NSArray*)createButtonsFromItems:(NSArray*)itemArray {
	return [itemArray kfi_map:^NSButton*(KFToolbarItem *item) {
		NSParameterAssert([item isKindOfClass:[KFToolbarItem class]]);
		
		NSButton *button = [[NSButton alloc] initWithFrame:NSZeroRect];
		KFToolbarItemButtonCell *cell = [[KFToolbarItemButtonCell alloc] init];
		cell.itemType = item.type;
		cell.showLeftShadow = item != self.leftItems.firstObject;
		cell.showRightShadow = item != self.rightItems.lastObject;
		button.cell = cell;
		[button setButtonType:NSMomentaryPushButton];
		button.title = item.text;
		button.image = item.image;
		button.tag = item.tag;
		button.keyEquivalent = item.keyEquivalent;
		button.toolTip = item.toolTip;
		button.translatesAutoresizingMaskIntoConstraints = NO;
		button.target = self;
		button.action = @selector(selectToolbarItem:);
		return button;
	}];
}

- (NSArray*)horizontalButtonConstraints {
	KFToolBarConstraintBuilder *builder = [[KFToolBarConstraintBuilder alloc] initWithLeftItems:self.leftViews rightItems:self.rightViews];
	builder.allowOverlappingItems = self.allowOverlappingItems;
	NSString *visualFormatString = builder.visualFormatString;
	if (!visualFormatString) {
		return @[];
	}
	return [NSLayoutConstraint constraintsWithVisualFormat:visualFormatString
												   options:NSLayoutFormatAlignAllCenterY
												   metrics:nil
													 views:builder.viewBindings];
}

- (NSArray*)verticalButtonConstraints {
	NSView *superview = self;
	return [self.subviews kfi_map:^NSLayoutConstraint*(NSView *view) {
		return [NSLayoutConstraint constraintWithItem:view
											attribute:NSLayoutAttributeCenterY
											relatedBy:NSLayoutRelationEqual
											   toItem:superview
											attribute:NSLayoutAttributeCenterY
										   multiplier:1
											 constant:0];
	}];
}

@end
