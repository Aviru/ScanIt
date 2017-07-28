//
//  SuggestedRetailerDetailsViewController.m
//  ScanIt
//
//  Created by Aviru bhattacharjee on 13/03/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import "SuggestedRetailerDetailsViewController.h"
#import "SuggestedRetailerWebSiteViewController.h"

@interface SuggestedRetailerDetailsViewController ()
{
    NSString *urlToHit;
}

@end

@implementation SuggestedRetailerDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _lblShopName.text = [[_arrSuggestedRetailerDetails objectAtIndex:0] objectForKey:@"shop_name"];
    
    _lblShopAddress.text = [[_arrSuggestedRetailerDetails objectAtIndex:0] objectForKey:@"shop_address"];
    
    _lblContact.text = [[_arrSuggestedRetailerDetails objectAtIndex:0] objectForKey:@"shop_phone_number"];
    
    _lblTimings.text = [[_arrSuggestedRetailerDetails objectAtIndex:0] objectForKey:@"shop_timings"];
    
    _lblWebSite.text = [[_arrSuggestedRetailerDetails objectAtIndex:0] objectForKey:@"website"];
   
    __weak typeof(self) weakSelf = self;
    
    _lblWebSite.detectionBlock = ^(STTweetHotWord hotWord, NSString *string, NSString *protocol, NSRange range) {
        
        if([string containsString:@"http"] || [string containsString:@"https"])
        {
            string = [string substringFromIndex:0];
            urlToHit = string;
            
            [weakSelf performSelector:@selector(visitUrlFromSuggestedRetailerDetails) withObject:nil];
            
        }
    };
}

#pragma mark - Visit the link

- (void)visitUrlFromSuggestedRetailerDetails
{
    [self performSegueWithIdentifier:@"showRetailerWebsiteFromRetailerDetails" sender:nil];
}

#pragma mark - Prepare For Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showRetailerWebsiteFromRetailerDetails"])
    {
        SuggestedRetailerWebSiteViewController* retailerWebVC = [segue destinationViewController];
        retailerWebVC.URL = urlToHit;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Button Action

- (IBAction)backToSuggestedRetailers:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)callUsAction:(id)sender
{
    NSURL *phoneUrl = [NSURL URLWithString:[@"tel://" stringByAppendingString:[[_arrSuggestedRetailerDetails objectAtIndex:0] objectForKey:@"shop_phone_number"]]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        UIAlertView *calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [calert show];
    }
}
@end
