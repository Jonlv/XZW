//
//  XZWMyProfileViewController.m
//  XZW
//
//  Created by dee on 13-9-10.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWMyProfileViewController.h"
#import "XZWUtil.h"
#import "JSONKit.h"
#import "XZWNetworkManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "XZWZodiacData.h"
#import "XZWModifyProfileViewController.h"
#import "MBProgressHUD.h"
#import "XZWButton.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "XZWSendGiftViewController.h"
#import "XZWChatViewController.h"
#import <SDWebImage/SDImageCache.h>
#import "GoodsGalleryViewController.h"
#import "XZWGiftListViewController.h"
#import "ELCImagePickerController.h"
#import "ELCAlbumPickerController.h"
#import "ELCAssetTablePicker.h"
#import "XZWAblumViewController.h"
#import "XZWSendGiftViewController.h"
#import "XZWKnowledgeMoreDetailViewController.h"
#import "XZWChatStyleTwoViewController.h"


#define AvatarStartTag 3000

@interface XZWMyProfileViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{


    UITableView *profileTableView;

    ASIHTTPRequest *profileRequest;

    NSMutableDictionary *profileDic;

    ASIHTTPRequest *picRequest;

    ASIHTTPRequest *saveRequest;

    int selectImageType;

    MBProgressHUD *hud;

    NSMutableArray *ablumArray;


    int  userID;


    ///

    UILabel *fansCount;


    UIButton *friendButton;

    ///好友的

    ASIHTTPRequest *sayHelloRequest;

    ASIHTTPRequest *likeRequest;

    UIButton *likeButton;

    BOOL isLike;


    ///
    ASIHTTPRequest *knowledgeRequest;

    NSMutableArray *knowledgeArray;


    ASIHTTPRequest *giftRequest;

    NSMutableArray *giftArray;

    //

    BOOL isNotSelf,notFromLeft;

    UIButton * avatarUIV;

}


@property (nonatomic, retain) ALAssetsLibrary *specialLibrary;

@end

@implementation XZWMyProfileViewController
@synthesize chosenImages = _chosenImages;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initUserID:(int)userIDArg{

    self = [super init];
    if (self) {
        // Custom initialization
        userID = userIDArg;

        isNotSelf =  !(userID==[[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] intValue]);

        notFromLeft  = true;


    }
    return self;
}


#pragma mark -

-(void)dealloc{

    NSLog(@"dealloc ");

    [knowledgeArray release];
    [ablumArray  release];
    [_specialLibrary release];
    [giftArray  release];
    [profileDic release];

    [super dealloc];
}

- (void)viewDidLoad
{

    [super viewDidLoad];
	// Do any additional setup after loading the view.


    if (!isNotSelf) {

        self.title = @"个人资料";

    }else {

        self.title = @"好友资料";
    }



    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(modifyDic:) name:XZWRefreshProfileNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(albumDeleted:) name:XZWNotification_AlbumDeleteSuccessfully object:nil];

    profileDic = [[NSMutableDictionary alloc]   init];

    ablumArray = [[NSMutableArray alloc]   init];

    giftArray = [[NSMutableArray alloc]   init];

    knowledgeArray = [[NSMutableArray alloc]   init];

    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];


    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];



    profileRequest = [XZWNetworkManager asiWithLink:!isNotSelf?XZWUserInfo:[XZWUserInfo stringByAppendingFormat:@"&uid=%d",userID] postDic:nil completionBlock:^{

        NSDictionary *responseDic = [[profileRequest   responseString]  objectFromJSONString];

        if ([[responseDic  objectForKey:@"status"]  intValue] == 0) {


        }else {

            [profileDic   setDictionary:[responseDic   objectForKey:@"data"]];


            isLike = [profileDic[@"like_state"] intValue] == 0 ? false : true;

            // 获取个人资料
            if (!isNotSelf) {

                userID = [[profileDic objectForKey:@"uid"]   intValue];

                [[NSUserDefaults standardUserDefaults]   setObject:[profileDic objectForKey:@"uid"] forKey:@"userID"];

                [[NSUserDefaults standardUserDefaults]   setObject:[profileDic objectForKey:@"uname"] forKey:@"username"];

                [[NSUserDefaults standardUserDefaults]   setObject:[profileDic objectForKey:@"avatar"] forKey:@"avatar"];

                [ [NSUserDefaults standardUserDefaults]  setObject:[profileDic objectForKey:@"constellation"] forKey:@"constellation"];

                [[NSUserDefaults standardUserDefaults]  synchronize];

            }



            giftRequest = [XZWNetworkManager asiWithLink:[XZWGiftBox   stringByAppendingFormat:@"&uid=%d&box=receive",userID] postDic:nil completionBlock:^{

                NSDictionary *responseDic = [[giftRequest   responseString]  objectFromJSONString];


                if ([[responseDic  objectForKey:@"status"]  intValue] == 0) {


                }else {

                    [giftArray    setArray:[[responseDic   objectForKey:@"data"]  objectForKey:@"data"]];

                    [profileTableView reloadData];
                }


            } failedBlock:^{

            }];


            [self initView];
        }


        [self getKnowledge];
        [self loadAblum];

        ;} failedBlock:  ^{

        }];


    //    return;
    //
    //
    //    picRequest  = [XZWNetworkManager asiWithLink:!isNotSelf?[XZWGetAlbum stringByAppendingFormat:@"&num=28"]:[XZWGetAlbum stringByAppendingFormat:@"&uid=%d&num=28",userID] postDic:nil completionBlock:^{
    //
    //        NSDictionary *responseDic = [[picRequest   responseString]  objectFromJSONString];
    //
    //        if ([[responseDic  objectForKey:@"status"]  intValue] == 0) {
    //
    //
    //        }else {
    //
    //
    //
    //            [ablumArray    setArray:[[responseDic   objectForKey:@"data"]  objectForKey:@"data"]];
    //
    //            [profileTableView reloadData];
    //        }
    //
    //
    //
    //        ;} failedBlock:nil];
}


#pragma mark -  Friend&view

#pragma mark -

