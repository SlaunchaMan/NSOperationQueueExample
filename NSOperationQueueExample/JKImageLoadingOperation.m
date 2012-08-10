//
//  JKImageLoadingOperation.m
//  NSOperationQueueExample
//
//  Created by Jeff Kelley on 8/10/12.
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//

#import "JKImageLoadingOperation.h"

@implementation JKImageLoadingOperation

- (void)main
{
	__block UIImage *image;
	
	if ([self isCancelled] == NO) {
		image = [UIImage imageWithContentsOfFile:[self imagePath]];
	}
	
	if ([self isCancelled] == NO) {
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			[[[self cell] imageView] setImage:image];
			[[self cell] setNeedsLayout];
		}];
	}
}

@end
