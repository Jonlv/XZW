//
//  XZWCustomSkinViewController.m
//  XZW
//
//  Created by dee on 13-9-13.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWCustomSkinViewController.h"
#import "IIViewDeckController.h"
#import "XZWUtil.h"
#import "SPUserResizableView.h"
#import <QuartzCore/QuartzCore.h>
#import "Interface.h"

@interface XZWCustomSkinViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,SPUserResizableViewDelegate>{
    
    
    UIImageView     *grayMainUIV;
    
    UIImageView     *brightUIV;
    
    UIImageView    *clipsUIV;
    
    
    SPUserResizableView *imageResizableView;
    UIView *uv;
    
}

@end

@implementation XZWCustomSkinViewController

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
    

    
    self.title = @"选择皮肤";
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];
    
    
    
     
    
    listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self action:@selector(confirmSkin) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"option"] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];
    
    
    
    
    grayMainUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(0, 0, 320, TotalScreenHeight - 64)];
  //  grayMainUIV.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:grayMainUIV];
    [grayMainUIV release];
    
    UIView *grayView = [[UIView alloc]   initWithFrame:grayMainUIV.bounds];
    grayView.backgroundColor = [[UIColor blackColor]  colorWithAlphaComponent:.5f];
    [grayMainUIV addSubview:grayView];
    [grayView release];
    
     
    
    
    clipsUIV = [[UIImageView alloc]   initWithFrame:grayMainUIV.bounds];
    [clipsUIV    setClipsToBounds:true];
    [self.view addSubview:clipsUIV];
    [clipsUIV release];
    
    
    brightUIV = [[UIImageView alloc]  initWithImage:[UIImage imageNamed:nil]];
    brightUIV.frame = CGRectMake(0, 0, 320, TotalScreenHeight - 64);
    [clipsUIV  addSubview:brightUIV];
    [brightUIV release];
    
    
    imageResizableView = [[SPUserResizableView alloc] initWithFrame:CGRectMake(10, 10, 320  , 165.f )];
    
    uv = [[UIView alloc]  initWithFrame:CGRectMake(-10, -10, 340, TotalScreenHeight-64 +20)];
   // uv.backgroundColor = [[UIColor blackColor]  colorWithAlphaComponent:.5f];
    [self.view addSubview:uv];
    [uv release];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:nil];
    imageResizableView.contentView = imageView;
    imageResizableView.delegate = self;
    [uv addSubview:imageResizableView];
    [imageView release]; [imageResizableView release];
    imageView.image = nil;
    
      
    [self showPicker];
}

-(void)confirmSkin{
    
    [UIImagePNGRepresentation( [self resizeImage] ) writeToFile:[[XZWUtil getMyPath] stringByAppendingPathComponent:@"skin.png" ] atomically:true];
    
    [[NSUserDefaults standardUserDefaults]   setInteger:  - 1 forKey:@"Skin"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:XZWChangeSkinNotification object:nil];
    
    [self.navigationController popToRootViewControllerAnimated:true];
    
}


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



-(UIImage *)resizeImage
{
    
    //CGRectMake(0,0,newSize.width,newSize.height)
//    CGSize newSize;
//    newSize.width =  CGRectGetWidth(imageResizableView.frame);
//    newSize.height = CGRectGetHeight(imageResizableView.frame);
//    UIGraphicsBeginImageContext(newSize);
//    [brightUIV.image drawInRect: imageResizableView.frame ];
//    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    
//    UIGraphicsBeginImageContext(imageResizableView.frame.size);//根据size大小创建一个基于位图的图形上下文
//    CGContextRef currentContext = UIGraphicsGetCurrentContext();//获取当前quartz 2d绘图环境
//    CGContextClipToRect( currentContext, imageResizableView.frame);//设置当前绘图环境到矩形框
//    
//    CGContextDrawImage(currentContext, imageResizableView.frame, brightUIV.image.CGImage);//绘图
//    UIImage *cropImage = UIGraphicsGetImageFromCurrentImageContext();//获得图片
//    UIGraphicsEndImageContext();//从当前堆栈中删除quartz 2d绘图环境
//    
    
 //   CGImageGetWidth(brightUIV.image);
    
    
    
    
    
//    UIGraphicsBeginImageContext(CGSizeMake(brightUIV.frame.size.width , brightUIV.frame.size.height ));
//    
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    // Clear whole thing
//    CGContextClearRect(ctx, brightUIV.bounds);
//    
//    // Add your code to create rounded rectangle clipping region
//    
//    // Draw view into context
//    [brightUIV.layer renderInContext:ctx];
//    
//    UIImage *smallUIV = UIGraphicsGetImageFromCurrentImageContext();
    
    
    
    UIImage *cropImage = nil;
    
    brightUIV.image = [self imageByRotatingImage:brightUIV.image fromImageOrientation:brightUIV.image.imageOrientation];
    
    
    
    CGFloat imageWidth = CGImageGetWidth(brightUIV.image.CGImage);
    CGFloat imageHeight = CGImageGetHeight(brightUIV.image.CGImage);
    
         
    
    
    cropImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([brightUIV.image CGImage],  CGRectMake((imageResizableView.frame.origin.x   *   imageWidth / CGRectGetWidth(brightUIV.frame)     ) , (imageResizableView.frame.origin.y   * imageHeight / CGRectGetHeight(brightUIV.frame)    ) , ((imageResizableView.frame.size.width  - 20 ) *  imageWidth / CGRectGetWidth(brightUIV.frame)      ) , ((((imageResizableView.frame.size.width  - 20 ) *  imageWidth / CGRectGetWidth(brightUIV.frame)      ) * 155.f /320 ))  )  )];
    
    
