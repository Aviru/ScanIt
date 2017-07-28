//
//  ViewController.m
//  ScanIt
//
//  Created by Aviru bhattacharjee on 23/02/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import "logInViewController.h"

@interface logInViewController ()
{
    BOOL isValidPassword,isValidEmail,whiteSpaceChracter;
}

@end

@implementation logInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.sinInBtnOutlet.layer.cornerRadius = 3.0f;
    
    [_txtSignInEmail addTarget:self
                        action:@selector(textFieldDidChange:)
              forControlEvents:UIControlEventEditingChanged];
    
    [_txtSignInPassword addTarget:self
                           action:@selector(textFieldDidChange:)
                 forControlEvents:UIControlEventEditingChanged];
    
    UIImage *img =[UIImage imageNamed:@"profile_pic.png"];
    
    [self setUserDefaultValue:UIImagePNGRepresentation(img) ForKey:@"CheckEmptyImage"];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /*
    _firstView.layer.cornerRadius = 4.0f;
    _firstView.layer.borderWidth = 1.0f;
    _firstView.layer.borderColor = [UIColor clearColor].CGColor;
    _firstView.layer.masksToBounds = YES;
    
    _firstView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    _firstView.layer.shadowOffset = CGSizeMake(0, 1.0f);
    _firstView.layer.shadowRadius = 0.8f;
    _firstView.layer.shadowOpacity = 0.5f;
    _firstView.layer.masksToBounds = NO;
    _firstView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_firstView.bounds cornerRadius:_firstView.layer.cornerRadius].CGPath;
    
    _secondView.layer.cornerRadius = 4.0f;
    _secondView.layer.borderWidth = 1.0f;
    _secondView.layer.borderColor = [UIColor clearColor].CGColor;
    _secondView.layer.masksToBounds = YES;
    
    _secondView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    _secondView.layer.shadowOffset = CGSizeMake(0, 1.0f);
    _secondView.layer.shadowRadius = 0.8f;
    _secondView.layer.shadowOpacity = 0.5f;
    _secondView.layer.masksToBounds = NO;
    _secondView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_secondView.bounds cornerRadius:_secondView.layer.cornerRadius].CGPath;
    */
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    
    if (textField==_txtSignInEmail) //***Email
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
    else if (textField==_txtSignInPassword) //***Password
    {
        NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
        
        if ([textField.text length]>0)
        {
            whiteSpaceChracter = NO;
            
            if([textField.text length] >= 6)
            {
                for (int i = 0; i < [_txtSignInPassword.text length]; i++)
                {
                    unichar c = [_txtSignInPassword.text characterAtIndex:i];
                    if(!whiteSpaceChracter)
                    {
                        whiteSpaceChracter = [whitespace characterIsMember:c];
                    }
                }
                
                if (whiteSpaceChracter)
                {
                    isValidPassword=NO;
                    
                }
                
                else
                {
                    isValidPassword = YES;
                    return;
                }
                
            }
            else
                isValidPassword=NO;
        }
        else
            isValidPassword=NO;
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
}

#pragma mark



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - Button Action

- (IBAction)signInAction:(id)sender
{
    if (!isValidEmail && !isValidPassword)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please all  details"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    else
    {
        if (!isValidEmail)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Please Ensure that you have entered correct Email/Password"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            
        }
        else if (!isValidPassword)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Please enter valid Password. The Password must contain atleast 6 characters and should not contain white space."
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            NSMutableDictionary *signInDict = [[NSMutableDictionary alloc]init];
            
            [signInDict setObject:_txtSignInEmail.text forKey:EMAIL];
            [signInDict setObject:_txtSignInPassword.text forKey:PASSWORD];
            [signInDict setObject:_txtSignInEmail.text forKey:UNIQUEUSERID];
            [signInDict setObject:[self getUserDefaultValueForKey:IMEI] forKey:IMEI];
            [signInDict setObject:@"" forKey:FIRSTNAME];
            [signInDict setObject:@"" forKey:LASTNAME];
            [signInDict setObject:@"N" forKey:REGISTRATIONTYPE];
            [signInDict setObject:@"" forKey:PROFILEIMAGE];
            
            [superViewController startActivity:self.view];
            
           
            [self LoginDetails:signInDict];
            
       }
    }

}

- (IBAction)forgotPasswordAction:(id)sender {
}

- (IBAction)backToHomeAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark

#pragma mark - Login Web service

