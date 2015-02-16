//
//  KFToolbarTests.m
//  KFToolbar
//
//  Created by Markus Müller on 15.02.15.
//  Copyright (c) 2015 com.kf-interactive.toolbar. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KFToolbar.h"
#import "MKMLayoutConstraintAssertions.h"
#import "NSArray+KFIAdditions.h"
#import "KFToolbarItemButtonCell.h"

@interface KFToolbarTests : XCTestCase

@property (nonatomic, strong) NSWindow *window;
@property (nonatomic, strong) NSImage *itemImage;
@property (nonatomic, strong) NSArray *items;

@end

@implementation KFToolbarTests
{
	KFToolbar *sut;
}


- (void)setUp {
    [super setUp];
	self.itemImage = [NSImage imageNamed:NSImageNameApplicationIcon];
    sut = [[KFToolbar alloc] initWithFrame:NSMakeRect(0, 0, 300, 40)];
}

- (void)tearDown {
	sut = nil;
	self.window = nil;
    [super tearDown];
}

- (void)givenAWindowWithAContentView {
	self.window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 400, 300) styleMask:0 backing:NSBackingStoreBuffered defer:NO];
	NSView *contentView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 400, 300)];
	self.window.contentView = contentView;
}

- (NSDictionary*)viewDictionaryForItems:(NSArray*)items {
	NSMutableDictionary *viewDictionary = [NSMutableDictionary dictionaryWithCapacity:items.count];

	[items enumerateObjectsUsingBlock:^(NSView *view, NSUInteger idx, BOOL *stop) {
		NSParameterAssert([view isKindOfClass:[NSView class]]);

		NSString *itemName = [@"item" stringByAppendingString:@(idx).stringValue];
		viewDictionary[itemName] = view;
	}];
	return [viewDictionary copy];
}

- (NSString*)visualFormatStringForItems:(NSArray*)items startIndex:(NSUInteger)startIndex {
	NSMutableArray *constraintStrings = [NSMutableArray arrayWithCapacity:items.count];
	
	[items enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop) {
		NSString *itemName = [@"item" stringByAppendingString:@(startIndex + idx).stringValue];
		NSString *itemString = [NSString stringWithFormat:@"[%@]", itemName];
		[constraintStrings addObject:itemString];
	}];
	return [constraintStrings componentsJoinedByString:@"-"];
}

- (NSArray*)expectedConstraintsForLeftItems:(NSArray*)items {
	if (!items.count) {
		return @[];
	}
	NSString *leftAnchor = @"|";
	return [NSLayoutConstraint constraintsWithVisualFormat:[leftAnchor stringByAppendingString:[self visualFormatStringForItems:items startIndex:0]]
												   options:NSLayoutFormatAlignAllCenterY
												   metrics:nil
													 views:[self viewDictionaryForItems:items]];
}

- (NSArray*)expectedConstraintsForRightItems:(NSArray*)items {
	if (!items.count) {
		return @[];
	}
	NSString *rightAnchor = @"|";
	return [NSLayoutConstraint constraintsWithVisualFormat:[[self visualFormatStringForItems:items startIndex:0] stringByAppendingString:rightAnchor]
												   options:NSLayoutFormatAlignAllCenterY
												   metrics:nil
													 views:[self viewDictionaryForItems:items]];
}

- (NSArray*)expectedConstraintsForLeftItems:(NSArray*)leftItems rightItems:(NSArray*)rightItems views:(NSArray*)views allowOverlappingOfItems:(BOOL)allowOverlappingItems {
	NSString *leftVisualFormat = [self visualFormatStringForItems:leftItems startIndex:0];
	NSString *rightVisualFormat = [self visualFormatStringForItems:rightItems startIndex:leftItems.count];

	NSLayoutPriority priority = allowOverlappingItems ? NSLayoutPriorityWindowSizeStayPut : NSLayoutPriorityWindowSizeStayPut + 1;
	return [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"|%@-(>=8@%@)-%@|", leftVisualFormat, @(priority), rightVisualFormat]
											options:NSLayoutFormatAlignAllCenterY
											metrics:nil
											  views:[self viewDictionaryForItems:views]];
	 
	
}

- (NSArray*)expectedVerticalConstraintsForViews:(NSArray*)views {
	NSView *superview = sut;
	return [views kfi_map:^NSLayoutConstraint*(NSView *view) {
		return [NSLayoutConstraint constraintWithItem:view
											attribute:NSLayoutAttributeCenterY
											relatedBy:NSLayoutRelationEqual
											   toItem:superview
											attribute:NSLayoutAttributeCenterY
										   multiplier:1
											 constant:0];
	}];
}

