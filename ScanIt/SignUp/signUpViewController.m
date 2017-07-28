//
//  signUpViewController.m
//  ScanIt
//
//  Created by Aviru bhattacharjee on 24/02/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import "signUpViewController.h"
#import "SignUpTableViewCell.h"

@interface signUpViewController ()<UITextFieldDelegate>
{
    NSString *firstName;
    NSString *lastName;
    NSString *password;
    NSString *strEmail, *strPhone;
    BOOL isValidfirstName,isValidLastName,isValidPassword,isValidEmail,isValidConfirmPassword,whiteSpaceChracter,isValidPhoneNumber,isViewUp;
    CGFloat prevYAxisValue;
    UIToolbar *toolBar,*toolbarText;
    UITextField *globalTextField;
    
    NSMutableArray *arrPlaceHolderValues, *arrCellIcon;
    
    IBOutlet UITableView *tblSignUp;
    
}

@end

@implementation signUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    arrPlaceHolderValues = [[NSMutableArray alloc] initWithObjects:@"First Name",@"Last Name",@"Email",@"Phone",@"Password",@"Confirm Password", nil];
    
    arrCellIcon = [[NSMutableArray alloc]initWithObjects:@"user_gray_icon.png",@"user_gray_icon.png",@"email_gray_icon.png",@"phone_gray_icon.png",@"Key Icon.png",@"Key Icon.png", nil];
    
    toolBar = [[UIToolbar alloc] init];
    [toolBar sizeToFit];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(doneClicked:)];
    [toolBar setItems:[NSArray arrayWithObjects:doneButton, nil]];
    
    firstName = @"";
    lastName = @"";
    password = @"";
    strEmail = @"";
    strPhone = @"";
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /*
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
     */

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    if (isViewUp)
    {
        [self viewDown];
    }
}

#pragma mark - Table view data source And Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return arrPlaceHolderValues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"signUpCell";
    
    SignUpTableViewCell *cell = (SignUpTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell.txtSignup.placeholder = arrPlaceHolderValues[indexPath.row];
    cell.txtSignup.tag = indexPath.row;
    cell.imgViewIcon.image = [UIImage imageNamed:arrCellIcon[indexPath.row]];
    
    if (indexPath.row == 0 || indexPath.row == 1)
    {
        cell.txtSignup.autocapitalizationType = UITextAutocapitalizationTypeWords;
    }
    else
      cell.txtSignup.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    if (indexPath.row == 2)
    {
        cell.txtSignup.keyboardType = UIKeyboardTypeEmailAddress;
    }
    else
        cell.txtSignup.keyboardType = UIKeyboardTypeDefault;
    
    if (indexPath.row == 3)
    {
        cell.txtSignup.keyboardType = UIKeyboardTypePhonePad;
        cell.txtSignup.inputAccessoryView = toolBar;
    }
    
    if (indexPath.row == 4 || indexPath.row == 5)
    {
        cell.txtSignup.secureTextEntry = YES;
    }
    else
      cell.txtSignup.secureTextEntry = NO;
    
    cell.txtSignup.delegate = self;
    [cell.txtSignup addTarget:self
                             action:@selector(textFieldDidChange:)
                   forControlEvents:UIControlEventEditingChanged];
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - TextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (isViewUp)
    {
        [self viewDown];
    }
    
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    globalTextField = textField;
    
    if (textField.tag == 3 || textField.tag == 4 || textField.tag == 5) {
        
        if (isViewUp) {
            
        }
        else
            [self viewUp];
    }
    
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.tag == 0)
    {
        NSString *rawString = [textField text];
        NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        firstName = [rawString stringByTrimmingCharactersInSet:whitespace];
        
        if (firstName.length>0)
        {
            isValidfirstName=YES;
            [arrPlaceHolderValues removeObjectAtIndex:textField.tag];
            [arrPlaceHolderValues insertObject:firstName atIndex:textField.tag];
        }
        else
        {
            isValidfirstName=NO;
            [arrPlaceHolderValues removeObjectAtIndex:textField.tag];
            [arrPlaceHolderValues insertObject:@"First Name" atIndex:textField.tag];
        }
        
    }
    
    if (textField.tag == 1)
    {
        NSString *rawString = [textField text];
        NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        lastName = [rawString stringByTrimmingCharactersInSet:whitespace];
        
        if (lastName.length>0)
        {
            isValidLastName=YES;
            [arrPlaceHolderValues removeObjectAtIndex:textField.tag];
            [arrPlaceHolderValues insertObject:lastName atIndex:textField.tag];
        }
        else
        {
            isValidLastName=NO;
            [arrPlaceHolderValues removeObjectAtIndex:textField.tag];
            [arrPlaceHolderValues insertObject:@"Last Name" atIndex:textField.tag];
        }
        
    }
    
    if (textField.tag == 2) //***Email
    {
        strEmail=[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if(strEmail.length > 0)
        {
            isValidEmail = [self validateEmail:textField.text];
            [arrPlaceHolderValues removeObjectAtIndex:textField.tag];
            [arrPlaceHolderValues insertObject:strEmail atIndex:textField.tag];
        }
        
        else
        {
            isValidEmail = NO;
            [arrPlaceHolderValues removeObjectAtIndex:textField.tag];
            [arrPlaceHolderValues insertObject:@"Email" atIndex:textField.tag];
        }
    }
    
    if (textField.tag == 3)
    {
        strPhone=[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([strPhone length]>0)
        {
            
            [arrPlaceHolderValues removeObjectAtIndex:textField.tag];
            [arrPlaceHolderValues insertObject:strPhone atIndex:textField.tag];
            
//            if([textField.text length] == 10)
//            {
//                isValidPhoneNumber = YES;
//            }
//            else
//                isValidPhoneNumber = NO;
            
        }
        else
        {
            [arrPlaceHolderValues removeObjectAtIndex:textField.tag];
            [arrPlaceHolderValues insertObject:@"Phone" atIndex:textField.tag];
        }
           // isValidPhoneNumber = NO;
    }
    
    if (textField.tag == 4) //***Password
    {
        NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
        
        if ([textField.text length]>0)
        {
            
            if([textField.text length] >= 6)
            {
                whiteSpaceChracter = NO;
                
                for (int i = 0; i < [textField.text length]; i++)
                {
                    unichar c = [textField.text characterAtIndex:i];
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
                    password = textField.text;
                    isValidPassword = YES;
                }
                
            }
            else
            {
                isValidPassword = NO;
            }
            
            [arrPlaceHolderValues removeObjectAtIndex:textField.tag];
            [arrPlaceHolderValues insertObject:textField.text atIndex:textField.tag];
            
        }
        else
        {
            isValidPassword=NO;
            [arrPlaceHolderValues removeObjectAtIndex:textField.tag];
            [arrPlaceHolderValues insertObject:@"Password" atIndex:textField.tag];
        }
        
    }
    
    if (textField.tag == 5) //***Confirm Password
    {
        if ([textField.text length]>0)
        {
            if ([password isEqualToString: textField.text])
            {
                isValidConfirmPassword = YES;
                [arrPlaceHolderValues removeObjectAtIndex:textField.tag];
                [arrPlaceHolderValues insertObject:textField.text atIndex:textField.tag];
            }
            
            else
            {
                isValidConfirmPassword = NO;
                [arrPlaceHolderValues removeObjectAtIndex:textField.tag];
                [arrPlaceHolderValues insertObject:@"Confirm Password" atIndex:textField.tag];
            }
            
        }
    }
    
      NSLog(@"PlaceHolder Array:%@",arrPlaceHolderValues);

}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    /*
    if (textField==_txtPassword)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y + 70), self.view.frame.size.width, self.view.frame.size.height);
        prevYAxisValue = self.view.frame.origin.y;
        [UIView commitAnimations];
        

    }
    
    if (textField==_txtConfirmPassword)
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
    */
    
}

