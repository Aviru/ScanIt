//
//  WebImageOperations.m
//  ScanIt
//
//  Created by Aviru bhattacharjee on 23/10/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import "WebImageOperations.h"
#import <QuartzCore/QuartzCore.h>

@implementation WebImageOperations

+ (void)processImageDataWithURLString:(NSString *)urlString andBlock:(void (^)(NSData *imageData))processImage
{
    NSURL *url = [NSURL URLWithString:urlString];
    
    dispatch_queue_t callerQueue = dispatch_get_current_queue();
    dispatch_queue_t downloadQueue = dispatch_queue_create("com.ScanIt.processImageQueue", NULL);
    dispatch_async(downloadQueue, ^{
        NSData * imageData = [NSData dataWithContentsOfURL:url];
        
        dispatch_async(callerQueue, ^{
            processImage(imageData);
        });
    });
}

@end
