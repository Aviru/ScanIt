//
//  ForgotPasswordViewController.m
//  ScanIt
//
//  Created by Aviru bhattacharjee on 15/03/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()
{
    BOOL isValidEmail;
}

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _forgotPassView.layer.cornerRadius = 4.0f;
    _forgotPassView.layer.borderWidth = 1.0f;
    _forgotPassView.layer.borderColor = [UIColor clearColor].CGColor;
    _forgotPassView.layer.masksToBounds = YES;
    
    _forgotPassView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    _forgotPassView.layer.shadowOffset = CGSizeMake(0, 1.0f);
    _forgotPassView.layer.shadowRadius = 0.8f;
    _forgotPassView.layer.shadowOpacity = 0.5f;
    _forgotPassView.layer.masksToBounds = NO;
    _forgotPassView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_forgotPassView.bounds cornerRadius:_forgotPassView.layer.cornerRadius].CGPath;
    
    [_txtEmail addTarget:self
                        action:@selector(textFieldDidChange:)
              forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - TextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField==_txtEmail) //***Email
    {
        if(textField.text.length > 0)
        {
            isValidEmail = [self validateEmail:textField.text];
        }
        
        else
        {
            isValidEmail = NO;
        }
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

- (IBAction)submitEmailAction:(id)sender
{
    if (!isValidEmail)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please Ensure that you have entered valid Email"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        
    }
    else
    {
        [superViewController startActivity:self.view];
        
        NSMutableDictionary *forgotPassDict = [[NSMutableDictionary alloc]init];
        
        [forgotPassDict setObject:_txtEmail.text forKey:EMAIL];
        
        [self getPassword:forgotPassDict];
    }
   

}

- (IBAction)backToSignInAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getPassword:(NSMutableDictionary *)forgotPassDict
{
    NSError *error=nil;
    NSData *jsonRequestDict= [NSJSONSerialization dataWithJSONObject:forgotPassDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *URL=[BASEURL stringByAppendingString:FORGOTPASSWORD];
    
    NSLog(@"FORGOTPASSWORD_Url:%@",URL);
    
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
        
        
        /*Response Dictionary:: {
         ContactNo = 8961390612;
         Email = "aviru.bhattacharjee@gmail.com";
         FirstName = aviru;
         LastName = bhattacharjee;
         UserID = 20;
         message = "Registration successful.";
         status = 1;
         }
         */
        
        [superViewController stopActivity:self.view];
        
        if ([[jsonResponseDict objectForKey:@"status"] integerValue]==1)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Password has been sent to your Email"
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
 
            
        }
        
        else
        {
            [superViewController stopActivity:self.view];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Unable to send password"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
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


@end
