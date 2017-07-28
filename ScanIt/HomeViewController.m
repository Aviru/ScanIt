//
//  HomeViewController.m
//  ScanIt
//
//  Created by Aviru bhattacharjee on 02/03/16.
//  Copyright © 2016 Aviru bhattacharjee. All rights reserved.
//

#import "HomeViewController.h"
#import "ProductOptionsViewController.h"

@interface HomeViewController ()
{
   UIImage *editedImage;
    CGPoint myPoint;
    CLLocation *myLoc;
    NSString *Name;
    NSString *queryToken;
    NSString *imageURL;
    UIImagePickerController *cameraUI;
}

@end

@implementation HomeViewController

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
    
//    self.locationManager = [CLLocationManager new];
//    self.locationManager.delegate = self;
//    self.locationManager.distanceFilter = kCLDistanceFilterNone;
//    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
//    {
//        [self.locationManager requestAlwaysAuthorization];
//    }
    
    [_leftBtnOutlet addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_isImageAvailable)
    {
        _capturedImgVw.image = editedImage;
        _openCameraBtnOutlet.hidden = YES;
        _lblOpenCamera.hidden = YES;
        _capturedImgVw.hidden = NO;
        _lblProcessingImage.hidden = NO;
        
        [self searchWithImage:editedImage];
    }
    
    else
    {
        _openCameraBtnOutlet.hidden = NO;
        _lblOpenCamera.hidden =NO;
        _capturedImgVw.hidden =YES;
        _lblProcessingImage.hidden = YES;
        
        //[self.locationManager startUpdatingLocation];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Determine Current Location
//
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations //***Aviru
//{
//    NSLog(@"lat:%f",manager.location.coordinate.latitude);
//    NSLog(@"long:%f",manager.location.coordinate.longitude);
//    
//    NSLog(@"location.lastobject:%@",[locations lastObject]);
//    myLoc = manager.location;
//    
//    myPoint = CGPointMake(manager.location.coordinate.latitude, manager.location.coordinate.longitude);
//    
//    [self.locationManager stopUpdatingLocation];
//    
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)leftPannelAction:(id)sender
{
    
}

- (IBAction)openCameraAction:(id)sender
{
    
    cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.delegate = self;
    cameraUI.allowsEditing = YES;
    
    if (IS_OS_8_OR_LATER)
    {
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select an option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                                @"Take Photo",
                                @"Choose From Album",
                                nil];
        popup.tag = 1;
        [popup showInView:self.view];
    }
    else if (IS_OS_9_OR_LATER)
    {
        UIAlertController *AlertControllerActionSheet = [UIAlertController alertControllerWithTitle:@"Select an option:" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [AlertControllerActionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            
            // Cancel button tappped do nothing.
            
        }]];
        
        [AlertControllerActionSheet addAction:[UIAlertAction actionWithTitle:@"Take photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            // take photo button tapped.
            [self captureImageFromCamera];
            
        }]];
        
        [AlertControllerActionSheet addAction:[UIAlertAction actionWithTitle:@"Choose From Album" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            // choose photo button tapped.
            [self chooseImageFromAlbum];
            
        }]];
    }
    
}

#pragma mark - Actionsheet Delegate

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        [self captureImageFromCamera];
    }
    else if(buttonIndex==1)
    {
        [self chooseImageFromAlbum];
    }
}

#pragma mark - Capture Image From Camera

-(void)captureImageFromCamera
{
   #if TARGET_IPHONE_SIMULATOR
    // Simulator
    editedImage = [UIImage imageNamed:@"test_img.jpg"];
    [self searchWithImage:editedImage];
   #else
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront] || [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear])
            
        {
            cameraUI.sourceType=UIImagePickerControllerSourceTypeCamera;
        }
        [self presentViewController:cameraUI animated:YES completion:NULL];
        
    }
    
    else
    {
        UIAlertView *a =[[UIAlertView alloc]initWithTitle:nil message:@"No camera Found" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil] ;
        [a show];
    }
    
   #endif
    
}

#pragma mark

#pragma mark -Choose Image From Album

-(void)chooseImageFromAlbum
{
    cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary|UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:cameraUI animated:YES completion:NULL];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if(!image)
    {
        image = info[UIImagePickerControllerOriginalImage];
    }
    else
        _isImageAvailable = YES;
    
    editedImage = image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - CloudSight--------

