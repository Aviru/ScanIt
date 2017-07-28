//
//  superViewController.m
//  ScanIt
//
//  Created by Aviru bhattacharjee on 24/02/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import "superViewController.h"

@interface superViewController ()

@end

@implementation superViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *UDID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [self setUserDefaultValue:UDID ForKey:IMEI];
}

#pragma mark _ Set UserDefaultValue

- (void)setUserDefaultValue:(id)value ForKey:(NSString *)key
{
    
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)getUserDefaultValueForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (void)RemoveUserDefaultValueForKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

#pragma mark - Email Id and Phone Number Validation

- (BOOL) validateEmail:(NSString *)tempMail
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:tempMail];
}

#pragma mark - Activity Indicator

+ (UIActivityIndicatorView *)startActivity:(UIView *)view
{
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center = view.center;
    activityView.color = [UIColor grayColor];
    [view addSubview:activityView];
    view.userInteractionEnabled = NO;
    [activityView startAnimating];
    
    return activityView;
}

+ (UIActivityIndicatorView *)stopActivity:(UIView *)view
{
    
    UIActivityIndicatorView *activityView = [self activityForView:view];
    activityView.center = view.center;
    [view addSubview:activityView];
    view.userInteractionEnabled = YES;
    [activityView stopAnimating];
    
    return activityView;
}

+ (UIActivityIndicatorView *)activityForView:(UIView *)view
{
    UIActivityIndicatorView *activity = nil;
    NSArray *subviews = view.subviews;
    Class activityClass = [UIActivityIndicatorView class];
    for (UIView *view in subviews)
    {
        if ([view isKindOfClass:activityClass])
        {
            activity = (UIActivityIndicatorView *)view;
        }
    }
    
    return activity;
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

@end
