//
//  homeViewController.m
//  ScanIt
//
//  Created by Aviru bhattacharjee on 24/02/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()
{
    NSMutableDictionary *loginDict;
    
    
}

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.signInBtnOtlet.layer.cornerRadius = 3.0f;
    
    self.signUpBtnOutlet.layer.cornerRadius = 3.0f;
    
    self.fbLoginBtnOutlet.layer.cornerRadius = 3.0f;
    
    self.loginAsGuestBtnOutlet.layer.cornerRadius = 3.0f;
    
    if ([FBSDKAccessToken currentAccessToken]) {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logOut];
    }
  
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
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
#pragma mark - Login with Facebook

- (IBAction)fbLoginAction:(id)sender
{
    [superViewController startActivity:self.view];
    
    if ([FBSDKAccessToken currentAccessToken])
    {
        [FBSDKAccessToken setCurrentAccessToken:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:FBSDKAccessTokenDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:FBSDKProfileDidChangeNotification object:nil];
        
        [superViewController stopActivity:self.view];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeTokenChange:) name:FBSDKAccessTokenDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeProfileChange:) name:FBSDKProfileDidChangeNotification object:nil];
        
        NSArray *requiredPermissions = @[@"email", @"user_friends"];
        
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions:requiredPermissions
                                handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                    if (error)
                                    {
                                        // Process error
                                        [self RemoveUserDefaultValueForKey:USERID];
                                        [superViewController stopActivity:self.view];
                                    }
                                    else if (result.isCancelled)
                                    {
                                        // Handle cancellations
                                        [self RemoveUserDefaultValueForKey:USERID];
                                        [superViewController stopActivity:self.view];
                                    }
                                    else
                                    {
                                        // If you ask for multiple permissions at once, you
                                        // should check if specific permissions missing
                                        if ([result.grantedPermissions containsObject:requiredPermissions])
                                        {
                                            // Do work
                                            
                                        }
                                    }
                                }];
    }
}

#pragma mark - Guest Login Button Action

- (IBAction)loginAsGuestAction:(id)sender
{
    [superViewController startActivity:self.view];
   
    loginDict=[[NSMutableDictionary alloc]init];
    
    [loginDict setObject:@"demouser@gmail.com" forKey:UNIQUEUSERID];
    [loginDict setObject:@"N" forKey:REGISTRATIONTYPE];
    [loginDict setObject:@"demouser@gmail.com" forKey:EMAIL];
    [loginDict setObject:@"demo123" forKey:PASSWORD];
    [loginDict setObject:[self getUserDefaultValueForKey:IMEI] forKey:IMEI];
    [loginDict setObject:@"" forKey:FIRSTNAME];
    [loginDict setObject:@"" forKey:LASTNAME];
    [loginDict setObject:@"" forKey:PROFILEIMAGE];
    
    [self LoginDetails:loginDict];
    
}

#pragma mark - Facebook Observations

- (void)observeProfileChange:(NSNotification *)notfication {
    if ([FBSDKProfile currentProfile]) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:FBSDKProfileDidChangeNotification object:nil];
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"picture.type(large), email,first_name,last_name"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"fetched user:%@", result);
                 
                 /*
                  fetched user:{
                  "first_name" = Scanit;
                  id = 246297969047935;
                  "last_name" = App;
                  picture =     {
                  data =         {
                  "is_silhouette" = 0;
                  url = "https://scontent.xx.fbcdn.net/hprofile-xat1/v/t1.0-1/s200x200/11960111_132179747126425_2359551410437321836_n.jpg?oh=831d9ebf2985b719c345db3db23257dc&oe=57646ED7";
                  };
                  };
                  }
                  */
                 
                 loginDict=[[NSMutableDictionary alloc]init];
                 if (result[@"email"] == nil)
                 {
                     [loginDict setObject:@"" forKey:EMAIL];
                 }
                 else
                 {
                     [loginDict setObject:result[@"email"] forKey:EMAIL];
                 }
                 [loginDict setObject:result[@"id"] forKey:UNIQUEUSERID];
                 [loginDict setObject:@"F" forKey:REGISTRATIONTYPE];
                 [loginDict setObject:result[@"first_name"] forKey:FIRSTNAME];
                 [loginDict setObject:result[@"last_name"] forKey:LASTNAME];
                 [loginDict setObject:result[@"picture"][@"data"][@"url"] forKey:PROFILEIMAGE];
                 [loginDict setObject:[self getUserDefaultValueForKey:IMEI] forKey:IMEI];
                 [loginDict setObject:@"" forKey:PASSWORD];

                 
                 [self LoginDetails:loginDict];
                 
             }  else {
                 NSLog(@"FBError: %@",error);
                 [self RemoveUserDefaultValueForKey:USERID];
                 [superViewController stopActivity:self.view];
             }
             
         }];
    }
    
    
}