// 获取“圈子列表”数据
-(void)getKnowledge{

    knowledgeRequest = [[ASIHTTPRequest alloc]  initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&id=%d",[XZWGetCollectionList stringByAppendingString:[NSString stringWithFormat:@"%d",1]],userID]]];


    [knowledgeRequest startAsynchronous];


    [knowledgeRequest setCompletionBlock:^{

        NSDictionary *messageDic = [[knowledgeRequest responseData]   objectFromJSONData];


        [knowledgeArray setArray:messageDic[@"data"]];

        [profileTableView reloadData];

    }];

}

-(void)sayHello{


    [XZWNetworkManager cancelAndReleaseRequest:sayHelloRequest];



    [hud   show:true];
    hud.labelText = @"发送中...";


    sayHelloRequest =  [XZWNetworkManager asiWithLink:[XZWSayHello  stringByAppendingFormat:@"&uid=%d&type=1",userID] postDic:nil completionBlock:^{



        if ([[[[sayHelloRequest responseString]   objectFromJSONString] objectForKey:@"status"] intValue]  == 1 ) {

            hud.labelText = @"发送成功...";

        }else {

            hud.labelText = @"发送失败...";

        }

        [hud hide:true afterDelay:1.2f];



    } failedBlock:^{

        hud.labelText = @"发送失败...";
        [hud hide:true];



    }];




}

-(void)snsAction{



    XZWChatStyleTwoViewController *chatVC = [[XZWChatStyleTwoViewController alloc]initWithUserID:userID nameString:[profileDic  objectForKey:@"uname"] avatarString:[profileDic  objectForKey:@"avatar"]];
    [self.navigationController pushViewController:chatVC animated:true];
    [chatVC release];

    //    XZWChatViewController *chatVC = [[XZWChatViewController alloc]initWithUserID:userID nameString:[profileDic  objectForKey:@"uname"] avatarString:[profileDic  objectForKey:@"avatar"]];
    //    [self.navigationController pushViewController:chatVC animated:true];
    //    [chatVC release];


}

-(void)addFriend{

    [XZWNetworkManager cancelAndReleaseRequest:likeRequest];



    [hud   show:true];
    hud.labelText = @"请求中...";


    likeRequest =  [XZWNetworkManager asiWithLink:[XZWTurnLike  stringByAppendingFormat:@"&uid=%d",userID] postDic:nil completionBlock:^{


        if ([[[[likeRequest responseString]   objectFromJSONString] objectForKey:@"status"] intValue]  == 1 ) {

            hud.labelText = @"请求成功";


            isLike = !isLike;



            if (isLike) {


                [likeButton  setImage:[UIImage imageNamed:@"red1_heart"] forState:UIControlStateNormal];

            }else {


                [likeButton  setImage:[UIImage imageNamed:@"redgray_heart"] forState:UIControlStateNormal];
            }

            ///////


            UILabel *descriptionUL = (UILabel *)[friendButton viewWithTag:888];

            if (isLike) {

                descriptionUL.text = @"删除好友";

            }else {

                descriptionUL.text = @"加好友";


            }

            if (isLike) {

                fansCount.text = [NSString stringWithFormat:@"%d",[fansCount.text  intValue] + 1];


            }else {


                fansCount.text = [NSString stringWithFormat:@"%d",[fansCount.text  intValue] - 1];


            }




        }else {

            hud.labelText = @"请求失败";

        }

        [hud hide:true afterDelay:.6f];



        //////





    } failedBlock:^{

        hud.labelText = @"请求失败...";
        [hud hide:true];

    }];




}







#pragma mark - loadAblum

// 获取相册
-(void)loadAblum{

    [XZWNetworkManager cancelAndReleaseRequest:picRequest];

    NSLog(@" %@",[XZWGetAlbum stringByAppendingFormat:@"&num=28"]);

    picRequest = [XZWNetworkManager asiWithLink:!isNotSelf?[XZWGetAlbum stringByAppendingFormat:@"&num=28"]:[XZWGetAlbum stringByAppendingFormat:@"&uid=%d&num=28",userID]  postDic:nil completionBlock:^{

        NSDictionary *responseDic = [[picRequest responseString] objectFromJSONString];

        if ([[responseDic  objectForKey:@"status"]  intValue] == 0) {

        } else {

            [ablumArray setArray:[[responseDic objectForKey:@"data"] objectForKey:@"data"]];

            [profileTableView reloadData];
        }

        ;} failedBlock:nil];

}

#pragma mark -


- (void)modifyProfile {

    XZWModifyProfileViewController *modifyProfile = [[XZWModifyProfileViewController alloc]  initWithDic:profileDic];
    [self.navigationController pushViewController:modifyProfile animated:true];
    [modifyProfile release];
}

- (void)modifyAvatar
{
    selectImageType =  0;

    UIActionSheet *sheet;

    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    }
    else {

        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }

    sheet.tag = 255;

    [sheet showInView:self.navigationController.view];
    [sheet release];

}



-(void)uploadPicture{


    selectImageType =  1;



    UIActionSheet *sheet;

    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    }
    else {

        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }

    sheet.tag = 255;

    [sheet showInView:self.navigationController.view];
    [sheet release];


}


- (void)modifyDic:(NSNotification*)notificationObject
{
    //    [profileDic   setDictionary:notificationObject.object];
    //
    //    [notificationObject object];


    [XZWNetworkManager cancelAndReleaseRequest:profileRequest];

    profileRequest = [XZWNetworkManager asiWithLink:XZWUserInfo postDic:nil completionBlock:^{

        NSDictionary *responseDic = [[profileRequest responseString] objectFromJSONString];

        if ([[responseDic objectForKey:@"status"] intValue] == 0) {


        } else {

            [profileDic setDictionary:[responseDic objectForKey:@"data"]];

            [[NSUserDefaults standardUserDefaults] setObject:[profileDic objectForKey:@"uname"]forKey:@"username"];

            [[NSUserDefaults standardUserDefaults] setObject:[profileDic objectForKey:@"avatar"] forKey:@"avatar"];

            [ [NSUserDefaults standardUserDefaults] setObject:[profileDic objectForKey:@"constellation"] forKey:@"constellation"];

            [[NSUserDefaults standardUserDefaults] synchronize];


            [[NSNotificationCenter defaultCenter] postNotificationName:XZWLoginNotification object:nil];
        }


        [self refreshHeadrView];

        [profileTableView reloadData];


        ;} failedBlock:nil];
}

- (void)albumDeleted:(NSNotification*)notification {
    [self loadAblum];
}

#pragma mark -

-(void)goBack{

    [[NSNotificationCenter defaultCenter]  removeObserver:self name:XZWRefreshProfileNotification object:nil];

    [[NSNotificationCenter defaultCenter]  removeObserver:self];

    //  [XZWNetworkManager   cancelAndReleaseRequest:saveRequest];

    [XZWNetworkManager   cancelAndReleaseRequest:picRequest];

    [XZWNetworkManager   cancelAndReleaseRequest:profileRequest];

    [XZWNetworkManager cancelAndReleaseRequest:likeRequest];

    if (!isNotSelf && !notFromLeft) {

        [self.navigationController dismissModalViewControllerAnimated:true];

    }else {


        [self.navigationController popViewControllerAnimated:true];
    }


}

#pragma mark -


-(UIImage*)imageByRotatingImage:(UIImage*)initImage fromImageOrientation:(UIImageOrientation)orientation
{
    CGImageRef imgRef = initImage.CGImage;

    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);

    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = orientation;
    switch(orient) {

        case UIImageOrientationUp: //EXIF = 1
            return initImage;
            break;

        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;

        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;

        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;

        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;

        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;

        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;

        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;

        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];

    }
    // Create the bitmap context
    CGContextRef    context = NULL;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;

    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (bounds.size.width * 4);
    bitmapByteCount     = (bitmapBytesPerRow * bounds.size.height);
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        return nil;
    }

    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    CGColorSpaceRef colorspace = CGImageGetColorSpace(imgRef);
    context = CGBitmapContextCreate (bitmapData,bounds.size.width,bounds.size.height,8,bitmapBytesPerRow,
                                     colorspace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorspace);

    if (context == NULL)
        // error creating context
        return nil;

    CGContextScaleCTM(context, -1.0, -1.0);
    CGContextTranslateCTM(context, -bounds.size.width, -bounds.size.height);

    CGContextConcatCTM(context, transform);

    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(context, CGRectMake(0,0,width, height), imgRef);

    CGImageRef imgRef2 = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    free(bitmapData);
    UIImage * image = [UIImage imageWithCGImage:imgRef2 scale:initImage.scale orientation:UIImageOrientationUp];
    CGImageRelease(imgRef2);
    return image;
}


