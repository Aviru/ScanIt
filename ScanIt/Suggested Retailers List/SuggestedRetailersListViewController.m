//
//  SuggestedRetailersListViewController.m
//  ScanIt
//
//  Created by Aviru bhattacharjee on 08/03/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import "SuggestedRetailersListViewController.h"
#import "SuggestedRetailersTableViewCell.h"
#import "SuggestedRetailerDetailsViewController.h"

@interface SuggestedRetailersListViewController ()<CLLocationManagerDelegate>
{
    SuggestedRetailersTableViewCell *cell;
    NSMutableArray *arrRetailersList;
    int selectedRow;
    BOOL didFindLocation;
}

///****LOCATION
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation SuggestedRetailersListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLLocationAccuracyHundredMeters;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.locationManager stopUpdatingLocation];
}

#pragma mark -  CLLocation AuthorizationStatus Delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
       
        NSLog(@"status:%d",status);
        
        [manager startUpdatingLocation];
    }
    else if (status == kCLAuthorizationStatusDenied)
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"This app needs you to authorize locations services to work."
                                      message:@"You can enable access in Settings->Privacy->Location->Location Services"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        
                                        [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
                                    }];
        
        
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }
    else
        NSLog(@"Wrong location status");
}

#pragma mark

#pragma mark - CLLocation Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation * currentLocation = [locations lastObject];
    NSString * latitude = [NSString stringWithFormat:@"%.6f", currentLocation.coordinate.latitude];
    NSString * longitude = [NSString stringWithFormat:@"%.6f", currentLocation.coordinate.longitude];
    
    NSLog(@"**latitude***:%@\n****longitude****:%@",latitude,longitude);
    
     NSMutableDictionary *retailerDict = [[NSMutableDictionary alloc]init];
    
    [retailerDict setObject:_productName forKey:@"keywords"];
    [retailerDict setObject:latitude forKey:@"latitude"];
    [retailerDict setObject:longitude forKey:@"longitude"];
    
    if (!didFindLocation)
    {
        didFindLocation = YES;
        [self.locationManager stopUpdatingLocation];
        
        [self getSuggestedRetailersList:retailerDict];
    }

    
}

#pragma mark

-(void)getSuggestedRetailersList:(NSMutableDictionary *)retailDict
{
    [superViewController startActivity:self.view];
    
    NSError *error=nil;
    NSData *jsonRequestDict= [NSJSONSerialization dataWithJSONObject:retailDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *URL=[BASEURL_FOR_SUGGESTEDRETAIL_AND_PURCHASELIST stringByAppendingString:SUGGESTEDRETAILERS];
    
    NSLog(@"Suggested_Retailers_Url:%@",URL);
    
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
        
        /*Response Dictionary:: {
         message = "Result get successfully.";
         response =     {
         "Suggested_Retail" =         (
         {
         "shop_address" = "6 Madan Street, Behind Chandni Chowk Metro Station, Kolkata - 700072";
         "shop_category" = "Electronics Store";
         "shop_name" = "Aroras DP Electronics";
         "shop_phone_number" = 919831208999;
         "shop_timings" = "9:00am to 10:00pm";
         website = "";
         },
         {
         "shop_address" = "42A Shakespeare Sarani, Roudon Street, Kolkata, 700017";
         "shop_category" = Electronics;
         "shop_name" = "Bhajanlal Stores";
         "shop_phone_number" = 913322831570;
         "shop_timings" = "10:00am to 10:00pm";
         website = "https://www.bhajanlal.net";
         }
         );
         };
         status = 1;
         }         */
        
        if ([[jsonResponseDict objectForKey:@"status"] integerValue]==1)
        {
            arrRetailersList = [[NSMutableArray alloc]init];
            
            if ([jsonResponseDict [@"response"][@"Suggested_Retail"] count] > 0)
            {
                arrRetailersList =  [jsonResponseDict [@"response"][@"Suggested_Retail"] mutableCopy];
                [_retailersListTableVw reloadData];
            }
           else
              _lblMeesage.hidden = NO;
           
        }
        
        else
        {            
             _lblMeesage.hidden = NO;
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

#pragma mark - Table View Delegates and Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (arrRetailersList.count > 0)
    {
        _retailersListTableVw.hidden = NO;
        _lblMeesage.hidden = YES;
    }
    else
    {
        _retailersListTableVw.hidden = YES;
    }
    return arrRetailersList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"retailersCell";
    
        cell = (SuggestedRetailersTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        cell.lblShopName.text = [[arrRetailersList objectAtIndex:indexPath.row] objectForKey:@"shop_name"];
        cell.lblShopAddress.text = [[arrRetailersList objectAtIndex:indexPath.row] objectForKey:@"shop_address"];
        
        if ([[[arrRetailersList objectAtIndex:indexPath.row] objectForKey:@"shop_type"] isEqualToString:@"Premium"] || [[[arrRetailersList objectAtIndex:indexPath.row] objectForKey:@"shop_type"] isEqualToString:@"Classic"]) {
            
            cell.lblShopType.text = [[arrRetailersList objectAtIndex:indexPath.row] objectForKey:@"shop_type"];
        }
        else
            cell.lblShopType.text = @"";
        
        if ([[[arrRetailersList objectAtIndex:indexPath.row] objectForKey:@"shop_offer"]length] > 0) {
            
            cell.offersImgVwIcon.hidden = NO;
        }
        else
            cell.offersImgVwIcon.hidden = YES;
        
        cell.lblPhoneNumber.text = [@"Call: " stringByAppendingString:[[arrRetailersList objectAtIndex:indexPath.row] objectForKey:@"shop_phone_number"]];
        
        [cell.callUsBtnOutlet addTarget:self action:@selector(callUsBtnTap:)  forControlEvents:UIControlEventTouchUpInside];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
  
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedRow = (int)indexPath.row;
    
    [self performSegueWithIdentifier:@"showSuggestedRetailerDetailsFromSuggestedRetailers" sender:nil];
}

#pragma mark

#pragma mark - Prepare For Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showSuggestedRetailerDetailsFromSuggestedRetailers"])
    {
        SuggestedRetailerDetailsViewController* suggestedRetailerDetailsVC = [segue destinationViewController];
        NSMutableDictionary *dict = [arrRetailersList objectAtIndex:selectedRow];
        suggestedRetailerDetailsVC.arrSuggestedRetailerDetails = [[NSMutableArray alloc]init];
        [suggestedRetailerDetailsVC.arrSuggestedRetailerDetails addObject: dict];
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

#pragma mark - Button Action

-(void)callUsBtnTap:(UIButton *)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.retailersListTableVw];
    NSIndexPath *indx = [_retailersListTableVw indexPathForRowAtPoint:buttonPosition];
    
    NSLog(@"indx.row:%ld",(long)indx.row);
    
    NSURL *phoneUrl = [NSURL URLWithString:[@"tel://" stringByAppendingString:[[arrRetailersList objectAtIndex:indx.row] objectForKey:@"shop_phone_number"]]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        UIAlertView *calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [calert show];
    }
}

- (IBAction)backToProductOptionsAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
