//
//  AmazonProductListingViewController.h
//  ScanIt
//
//  Created by Aviru bhattacharjee on 25/03/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AmazonProductListingViewController : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *amazonProductListWebView;


- (IBAction)showLeftPannelAction:(id)sender;


@property(strong,nonatomic)NSString *amazonProductListURL;

@end