#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissViewControllerAnimated:YES completion:^{}];


    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    //    NSLog(@"imageOrientation %d",image.imageOrientation);


    image = [self imageByRotatingImage:image fromImageOrientation:image.imageOrientation];
    /*
     UIImage * LandscapeImage = [UIImage imageNamed: imgname];
     UIImage * PortraitImage = [[UIImage alloc] initWithCGImage: LandscapeImage.CGImage
     scale: 1.0
     orientation: UIImageOrientationLeft];
     */

    //    CGFloat imageWidth = CGImageGetWidth(image.CGImage);
    //    CGFloat imageHeight = CGImageGetHeight(image.CGImage);

    //NSLog(@"imageWidth %f %f ",imageWidth,imageHeight);

    //    if (imageWidth < 300 || imageHeight < 300 ) {
    //
    //        [[[[UIAlertView alloc] initWithTitle:nil message:@"图片太小了,请重新输入" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil]  autorelease]  show];
    //
    //
    //        return ;
    //    }


    switch (selectImageType) {
        case 0:
        {


            [XZWNetworkManager cancelAndReleaseRequest:saveRequest];


            [hud   show:true];
            hud.labelText = @"上传中...";

            saveRequest =  [XZWNetworkManager asiWithLink:XZWSaveAvatar postDic:nil imageData:UIImageJPEGRepresentation([XZWUtil getRightUIImage:image] ,1.f) andImageKey:@"Filedata" completionBlock:^{



                if ([[[[saveRequest responseString]   objectFromJSONString] objectForKey:@"status"] intValue]  == 1 ) {

                    hud.labelText = @"上传成功...";


                    [[SDImageCache sharedImageCache]  removeImageForKey:profileDic[@"avatar"]];

                    [[NSNotificationCenter defaultCenter]  postNotificationName:XZWRefreshProfileNotification object:nil];



                }else {

                    hud.labelText = @"上传失败...";

                }

                [hud hide:true afterDelay:.6f];

                //
                //       [[NSUserDefaults standardUserDefaults]   setObject:[[responseDic  objectForKey:@"data"] objectForKey:@"avatar"] forKey:@"avatar"];
                //
                //       [[NSUserDefaults standardUserDefaults]  synchronize];
                //
                //       [[NSNotificationCenter defaultCenter]  postNotificationName:XZWLoginNotification object:nil];
                //


            } failedBlock:^{

                hud.labelText = @"上传失败...";
                [hud hide:true afterDelay:.6f];







            }];

        }

            break;

        default:

        {


        }
            break;
    }


}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissViewControllerAnimated:YES completion:^{}];
}




#pragma mark - actionsheet

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    NSUInteger sourceType = 0;

    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {

        switch (buttonIndex) {

            case 0:
                // 相机
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;

            case 1:
                // 相册
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            case 2:
                // 取消
                return;
        }
    }
    else {
        if (buttonIndex == 0) {

            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;

        } else {
            return;
        }
    }
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];

    imagePickerController.delegate = self;

    imagePickerController.allowsEditing = YES;

    imagePickerController.sourceType = sourceType;

    [self.navigationController presentViewController:imagePickerController animated:YES completion:^{}];

    [imagePickerController release];
}


#pragma mark -

