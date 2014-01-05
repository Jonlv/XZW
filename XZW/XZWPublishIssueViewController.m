//
//  XZWPublishIssueViewController.m
//  XZW
//
//  Created by dee on 13-10-12.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWPublishIssueViewController.h"
#import "XZWNetworkManager.h"
#import "MBProgressHUD.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "XZWUtil.h"

#import "ELCImagePickerController.h"
#import "ELCAlbumPickerController.h"
#import "ELCAssetTablePicker.h"

#define MBProgessHud 8888

#define ImageStartBtn 3000


@interface XZWPublishIssueViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate,ELCImagePickerControllerDelegate,UIActionSheetDelegate>{
    
    UITextView *issueUTV;
  //  UIImageView *picUIV ;
    UIButton  *addPicBtn;
    
    UILabel *positionUL;
    
    UIScrollView *imageUSV;
    
    CLLocationManager *locManager;
    
    CLGeocoder *myGeocoder;
    
    ASIHTTPRequest *sendRequest;
    
    int quanID;
    
    int currentCount;
    
    BOOL isSending;
    
    
}

@end

@implementation XZWPublishIssueViewController


- (id)initWithQuanID:(int)theQuan{
    
    self = [super init];
    if (self) {
        // Custom initialization
        
        quanID = theQuan;
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    self.title =  @"发表话题" ;
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];


    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];
    
    
    listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self action:@selector(sendIssue) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"option"] forState:UIControlStateNormal];
   
    
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];
   
    
//    myGeocoder = [[CLGeocoder alloc] init];
//    
//    locManager = [[CLLocationManager alloc]init];
//    //设置代理
//    locManager.delegate = self;
//    //设置位置经度
//    locManager.desiredAccuracy = kCLLocationAccuracyBest;
//    //设置每隔100米更新位置
//    locManager.distanceFilter = 100;
//    
//    
  
    
    [self initView];
    
}

-(void)goBack{
    
//    locManager.delegate = nil;
//    [locManager release]; 
//    
//    [myGeocoder release];
//    myGeocoder = nil;
    
    [self.navigationController popViewControllerAnimated:true];
    
}



#pragma mark -

-(void)sendIssue{
    
    [self.view endEditing:true];
    
    
    
//    if (picUIV.image) {
// 
//    }else
//    {
//        
//    }
    
    
    if (isSending) {
        
        return ;
    }
    
    
    NSMutableArray  *theArray = [NSMutableArray array];
    
    for (int i = 0 ; i < currentCount ; i++) {
        
        UIButton *nowBtn = (UIButton *)[imageUSV viewWithTag:ImageStartBtn + i ];
        
        [theArray addObject: [nowBtn imageForState:UIControlStateNormal] ];
        
    }
    
    
    MBProgressHUD *hud =  (MBProgressHUD *) [self.view viewWithTag:MBProgessHud];
    hud.labelText = @"加载中...";
    [hud show:true];
    
    isSending = true;
    
    
    sendRequest = [XZWNetworkManager asiWithLink:XZWQuanZiPostHt postDic:@{
                   
//                   @"body":[issueUTV.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
//                   @"type":@"post",
//                   @"app_name":@"public",
//                   
                   @"content":[issueUTV.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                   
//                   @"attach_id":@"",
//                   @"videourl":@"",
                   
                   
                   @"gid": [NSString stringWithFormat:@"%d",quanID]
                   
                   
                   
                    
                    
                   
                   } imageArray:theArray andImageKey:@"fileField[]"  completionBlock:^{
                       
                       
                       isSending = false;
                       
                       NSDictionary *tempDic = [[sendRequest responseString]  objectFromJSONString];
                       
                       NSLog(@"tempDic %@",tempDic);
                       
                       
                       if ([tempDic[@"status"]    intValue] == 1    ) {
                           
                           
                           
                           [hud setLabelText:@"发布成功！"];
                         //  [hud   hide:true afterDelay:.6f];
                           
                           [[NSNotificationCenter defaultCenter] postNotificationName:XZWSendSuccessNotification object:nil];
                           
                           [self performSelector:@selector(goBack) withObject:nil afterDelay:1.3f];
                           
                       }else {
                           
                           
                           [hud setLabelText:@"发布失败！"];
                           [hud   hide:true afterDelay:1.f];
                           
                       }
                       
                       
                       
                       
                   } failedBlock:^{
                       
                       
                       isSending = false;
                       
                       [hud setLabelText:@"发布失败！"];
                       [hud   hide:true afterDelay:.8f];
                   
                   
                   }];
    
    
    
    
}


-(void)addPic{
    
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
        
        
        NSUInteger sourceType = UIImagePickerControllerSourceTypeCamera;
        
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = true;
        
        imagePickerController.sourceType = sourceType;
        
        [self.navigationController presentViewController:imagePickerController animated:YES completion:^{}];
        
        [imagePickerController release];
        
    }
    
    
    
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
    [self.view endEditing:true];
}