- (void)givenAToolBarWithThreeLeftItems {
	NSArray *items = @[
					   [KFToolbarItem pushToolbarItemWithImage:self.itemImage tag:1],
					   [KFToolbarItem pushToolbarItemWithText:@"title" tag:2],
					   [KFToolbarItem toggleToolbarItemWithImage:self.itemImage tag:3]
					   ];

	sut.leftItems = items;
	[sut layoutSubtreeIfNeeded];
}

- (void)givenAToolBarWithThreeLeftItemsAndTwoRightItems {
	sut.leftItems = @[
					  [KFToolbarItem pushToolbarItemWithImage:self.itemImage tag:1],
					  [KFToolbarItem pushToolbarItemWithText:@"left" tag:2],
					  [KFToolbarItem toggleToolbarItemWithImage:self.itemImage tag:3]
					  ];
	sut.rightItems = @[
					   [KFToolbarItem toggleToolbarItemWithImage:self.itemImage tag:4],
					   [KFToolbarItem pushToolbarItemWithText:@"right" tag:5],
					   ];
	[sut layoutSubtreeIfNeeded];
}

- (void)givenTheToolBarIsInAWindow {
	[self givenAWindowWithAContentView];

	[self.window.contentView addSubview:sut];
	NSView *toolbar = sut;
	[self.window.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[toolbar]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toolbar)]];
	[self.window.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=10)-[toolbar]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toolbar)]];
	[self.window makeKeyAndOrderFront:self];
}

- (NSButton*)buttonForItem:(NSUInteger)index {
	NSParameterAssert(index < sut.subviews.count);

	return sut.subviews[index];
}

#pragma mark - Test

- (void)testThatItRequiresAutoLayout {
	XCTAssertTrue([[sut class] requiresConstraintBasedLayout]);
	XCTAssertFalse(sut.translatesAutoresizingMaskIntoConstraints);
}

- (void)testThatItIsEnabled {
	[self givenAToolBarWithThreeLeftItemsAndTwoRightItems];

	XCTAssertTrue(sut.isEnabled);
	[sut.subviews enumerateObjectsUsingBlock:^(NSButton *button, NSUInteger idx, BOOL *stop) {
		XCTAssertTrue(button.enabled);
	}];
}

- (void)testThatItCanBeDisabledAndReEnabled {
	[self givenAToolBarWithThreeLeftItemsAndTwoRightItems];
	
	sut.enabled = NO;
	XCTAssertFalse(sut.isEnabled);
	[sut.subviews enumerateObjectsUsingBlock:^(NSButton *button, NSUInteger idx, BOOL *stop) {
		XCTAssertFalse(button.enabled);
	}];

	sut.enabled = YES;
	[sut.subviews enumerateObjectsUsingBlock:^(NSButton *button, NSUInteger idx, BOOL *stop) {
		XCTAssertTrue(button.enabled);
	}];
}

- (void)testThatItemsCanDisabled {
	[self givenAToolBarWithThreeLeftItemsAndTwoRightItems];

	[sut setEnabled:NO forItem:0];
	XCTAssertFalse([self buttonForItem:0].enabled);

	[sut setEnabled:YES forItem:0];
	XCTAssertTrue([self buttonForItem:0].enabled);

	[sut setEnabled:NO forItem:3];
	XCTAssertFalse([self buttonForItem:3].enabled);

	[sut setEnabled:YES forItem:3];
	XCTAssertTrue([self buttonForItem:3].enabled);
}

- (void)testThatItAllowsOverlappingItems
{
	XCTAssertTrue(sut.allowOverlappingItems);
}

- (void)testThatInsertingInAWindowWillSetTheWindowsContentBorderToTheHeightOfTheToolBar {
	[self givenTheToolBarIsInAWindow];

	XCTAssertEqualWithAccuracy([self.window contentBorderThicknessForEdge:NSMinYEdge], NSHeight(sut.bounds), .00001);
}

- (void)testAddingOneLeftItem {
	KFToolbarItem *item = [KFToolbarItem toggleToolbarItemWithImage:self.itemImage tag:1];

	sut.leftItems = @[item];

	XCTAssertEqualObjects(sut.leftItems, @[item]);
	XCTAssertTrue(sut.subviews.count == 1);

	NSButton *button = sut.subviews.firstObject;
	XCTAssertFalse(button.translatesAutoresizingMaskIntoConstraints);
	XCTAssertEqualObjects(button.title, item.text);
	XCTAssertEqualObjects(button.image, item.image);
	XCTAssertEqualObjects(button.toolTip, item.toolTip);
	XCTAssertEqualObjects(button.keyEquivalent, item.keyEquivalent);
	XCTAssertTrue([button.cell isKindOfClass:[KFToolbarItemButtonCell class]]);
	KFToolbarItemButtonCell *cell = button.cell;
	XCTAssertFalse(cell.showLeftShadow);
	XCTAssertTrue(cell.showRightShadow);
	XCTAssertEqual(cell.itemType, item.type);}

