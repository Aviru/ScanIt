//
//  WebImageOperations.h
//  ScanIt
//
//  Created by Aviru bhattacharjee on 23/10/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebImageOperations : NSObject

// This takes in a string and imagedata object and returns imagedata processed on a background thread
+ (void)processImageDataWithURLString:(NSString *)urlString andBlock:(void (^)(NSData *imageData))processImage;

@end