-(void)initView{
    
    
    UIImageView *backgroundUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(10, 10, 300, 122)];
    backgroundUIV.image = [[UIImage imageNamed:@"corner"]  stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    [self.view addSubview:backgroundUIV];
    [backgroundUIV release];
    
    issueUTV = [[UITextView alloc]  initWithFrame:CGRectMake(12, 16, 296, 112)];
    issueUTV.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:issueUTV];
    [issueUTV release];

    [issueUTV  becomeFirstResponder];
     
    
    backgroundUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(10, 140, 300, 70)];
    backgroundUIV.image = [[UIImage imageNamed:@"corner"]  stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    [self.view addSubview:backgroundUIV];
    [backgroundUIV release];
    
  
    
    
    imageUSV = [[UIScrollView alloc]  initWithFrame:CGRectMake(12, 140, 295, 70)];
    imageUSV.pagingEnabled = true;
    imageUSV.showsHorizontalScrollIndicator = imageUSV.showsHorizontalScrollIndicator = false;
    imageUSV.contentSize = CGSizeMake(CGRectGetWidth(imageUSV.frame) * 2 , CGRectGetHeight(imageUSV.frame));
    [self.view addSubview:imageUSV];
    [imageUSV release];
 //   imageUSV.backgroundColor = [UIColor yellowColor];
    
    
    
    for (int i = 0; i < 10; i++) {
        
        UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        imageBtn.exclusiveTouch = true;
        [imageBtn setImage:nil forState:UIControlStateNormal];
        [imageBtn  addTarget:self action:@selector(deleteSelf:) forControlEvents:UIControlEventTouchUpInside];
        imageBtn.frame = CGRectMake( 10 * ( i / 5 + 1)  + 57 * i, 12, 46, 46);
        imageBtn.tag = ImageStartBtn + i ;
        imageBtn.contentMode = UIViewContentModeScaleAspectFill;
        [imageUSV addSubview:imageBtn]; 
 
    }
    
    
    
    addPicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addPicBtn   setImage:[UIImage imageNamed:@"add_icon"] forState:UIControlStateNormal];
    [addPicBtn  addTarget:self action:@selector(selectPicType) forControlEvents:UIControlEventTouchUpInside];
    [addPicBtn  setFrame:CGRectMake( 10 * ( currentCount / 5 + 1)  + 57 * currentCount, 12, 46, 46)];
    [imageUSV addSubview:addPicBtn];
    
    
    
