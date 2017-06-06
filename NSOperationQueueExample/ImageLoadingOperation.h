//
//  ImageLoadingOperation.h
//  NSOperationQueueExample
//
//  Created by Jeff Kelley on 8/10/12.
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageLoadingOperation : NSOperation

@property (copy, nonatomic) NSString *imagePath;
@property (nullable, weak, nonatomic) UITableViewCell *cell;

@end

NS_ASSUME_NONNULL_END
