//
//  SuggestedRetailerWebSiteViewController.h
//  ScanIt
//
//  Created by Aviru bhattacharjee on 20/03/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuggestedRetailerWebSiteViewController : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *linkWebVw;

- (IBAction)backToSuggestedRetailerDetailsAction:(id)sender;

@property (strong, nonatomic)NSString *URL;

@end