- (void)testAddingOneRightItem {
	KFToolbarItem *item = [KFToolbarItem pushToolbarItemWithImage:self.itemImage tag:42];
	
	sut.rightItems = @[item];

	XCTAssertEqualObjects(sut.rightItems, @[item]);
	XCTAssertTrue(sut.subviews.count == 1);
	NSButton *button = sut.subviews.firstObject;
	XCTAssertFalse(button.translatesAutoresizingMaskIntoConstraints);
	XCTAssertEqualObjects(button.title, item.text);
	XCTAssertEqualObjects(button.image, item.image);
	XCTAssertEqualObjects(button.toolTip, item.toolTip);
	XCTAssertEqualObjects(button.keyEquivalent, item.keyEquivalent);
	XCTAssertTrue([button.cell isKindOfClass:[KFToolbarItemButtonCell class]]);
	KFToolbarItemButtonCell *cell = button.cell;
	XCTAssertTrue(cell.showLeftShadow);
	XCTAssertFalse(cell.showRightShadow);
	XCTAssertEqual(cell.itemType, item.type);}

- (void)testAddingManyLeftItems {
	NSArray *items = @[
					   [KFToolbarItem pushToolbarItemWithImage:self.itemImage tag:1],
					   [KFToolbarItem pushToolbarItemWithText:@"title" tag:2]
					   ];

	sut.leftItems = items;

	XCTAssertEqualObjects(sut.leftItems, items);
	NSArray *subviews = sut.subviews;
	XCTAssertEqual(subviews.count, (NSUInteger)2);
	[items enumerateObjectsUsingBlock:^(KFToolbarItem *item, NSUInteger idx, BOOL *stop) {
		NSButton *button = subviews[idx];
		XCTAssertFalse(button.translatesAutoresizingMaskIntoConstraints);
		XCTAssertEqualObjects(button.title, item.text);
		XCTAssertEqualObjects(button.image, item.image);
		XCTAssertEqualObjects(button.toolTip, item.toolTip);
		XCTAssertEqualObjects(button.keyEquivalent, item.keyEquivalent);
		XCTAssertTrue([button.cell isKindOfClass:[KFToolbarItemButtonCell class]]);
		KFToolbarItemButtonCell *cell = button.cell;
		if (item == items.firstObject) {
			XCTAssertFalse(cell.showLeftShadow);
		}
		else {
			XCTAssertTrue(cell.showLeftShadow);
		}
		XCTAssertTrue(cell.showRightShadow);
		XCTAssertEqual(cell.itemType, item.type);
	}];
}

- (void)testAddingManyRightItems {
	NSArray *items = @[
					   [KFToolbarItem pushToolbarItemWithImage:self.itemImage tag:1],
					   [KFToolbarItem pushToolbarItemWithText:@"title" tag:2]
					   ];
	
	sut.rightItems = items;
	
	XCTAssertEqualObjects(sut.rightItems, items);
	
	NSArray *subviews = sut.subviews;
	XCTAssertEqual(subviews.count, (NSUInteger)2);
	[items enumerateObjectsUsingBlock:^(KFToolbarItem *item, NSUInteger idx, BOOL *stop) {
		NSButton *button = subviews[idx];
		XCTAssertFalse(button.translatesAutoresizingMaskIntoConstraints);
		XCTAssertEqualObjects(button.title, item.text);
		XCTAssertEqualObjects(button.image, item.image);
		XCTAssertEqualObjects(button.toolTip, item.toolTip);
		XCTAssertEqualObjects(button.keyEquivalent, item.keyEquivalent);
		XCTAssertTrue([button.cell isKindOfClass:[KFToolbarItemButtonCell class]]);
		KFToolbarItemButtonCell *cell = button.cell;
		XCTAssertTrue(cell.showLeftShadow);
		if (item == items.lastObject) {
			XCTAssertFalse(cell.showRightShadow);
		}
		else {
			XCTAssertTrue(cell.showRightShadow);
		}
		
		XCTAssertEqual(cell.itemType, item.type);
	}];

}


- (void)testThatItHasNoConstraintsWithNoItems {
	XCTAssertEqualObjects(sut.leftItems, @[]);
	XCTAssertEqualObjects(sut.rightItems, @[]);
	XCTAssertEqualObjects(sut.constraints, @[]);
}