-(void)LoginDetails:(NSMutableDictionary *)dictLogin
{
    NSError *error=nil;
    NSData *jsonRequestDict= [NSJSONSerialization dataWithJSONObject:dictLogin options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *URL=[BASEURL stringByAppendingString:LOGIN];
    NSLog(@"Login_Url:%@",URL);
    
    NSString *jsonCommand=[[NSString alloc] initWithData:jsonRequestDict encoding:NSUTF8StringEncoding];
    NSLog(@"***jsonCommand***%@",jsonCommand);
     NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:jsonCommand,@"requestParam", nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //[manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:URL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error=nil;
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"Request Successful, response '%@'", responseStr);
        NSMutableDictionary *jsonResponseDict= [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        NSLog(@"Response Dictionary:: %@",jsonResponseDict);
        
        [superViewController stopActivity:self.view];
        
        /*Response Dictionary:: {
         message = "successfully logged in.";
         response =     {
         "user_details" =         {
         Address = "";
         ContactNo = 8961390612;
         Email = "aviru.bhattacharjee@gmail.com";
         FirstName = avi;
         LastName = bhattacharjee;
         ProfileImage = "";
         Status = Y;
         UserID = 96;
         deviceToken = N;
         "reg_type" = N;
         "unique_userid" = "aviru.bhattacharjee@gmail.com";
         };
         };
         status = 2;
         }
         */
        
        if ([[jsonResponseDict objectForKey:@"status"] integerValue]==1 || [[jsonResponseDict objectForKey:@"status"] integerValue]==2)
        {
            [self setUserDefaultValue:jsonResponseDict [@"response"][@"user_details"][USERID] ForKey:USERID];//set UserId
            [self setUserDefaultValue:jsonResponseDict [@"response"][@"user_details"][FIRSTNAME] ForKey:FIRSTNAME];
            [self setUserDefaultValue:jsonResponseDict [@"response"][@"user_details"][LASTNAME] ForKey:LASTNAME];
            if (jsonResponseDict [@"response"][@"user_details"][EMAIL])
            {
                [self setUserDefaultValue:jsonResponseDict [@"response"][@"user_details"][EMAIL] ForKey:EMAIL];
            }
            else
              [self setUserDefaultValue:@"" ForKey:EMAIL];
            
            if (jsonResponseDict [@"response"][@"user_details"][PHONENUMBER])
            {
                [self setUserDefaultValue:jsonResponseDict [@"response"][@"user_details"][PHONENUMBER] ForKey:PHONENUMBER];
            }
            else
                [self setUserDefaultValue:@"" ForKey:PHONENUMBER];
            
            [self setUserDefaultValue:jsonResponseDict [@"response"][@"user_details"][REGISTRATIONTYPE] ForKey:REGISTRATIONTYPE];
            
            if (jsonResponseDict [@"response"][@"user_details"][PROFILEIMAGE])
            {
                NSURL *picurl = [NSURL URLWithString:jsonResponseDict[@"response"][@"user_details"][PROFILEIMAGE] ];
                NSData *pictureData = [NSData dataWithContentsOfURL:picurl];
                
                UIImage *im=[UIImage imageWithData:pictureData];
                
                if ( [[self getUserDefaultValueForKey:@"CheckEmptyImage"] isEqualToData:UIImagePNGRepresentation(im)])
                {
                    [self setUserDefaultValue:@"" ForKey:PROFILEIMAGE];
                }
                else
                {
                    [self setUserDefaultValue:UIImagePNGRepresentation(im) ForKey:PROFILEIMAGE];
                }
                
            }
            else
              [self setUserDefaultValue:@"" ForKey:PROFILEIMAGE];  
            
            NSLog(@"*****");
            
            [self addDeviceToken];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:jsonResponseDict[@"message"]
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
            [superViewController stopActivity:self.view];
             
             NSLog(@"Error: %@", error);
             
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Please try again"
                                                            delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
         
     }];
}

#pragma mark - Add Device token

-(void)addDeviceToken
{
    NSMutableDictionary *devideTokenDict = [[NSMutableDictionary alloc] init];
    
    NSLog(@"crash in addDeviceToken in login:%@",USERID);
    
    
    [devideTokenDict setObject:[self getUserDefaultValueForKey:USERID] forKey:USERID];
    [devideTokenDict setObject:@"Iphone" forKey:@"deviceType"];
    [devideTokenDict setObject:[self getUserDefaultValueForKey:IMEI] forKey:IMEI]; //2847D1F5-5BEF-4A0C-8274-4CAE75B52B1D
    
#if TARGET_IPHONE_SIMULATOR
    // Simulator
    [devideTokenDict setObject:@"fe3c1c39fb267847300fd9bd5fb30fc3df6a22c5d00f59743c138bfe15429d48" forKey:DEVICETOKEN];
#else
    // iPhones
    [devideTokenDict setObject:[self getUserDefaultValueForKey:DEVICETOKEN] forKey:DEVICETOKEN];
#endif
    
    NSError *error=nil;
    NSString *URL=[BASEURL stringByAppendingString:ADD_DEVICE_TOKEN];
    
    NSLog(@"Add_Device_Token_URL_Url:%@",URL);
    NSData *jsonRequestDict= [NSJSONSerialization dataWithJSONObject:devideTokenDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonCommand=[[NSString alloc] initWithData:jsonRequestDict encoding:NSUTF8StringEncoding];
    //NSLog(@"***jsonCommand***%@",jsonCommand);
    
    NSDictionary *params =[NSDictionary dictionaryWithObjectsAndKeys:jsonCommand,@"requestParam", nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:URL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error=nil;
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"Request Successful, response '%@'", responseStr);
        NSMutableDictionary *jsonResponseDict= [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        NSLog(@"Response Dictionary:: %@",jsonResponseDict);
        
        [self setUserDefaultValue:@"YES" ForKey:ISLOGGEDIN];
        
        [superViewController stopActivity:self.view];
        
        [self performSegueWithIdentifier:@"showRevealViewFromSignIn" sender:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request Error: %@", error);
        [superViewController stopActivity:self.view];
    }];
}


@end