- (void)observeTokenChange:(NSNotification *)notfication {
    if (![FBSDKAccessToken currentAccessToken]) {
        
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:FBSDKAccessTokenDidChangeNotification object:nil];
        [self observeProfileChange:nil];
    }
}

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
    
    [manager POST:URL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error=nil;
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"Request Successful, response '%@'", responseStr);
        NSMutableDictionary *jsonResponseDict= [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        NSLog(@"Response Dictionary:: %@",jsonResponseDict);
        
        [superViewController stopActivity:self.view];
        
        /* Response Dictionary:: {
         message = "successfully logged in.";
         response =     {
         "user_details" =         {
         Address = "";
         ContactNo = 0;
         Email = "";
         FirstName = Scanit;
         LastName = App;
         ProfileImage = "https://scontent.xx.fbcdn.net/hprofile-xat1/v/t1.0-1/s200x200/11960111_132179747126425_2359551410437321836_n.jpg?oh=831d9ebf2985b719c345db3db23257dc&oe=57646ED7";
         Status = Y;
         UserID = 22;
         deviceToken = N;
         "reg_type" = F;
         "unique_userid" = 1132700696748193;
         };
         };
         status = 1;
         }
         */
        
        
        ///*****RESPONSE FOR DEMO USER*****///
        
        /*
         Response Dictionary:: {
         message = "successfully logged in.";
         response =     {
         "user_details" =         {
         Address = "";
         ContactNo = 1234567890;
         Email = "demouser@gmail.com";
         FirstName = Demo;
         LastName = "";
         ProfileImage = "";
         Status = Y;
         UserID = 137;
         deviceToken = Y;
         "reg_type" = N;
         "unique_userid" = "demouser@gmail.com";
         };
         };
         status = 2;
         }
         */
        
        /////***************************//////
        
        if ([[jsonResponseDict objectForKey:@"status"] integerValue]==1 || [[jsonResponseDict objectForKey:@"status"] integerValue]==2)
        {
            
            if ([jsonResponseDict[@"response"][@"user_details"][REGISTRATIONTYPE] isEqualToString:@"F"])
            {
                [self setUserDefaultValue:@"F" ForKey:REGISTRATIONTYPE];
            }
            if ([jsonResponseDict[@"response"][@"user_details"][REGISTRATIONTYPE] isEqualToString:@"N"])
            {
                if ([jsonResponseDict[@"response"][@"user_details"][FIRSTNAME] isEqualToString:@"Demo"])
                {
                    [self setUserDefaultValue:@"Demo" ForKey:REGISTRATIONTYPE];
                }
                else
                    [self setUserDefaultValue:@"N" ForKey:REGISTRATIONTYPE];
            }
            
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
            
            [self addDeviceToken];
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Please Check the Login Details"
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
        
         if ([FBSDKAccessToken currentAccessToken]) {
             FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
             [login logOut];
         }

         
     }];
}

#pragma mark - Add Device token

-(void)addDeviceToken
{
    NSMutableDictionary *devideTokenDict = [[NSMutableDictionary alloc] init];
    
   // NSLog(@"crash in addDeviceToken in login:%@",USERID);
    
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
        
        [self performSegueWithIdentifier:@"showRevealViewFromFirstView" sender:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request Error: %@", error);
        [superViewController stopActivity:self.view];
    }];
}

@end
