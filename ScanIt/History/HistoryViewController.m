//
//  HistoryViewController.m
//  ScanIt
//
//  Created by Aviru bhattacharjee on 03/03/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryTableViewCell.h"
#import "ProductOptionsViewController.h"

#define kAlbumName @"ScanIt"

@interface HistoryViewController ()
{
    NSManagedObject *productDetailsObj;
    NSMutableArray *arrProductDetails;
    HistoryTableViewCell *cell;
    AppDelegate *appDelegate;
    __block NSMutableArray *imgArr;
    NSUInteger count;
    int i;
}

@end

@implementation HistoryViewController

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
    self.clearAllBtnOutletr.layer.cornerRadius = 3.0f;
    
    [_leftPannelBtnOutlet addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    imgArr = [[NSMutableArray alloc]init];
    
    // Fetch the Product Details from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"ProductDetails"];
    arrProductDetails = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    count = arrProductDetails.count;
    NSLog(@"arrProductDetails:%@",arrProductDetails);
    
//    if (arrProductDetails.count > 0)
//    {
//        _lblMessage.hidden = YES;
//        _historyTableContainingView.hidden = NO;
//    }
//    else
//    {
//        _lblMessage.hidden = NO;
//        _historyTableContainingView.hidden = YES;
//    }
    
    [superViewController startActivity:self.view];
    
    i=0;
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    // Load Albums into assetGroups
    
    // Group enumerator Block
    void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) //ALAssetsGroup *group
    {
        if (group == nil)
        {
            return;
        }
        
        if([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:kAlbumName])
        {
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop)
             {
                 
                 while (i<count)
                 {
                     
                     productDetailsObj = [arrProductDetails objectAtIndex:i];
                     
                     ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                     {
                         CGImageRef iref = [myasset thumbnail];
                         // CGImageRef iref = [rep fullResolutionImage];
                         
                         if (iref)
                         {
                             UIImage *image = [UIImage imageWithCGImage:iref scale:1.0f orientation:UIImageOrientationUp];
                             [imgArr addObject:image];
                             [superViewController stopActivity:self.view];
                             [self.historyTableVw reloadData];
                         }
                         else
                         {
                             NSLog(@"NO photo");
                             UIImage *noImage =[UIImage imageNamed:@"no_image_product.jpg"];
                             //cell.productImgVw.image =[UIImage imageWithData:UIImageJPEGRepresentation(noImage, .6)];
                             [imgArr addObject:[UIImage imageWithData:UIImageJPEGRepresentation(noImage, .6)]];
                             [superViewController stopActivity:self.view];
                             [self.historyTableVw reloadData];
                         }
                         
                     };
                     
                     ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
                     {
                         NSLog(@"Can't get image - %@",[myerror localizedDescription]);
                         
                         cell.productImgVw.image =[UIImage imageNamed:@"no_image_product.jpg"];
                     };
                     
                     NSURL *asseturl = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [productDetailsObj valueForKey:@"imageUrl"]]];
                     
                     ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                     [assetslibrary assetForURL:asseturl
                                    resultBlock:resultblock
                                   failureBlock:failureblock];
                     
                     i++;
                 }
                 
                 [superViewController stopActivity:self.view];
                 
//                 else
//                 {
//                    [superViewController stopActivity:self.view];
//                    return;
//                 }
                 
                 
             }];
            
            return;
            
        }
    };
    
    // Group Enumerator Failure Block
    void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Album Error: %@ - %@", [error localizedDescription], [error localizedRecoverySuggestion]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
        NSLog(@"A problem occured %@", [error description]);
    };
    
    // Enumerate Albums
    [library enumerateGroupsWithTypes:ALAssetsGroupAll
                           usingBlock:assetGroupEnumerator
                         failureBlock:assetGroupEnumberatorFailure];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source And Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (arrProductDetails.count > 0) //arrProductDetails
    {
        _lblMessage.hidden = YES;
        _historyTableContainingView.hidden = NO;
    }
    else
    {
        _lblMessage.hidden = NO;
        _historyTableContainingView.hidden = YES;
    }
    return arrProductDetails.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Historycell";
    
        cell = (HistoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    productDetailsObj = [arrProductDetails objectAtIndex:indexPath.row];
    
    cell.lblProductName.text = [NSString stringWithFormat:@"%@", [productDetailsObj valueForKey:@"productName"]];
    
    if (imgArr.count > indexPath.row)
    {
        [cell.productImgVw setImage:[imgArr objectAtIndex:indexPath.row]];
    }
    else
      [cell.productImgVw setImage:[UIImage imageNamed:@"no_image_product.jpg"]];

    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    appDelegate.isFromHistoryPage = YES;
    appDelegate.isFromLikePage = NO;
    
    //Calling storyboard scene programmatically (without needing segue)
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProductOptionsViewController *productVC = (ProductOptionsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ProductOptionsViewController"];
    
    productDetailsObj = [arrProductDetails objectAtIndex:indexPath.row];
    productVC.productImageUrl = [productDetailsObj valueForKey:@"imageUrl"];
    productVC.productName = [productDetailsObj valueForKey:@"productName"];
    productVC.queryTokenForSelectedProduct = [productDetailsObj valueForKey:@"queryToken"];
    
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


- (IBAction)clearAllAction:(id)sender
{
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
        
        [arrProductDetails removeAllObjects];
        [_historyTableVw reloadData];
    }
    
}
@end
