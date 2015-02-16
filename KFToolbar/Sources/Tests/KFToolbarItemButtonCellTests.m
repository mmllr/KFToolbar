//
//  KFToolbarItemButtonCellTests.m
//  KFToolbar
//
//  Created by Markus Müller on 15.02.15.
//  Copyright (c) 2015 com.kf-interactive.toolbar. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "KFToolbarItemButtonCell.h"

@interface KFToolbarItemButtonCellTests : XCTestCase

@end

@implementation KFToolbarItemButtonCellTests
{
	KFToolbarItemButtonCell *sut;
}

- (void)setUp {
    [super setUp];
	sut = [[KFToolbarItemButtonCell alloc] init];
}

- (void)testThatItHasTheInitialPropertiesWhenCreatedWithPlainInit
{
	XCTAssertEqual(sut.itemType, kKFToolbarItemTypePush);
	XCTAssertEqual(sut.bezelStyle, NSTexturedRoundedBezelStyle);
	XCTAssertEqual(sut.showsStateBy, 0);
	XCTAssertEqual(sut.highlightsBy, NSPushInCellMask);
	XCTAssertTrue(sut.showLeftShadow);
	XCTAssertTrue(sut.showRightShadow);
	XCTAssertEqual(sut.state, NSOffState);
}

- (void)testDesignatedInitalizer {
	sut = [[KFToolbarItemButtonCell alloc] initTextCell:@"text"];

	XCTAssertEqual(sut.title, @"text");
	XCTAssertEqual(sut.itemType, kKFToolbarItemTypePush);
	XCTAssertEqual(sut.bezelStyle, NSTexturedRoundedBezelStyle);
	XCTAssertEqual(sut.showsStateBy, 0);
	XCTAssertEqual(sut.highlightsBy, NSPushInCellMask);
	XCTAssertTrue(sut.showLeftShadow);
	XCTAssertTrue(sut.showRightShadow);
	XCTAssertEqual(sut.state, NSOffState);
}

- (void)testThatNextStateIsOffWhenOn {
	sut.state = NSOnState;

	XCTAssertEqual(sut.nextState, NSOffState);
}

- (void)testThatNextStateIsOffWhenOff {
	sut.state = NSOffState;

	XCTAssertEqual(sut.nextState, NSOffState);
}

- (void)testThatNexStateIsOnStateWhenButtonTypeIsToggleButton {
	sut.itemType = kKFToolbarItemTypeToggle;

	XCTAssertEqual(sut.nextState, NSOnState);
}

- (void)testThatNexStateIsOffStateWhenOnAndButtonTypeIsToggleButton {
	sut.itemType = kKFToolbarItemTypeToggle;

	sut.state = NSOnState;
	XCTAssertEqual(sut.nextState, NSOffState);
}

@end
