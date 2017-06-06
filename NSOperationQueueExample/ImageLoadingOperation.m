//
//  ImageLoadingOperation.m
//  NSOperationQueueExample
//
//  Created by Jeff Kelley on 8/10/12.
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//

#import "ImageLoadingOperation.h"

@implementation ImageLoadingOperation

- (void)main
{
    __block UIImage *image;
    
    if (self.cancelled == NO) {
        image = [UIImage imageWithContentsOfFile:self.imagePath];
    }
    
    if (self.cancelled == NO) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.cell.imageView.image = image;
            [self.cell setNeedsLayout];
        }];
    }
}

@end
