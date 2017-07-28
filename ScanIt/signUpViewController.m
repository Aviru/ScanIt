//
//  signUpViewController.m
//  ScanIt
//
//  Created by Aviru bhattacharjee on 24/02/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import "signUpViewController.h"

@interface signUpViewController ()
{
    NSString *firstName;
    NSString *lastName;
    NSString *password;
    BOOL isValidfirstName,isValidLastName,isValidPassword,isValidEmail,isValidConfirmPassword,whiteSpaceChracter,isValidPhoneNumber;
    CGFloat prevYAxisValue;
}

@end

@implementation signUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _firstVw.layer.cornerRadius = 4.0f;
    _firstVw.layer.borderWidth = 1.0f;
    _firstVw.layer.borderColor = [UIColor clearColor].CGColor;
    _firstVw.layer.masksToBounds = YES;
    
    _firstVw.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    _firstVw.layer.shadowOffset = CGSizeMake(0, 1.0f);
    _firstVw.layer.shadowRadius = 0.8f;
    _firstVw.layer.shadowOpacity = 0.5f;
    _firstVw.layer.masksToBounds = NO;
    _firstVw.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_firstVw.bounds cornerRadius:_firstVw.layer.cornerRadius].CGPath;
    
    _secondVw.layer.cornerRadius = 4.0f;
    _secondVw.layer.borderWidth = 1.0f;
    _secondVw.layer.borderColor = [UIColor clearColor].CGColor;
    _secondVw.layer.masksToBounds = YES;
    
    _secondVw.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    _secondVw.layer.shadowOffset = CGSizeMake(0, 1.0f);
    _secondVw.layer.shadowRadius = 0.8f;
    _secondVw.layer.shadowOpacity = 0.5f;
    _secondVw.layer.masksToBounds = NO;
    _secondVw.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_secondVw.bounds cornerRadius:_secondVw.layer.cornerRadius].CGPath;
    
    [_txtFirstName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_txtLastName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_txtEmailAddress addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_txtMobileNumber addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_txtPassword addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_txtConfirmPassword addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

#pragma mark - TextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==_txtPassword) //***Confirm Password
    {
        if (self.view.frame.origin.y == prevYAxisValue)
        {
            NSLog(@"previous text field y axis value same as now");
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.4];
            [UIView setAnimationBeginsFromCurrentState:YES];
            prevYAxisValue = (self.view.frame.origin.y - 70);
            self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y - 70), self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
           
        }
       
    }
    if (textField==_txtConfirmPassword) //***Confirm Password
    {
        if (self.view.frame.origin.y == prevYAxisValue)
        {
            NSLog(@"previous text field y axis value same as now");
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.4];
            [UIView setAnimationBeginsFromCurrentState:YES];
            prevYAxisValue = (self.view.frame.origin.y - 60);
            self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y - 60), self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
            
        }
       
    }
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField==_txtFirstName)
    {
        NSString *rawString = [_txtFirstName text];
        NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        firstName = [rawString stringByTrimmingCharactersInSet:whitespace];
        
        if (firstName.length>0)
        {
            isValidfirstName=YES;
        }
        else
        {
            isValidfirstName=NO;
            
        }
        
    }
    
    if (textField==_txtLastName)
    {
        NSString *rawString = [_txtLastName text];
        NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        lastName = [rawString stringByTrimmingCharactersInSet:whitespace];
        
        if (lastName.length>0)
        {
            isValidLastName=YES;
        }
        else
        {
            isValidLastName=NO;
            
        }
        
    }
    
    if (textField==_txtEmailAddress) //***Email
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
    
    if (textField== _txtMobileNumber)
    {
        if ([textField.text length]>0)
        {
//            if([textField.text length] == 10)
//            {
//                isValidPhoneNumber = YES;
//            }
//            else
//                isValidPhoneNumber = NO;
            
        }
        else
            _txtMobileNumber.text = @"";
           // isValidPhoneNumber = NO;
    }
    
    if (textField==_txtPassword) //***Password
    {
        NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
        
        if ([textField.text length]>0)
        {
            
            if([textField.text length] >= 6)
            {
                whiteSpaceChracter = NO;
                
                for (int i = 0; i < [_txtPassword.text length]; i++)
                {
                    unichar c = [_txtPassword.text characterAtIndex:i];
                    if(!whiteSpaceChracter)
                    {
                        whiteSpaceChracter = [whitespace characterIsMember:c];
                    }
                }
                
                if (whiteSpaceChracter)
                {
                    isValidPassword = NO;
                    
                }
                
                else
                {
                    password = _txtPassword.text;
                    isValidPassword = YES;
                }
                
            }
            else
                isValidPassword = NO;
        }
        else
            isValidPassword=NO;
    }
    
    if ([textField.text length]>0)
    {
        
        if ([password isEqualToString: _txtConfirmPassword.text])
        {
            isValidConfirmPassword = YES;
            
        }
        
        else
        {
            isValidConfirmPassword = NO;
        }
        
    }

    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (textField==_txtPassword) //***Password
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y + 70), self.view.frame.size.width, self.view.frame.size.height);
        prevYAxisValue = self.view.frame.origin.y;
        [UIView commitAnimations];
        

    }
    
    if (textField==_txtConfirmPassword) //***Confirm Password
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y + 60), self.view.frame.size.width, self.view.frame.size.height);
        prevYAxisValue = self.view.frame.origin.y;
        [UIView commitAnimations];
        
    }
    
    if (textField== _txtMobileNumber)
    {
        if ([textField.text length]>0)
        {
            if([textField.text length] == 10)
            {
                isValidPhoneNumber = YES;
            }
            else
                isValidPhoneNumber = NO;
        }
        else
          isValidPhoneNumber = NO;  
    }
    
}