- (void)searchWithImage:(UIImage *)image {
    NSString *deviceIdentifier = [self getUserDefaultValueForKey:IMEI];  // This can be any unique identifier per device, and is optional - we like to use UUIDs
    CLLocation *location = nil; // you can use the CLLocationManager to determine the user's location
    
    // We recommend sending a JPG image no larger than 1024x1024 and with a 0.7-0.8 compression quality,
    // you can reduce this on a Cellular network to 800x800 at quality = 0.4
    NSData *imageData = UIImageJPEGRepresentation(image, 0.4);
    
    NSData *compressImgData = UIImageJPEGRepresentation(image, 0.5);
    editedImage = [UIImage imageWithData:compressImgData];
    
    // Create the actual query object
    CloudSightQuery *query = [[CloudSightQuery alloc] initWithImage:imageData
                                                         atLocation:CGPointMake(0.0, 0.0)
                                                       withDelegate:self
                                                        atPlacemark:nil
                                                       withDeviceId:deviceIdentifier];
    
    // Start the query process
    [query start];
}

#pragma mark CloudSightQueryDelegate

- (void)cloudSightQueryDidFinishIdentifying:(CloudSightQuery *)query {
    if (query.skipReason != nil) {
        NSLog(@"Skipped: %@", query.skipReason);
    } else {
        //NSLog(@"Identified title: %@", query.title);
         NSLog(@"Identified name: %@", query.name);
         NSLog(@"Query token: %@", query.token);
        queryToken = query.token;
        Name = query.name;
        _isImageAvailable = NO;
        
       // [self saveImage];
        
        [self performSegueWithIdentifier:@"showProductOptionsFromHome" sender:nil];
    }
}

- (void)cloudSightQueryDidFinishUploading:(CloudSightQuery *)query
{
    NSLog(@"cloudSightQueryDidFinishUploading called");
}

- (void)cloudSightQueryDidFail:(CloudSightQuery *)query withError:(NSError *)error {
    NSLog(@"cloudSightQueryDidFail Error: %@", error);
    
    
    //[self.locationManager startUpdatingLocation];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"Unable to process Image"
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        _isImageAvailable = NO;
        
        _openCameraBtnOutlet.hidden = NO;
        _lblOpenCamera.hidden = NO;
        _capturedImgVw.hidden =YES;
        _lblProcessingImage.hidden = YES;
    }
}


#pragma mark

#pragma mark - Prepare For Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showProductOptionsFromHome"])
    {
        AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
        appDelegate.isFromLikePage = NO;
        appDelegate.isFromHistoryPage = NO;
        
        ProductOptionsViewController* productOptionsVC = [segue destinationViewController];
        productOptionsVC.productImage = editedImage;
        productOptionsVC.productImageUrl = imageURL;
        productOptionsVC.queryTokenForSelectedProduct = queryToken;
        productOptionsVC.productName = Name;
    }
}

#pragma mark - Save Image to Asset Library And To Database

-(void)saveImage
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    [library addAssetsGroupAlbumWithName:@"ScanIt" resultBlock:^(ALAssetsGroup *group)
     {
         
         NSLog(@"Adding Folder:'ScanIt', success: %s", group.editable ? "Success" : "Already created: Not Success");
         
         //        Handler(group,nil);
         
     } failureBlock:^(NSError *error)
     {
         
         NSLog(@"Error: Adding on Folder");
         
     }];
    
    NSData *imgData = UIImageJPEGRepresentation(_capturedImgVw.image, 0.4);
    
    UIImage *img = [UIImage imageWithData:imgData];
    
    [library saveImage:img toAlbum:@"ScanIt" completion:^(NSURL *assetURL, NSError *error)
     {
         NSLog(@"image saved to Album");
         
         imageURL = [assetURL absoluteString];
         
         NSManagedObjectContext *context = [self managedObjectContext];
         
         NSManagedObject *prodDetails = [NSEntityDescription insertNewObjectForEntityForName:@"ProductDetails" inManagedObjectContext:context];
         
         [prodDetails setValue:Name forKey:@"productName"];
         [prodDetails setValue:[assetURL absoluteString]  forKey:@"imageUrl"];
         [prodDetails setValue:[self getUserDefaultValueForKey:USERID] forKey:@"userId"];
         [prodDetails setValue:queryToken forKey:@"queryToken"];
         [prodDetails setValue:@"NO" forKey:@"likeProduct"];
         
         NSError *DBerror = nil;
         // Save the object to persistent store
         if (![context save:&DBerror]) {
             NSLog(@"Can't Save! %@ %@", DBerror, [DBerror localizedDescription]);
         }
         else
         {
             NSLog(@"Data added to database successfully");
             
             [self performSegueWithIdentifier:@"showProductOptionsFromHome" sender:nil];
         }
         
     }
     
     
    failure:^(NSError *error)
     {
         UIAlertView *alertMsg = [[UIAlertView alloc] initWithTitle:@"Saving Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
         
         [alertMsg show];
     }];
    
    
}

@end
