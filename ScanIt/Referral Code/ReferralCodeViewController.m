//
//  ReferralCodeViewController.m
//  ScanIt
//
//  Created by Aviru bhattacharjee on 30/10/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import "ReferralCodeViewController.h"

@interface ReferralCodeViewController ()<UITextFieldDelegate>
{
    
    IBOutlet UITextField *txtReferralCode;
    
    IBOutlet UIButton *submitBtnOutlet;
    
    IBOutlet UIButton *leftPannelBtn;
}

@end

@implementation ReferralCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    txtReferralCode.layer.borderWidth = 1.0f;
    txtReferralCode.layer.borderColor = [UIColor colorWithRed:193.0/255.0 green:53.0/255.0 blue:30.0/255.0 alpha:1.0].CGColor;
    
    submitBtnOutlet.layer.cornerRadius = 4.0f;
    submitBtnOutlet.layer.masksToBounds = YES;
    
    [leftPannelBtn addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)submitBtnAction:(id)sender {
    
    [self.view endEditing:YES];
    
    if ([txtReferralCode.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
    {
        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"Alert!" message:@"Please Enter Referral Code" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOK=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertController addAction:actionOK];
        [self presentViewController:alertController animated:YES completion:^{
        }];
    }
    else
    {
        [superViewController startActivity:self.view];
        
        NSMutableDictionary *referralCodeDict = [[NSMutableDictionary alloc]init];
        
        [referralCodeDict setObject:[self getUserDefaultValueForKey:USERID] forKey:@"UserID"];
        [referralCodeDict setObject:txtReferralCode.text forKey:@"referrel_code"];
        
        NSError *error=nil;
        NSData *jsonRequestDict= [NSJSONSerialization dataWithJSONObject:referralCodeDict options:NSJSONWritingPrettyPrinted error:&error];
        NSString *URL=[BASEURL_FOR_SUGGESTEDRETAIL_AND_PURCHASELIST stringByAppendingString:REFERRALCODE];
        
        NSLog(@"ReferralCode_Url:%@",URL);
        
        NSString *jsonCommand=[[NSString alloc] initWithData:jsonRequestDict encoding:NSUTF8StringEncoding];
        NSLog(@"***jsonCommand***%@",jsonCommand);
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:jsonCommand,@"requestParam", nil];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager POST:URL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSError *error=nil;
            NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"Request Successful, response '%@'", responseStr);
            NSMutableDictionary *jsonResponseDict= [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
            NSLog(@"Response Dictionary:: %@",jsonResponseDict);
            
            [superViewController stopActivity:self.view];
            
            if ([[jsonResponseDict objectForKey:@"status"] integerValue] == 0)
            {
                UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"Error!" message:[jsonResponseDict objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionOK=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [alertController dismissViewControllerAnimated:YES completion:nil];
                }];
                [alertController addAction:actionOK];
                [self presentViewController:alertController animated:YES completion:^{
                }];
            }
            else
            {
                UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"Success" message:[jsonResponseDict objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionOK=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [alertController dismissViewControllerAnimated:YES completion:nil];
                }];
                [alertController addAction:actionOK];
                [self presentViewController:alertController animated:YES completion:^{
                }];
            }
            
            
        }
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [superViewController stopActivity:self.view];
             
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                             message:@"please check your network connection"
                                                            delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
             NSLog(@"Error: %@", error);
         }];
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

@end
