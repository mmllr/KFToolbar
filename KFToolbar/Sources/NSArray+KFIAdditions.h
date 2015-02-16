//
//  NSArray+KFIAdditions.h
//  KFToolbar
//
//  Created by Markus Müller on 09.02.14.
//  Copyright (c) 2014 com.kf-interactive.toolbar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (KFIAdditions)

- (instancetype)kfi_minusArray:(NSArray*)other;
- (instancetype)kfi_map:(id (^)(id input))transformBlock;

@end
