//
//  SuggestedRetailerWebSiteViewController.m
//  ScanIt
//
//  Created by Aviru bhattacharjee on 20/03/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import "SuggestedRetailerWebSiteViewController.h"

@interface SuggestedRetailerWebSiteViewController ()

@end

@implementation SuggestedRetailerWebSiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     [self.linkWebVw loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_URL]]];
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

- (IBAction)backToSuggestedRetailerDetailsAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