- (void)testThatItSetsTheConstraintsForTheLeftItems {
	KFToolbarItem *item = [KFToolbarItem pushToolbarItemWithText:@"left" tag:1];
	KFToolbarItem *otherItem = [KFToolbarItem pushToolbarItemWithImage:self.itemImage tag:2];

	NSArray *items = @[item, otherItem];
	sut.leftItems = items;

	[sut layoutSubtreeIfNeeded];

	// @"|[item]-[otherItem]"
	MKMAssertArrayContainsLayoutConstraints(sut.constraints, [self expectedConstraintsForLeftItems:sut.subviews]);
}

- (void)testThatItSetsTheConstraintsForTheRightItems {
	KFToolbarItem *item = [KFToolbarItem pushToolbarItemWithText:@"right" tag:1];
	KFToolbarItem *otherItem = [KFToolbarItem pushToolbarItemWithImage:self.itemImage tag:2];

	NSArray *items = @[otherItem, item];
	sut.rightItems = items;
	[sut updateConstraintsForSubtreeIfNeeded];

	// @"[otherItem]-[item]|"
	MKMAssertArrayContainsLayoutConstraints(sut.constraints, [self expectedConstraintsForRightItems:sut.subviews]);
}

- (void)testThatItHasConstraintsWithLeftAndRightItemsAllowingOverlappingItems {
	KFToolbarItem *left = [KFToolbarItem pushToolbarItemWithText:@"left" tag:1];
	KFToolbarItem *right1 = [KFToolbarItem pushToolbarItemWithText:@"right1" tag:2];
	KFToolbarItem *right2 = [KFToolbarItem pushToolbarItemWithText:@"right2" tag:3];

	sut.leftItems = @[left];
	sut.rightItems = @[right1, right2];
	sut.allowOverlappingItems = YES;
	[sut updateConstraintsForSubtreeIfNeeded];

	NSArray *expectedHorizontalConstraints = [self expectedConstraintsForLeftItems:sut.leftItems rightItems:sut.rightItems views:sut.subviews allowOverlappingOfItems:sut.allowOverlappingItems];
	NSArray *expectedVerticalConstraints = [self expectedVerticalConstraintsForViews:sut.subviews];
	MKMAssertArrayContainsLayoutConstraints(sut.constraints, expectedHorizontalConstraints);
	MKMAssertArrayContainsLayoutConstraints(sut.constraints, expectedVerticalConstraints);
}

- (void)testThatItHasConstraintsWithLeftAndRightItemsForbiddingOverlappingItems {
	KFToolbarItem *left = [KFToolbarItem pushToolbarItemWithText:@"left" tag:1];
	KFToolbarItem *right1 = [KFToolbarItem pushToolbarItemWithText:@"right1" tag:2];
	KFToolbarItem *right2 = [KFToolbarItem pushToolbarItemWithText:@"right2" tag:3];
	
	sut.leftItems = @[left];
	sut.rightItems = @[right1, right2];
	sut.allowOverlappingItems = NO;
	[sut updateConstraintsForSubtreeIfNeeded];
	
	NSArray *expectedHorizontalConstraints = [self expectedConstraintsForLeftItems:sut.leftItems rightItems:sut.rightItems views:sut.subviews allowOverlappingOfItems:NO];
	NSArray *expectedVerticalConstraints = [self expectedVerticalConstraintsForViews:sut.subviews];
	MKMAssertArrayContainsLayoutConstraints(sut.constraints, expectedHorizontalConstraints);
	MKMAssertArrayContainsLayoutConstraints(sut.constraints, expectedVerticalConstraints);
}

- (void)testThatSelectionWorks {
	KFToolbarItem *left = [KFToolbarItem pushToolbarItemWithText:@"left" tag:11];
	KFToolbarItem *right = [KFToolbarItem pushToolbarItemWithText:@"right1" tag:42];
	
	sut.leftItems = @[left];
	sut.rightItems = @[right];

	__block KFToolbarItem *selectedItem = nil;
	__block NSInteger selectedTag = NSNotFound;

	sut.itemSelectionHandler = ^(KFToolbarItemSelectionType selectionType, KFToolbarItem *targetToolbarItem, NSInteger tag) {
		selectedItem = targetToolbarItem;
		selectedTag = tag;
	};

	NSButton *button = [self buttonForItem:0];
	[button performClick:button];

	XCTAssertEqualObjects(selectedItem, left);
	XCTAssertEqual(selectedTag, 11);
	XCTAssertEqual(sut.selectedIndex, (NSUInteger)0);

	button = [self buttonForItem:1];
	[button performClick:button];

	XCTAssertEqualObjects(selectedItem, right);
	XCTAssertEqual(selectedTag, 42);
	XCTAssertEqual(sut.selectedIndex, (NSUInteger)1);
}

@end
