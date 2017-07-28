//
//  LikesViewController.m
//  ScanIt
//
//  Created by Aviru bhattacharjee on 03/03/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import "LikesViewController.h"
#import "LikesTableViewCell.h"
#import "ProductOptionsViewController.h"

#define kAlbumName @"ScanIt"

@interface LikesViewController ()
{
    NSManagedObject *productDetailsObj;
    NSMutableArray *arrProductDetails;
    LikesTableViewCell *cell;
    AppDelegate *appDelegate;
    __block NSMutableArray *imgArr;
    NSUInteger count;
}

@end

@implementation LikesViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.clearAllBtnOutlet.layer.cornerRadius = 3.0f;
    
    [_leftPannelBtnOutlet addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [superViewController startActivity:self.view];
    
    [self callLikeList];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Like list web service
-(void)callLikeList
{
    NSError *error=nil;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"yes" forKey:@"like"];
    [dict setObject:[self getUserDefaultValueForKey:USERID] forKey:USERID]; //@"13"
    
    NSData *jsonRequestDict= [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonCommand=[[NSString alloc] initWithData:jsonRequestDict encoding:NSUTF8StringEncoding];
    NSLog(@"***jsonCommand***%@",jsonCommand);
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:jsonCommand,@"requestParam", nil];
    
    NSString *URL=[BASEURL_FOR_SUGGESTEDRETAIL_AND_PURCHASELIST stringByAppendingString:GET_HISTORY_OR_LIKE];
    NSLog(@"GET_HISTORY_Url:%@",URL);
    
    
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
            //arrProductDetails= [[NSMutableArray alloc]init];
            
            if ([jsonResponseDict[@"historylist"] count]>0)
            {
                NSMutableArray *arr = [jsonResponseDict[@"historylist"]mutableCopy];
                
                arrProductDetails = arr;   //[[[arr reverseObjectEnumerator] allObjects] mutableCopy];
                
                [_likeTableView reloadData];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"No History Listing Found!"
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
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


#pragma mark - Table view data source And Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (arrProductDetails.count > 0)
    {
        _lblMessage.hidden = YES;
        _likeView.hidden = NO;
    }
    else
    {
        _lblMessage.hidden = NO;
        _likeView.hidden = YES;
    }
    return arrProductDetails.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"likeCell";
    
    cell = (LikesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell.lblLikedProductName.text = [[arrProductDetails objectAtIndex:indexPath.row] objectForKey:@"product_keywords"];
    
    if ([[[arrProductDetails objectAtIndex:indexPath.row] objectForKey:@"ProductImage"] isEqualToString:@""])
    {
        [cell.likedProductImgVw setImage:[UIImage imageNamed:@"no_image_product.jpg"]];
    }
    else
    {
        [cell.likedProductImgVw setImage:[UIImage imageNamed:@"no_image_product.jpg"]];
        
        NSURL *url = [NSURL URLWithString:[[arrProductDetails objectAtIndex:indexPath.row] objectForKey:@"ProductImage"]];
        [cell.likedProductImgVw sd_setImageWithURL:url
                                  placeholderImage:[UIImage imageNamed:@"no_image_product.jpg"]
                                           options:SDWebImageRefreshCached];
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    appDelegate.isFromLikePage = YES;
    appDelegate.isFromHistoryPage = NO;
    
    //Calling storyboard scene programmatically (without needing segue)
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProductOptionsViewController *productVC = (ProductOptionsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ProductOptionsViewController"];
    
    productVC.productImageUrl = [[arrProductDetails objectAtIndex:indexPath.row] objectForKey:@"ProductImage"];
    productVC.productName = [[arrProductDetails objectAtIndex:indexPath.row] objectForKey:@"product_keywords"];
    productVC.isProductLiked = YES;
    
    [self.navigationController pushViewController:productVC animated:YES];
}

#pragma mark

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Button Action

- (IBAction)clearAllAction:(id)sender
{
    [arrProductDetails removeAllObjects];
    [_likeTableView reloadData];
}
@end
