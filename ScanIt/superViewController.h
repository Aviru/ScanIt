//
//  superViewController.h
//  ScanIt
//
//  Created by Aviru bhattacharjee on 24/02/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface superViewController : UIViewController

- (BOOL) validateEmail:(NSString *)tempMail;

- (void)setUserDefaultValue:(id)value ForKey:(NSString *)key;
- (id)getUserDefaultValueForKey:(NSString *)key;
- (void)RemoveUserDefaultValueForKey:(NSString *)key;

+ (UIActivityIndicatorView *)startActivity:(UIView *)view;
+ (UIActivityIndicatorView *)stopActivity:(UIView *)view;

@end