-(void)viewUp
{
    if (IS_IPHONE_4) {
        
        [UIView animateWithDuration:0.5 animations:^{
            self.view.frame=CGRectMake(self.view.frame.origin.x,-130, self.view.frame.size.width, self.view.frame.size.height);
            isViewUp=YES;
        }];
    }
    else
        [UIView animateWithDuration:0.5 animations:^{
            self.view.frame=CGRectMake(self.view.frame.origin.x,-110, self.view.frame.size.width, self.view.frame.size.height);
            isViewUp=YES;
        }];
    
}

-(void)viewDown
{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        isViewUp=NO;
    }];
}

#pragma mark

#pragma mark - Touches Event

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark

#pragma mark
#pragma mark - Toolbar Done Button Action
#pragma mark

- (IBAction)doneClicked:(id)sender
{
    NSLog(@"Done Clicked.");
    
    if (isViewUp)
    {
        [self viewDown];
    }
    
    [self.view endEditing:YES];
}

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
            
            [regDict setObject:firstName forKey:FIRSTNAME];
            [regDict setObject:lastName forKey:LASTNAME];
            [regDict setObject:password forKey:PASSWORD];
            [regDict setObject:strEmail forKey:EMAIL];
            [regDict setObject:strPhone forKey:PHONENUMBER];
            
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
            
            [self setUserDefaultValue:[jsonResponseDict objectForKey:USERID] ForKey:USERID];
            
            [self setUserDefaultValue:jsonResponseDict [FIRSTNAME] ForKey:FIRSTNAME];
            [self setUserDefaultValue:jsonResponseDict [LASTNAME] ForKey:LASTNAME];
            [self setUserDefaultValue:jsonResponseDict [EMAIL] ForKey:EMAIL];
            [self setUserDefaultValue:jsonResponseDict [PHONENUMBER] ForKey:PHONENUMBER];
            
            [self setUserDefaultValue:@"" ForKey:PROFILEIMAGE];
            
            [self addDeviceToken];
            
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

#pragma mark - Add Device token

-(void)addDeviceToken
{
    NSMutableDictionary *devideTokenDict = [[NSMutableDictionary alloc] init];
    
    NSLog(@"USER ID:%@",USERID);

    
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
        
        [superViewController stopActivity:self.view];
        
        [self setUserDefaultValue:@"YES" ForKey:ISLOGGEDIN];
        
        [self performSegueWithIdentifier:@"showRevealViewFromSignUp" sender:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request Error: %@", error);
        [superViewController stopActivity:self.view];
    }];
}

#pragma mark

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
