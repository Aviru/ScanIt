//
//  AmazonProductListingViewController.m
//  ScanIt
//
//  Created by Aviru bhattacharjee on 25/03/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import "AmazonProductListingViewController.h"

@interface AmazonProductListingViewController ()

@end

@implementation AmazonProductListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   

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

- (IBAction)showLeftPannelAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
