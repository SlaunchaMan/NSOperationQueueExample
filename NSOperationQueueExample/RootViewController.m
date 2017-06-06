//
//  RootViewController.m
//  NSOperationQueueExample
//
//  Created by Jeff Kelley on 8/10/12.
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//

#import "RootViewController.h"

#import "ImageLoadingOperation.h"

#import <objc/runtime.h>

static const void *kImageLoadingOperationKey = &kImageLoadingOperationKey;

@interface RootViewController ()

@property (nonnull, copy, nonatomic) NSString *imageFolder;
@property (nonnull, copy, nonatomic) NSArray<NSString *> *imagePaths;
@property (nonnull, strong, nonatomic) NSOperationQueue *imageLoadingQueue;

@end

@implementation RootViewController

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *resourcePath = [NSBundle mainBundle].resourcePath;
    self.imageFolder = [[resourcePath stringByAppendingPathComponent:@"Nature"] copy];
    self.imagePaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.imageFolder
                                                                          error:NULL];
    self.imageLoadingQueue = [[NSOperationQueue alloc] init];
    self.imageLoadingQueue.name = @"Image Loading Queue";
}

#pragma mark - UITableViewDataSource Protocol Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.imagePaths.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Get the filename to load.
    NSString *imageFilename = self.imagePaths[indexPath.row];
    NSString *imagePath = [self.imageFolder stringByAppendingPathComponent:imageFilename];
    
    cell.textLabel.text = imageFilename.stringByDeletingPathExtension;
    
    NSOperation *currentOperation = objc_getAssociatedObject(cell, kImageLoadingOperationKey);
    [currentOperation cancel];
    [cell.imageView setImage:nil];
    
    ImageLoadingOperation *imageLoadingOperation = [[ImageLoadingOperation alloc] init];
    imageLoadingOperation.imagePath = imagePath;
    imageLoadingOperation.cell = cell;
    
    objc_setAssociatedObject(cell, kImageLoadingOperationKey, imageLoadingOperation, OBJC_ASSOCIATION_RETAIN);
    
    [self.imageLoadingQueue addOperation:imageLoadingOperation];
    
    return cell;
}

#pragma mark -

@end
