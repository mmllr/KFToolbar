//
//  NSArray+KFIAdditions.m
//  KFToolbar
//
//  Created by Markus Müller on 09.02.14.
//  Copyright (c) 2014 com.kf-interactive.toolbar. All rights reserved.
//

#import "NSArray+KFIAdditions.h"

@implementation NSArray (KFIAdditions)

- (instancetype)kfi_minusArray:(NSArray*)other
{
	NSMutableArray *objectsNotInOtherArray = [self mutableCopy];
	[objectsNotInOtherArray removeObjectsInArray:other];
	return [objectsNotInOtherArray copy];
}

- (instancetype)kfi_map:(id (^)(id))transformBlock
{
	if (!transformBlock ||
		self.count == 0) {
		return self;
	}
	NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
	
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[result addObject:transformBlock(obj)];
	}];
	return [result copy];
}

@end