//    picUIV = [[UIImageView alloc]  initWithImage:[UIImage imageNamed:@"add_icon"]];
//    picUIV.contentMode = UIViewContentModeScaleAspectFill;
//    picUIV.clipsToBounds = true;
//    [imageUSV addSubview:picUIV];
//    [picUIV release];
//    
//    picUIV.frame = CGRectMake(10 + 56 * currentCount, 7, 46, 46);
    
    
//    UIButton *addPicBtn = [UIButton buttonWithType:UIButtonTypeCustom]; 
//    [addPicBtn  addTarget:self action:@selector(addPic) forControlEvents:UIControlEventTouchUpInside];
//   // [addPicBtn setFrame:backgroundUIV.frame];
//   // addPicBtn.frame = CGRectMake(10, 140, 300, 70);
//    addPicBtn.frame =[backgroundUIV convertRect:picUIV.frame toView:self.view];
//    
//    [self.view addSubview:addPicBtn];
//    
//    
//    positionUL = [[UILabel alloc]   initWithFrame:CGRectMake(10, CGRectGetMaxY(backgroundUIV.frame) + 12, 200, 20)];
//    positionUL.layer.cornerRadius = 4.f;
//    positionUL.backgroundColor = [[UIColor blackColor]  colorWithAlphaComponent:.6f];
////    positionUL.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"qz_bg"]  stretchableImageWithLeftCapWidth:9 topCapHeight:9]];
//    positionUL.textColor = [UIColor whiteColor];
//    positionUL.text = @"      显示位置 ";
//    positionUL.font = [UIFont systemFontOfSize:12];
//    [self.view addSubview:positionUL];
//    [positionUL release];
//    
//    [positionUL sizeToFit];
//
    
    
//    UIButton *positionButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [positionButton  setFrame:CGRectMake(10, CGRectGetMaxY(backgroundUIV.frame) + 10 , 200, 20)];
//    [positionButton  setImage:[UIImage imageNamed:@"display"] forState:UIControlStateNormal];
//    positionButton.imageEdgeInsets = UIEdgeInsetsMake(0, -175, 0, 0);
//    [positionButton addTarget:self action:@selector(addPosition) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:positionButton];
    
    
    
    
    MBProgressHUD *mbProgessHud = [[MBProgressHUD alloc]  initWithView:self.view];
    mbProgessHud.tag = MBProgessHud;
    mbProgessHud.labelText = @"加载中...";
    [self.view addSubview:mbProgessHud];
    [mbProgessHud release];
    
    
}

-(void)addPosition{
      
    //开始定位服务
    [locManager startUpdatingLocation];
    
}

-(void)deleteSelf:(UIButton*)sender{
    
    int loopCount = sender.tag - ImageStartBtn ;
    
    if (currentCount <= loopCount ) {
        
        return ;
    }
    
    
    addPicBtn.hidden = false;
    
    currentCount -- ;
    
    [addPicBtn  setFrame:CGRectMake( 10 * ( currentCount / 5 + 1)  + 57 * currentCount, 12, 46, 46)];
    
    
    
    
    for (int i = loopCount; i < 10; i++) {
        
        UIButton *nowBtn = (UIButton *)[sender.superview viewWithTag:ImageStartBtn + i];
        UIButton *frontBtn = (UIButton *)[sender.superview viewWithTag:ImageStartBtn + i + 1];
        
        
        [nowBtn  setImage:[frontBtn imageForState:UIControlStateNormal] forState:UIControlStateNormal];
        
        
    }
    
    
    
    
     
}


#pragma mark - 

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [manager stopUpdatingLocation];
    
    [myGeocoder reverseGeocodeLocation:manager.location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error == nil &&[placemarks count] > 0){
            
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
             

            
            positionUL.text = [NSString stringWithFormat:@"      %@%@%@%@ ",[placemark.addressDictionary objectForKey:@"State"],[placemark.addressDictionary objectForKey:@"SubLocality"],[placemark.addressDictionary objectForKey:@"Thoroughfare"],[placemark.addressDictionary objectForKey:@"SubThoroughfare"]];
            
            
        }else if (error == nil &&   [placemarks count] == 0){
            
            positionUL.text = @"      获取失败 ";
            
        }else {
            
            positionUL.text = @"      获取失败 ";
            
        }
       
        
        [positionUL sizeToFit];
    }];
    
}