-(void)initView
{
    profileTableView = [[UITableView alloc]  initWithFrame:CGRectMake(0, 0, 320, TotalScreenHeight - 88 - 20 ) style:UITableViewStyleGrouped];
    profileTableView.delegate = self;
    profileTableView.dataSource = self;
    profileTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    [self.view addSubview:profileTableView];
    [profileTableView release];

    UIView *uv = [[UIView alloc]  initWithFrame:profileTableView.bounds];
    uv.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    [profileTableView  setBackgroundView:uv];
    [uv release];



    UIView *headerView = [[UIView alloc]  initWithFrame:CGRectMake(0, 0, 320, 80)];
    [profileTableView setTableHeaderView:headerView];
    [headerView release];


    UIImageView *backView = [[UIImageView alloc]  initWithFrame:CGRectMake(9, 9, 64, 64)];
    backView.image = [UIImage imageNamed:@"personimg"];
    [headerView addSubview:backView];
    [backView release];





    if (isNotSelf) {

        likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [likeButton setFrame:CGRectMake(265, 20, 16, 15)];
        [likeButton  setImage:[UIImage imageNamed:@"redgray_heart"] forState:UIControlStateNormal];
        [likeButton addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:likeButton];


        if (isLike) {

            [likeButton  setImage:[UIImage imageNamed:@"red1_heart"] forState:UIControlStateNormal];

        }else {

            [likeButton  setImage:[UIImage imageNamed:@"redgray_heart"] forState:UIControlStateNormal];
        }

    }else {


        UIImageView *fansUIV = [[UIImageView alloc]  initWithFrame:CGRectMake(265, 20, 16, 15)];
        [headerView addSubview:fansUIV];
        [fansUIV release];
        [fansUIV  setImage:[UIImage imageNamed:@"redgray_heart"]];
    }




    fansCount = [[UILabel alloc]  initWithFrame:CGRectOffset(CGRectMake(265, 20, 200, 15), 20, 0)];
    [fansCount setBackgroundColor:[UIColor clearColor]];
    fansCount.text = [[profileDic  objectForKey:@"like_count"] description];
    fansCount.textColor = [XZWUtil xzwRedColor];
    [headerView addSubview:fansCount];
    [fansCount  release];



    avatarUIV = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 62, 62)];
    //  avatarUIV.image = [UIImage imageNamed:@"personimg"];
    [avatarUIV  addTarget:self action:@selector(avatarAction) forControlEvents:UIControlEventTouchUpInside];
    [avatarUIV  setImageWithURL:[NSURL URLWithString:[profileDic  objectForKey:@"avatar"]] forState:UIControlStateNormal];
    // [avatarUIV   setImageWithURL:[NSURL URLWithString:[profileDic  objectForKey:@"avatar"]]];
    [headerView addSubview:avatarUIV];
    [avatarUIV release];

    UILabel *nameUL = [[UILabel alloc]  initWithFrame:CGRectMake(85, 5, 200, 30)];
    nameUL.text = [profileDic  objectForKey:@"uname"];
    nameUL.textColor = [XZWUtil xzwRedColor];
    nameUL.backgroundColor = [UIColor clearColor];
    [nameUL setFont:[UIFont systemFontOfSize:18]];
    [headerView addSubview:nameUL];
    [nameUL release];

    UILabel *idUL = [[UILabel alloc] initWithFrame:CGRectMake(85, 25, 200, 30)];
    idUL.text = [@"ID:"  stringByAppendingString:[profileDic  objectForKey:@"uid"]];
    idUL.backgroundColor = [UIColor clearColor];
    idUL.textColor = [UIColor grayColor];
    [idUL setFont:[UIFont systemFontOfSize:18]];
    [headerView addSubview:idUL];
    [idUL release];

    UIImageView *ageUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(85, 51, 81, 20)];
    ageUIV.image = [UIImage imageNamed:@"const"];
    [headerView addSubview:ageUIV];
    [ageUIV release];


    //♂  ♀

    NSMutableString *ageString = [NSMutableString string];

    if ([[profileDic  objectForKey:@"sex"]  intValue] ==1  ) {

        [ageString  appendFormat:@"♂ %@ %@",[profileDic  objectForKey:@"age"],[[XZWZodiacData getSignArray]  objectAtIndex:  [[profileDic  objectForKey:@"constellation"] intValue]]];

    }else {


        [ageString  appendFormat:@"♀ %@ %@",[profileDic  objectForKey:@"age"],[[XZWZodiacData getSignArray]  objectAtIndex:  [[profileDic  objectForKey:@"constellation"] intValue]]];
    }


    UILabel *ageUL = [[UILabel alloc]   initWithFrame:ageUIV.bounds];
    ageUL.text =  ageString ;
    ageUL.adjustsFontSizeToFitWidth = true;
    ageUL.backgroundColor = [UIColor clearColor];
    ageUL.textColor = [UIColor whiteColor];
    [ageUIV  addSubview:ageUL];
    [ageUL release];


    // 底部横条，放修改资料、修改头像、上传相片
    UIImageView *bottomUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(0, TotalScreenHeight - 64 -44 , 320 , 44)];
    bottomUIV.userInteractionEnabled = true;
    [bottomUIV setImage:[UIImage imageNamed:@"personbt"]];
    [self.view addSubview:bottomUIV];
    [bottomUIV release];


    if (!isNotSelf) {

        // 修改资料
        UIButton *profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
        profileButton.clipsToBounds = false;
        [profileButton setImage:[UIImage imageNamed:@"data"] forState:UIControlStateNormal];
        // [profileButton setTitle:@"修改资料" forState:UIControlStateNormal];
        [bottomUIV addSubview:profileButton];
        profileButton.titleLabel.textAlignment = UITextAlignmentCenter;
        [profileButton  addTarget:self action:@selector(modifyProfile) forControlEvents:UIControlEventTouchUpInside];
        profileButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [profileButton   setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        profileButton.frame = CGRectMake(65, 4, 44, 38);
        [profileButton setImageEdgeInsets:UIEdgeInsetsMake(-15, 0, 0, 0)];
        [profileButton    setTitleEdgeInsets:UIEdgeInsetsMake(20, -45, 0, -30)];




        UILabel * descriptionUL = [[UILabel alloc]  initWithFrame:CGRectMake(-5, 20, 54, 20)];
        descriptionUL.backgroundColor = [UIColor clearColor];
        descriptionUL.text = @"修改资料";
        descriptionUL.font = [UIFont systemFontOfSize:13];
        descriptionUL.adjustsFontSizeToFitWidth = true;
        descriptionUL.textAlignment = UITextAlignmentCenter;
        descriptionUL.textColor = [UIColor grayColor];
        [profileButton addSubview:descriptionUL];
        [descriptionUL release];


        // 修改头像
        profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
        profileButton.clipsToBounds = false;
        [profileButton setImage:[UIImage imageNamed:@"head"] forState:UIControlStateNormal];
        // [profileButton setTitle:@"修改头像" forState:UIControlStateNormal];
        [bottomUIV addSubview:profileButton];
        profileButton.titleLabel.textAlignment = UITextAlignmentCenter;
        [profileButton  addTarget:self action:@selector(modifyAvatar) forControlEvents:UIControlEventTouchUpInside];
        profileButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [profileButton   setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        profileButton.frame = CGRectMake(140, 4, 44, 38);
        [profileButton setImageEdgeInsets:UIEdgeInsetsMake(-15, 0, 0, 0)];
        [profileButton    setTitleEdgeInsets:UIEdgeInsetsMake(20, -45, 0, -30)];


        descriptionUL = [[UILabel alloc]  initWithFrame:CGRectMake(-5, 20, 54, 20)];
        descriptionUL.backgroundColor = [UIColor clearColor];
        descriptionUL.text = @"修改头像";
        descriptionUL.font = [UIFont systemFontOfSize:13];
        descriptionUL.adjustsFontSizeToFitWidth = true;
        descriptionUL.textAlignment = UITextAlignmentCenter;
        descriptionUL.textColor = [UIColor grayColor];
        [profileButton addSubview:descriptionUL];
        [descriptionUL release];


        // 上传相片
        profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
        profileButton.clipsToBounds = false;
        [profileButton setImage:[UIImage imageNamed:@"upload"] forState:UIControlStateNormal];
        //     [profileButton setTitle:@"上传相片" forState:UIControlStateNormal];
        [bottomUIV addSubview:profileButton];
        profileButton.titleLabel.textAlignment = UITextAlignmentCenter;
        profileButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [profileButton   setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        profileButton.frame = CGRectMake(215, 4, 44, 38);
        [profileButton setImageEdgeInsets:UIEdgeInsetsMake(-15, 0, 0, 0)];
        [profileButton    setTitleEdgeInsets:UIEdgeInsetsMake(20, -45, 0, -30)];
        [profileButton  addTarget:self action:@selector(launchController) forControlEvents:UIControlEventTouchUpInside];



        descriptionUL = [[UILabel alloc]  initWithFrame:CGRectMake(-5, 20, 54, 20)];
        descriptionUL.backgroundColor = [UIColor clearColor];
        descriptionUL.text = @"上传相片";
        descriptionUL.font = [UIFont systemFontOfSize:13];
        descriptionUL.adjustsFontSizeToFitWidth = true;
        descriptionUL.textAlignment = UITextAlignmentCenter;
        descriptionUL.textColor = [UIColor grayColor];
        [profileButton addSubview:descriptionUL];
        [descriptionUL release];

    } else {

        UIButton *profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
        profileButton.clipsToBounds = false;
        [profileButton setImage:[UIImage imageNamed:@"hi"] forState:UIControlStateNormal];
        // [profileButton setTitle:@"打招呼" forState:UIControlStateNormal];
        [bottomUIV addSubview:profileButton];
        profileButton.titleLabel.textAlignment = UITextAlignmentCenter;
        [profileButton  addTarget:self action:@selector(sayHello) forControlEvents:UIControlEventTouchUpInside];
        profileButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [profileButton   setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        profileButton.frame = CGRectMake(18, 4, 44, 38);
        [profileButton setImageEdgeInsets:UIEdgeInsetsMake(-15, 0, 0, 0)];
        [profileButton    setTitleEdgeInsets:UIEdgeInsetsMake(20, -45, 0, -30)];


        UILabel *descriptionUL = [[UILabel alloc]  initWithFrame:CGRectMake(0, 20, 44, 20)];
        descriptionUL.backgroundColor = [UIColor clearColor];
        descriptionUL.text = @"打招呼";
        descriptionUL.font = [UIFont systemFontOfSize:13];
        descriptionUL.adjustsFontSizeToFitWidth = true;
        descriptionUL.textAlignment = UITextAlignmentCenter;
        descriptionUL.textColor = [UIColor grayColor];
        [profileButton addSubview:descriptionUL];
        [descriptionUL release];


        profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
        profileButton.clipsToBounds = false;
        profileButton.titleLabel.textAlignment = UITextAlignmentCenter;
        [profileButton setImage:[UIImage imageNamed:@"shixin"] forState:UIControlStateNormal];
        //[profileButton setTitle:@"发私信" forState:UIControlStateNormal];
        [bottomUIV addSubview:profileButton];
        [profileButton  addTarget:self action:@selector(snsAction) forControlEvents:UIControlEventTouchUpInside];
        profileButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [profileButton   setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        profileButton.frame = CGRectMake(18 + 80, 4, 44, 38);
        [profileButton setImageEdgeInsets:UIEdgeInsetsMake(-15, 0, 0, 0)];
        [profileButton    setTitleEdgeInsets:UIEdgeInsetsMake(20, -45, 0, -30)];


        descriptionUL = [[UILabel alloc]  initWithFrame:CGRectMake(0, 20, 44, 20)];
        descriptionUL.backgroundColor = [UIColor clearColor];
        descriptionUL.text = @"发私信";
        descriptionUL.font = [UIFont systemFontOfSize:13];
        descriptionUL.adjustsFontSizeToFitWidth = true;
        descriptionUL.textAlignment = UITextAlignmentCenter;
        descriptionUL.textColor = [UIColor grayColor];
        [profileButton addSubview:descriptionUL];
        [descriptionUL release];



        friendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        friendButton.clipsToBounds = false;
        [friendButton setImage:[UIImage imageNamed:@"addfriends"] forState:UIControlStateNormal];
        // [friendButton setTitle:@"加好友" forState:UIControlStateNormal];
        [bottomUIV addSubview:friendButton];
        profileButton.titleLabel.textAlignment = UITextAlignmentCenter;
        friendButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [friendButton   setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        friendButton.frame = CGRectMake(18 + 80 * 2, 4, 44, 38);
        [friendButton setImageEdgeInsets:UIEdgeInsetsMake(-15, 0, 0, 0)];
        [friendButton    setTitleEdgeInsets:UIEdgeInsetsMake(20, -45, 0, -30)];
        [friendButton  addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];


        descriptionUL = [[UILabel alloc]  initWithFrame:CGRectMake(-5, 20, 54, 20)];
        descriptionUL.backgroundColor = [UIColor clearColor];
        descriptionUL.text = @"加好友";
        descriptionUL.tag = 888 ;
        descriptionUL.font = [UIFont systemFontOfSize:13];
        descriptionUL.adjustsFontSizeToFitWidth = true;
        descriptionUL.textAlignment = UITextAlignmentCenter;
        descriptionUL.textColor = [UIColor grayColor];
        [friendButton addSubview:descriptionUL];
        [descriptionUL release];


        if (isLike) {

            // [friendButton setTitle:@"删除好友" forState:UIControlStateNormal];
            descriptionUL.text = @"删除好友";
        }else {
            descriptionUL.text = @"加好友";

            // [friendButton setTitle:@"加好友" forState:UIControlStateNormal];
        }



        profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
        profileButton.clipsToBounds = false;
        [profileButton setImage:[UIImage imageNamed:@"gift_2"] forState:UIControlStateNormal];
        //  [profileButton setTitle:@"送礼物" forState:UIControlStateNormal];
        [bottomUIV addSubview:profileButton];
        profileButton.titleLabel.textAlignment = UITextAlignmentCenter;
        [profileButton  addTarget:self action:@selector(sendGift) forControlEvents:UIControlEventTouchUpInside];
        profileButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [profileButton   setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        profileButton.frame = CGRectMake(18 + 80 * 3 , 4, 44, 38);
        [profileButton setImageEdgeInsets:UIEdgeInsetsMake(-15, 0, 0, 0)];
        [profileButton    setTitleEdgeInsets:UIEdgeInsetsMake(20, -45, 0, -30)];



        descriptionUL = [[UILabel alloc]  initWithFrame:CGRectMake(0, 20, 44, 20)];
        descriptionUL.backgroundColor = [UIColor clearColor];
        descriptionUL.text = @"送礼物";
        descriptionUL.font = [UIFont systemFontOfSize:13];
        descriptionUL.adjustsFontSizeToFitWidth = true;
        descriptionUL.textAlignment = UITextAlignmentCenter;
        descriptionUL.textColor = [UIColor grayColor];
        [profileButton addSubview:descriptionUL];
        [descriptionUL release];

    }



    hud = [[MBProgressHUD alloc]  initWithView:self.view];
    [self.navigationController.view addSubview:hud];
    [hud release];
}



#pragma mark -



-(void)refreshHeadrView{

    UIView *headerView = [[UIView alloc]  initWithFrame:CGRectMake(0, 0, 320, 80)];
    [profileTableView setTableHeaderView:headerView];
    [headerView release];


    UIImageView *backView = [[UIImageView alloc]  initWithFrame:CGRectMake(9, 9, 64, 64)];
    backView.image = [UIImage imageNamed:@"personimg"];
    [headerView addSubview:backView];
    [backView release];


    //    UIImageView * avatarUIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 62, 62)];
    //    //  avatarUIV.image = [UIImage imageNamed:@"personimg"];
    //    [avatarUIV   setImageWithURL:[NSURL URLWithString:[profileDic  objectForKey:@"avatar"]]];
    //    [headerView addSubview:avatarUIV];
    //    [avatarUIV release];
    //

    avatarUIV = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 62, 62)];
    //  avatarUIV.image = [UIImage imageNamed:@"personimg"];
    [avatarUIV  addTarget:self action:@selector(avatarAction) forControlEvents:UIControlEventTouchUpInside];
    [avatarUIV  setImageWithURL:[NSURL URLWithString:[profileDic  objectForKey:@"avatar"]] forState:UIControlStateNormal];
    // [avatarUIV   setImageWithURL:[NSURL URLWithString:[profileDic  objectForKey:@"avatar"]]];
    [headerView addSubview:avatarUIV];
    [avatarUIV release];

    UILabel *nameUL = [[UILabel alloc]  initWithFrame:CGRectMake(85, 5, 200, 30)];
    nameUL.text = [profileDic  objectForKey:@"uname"];
    nameUL.textColor = [XZWUtil xzwRedColor];
    nameUL.backgroundColor = [UIColor clearColor];
    [nameUL setFont:[UIFont systemFontOfSize:18]];
    [headerView addSubview:nameUL];
    [nameUL release];

    UILabel *idUL = [[UILabel alloc] initWithFrame:CGRectMake(85, 25, 200, 30)];
    idUL.text = [@"ID:"  stringByAppendingString:[profileDic  objectForKey:@"uid"]];
    idUL.backgroundColor = [UIColor clearColor];
    idUL.textColor = [UIColor grayColor];
    [idUL setFont:[UIFont systemFontOfSize:18]];
    [headerView addSubview:idUL];
    [idUL release];

    UIImageView *ageUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(85, 51, 81, 20)];
    ageUIV.image = [UIImage imageNamed:@"const"];
    [headerView addSubview:ageUIV];
    [ageUIV release];


    //♂  ♀

    NSMutableString *ageString = [NSMutableString string];

    if ([[profileDic  objectForKey:@"sex"]  intValue] ==1  ) {

        [ageString  appendFormat:@"♂ %@ %@",[profileDic  objectForKey:@"age"],[[XZWZodiacData getSignArray]  objectAtIndex:  [[profileDic  objectForKey:@"constellation"] intValue]]];

    }else {


        [ageString  appendFormat:@"♀ %@ %@",[profileDic  objectForKey:@"age"],[[XZWZodiacData getSignArray]  objectAtIndex:  [[profileDic  objectForKey:@"constellation"] intValue]]];
    }


    UILabel *ageUL = [[UILabel alloc]   initWithFrame:ageUIV.bounds];
    ageUL.text =  ageString ;
    ageUL.adjustsFontSizeToFitWidth = true;
    ageUL.backgroundColor = [UIColor clearColor];
    ageUL.textColor = [UIColor whiteColor];
    [ageUIV  addSubview:ageUL];
    [ageUL release];


}

#pragma mark - giftaction


-(void)sendGift{


    XZWGiftListViewController *giftVC = [[XZWGiftListViewController alloc]  initWithName:[profileDic  objectForKey:@"uname"] andUser:[[profileDic  objectForKey:@"uid"]  intValue]];
    [self.navigationController pushViewController:giftVC animated:true];
    [giftVC release];

}

-(void)giftAction:(UIButton*)sender{

    XZWSendGiftViewController *sendGift = [[XZWSendGiftViewController alloc]  initWithName:[profileDic  objectForKey:@"uname"] andUser:userID];
    [self.navigationController pushViewController:sendGift animated:true];
    [sendGift release];


}

-(void)avatarAction{


    GoodsGalleryViewController *ggvc = [[GoodsGalleryViewController alloc]  initWithPhotoOneArrayFullLinkArray:@[[profileDic  objectForKey:@"avatar"]] page:0];
    [self.navigationController presentModalViewController:ggvc animated:true];
    [ggvc release];



    //    if (!isNotSelf) {
    //
    //
    //
    //    }else {
    //
    //
    //
    //    }
    //

}


#pragma mark -

// 点击相片
-(void)selectButton:(XZWButton*)sender {

    if (sender.buttonTag == 3) {

        XZWAblumViewController *avc = [[XZWAblumViewController alloc]  initWithUserID:userID];
        [self.navigationController pushViewController:avc animated:true];
        [avc release];

    } else {

        GoodsGalleryViewController *goodsGVC = [[GoodsGalleryViewController alloc]  initWithPhotoArray:ablumArray page:sender.buttonTag];
        [self.navigationController presentModalViewController:goodsGVC animated:true];
        [goodsGVC release];
    }
}


#pragma mark -

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UIImageView *tempView = [[[UIImageView alloc]   initWithFrame:CGRectMake(0, 0, 320, 24)]  autorelease];
    tempView.backgroundColor =  [UIColor clearColor];
    UILabel *tempUL = [[UILabel alloc]   initWithFrame:tempView.bounds];

    if (section == 0) {

        [tempUL setText:@"   "];

    }else if (section == 1){

        [tempUL setText:@"   相册"];

    }else if (section == 3){

        [tempUL setText:@"   收到的礼物"];

    }else  if (section == 2){

        [tempUL setText:@"   资料"];

    }else{

        [tempUL setText:@"   兴趣知识"];
    }



    tempUL.font = [UIFont boldSystemFontOfSize:15];
    // tempUL.shadowColor = [[UIColor blackColor]  colorWithAlphaComponent:.5f];
    // tempUL.shadowOffset = CGSizeMake(1 , -1);
    [tempUL setBackgroundColor:[UIColor clearColor]];
    [tempUL setTextColor:[UIColor grayColor]];
    [tempView addSubview:tempUL];
    [tempUL release];


    return tempView ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section == 0) {
        return  0 ;
    }


    return  25.f;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    int    height = 0.f;

    switch (indexPath.section) {
        case 0:
        {

            height = 37.f;

        }
            break;
        case 1:   {

            height = 76.f;

        }
            break;

        case 3:
        {

            height = 96.f;

        }
            break;


        case 2:
        {

            height = 37.f;


            switch (indexPath.row) {
                case 3:
                {

                    UILabel *resultUL = [[[UILabel alloc]   initWithFrame:CGRectMake(80, 0, 220, 37)]  autorelease];
                    resultUL.backgroundColor = [UIColor clearColor];
                    resultUL.textAlignment = UITextAlignmentLeft;
                    resultUL.textColor = [XZWUtil xzwRedColor];
                    resultUL.frame = CGRectMake(80, 10, 210, 37);
                    resultUL.numberOfLines = 0 ;
                    resultUL.text = [profileDic  objectForKey:@"intro"];
                    [resultUL  sizeThatFits:CGSizeMake(210, 1037)];
                    [resultUL sizeToFit];

                    height = CGRectGetMaxY(resultUL.frame) + 10 ;

                    if (height < 37 ) {

                        height = 37;
                    }

                }
                    break;

                default:
                    break;
            }

        }
            break;

        default:
        {

            height = 37.f;
        }
            break ;

    }



    return  height;
}

// 未搞懂？？？？
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 4) {

        XZWKnowledgeMoreDetailViewController *moreDetail = [[XZWKnowledgeMoreDetailViewController alloc]   initKnowledgeDic:@{@"name":@"收藏",@"id":knowledgeArray[indexPath.row][@"art_id"]}];
        [self.navigationController pushViewController:moreDetail animated:true];
        [moreDetail release];

    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([knowledgeArray  count] > 0 ) {
        return 5;
    }


    return 4;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int rows  = 0 ;

    switch (section) {
        case 0:
        {
            rows = 2;
        }
            break;
        case 1:
        {
            rows = 1;

        }
            break;

        case 2:
        {
            rows = 4;

        }
            break;
        case 3:
        {
            rows = 1;

        }
            break;

        default:
        {
            rows = [knowledgeArray count];
        }
            break;
    }

    return rows ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

#define AlbumCell_NoPictureTip 363

    // 相册
    if (indexPath.section == 1 ) {

        static NSString *CellIdentifier = @"AblumCell";

        UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {

            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];

            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone ;

            UILabel *tipsUL = [[UILabel alloc]  initWithFrame:CGRectMake(0, 0, 300, 76)];
            tipsUL.tag = AlbumCell_NoPictureTip;
            tipsUL.textAlignment = UITextAlignmentCenter;
            tipsUL.text = @"该用户还未上传照片";
            tipsUL.textColor = [UIColor grayColor];
            tipsUL.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:tipsUL];
            [tipsUL release];


            for (int i = 0 ; i < 4 ; i++) {

                XZWButton *button = [XZWButton buttonWithType:UIButtonTypeCustom];
                button.frame =  CGRectMake(8 + 75 * i, 8, 60, 60);
                button.buttonTag = i;
                button.imageView.contentMode = UIViewContentModeScaleAspectFill;
                [button addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = i + 1;
                [cell.contentView addSubview:button];


                if (i == 3) {
                    UILabel *seeMore = [[UILabel alloc]  initWithFrame:CGRectMake(0, 40, 60, 20)];
                    seeMore.backgroundColor = [[UIColor blackColor]  colorWithAlphaComponent:.5f];
                    seeMore.text = @"查看更多";
                    seeMore.font = [UIFont systemFontOfSize:12];
                    seeMore.textColor = [UIColor whiteColor];
                    seeMore.textAlignment = UITextAlignmentCenter;
                    [button addSubview:seeMore];
                    [seeMore release];
                }
            }
        }


        if ([ablumArray  count]  ==  0 ) {

            [cell.contentView viewWithTag:AlbumCell_NoPictureTip].hidden = false;

        } else {

            [cell.contentView viewWithTag:AlbumCell_NoPictureTip].hidden = true;
        }

        for (int i = 0 ; i < 4 ; i++) {

            XZWButton *button = (XZWButton *)[cell.contentView  viewWithTag:i + 1];


            if ([ablumArray count] > i) {

                [button   setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@data/upload/%@",XZWHost,[[[[ablumArray  objectAtIndex:i]  objectForKey:@"savepath"] stringByReplacingOccurrencesOfString:@".jpg" withString:@"_200_200.jpg"]  stringByReplacingOccurrencesOfString:@".png" withString:@"_200_200.png"]]] forState:UIControlStateNormal];
                button.hidden = false;

            } else {

                button.hidden = true;
            }
        }


        return cell;
    }

    // 收到的礼物
    else if (indexPath.section == 3 ) {

        static NSString *CellIdentifier = @"GiftCell";

        UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {

            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];

            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone ;

            UILabel *tipsUL = [[UILabel alloc]  initWithFrame:CGRectMake(0, 0, 300, 96)];
            tipsUL.tag = 363;
            tipsUL.textAlignment = UITextAlignmentCenter;
            tipsUL.text = @"该用户还未收到礼物";
            tipsUL.font = [UIFont systemFontOfSize:17];
            tipsUL.textColor = [UIColor grayColor];
            tipsUL.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:tipsUL];
            [tipsUL release];


            for (int i = 0 ; i < 4 ; i++) {

                //                XZWButton *button = [XZWButton buttonWithType:UIButtonTypeCustom];
                //                button.frame =  CGRectMake(8 + 75 * i, 8, 60, 60);
                //                button.buttonTag = i;
                //                button.imageView.contentMode = UIViewContentModeScaleAspectFill;
                //                [button addTarget:self action:@selector(giftAction:) forControlEvents:UIControlEventTouchUpInside];
                //                button.tag = i + 1;
                //                button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
                //                [cell.contentView addSubview:button];
                //





                UIImageView *button = [[UIImageView alloc] initWithFrame:CGRectMake(8 + 75 * i, 8, 60, 60)];
                button.tag = i + 1;
                [cell .contentView addSubview:button];
                [button release];

                UIButton *tapButton = [UIButton buttonWithType:UIButtonTypeCustom];
                tapButton.frame = button.frame ;
                [tapButton  addTarget:self action:@selector(giftAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:tapButton];


                UILabel *nameUL = [[UILabel alloc]  initWithFrame:CGRectMake(0, 60, 60, 20)];
                nameUL.tag = 444;
                nameUL.font = [UIFont systemFontOfSize:14];
                nameUL.textAlignment = UITextAlignmentCenter;
                nameUL.textColor = [XZWUtil xzwRedColor];
                nameUL.adjustsFontSizeToFitWidth = true;
                [nameUL setBackgroundColor:[UIColor clearColor]];
                [button addSubview:nameUL];
                [nameUL release];


                //                if (i == 3) {
                //
                //
                //                    UILabel *seeMore = [[UILabel alloc]  initWithFrame:CGRectMake(0, 40, 60, 20)];
                //                    seeMore.backgroundColor = [[UIColor blackColor]  colorWithAlphaComponent:.5f];
                //                    seeMore.text = @"查看更多";
                //                    seeMore.font = [UIFont systemFontOfSize:12];
                //                    seeMore.textColor = [UIColor whiteColor];
                //                    seeMore.textAlignment = UITextAlignmentCenter;
                //                    [button addSubview:seeMore];
                //                    [seeMore release];
                //
                //                }
                //

            }
        }



        if ([giftArray  count]  ==  0 ) {

            [cell.contentView viewWithTag:363].hidden = false;

        } else {

            [cell.contentView viewWithTag:363].hidden = true;
        }

        for (int i = 0 ; i < 4 ; i++) {

            //            XZWButton *button = (XZWButton *)[cell.contentView  viewWithTag:i + 1];


            UIImageView *button = (UIImageView *)[cell.contentView  viewWithTag:i + 1];

            UILabel *nameUL = (UILabel *)[button  viewWithTag: 444];

            if ([giftArray count] > i) {



                //[button   setImage:nil forState:UIControlStateNormal ];

                // [button   setBackgroundImage:nil forState:UIControlStateNormal ];

                //                [button   setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@apps/gift/Tpl/default/Public/gift/%@",XZWHost,[[giftArray  objectAtIndex:i]  objectForKey:@"giftImg"]]] forState:UIControlStateNormal];
                //


                [button setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@apps/gift/Tpl/default/Public/gift/%@",XZWHost,[[giftArray  objectAtIndex:i]  objectForKey:@"giftImg"]]]];


                [nameUL  setText:[[giftArray  objectAtIndex:i]  objectForKey:@"giftName"]];


                button.hidden = false;

            }else {

                button.hidden = true;
            }


        }


        return cell;
    }

    else if (indexPath.section == 2  || indexPath.section == 0) {

        static NSString *CellIdentifier = @"Cell";

        UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];


            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone ;

            cell.backgroundColor = [UIColor whiteColor];


            UILabel *resultUL = [[UILabel alloc]   initWithFrame:CGRectMake(80, 0, 220, 37)];
            resultUL.backgroundColor = [UIColor clearColor];
            resultUL.tag = 8;
            resultUL.textAlignment = UITextAlignmentRight;
            resultUL.textColor = [XZWUtil xzwRedColor];
            [cell.contentView addSubview:resultUL];
            [resultUL release];

            // left
            resultUL = [[UILabel alloc]   initWithFrame:CGRectMake(10, 0, 220, 37)];
            resultUL.backgroundColor = [UIColor clearColor];
            resultUL.tag = 9;
            resultUL.font = [UIFont boldSystemFontOfSize:15];
            resultUL.textColor = [XZWUtil xzwRedColor];
            [cell.contentView addSubview:resultUL];
            [resultUL release];
        }

        UILabel *leftUL =    (UILabel *)[cell.contentView viewWithTag:9];
        leftUL.textColor = [UIColor grayColor];
        UILabel *resultUL = (UILabel *)[cell.contentView viewWithTag:8];
        resultUL.frame = CGRectMake(80, 0, 210, 37);
        resultUL.textAlignment = UITextAlignmentRight;

        switch (indexPath.section) {

                // setion 0
            case 0:
            {
                switch (indexPath.row) {
                    case 0:
                    {
                        leftUL.text = @"魅力";
                        resultUL.text = [[profileDic  objectForKey:@"charm"]  description];
                    }
                        break;

                    default:
                    {
                        leftUL.text = @"财富";
                        resultUL.text = [[profileDic  objectForKey:@"score"]  description];
                    }
                        break;
                }
            }
                break;

                // setion 2，“资料”
            case 2:
            {
                switch (indexPath.row) {
                    case 0:
                    {
                        leftUL.text = @"婚恋状态";

                        switch ([[profileDic  objectForKey:@"relationship_status"] intValue]) {
                            case 0:
                            {
                                resultUL.text = @"保密";
                            }
                                break;

                            case 1:
                            {
                                resultUL.text = @"单身";
                            }
                                break;

                            case 2:
                            {
                                resultUL.text = @"恋爱";
                            }
                                break;

                            case 3:
                            {
                                resultUL.text = @"已婚";
                            }
                                break;

                            case 4:
                            {
                                resultUL.text = @"离婚";
                            }
                                break;

                            default:
                            {
                                resultUL.text = @"未婚";
                            }
                                break;
                        }

                    }
                        break;

                    case 1:
                    {
                        leftUL.text = @"血型";

                        switch ([[profileDic  objectForKey:@"blood_type"] intValue]) {
                            case 0:{

                                resultUL.text = @"保密";
                            }
                                break;
                            case 1:{


                                resultUL.text = @"A型";
                            }
                                break;
                            case 2:{


                                resultUL.text = @"B型";
                            }
                                break;

                            case 3:{


                                resultUL.text = @"AB型";
                            }
                                break;
                            case 4:{


                                resultUL.text = @"O型";
                            }
                                break;

                            default:{

                                resultUL.text = @"S型";

                            }
                                break;
                        }
                    }
                        break;

                    case 2:
                    {
                        leftUL.text = @"位置";
                        resultUL.text = [[profileDic  objectForKey:@"location"]  description];


                        // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator ;
                        //  resultUL.frame = CGRectMake(0, 0, 270, 37);
                    }
                        break;

                    default:
                    {
                        leftUL.text = @"个性签名";

                        resultUL.frame = CGRectMake(80, 10, 210, 37);
                        resultUL.text = [profileDic  objectForKey:@"intro"];
                        resultUL.numberOfLines = 0 ;
                        resultUL.textAlignment = UITextAlignmentLeft;
                        [resultUL  sizeThatFits:CGSizeMake(210, 1037)];
                        [resultUL sizeToFit];

                        if (CGRectGetHeight(resultUL.frame) < 30) {

                            resultUL.frame = CGRectMake(290 - CGRectGetWidth(resultUL.frame), 10, CGRectGetWidth(resultUL.frame), CGRectGetHeight(resultUL.frame));
                        }

                    }
                        break;
                }

            }
                break;

            default:
            {

            }
                break;
        }


        return cell;
    }

    else if (indexPath.section == 4 ) {
        static NSString *CellIdentifier = @"CollectionCell";

        UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];

            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.textColor = [UIColor grayColor];

            cell.backgroundColor = [UIColor whiteColor];
        }

        cell.textLabel.text = [ [knowledgeArray objectAtIndex:indexPath.row][@"art_title"] description] ;


        return cell;

    } else {

        return nil;
    }
}

