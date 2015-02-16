//
//  NSLayoutConstraint+MKMAdditions.h
//  Cantatas
//
//  Created by Markus Müller on 28.08.14.
//  Copyright (c) 2014 Markus Müller. All rights reserved.
//

#import <TargetConditionals.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
#import <Cocoa/Cocoa.h>
#endif

@interface NSLayoutConstraint (MKMAdditions)

- (BOOL)mkm_isEqualToLayoutConstraint:(NSLayoutConstraint*)other;

@end
