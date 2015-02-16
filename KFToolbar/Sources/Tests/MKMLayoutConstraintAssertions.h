//
//  __MKM_LAYOUT_CONSTRAINT_ASSERTIONS_H
//
//  Created by Markus Müller on 28.08.14.
//  Copyright (c) 2014 Markus Müller. All rights reserved.
//

#ifndef __MKM_LAYOUT_CONSTRAINT_ASSERTIONS_H
#define __MKM_LAYOUT_CONSTRAINT_ASSERTIONS_H

#import <XCTest/XCTest.h>

#import "NSLayoutConstraint+MKMAdditions.h"

#define MKMAssertEqualLayoutConstraints(lhs, rhs) \
do { \
	XCTAssertEqualObjects(lhs.firstItem, rhs.firstItem); \
	XCTAssertEqualObjects(lhs.secondItem, rhs.secondItem); \
	XCTAssertEqual(lhs.firstAttribute, rhs.firstAttribute); \
	XCTAssertEqual(lhs.secondAttribute, rhs.secondAttribute); \
	XCTAssertEqual(lhs.relation, rhs.relation); \
	XCTAssertEqual(lhs.multiplier, rhs.multiplier); \
	XCTAssertEqual(lhs.constant, rhs.constant); \
	XCTAssertEqual(lhs.priority, rhs.priority); \
} while (0);

#define MKMAssertContainsLayoutConstraint(array, constraint) \
do { \
	NSIndexSet *indexes = [array indexesOfObjectsPassingTest:^BOOL(NSLayoutConstraint *other, NSUInteger idx, BOOL *stop) { \
		return [other mkm_isEqualToLayoutConstraint:constraint]; \
	}]; \
	XCTAssertTrue([indexes count] > 0, @"Constraint %@ not in array", constraint); \
} while (0);

#define MKMAssertArrayContainsLayoutConstraints(array, constraints) \
do { \
   for (NSLayoutConstraint *c in constraints) { \
	  MKMAssertContainsLayoutConstraint(array, c); \
   } \
} while (0);


#endif	// __MKM_LAYOUT_CONSTRAINT_ASSERTIONS_H