#pragma mark -

- (IBAction)launchController
{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"uploadLimit" ];

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

- (void)launchSpecialController
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    self.specialLibrary = library;
    [library release];
    NSMutableArray *groups = [NSMutableArray array];
    [_specialLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [groups addObject:group];
        } else {
            // this is the end
            [self displayPickerForGroup:[groups objectAtIndex:0]];
        }
    } failureBlock:^(NSError *error) {
        self.chosenImages = nil;
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Album Error: %@ - %@", [error localizedDescription], [error localizedRecoverySuggestion]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        NSLog(@"A problem occured %@", [error description]);
        // an error here means that the asset groups were inaccessable.
        // Maybe the user or system preferences refused access.
    }];
}

- (void)displayPickerForGroup:(ALAssetsGroup *)group
{
	ELCAssetTablePicker *tablePicker = [[ELCAssetTablePicker alloc] initWithNibName: nil bundle: nil];
    tablePicker.singleSelection = YES;
    tablePicker.immediateReturn = YES;
    
	ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initWithRootViewController:tablePicker];
    elcPicker.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    elcPicker.navigationBar.tintColor = [UIColor blackColor];
    elcPicker.delegate = self;
	tablePicker.parent = elcPicker;
    
    // Move me
    tablePicker.assetGroup = group;
    [tablePicker.assetGroup setAssetsFilter:[ALAssetsFilter allAssets]];
    
    [self presentViewController:elcPicker animated:YES completion:nil];
    [tablePicker release];
    [elcPicker release];
}



