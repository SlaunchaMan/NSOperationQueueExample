//
//  JKImageLoadingOperation.h
//  NSOperationQueueExample
//
//  Created by Jeff Kelley on 8/10/12.
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UITableViewCell.h>

@interface JKImageLoadingOperation : NSOperation

@property (copy, atomic) NSString *imagePath;
@property (strong, atomic) UITableViewCell *cell;

@end
