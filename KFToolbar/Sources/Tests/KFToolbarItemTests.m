//
//  KFToolbarItemTests.m
//  KFToolbar
//
//  Created by Markus Müller on 15.02.15.
//  Copyright (c) 2015 com.kf-interactive.toolbar. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "KFToolbarItem.h"
#import "KFToolbarItemButtonCell.h"

@interface KFToolbarItemTests : XCTestCase

@property (nonatomic, strong) NSImage *image;

@end

@implementation KFToolbarItemTests
{
	KFToolbarItem *sut;
}

- (void)setUp {
    [super setUp];
	self.image = [NSImage imageNamed:NSImageNameAddTemplate];
}

- (void)testDesignatedInitalizer {
	sut = [[KFToolbarItem alloc] initWithType:kKFToolbarItemTypePush image:self.image text:@"text" tag:42 keyEquivalent:@"key" toolTip:@"tooltip"];
	XCTAssertEqual(sut.tag, 42);
	XCTAssertEqual(sut.image, self.image);
	XCTAssertEqual(sut.type, kKFToolbarItemTypePush);
	XCTAssertEqualObjects(sut.keyEquivalent, @"key");
	XCTAssertEqualObjects(sut.toolTip, @"tooltip");
}


@end