-(void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error{
     
    
     
    
    
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
  
    NSString *errorMsg = nil;
    if ([error code] == kCLErrorDenied) {
        errorMsg = @"访问被拒绝";
    }
    if ([error code] == kCLErrorLocationUnknown) {
        errorMsg = @"获取位置信息失败";
    }
    
    positionUL.text = [NSString stringWithFormat:@"      %@ ",errorMsg];
    
    [positionUL sizeToFit];
}


#pragma mark - getPic

-(void)getPic{
    
    
}


#pragma mark - elca

-(void)selectPicType{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]  initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择" , nil];
    actionSheet.tag = 2; 
    [actionSheet showInView:self.navigationController.view];
    [actionSheet release];
 
    
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    
    [self.view endEditing:true];
    
    
    if (buttonIndex == 0) {
        
        [self addPic];
        
    }else if (buttonIndex == 1){
        
        
        [self launchController];
        
    }
    
    
    
}

- (IBAction)launchController
{
 
    [[NSUserDefaults standardUserDefaults] setInteger:currentCount forKey:@"uploadLimit" ];
    
    ELCAlbumPickerController *albumController = [[ELCAlbumPickerController alloc] initWithNibName: nil bundle: nil];
	ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initWithRootViewController:albumController];
    elcPicker.navigationBar.barStyle = UIBarStyleBlackOpaque;
    //[elcPicker.navigationBar   setBackgroundImage:[UIImage imageNamed:@"top"] forBarMetrics:UIBarMetricsDefault];
    
    [albumController setParent:elcPicker];
	[elcPicker setDelegate:self];
    
    //    ELCImagePickerDemoAppDelegate *app = (ELCImagePickerDemoAppDelegate *)[[UIApplication sharedApplication] delegate];
    //    [app.viewController presentViewController:elcPicker animated:YES completion:nil];
    
    [self.navigationController presentViewController:elcPicker animated:YES completion:nil];
    
    
    [elcPicker release];
    [albumController release];
}


 

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    
	[picker dismissViewControllerAnimated:YES completion:^{
        
        
        
        
    }];
    
    
     UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
     
    
 //   picUIV.image = image;
    
    // imageBtn.hidden = true;
    
     
        
        UIButton *nowBtn = (UIButton *)[imageUSV viewWithTag:ImageStartBtn + currentCount ];
        
        if (nowBtn) {
            
            
            [nowBtn    setImage:image forState:UIControlStateNormal];
            
            currentCount ++ ;
            
        }
        
         
    
    
    [addPicBtn  setFrame:CGRectMake( 10 * ( (currentCount  ) / 5 + 1)  + 57 * (currentCount  ), 12, 46, 46)];
    
    if (currentCount >= 10) {
        
        addPicBtn.hidden = true;
        
    }else {
        
        
        addPicBtn.hidden = false;
    }
    

    
    
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:^{
         
        
        
    }];
    
    
    
}



#pragma mark -

#pragma mark ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
    
    
    
	
	for(NSDictionary *dict in info) {
        
        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
         
        
	
      
        
        UIImage *imageToDisplay =
        [UIImage imageWithCGImage:[image CGImage]
                            scale:1.0
                      orientation: UIImageOrientationUp];
        
         
        
        [images addObject: [XZWUtil getRightUIImage: imageToDisplay]];
        
 
    }
    
    
    for (UIImage *image in images) {
        
        UIButton *nowBtn = (UIButton *)[imageUSV viewWithTag:ImageStartBtn + currentCount ];

        if (nowBtn) {
            
            
            [nowBtn    setImage:image forState:UIControlStateNormal];
            
            currentCount ++ ;
            
        }
        
      
        
    }
    
    
    [addPicBtn  setFrame:CGRectMake( 10 * ( (currentCount  ) / 5 + 1)  + 57 * (currentCount  ), 12, 46, 46)];
    
    if (currentCount >= 10) {
        
        addPicBtn.hidden = true;
        
    }else {
        
        
        addPicBtn.hidden = false;
    }
    
    
    
    
}


- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}




#pragma mark -




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
