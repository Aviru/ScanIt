//
//  LeftPannelViewController.m
//  ScanIt
//
//  Created by Aviru bhattacharjee on 02/03/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import "LeftPannelViewController.h"
#import "LeftPannelTableViewCell.h"

@interface LeftPannelViewController ()
{
     NSArray *menuItems;
}

@end

@implementation LeftPannelViewController

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.hidesBackButton = YES;
    
    menuItems = @[@"HomeCell", @"AccountCell", @"HistoryCell", @"LikeCell", @"PurchaseCell", @"RateUsCell", @"LogOutCell"];

    [_leftPannelTableVw selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:0];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([[self getUserDefaultValueForKey:PROFILEIMAGE] length] != 0)
    {
        _profileImgVw.layer.cornerRadius = _profileImgVw.frame.size.width / 2;
        _profileImgVw.layer.masksToBounds = YES;
        _profileImgVw.image = [UIImage imageWithData:[self getUserDefaultValueForKey:PROFILEIMAGE]];
    }
    else
    {
        _profileImgVw.image = [UIImage imageNamed:@"profile_pic.png"];
    }

    NSString *fName =[NSString stringWithFormat:@"%@",[self getUserDefaultValueForKey:FIRSTNAME]];
    
    _lblUserName.text = [[fName stringByAppendingString:@" "] stringByAppendingString:[NSString stringWithFormat:@"%@",[self getUserDefaultValueForKey:LASTNAME]]];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    LeftPannelTableViewCell *cell = (LeftPannelTableViewCell *) [_leftPannelTableVw dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 6)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Do you want to logout?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        
        [alert show];
    
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self logoutWebServiceMeth];
    }
}

-(void)logoutWebServiceMeth
{
    [superViewController startActivity:self.view];
    
    NSError *error = nil;
    
    NSMutableDictionary *logoutDict = [[NSMutableDictionary alloc]init];
    
    [logoutDict setObject:[self getUserDefaultValueForKey:USERID] forKey:USERID];
    [logoutDict setObject:[self getUserDefaultValueForKey:IMEI] forKey:IMEI];
    
    NSString *URL=[BASEURL stringByAppendingString:LOGOUT];
    NSLog(@"Login_Url:%@",URL);
    
    NSData *jsonRequestDict = [NSJSONSerialization dataWithJSONObject:logoutDict options:NSJSONWritingPrettyPrinted error:&error];
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
        
        
        if ([[jsonResponseDict objectForKey:@"status"] integerValue]==1)
        {
            NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
            [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
            
             [self setUserDefaultValue:@"NO" ForKey:ISLOGGEDIN];
            
            if ([FBSDKAccessToken currentAccessToken])
            {
                FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
                [login logOut];
            }
            
            
            ////******CLEAR DATABASE ON LOGOUT********////
            
            
            NSFetchRequest *allProductsFetchRequest = [[NSFetchRequest alloc] init];
            NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
            [allProductsFetchRequest setEntity:[NSEntityDescription entityForName:@"ProductDetails" inManagedObjectContext:managedObjectContext]];
            [allProductsFetchRequest setIncludesPropertyValues:NO]; //only fetch the managedObjectID
            
            NSError *error = nil;
            NSArray *products;
            
            if (![managedObjectContext executeFetchRequest:allProductsFetchRequest error:&error]) {
                NSLog(@"Can't Fetch! %@ %@", error, [error localizedDescription]);
            }
            else
            {
                products = [managedObjectContext executeFetchRequest:allProductsFetchRequest error:&error];
            }
            
            //error handling goes here
            for (NSManagedObject *product in products) {
                [managedObjectContext deleteObject:product];
            }
            
            NSError *saveError = nil;
            // Save the object to persistent store
            if (![managedObjectContext save:&saveError]) {
                NSLog(@"Can't delete object! %@ %@", saveError, [saveError localizedDescription]);
            }
            else
            {
                NSLog(@"deleted object from database  successfully");

            }
            
            
            
            [self performSegueWithIdentifier:@"showFirstViewFromLeftPannel" sender:nil];
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Some error occured during Logout"
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
