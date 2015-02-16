//
//  NSLayoutConstraint+MKMAdditions.m
//  Cantatas
//
//  Created by Markus Müller on 28.08.14.
//  Copyright (c) 2014 Markus Müller. All rights reserved.
//

#import "NSLayoutConstraint+MKMAdditions.h"

@implementation NSLayoutConstraint (MKMAdditions)

- (BOOL)mkm_isEqualToLayoutConstraint:(NSLayoutConstraint *)other
{
	if (![self.firstItem isEqual:other.firstItem]) {
		return NO;
	}
	if (self.firstAttribute != other.firstAttribute) {
		return NO;
	}
	if (self.secondAttribute != other.secondAttribute) {
		return NO;
	}
	if (self.relation != other.relation) {
		return NO;
	}
	if (self.multiplier != other.multiplier) {
		return NO;
	}
	if (self.constant != other.constant) {
		return NO;
	}
	if (self.priority != other.priority) {
		return NO;
	}
	return YES;
}

@end