#pragma mark -

#pragma mark ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
    
	for(NSDictionary *dict in info) {
        
        UIImage *
        
        image = [dict objectForKey:UIImagePickerControllerEditedImage];
        
        if (!image){
            image = [dict objectForKey:UIImagePickerControllerOriginalImage];
        }
        
        if (image) {
            
            [images addObject:([XZWUtil getRightUIImage:image] )];
        }
        
        
	}
    
    self.chosenImages = images;
    
    
    
    if ([self.chosenImages  count] == 0) {
        
        
        
        
        return ;
    }
    
    
    
    
    __block int uploadedSuccess = 0;
    
    __block int uploadImage = 0 ;
    
    
    hud.labelText =  @"上传中..." ;
    [hud show:true];
    
    
    
    
    for (UIImage *oneImage  in self.chosenImages) {
        
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:XZWUploadToAlbum]];
        [request  addRequestHeader:@"User-Agent" value:@"Shockwave Flash"];
        
        
        NSMutableString *cookieString = [NSMutableString string];
        
        
        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in [cookieJar cookies]) {
            
            if ([cookie.name   isEqualToString:@"PHPSESSID"]) {
                
                [cookieString   appendFormat: @"%@=%@;",cookie.name,cookie.value];
            }
            
            
            
        }
        [request  addData:UIImageJPEGRepresentation(oneImage,1.f) withFileName:@"111.jpg" andContentType:@"image/jpeg" forKey:@"Filedata"  ];
        
        [request  addRequestHeader:@"Cookie" value:cookieString];
        
        
        
        
        [request setRequestMethod:@"POST"];
        
        [request startAsynchronous];
        
        [request setCompletionBlock:^{
            
            
            uploadImage ++ ;
            
            
            
            if ([[[[request responseString]   objectFromJSONString] objectForKey:@"status"] intValue]  == 1 ) {
                
                
                uploadedSuccess ++;
                
            }else {
                
                
            }
            
            
            
            if (uploadImage == [self.chosenImages count] ) {
                
                hud.labelText =  [self.chosenImages count] -  uploadedSuccess ==0 ? [NSString stringWithFormat:@"成功上传%d张图片",uploadedSuccess ] :  [NSString stringWithFormat:@"成功上传%d张图片失败%d张",uploadedSuccess, [self.chosenImages count] -  uploadedSuccess ] ;
                [hud hide:true afterDelay:1.f];
                
                
                [self loadAblum];
                
            }
            
            
            ;}];
        
        [request setFailedBlock:^{
            
            uploadImage ++ ;
            
            
            if (uploadImage == [self.chosenImages count] ) {
                
                hud.labelText =  [self.chosenImages count] -  uploadedSuccess ==0 ? [NSString stringWithFormat:@"成功上传%d张图片",uploadedSuccess ] :  [NSString stringWithFormat:@"成功上传%d张图片失败%d张",uploadedSuccess, [self.chosenImages count] -  uploadedSuccess ] ;
                [hud hide:true afterDelay:1.f];
                
                [self loadAblum];
                
            }
            
            
        }];
        
        
    }
    
    
    
    
    
    ////////
    //
    //    /*
    // //   for (UIImage *oneImage  in self.chosenImages) {
    //
    //       tempRequest =  [XZWNetworkManager asiWithLink:XZWUploadImage postDic:nil imageData:UIImagePNGRepresentation(self.chosenImages[0]) andImageKey:@"Filedata" completionBlock:^{
    //
    //
    //            uploadImage ++ ;
    //
    //           NSLog(@"%@",[tempRequest responseString]);
    //
    //
    //            if ([[[[tempRequest responseString]   objectFromJSONString] objectForKey:@"status"] intValue]  == 1 ) {
    //
    //
    //                uploadedSuccess ++;
    //
    //            }else {
    //
    //                uploadedSuccess --;
    //
    //            }
    ////
    //            if (uploadImage == [self.chosenImages count] ) {
    //
    //                 hud.labelText =  [NSString stringWithFormat:@"上传成功 %d 失败 %d...",uploadedSuccess, [self.chosenImages count] -  uploadedSuccess ] ;
    //                 [hud hide:true];
    //
    //
    //            }
    //
    //           /*
    //           [XZWNetworkManager cancelAndReleaseRequest:tempRequest];
    //           */
    //
    //        } failedBlock:^{
    //
    //            /*
    //            uploadImage ++ ;
    //
    //
    //            if (uploadImage == [self.chosenImages count] ) {
    //
    ////                hud.labelText =  [NSString stringWithFormat:@"上传成功 %d 失败 %d...",uploadedSuccess, [self.chosenImages count] -  uploadedSuccess ] ;
    ////                [hud hide:true];
    //                
    //                
    //            }
    //
    //            
    //            [XZWNetworkManager cancelAndReleaseRequest:tempRequest];
    //            */
    //        }];
    //        
    //        
    //   // }
    
    
    
    
    
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