//    if (IS_retina) {
//        
//         cropImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([brightUIV CGImage],  CGRectMake((imageResizableView.frame.origin.x  ) * 2, (imageResizableView.frame.origin.y  ) * 2, (imageResizableView.frame.size.width  -20) * 2, (imageResizableView.frame.size.height -0) * 2)  )];
//        
//        
//    }else{
//        
//        cropImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([smallUIV CGImage], CGRectMake((imageResizableView.frame.origin.x ) , (imageResizableView.frame.origin.y  ) , (imageResizableView.frame.size.width  -20) , (imageResizableView.frame.size.height -0)))];
//    }
    
    
    
//    UIGraphicsEndImageContext();
//
    
    return cropImage;
}

-(void)showPicker{
    
    
    NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
   
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
    
    imagePickerController.allowsEditing = false;
    
    imagePickerController.sourceType = sourceType;
    
    [self.navigationController presentViewController:imagePickerController animated:YES completion:^{}];
    
    [imagePickerController release];
    
    
}



#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    
	[picker dismissViewControllerAnimated:YES completion:^{
    
        
        
        }];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // [UIImage imageNamed:@"Default"]; //
    
    CGFloat imageWidth = CGImageGetWidth(image.CGImage);
    CGFloat imageHeight = CGImageGetHeight(image.CGImage);
    
    NSLog(@"imageWidth %f imageHeight %f",imageWidth,imageHeight);
    
    if (imageWidth < 320 || imageHeight < 155) {
        
        [[[[UIAlertView alloc]  initWithTitle:nil message:@"图片尺寸太小,请重新选择" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease]  show];
         
        [self.navigationController popViewControllerAnimated:true];

        
        return ;
        
    }
    
    
    
    
    [grayMainUIV  setImage:image];
    
    
    
    
    grayMainUIV.frame = CGRectMake(0, 0, 320,  320 * imageHeight  / imageWidth  );
    
    
    uv.frame =    CGRectMake(-10, -10, 340, CGRectGetHeight(grayMainUIV.frame) +20);
    
    
    
   // grayMainUIV.center = CGPointMake( 160, (TotalScreenHeight - 64 )/ 2)  ;
    
    
         
    [brightUIV setImage:image];
    
     
    
//    clipsUIV.frame = CGRectMake(0, 0, 320, 155);
//    
//    brightUIV.frame = grayMainUIV.frame ;
   
    
    [imageResizableView  showEditingHandles];
    
    
    
    ////
    
    clipsUIV.frame =  CGRectMake(CGRectGetMinX(imageResizableView.frame) + 10 -10, CGRectGetMinY(imageResizableView.frame)+10 -10, CGRectGetWidth(imageResizableView.frame) - 20, CGRectGetHeight(imageResizableView.frame) -20 );
    
    brightUIV.frame = CGRectMake(-CGRectGetMinX(clipsUIV.frame), -CGRectGetMinY(clipsUIV.frame), CGRectGetWidth(grayMainUIV.frame), CGRectGetHeight(grayMainUIV.frame) );
    
    //
     
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissViewControllerAnimated:YES completion:^{
    
        [self.navigationController popViewControllerAnimated:true];
        
    }];
}
 
#pragma mark -

- (void)userResizableViewDidBeginEditing:(SPUserResizableView *)userResizableView {
    
  
//    [currentlyEditingView hideEditingHandles];
//    currentlyEditingView = userResizableView;
}

- (void)userResizableViewDidEndEditing:(SPUserResizableView *)userResizableView {
   // lastEditedView = userResizableView;
    
    // largeUIV.frame = userResizableView.frame ;
    
    // clipsUIV.frame = userResizableView.frame;
    
    
    clipsUIV.frame =  CGRectMake(CGRectGetMinX(userResizableView.frame) + 10 -10, CGRectGetMinY(userResizableView.frame)+10 -10, CGRectGetWidth(userResizableView.frame) - 20, CGRectGetHeight(userResizableView.frame) -20 );
    
    brightUIV.frame = CGRectMake(-CGRectGetMinX(clipsUIV.frame), -CGRectGetMinY(clipsUIV.frame), CGRectGetWidth(grayMainUIV.frame), CGRectGetHeight(grayMainUIV.frame));
    
   
    
}


-(void)userResizableViewDidMoving:(SPUserResizableView *)userResizableView{
    
    
    //  largeUIV.frame = userResizableView.frame ;
    
    clipsUIV.frame =  CGRectMake(CGRectGetMinX(userResizableView.frame) + 10 -10, CGRectGetMinY(userResizableView.frame)+10 -10, CGRectGetWidth(userResizableView.frame) - 20, CGRectGetHeight(userResizableView.frame) -20 );
    brightUIV.frame = CGRectMake(-CGRectGetMinX(clipsUIV.frame), -CGRectGetMinY(clipsUIV.frame), CGRectGetWidth(grayMainUIV.frame), CGRectGetHeight(grayMainUIV.frame));
    
    
    
}

#pragma mark - 


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
