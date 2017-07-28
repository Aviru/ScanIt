//
//  WhtasNewViewController.m
//  ScanIt
//
//  Created by Aviru bhattacharjee on 26/11/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import "WhatsNewViewController.h"
#import "WhatsNewTableViewCell.h"
#import "ProductOptionsViewController.h"


@interface WhatsNewViewController()<UITableViewDelegate,UITableViewDataSource>
{
    
    IBOutlet UIButton *btnMenuOutlet;
    
    IBOutlet UILabel *lblMessage;
    
    IBOutlet UIView *VwWhatsNewTableContainer;
    
    IBOutlet UITableView *tableWhatsNew;
    
    NSMutableArray *arrWhatsNew;
     AppDelegate *appDelegate;
    
}

@end

@implementation WhatsNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [btnMenuOutlet addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    [superViewController startActivity:self.view];
    
    [self getWhatsNew];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source And Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return arrWhatsNew.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"WhatsNewCell";
    
    WhatsNewTableViewCell *cell = (WhatsNewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell.lblProductCategoryName.text = [[arrWhatsNew objectAtIndex:indexPath.row] objectForKey:@"product_keyword"];
    
    cell.lblDate.text = [self convertDateFormat:[[arrWhatsNew objectAtIndex:indexPath.row] objectForKey:@"AddDate"]];
    
    [cell.imgVwProduct setImage:[UIImage imageNamed:@"no_image_product.jpg"]];
    
    NSURL *url = [NSURL URLWithString:[[arrWhatsNew objectAtIndex:indexPath.row] objectForKey:@"ProductImage"]];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data scale:0.5];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    WhatsNewTableViewCell *myCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                    if (myCell)
                    {
                        cell.imgVwProduct.image = image;
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
    appDelegate.isFromHistoryPage = NO;
    appDelegate.isFromLikePage = NO;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProductOptionsViewController *productVC = (ProductOptionsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ProductOptionsViewController"];
    
    productVC.productImageUrl = [[arrWhatsNew objectAtIndex:indexPath.row] objectForKey:@"ProductImage"];
    productVC.productName = [[arrWhatsNew objectAtIndex:indexPath.row] objectForKey:@"product_keyword"];
    productVC.isFromWhatsNewPage = YES;
    
    [self.navigationController pushViewController:productVC animated:YES];
}

#pragma mark

#pragma mark - Web Service

-(void)getWhatsNew
{
    NSMutableDictionary *whatsNewDict = [[NSMutableDictionary alloc]init];
    
    [whatsNewDict setObject:@"newproductlist" forKey:@"show"];
    
    NSError *error=nil;
    NSData *jsonRequestDict= [NSJSONSerialization dataWithJSONObject:whatsNewDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *URL=[BASEURL_FOR_SUGGESTEDRETAIL_AND_PURCHASELIST stringByAppendingString:WHATSNEW];
    
    NSLog(@"WHATSNEW_Url:%@",URL);
    
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
            if ([jsonResponseDict[@"newproductlist"] count] > 0)
            {
                arrWhatsNew = [[NSMutableArray alloc]init];
                arrWhatsNew =  [jsonResponseDict [@"newproductlist"] mutableCopy];
                lblMessage.hidden = YES;
                [tableWhatsNew reloadData];
            }
            else
            {
                lblMessage.hidden = NO;
            }
        }
        
        else
        {
            lblMessage.hidden = NO;
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