#pragma mark

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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

- (IBAction)doneAction:(id)sender
{
    if (isValidfirstName == NO && isValidLastName == NO && isValidPassword == NO && isValidConfirmPassword == NO && isValidEmail == NO && isValidPhoneNumber == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please Enter all details"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    else
    {
        if (isValidfirstName == NO)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Please enter valid First Name"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else if (isValidLastName == NO)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Please enter valid Last Name"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
        else if (isValidEmail == NO)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Please Ensure that you have entered correct Email"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
        else if (isValidPassword == NO)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Please enter valid Password. The Password must contain atleast 6 characters and should not contain white space."
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else if (isValidConfirmPassword == NO)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Confirm Password is not same"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
//        else if (isValidPhoneNumber == NO)
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                            message:@"Please enter valid mobile number"
//                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//        }
        
        else
        {
            NSMutableDictionary *regDict = [[NSMutableDictionary alloc]init];
            
            [regDict setObject:_txtFirstName.text forKey:FIRSTNAME];
            [regDict setObject:_txtLastName.text forKey:LASTNAME];
            [regDict setObject:_txtPassword.text forKey:PASSWORD];
            [regDict setObject:_txtEmailAddress.text forKey:EMAIL];
            [regDict setObject:_txtMobileNumber.text forKey:PHONENUMBER];
            
            [superViewController startActivity:self.view];
            
            [self signUpDetails:regDict];
        }
    }
    

}



- (IBAction)backToHomeAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Web Service

-(void)signUpDetails:(NSMutableDictionary *)dictSignUp
{
    NSError *error=nil;
    NSData *jsonRequestDict= [NSJSONSerialization dataWithJSONObject:dictSignUp options:NSJSONWritingPrettyPrinted error:&error];
    NSString *URL=[BASEURL stringByAppendingString:REGISTRATION];
    
    NSLog(@"Signup_Url:%@",URL);
    
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
         FirstName = avi;
         LastName = bhattacharjee;
         UserID = 94;
         message = "Registration successful.";
         status = 1;
         }
         */
        
        if ([[jsonResponseDict objectForKey:@"status"] integerValue]==1)
        {
            [superViewController stopActivity:self.view];
            
            [self setUserDefaultValue:@"YES" ForKey:ISLOGGEDIN];
            
            [self setUserDefaultValue:[jsonResponseDict objectForKey:USERID] ForKey:USERID];
            
            [self setUserDefaultValue:jsonResponseDict [FIRSTNAME] ForKey:FIRSTNAME];
            [self setUserDefaultValue:jsonResponseDict [LASTNAME] ForKey:LASTNAME];
            [self setUserDefaultValue:jsonResponseDict [EMAIL] ForKey:EMAIL];
            [self setUserDefaultValue:jsonResponseDict [PHONENUMBER] ForKey:PHONENUMBER];
            
            [self setUserDefaultValue:@"" ForKey:PROFILEIMAGE];
            
            [self performSegueWithIdentifier:@"showRevealViewFromSignUp" sender:nil];
            
        }
        
        else
        {
            [superViewController stopActivity:self.view];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"User already registered"
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
