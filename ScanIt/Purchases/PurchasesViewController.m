//
//  PurchasesViewController.m
//  ScanIt
//
//  Created by Aviru bhattacharjee on 03/03/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import "PurchasesViewController.h"
#import "PurchaseTableViewCell.h"
#import "PurchaseDetailsViewController.h"

@interface PurchasesViewController ()
{
    PurchaseTableViewCell *cell;
    NSMutableArray *arrPurchaseHistory;
    int selectedRow;
}

@end

@implementation PurchasesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_leftPannelBtnOutlet addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
   // [superViewController startActivity:self.view];
    
   // [self getPurchaseHistory];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if (arrPurchaseHistory.count > 0)
    {
        _lblMessage.hidden = YES;
        _purchaseTableView.hidden = NO;
    }
    else
    {
        _lblMessage.hidden = NO;
        _purchaseTableView.hidden = YES;
    }

    
    return arrPurchaseHistory.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"purchaseCell";
    cell = (PurchaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell.lblProductName.text = [[arrPurchaseHistory objectAtIndex:indexPath.row] objectForKey:@"product_name"];
    cell.lblProductInvoice.text = [[arrPurchaseHistory objectAtIndex:indexPath.row] objectForKey:@"invoice_number"];
    
    NSURL *url = [NSURL URLWithString:[[arrPurchaseHistory objectAtIndex:indexPath.row] objectForKey:PROFILEIMAGE]];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data scale:0.5];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    PurchaseTableViewCell *myCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                    if (myCell)
                    {
                        cell.scanItImgVw.image = image;
                    }
                });
            }
        }
    }];
    [task resume];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedRow = (int)indexPath.row;
    
    [self performSegueWithIdentifier:@"showPurchaseDetailsFromPurchases" sender:nil];
}

#pragma mark

#pragma mark - Prepare For Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showPurchaseDetailsFromPurchases"])
    {
        PurchaseDetailsViewController* purchaseDetailsVC = [segue destinationViewController];
        NSMutableDictionary *dict = [arrPurchaseHistory objectAtIndex:selectedRow];
        purchaseDetailsVC.arrPurchaseHistoryDetails = [[NSMutableArray alloc]init];
        [purchaseDetailsVC.arrPurchaseHistoryDetails addObject: dict];
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Web Service

-(void)getPurchaseHistory
{
    NSMutableDictionary *purchaseDict = [[NSMutableDictionary alloc]initWithObjects:@[[self getUserDefaultValueForKey:USERID]] forKeys:@[USERID]];
    
    NSError *error=nil;
    NSData *jsonRequestDict= [NSJSONSerialization dataWithJSONObject:purchaseDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *URL=[BASEURL_FOR_SUGGESTEDRETAIL_AND_PURCHASELIST stringByAppendingString:PURCHASELIST];
    
    NSLog(@"PURCHASELIST_Url:%@",URL);
    
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
         ContactNo = 8961390612;
         Email = "aviru.bhattacharjee@gmail.com";
         FirstName = aviru;
         LastName = bhattacharjee;
         UserID = 20;
         message = "Registration successful.";
         status = 1;
         }
         */
        
        if ([[jsonResponseDict objectForKey:@"status"] integerValue]==1)
        {
            
            
            if ([jsonResponseDict [@"response"][@"purchase_list"] count] > 0)
            {
                arrPurchaseHistory = [[NSMutableArray alloc]init];
                arrPurchaseHistory =  [jsonResponseDict [@"response"][@"purchase_list"] mutableCopy];
                [_purchaseTableView reloadData];
            }
            else
                _lblMessage.hidden = NO;
            
        }
        
        else
        {
            _lblMessage.hidden = NO;
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
