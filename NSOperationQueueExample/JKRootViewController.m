//
//  JKRootViewController.m
//  NSOperationQueueExample
//
//  Created by Jeff Kelley on 8/10/12.
//  Copyright (c) 2012 Jeff Kelley. All rights reserved.
//


#import "JKRootViewController.h"

#import "JKImageLoadingOperation.h"

#import <objc/runtime.h>

static const void *kImageLoadingOperationKey = &kImageLoadingOperationKey;


@implementation JKRootViewController {
    NSString	*imageFolder;
    NSArray 	*imagePathArray;
	NSOperationQueue *imageLoadingQueue;
}

#pragma mark - View Controller Lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    imageFolder = [[resourcePath stringByAppendingPathComponent:@"Nature"] copy];
    imagePathArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:imageFolder
																		 error:NULL];
}

#pragma mark - UITableViewDataSource Protocol Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [imagePathArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
									  reuseIdentifier:CellIdentifier];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    // Get the filename to load.
    NSString *imageFilename = [imagePathArray objectAtIndex:[indexPath row]];
    NSString *imagePath = [imageFolder stringByAppendingPathComponent:imageFilename];
    
    [[cell textLabel] setText:[imageFilename stringByDeletingPathExtension]];
	
	if (imageLoadingQueue == nil) {
		imageLoadingQueue = [[NSOperationQueue alloc] init];
		[imageLoadingQueue setName:@"Image Loading Queue"];
	}
	
	NSOperation *currentOperation = objc_getAssociatedObject(cell, kImageLoadingOperationKey);
	[currentOperation cancel];
	[[cell imageView] setImage:nil];
	
	JKImageLoadingOperation *imageLoadingOperation = [[JKImageLoadingOperation alloc] init];
	[imageLoadingOperation setImagePath:imagePath];
	[imageLoadingOperation setCell:cell];
	
	objc_setAssociatedObject(cell, kImageLoadingOperationKey, imageLoadingOperation, OBJC_ASSOCIATION_RETAIN);
	
	[imageLoadingQueue addOperation:imageLoadingOperation];
	
	return cell;
}

#pragma mark -

@end
