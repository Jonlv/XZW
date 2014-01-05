//
//  XZWUtil.m
//  XZW
//
//  Created by Dee on 13-8-23.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWUtil.h"

#define SmallImageSize  ( 1024.f * 50.f )


@interface UIImage (RotationMethods)
//- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
@end

@implementation UIImage (RotationMethods)


/*
float RadiantoDegree(float radian)
{
	return ((radian / M_PI) * 180.0f);
}

float DegreetoRadian(float degree)
{
	return ((degree / 180.0f) * M_PI);
}


- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreetoRadian(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, DegreetoRadian(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}
*/
@end

@implementation XZWUtil


+(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    
    return html;
}


+ (NSString *)stringByEscapingXML:(NSString*)theString
{
	NSMutableString *escapedString = [[theString mutableCopy] autorelease];
	[escapedString replaceOccurrencesOfString:@"\"" withString:@"&quot;" options:0 range:NSMakeRange(0, [escapedString length])];
	[escapedString replaceOccurrencesOfString:@"'" withString:@"&apos;" options:0 range:NSMakeRange(0, [escapedString length])];
	[escapedString replaceOccurrencesOfString:@"<" withString:@"&lt;" options:0 range:NSMakeRange(0, [escapedString length])];
	[escapedString replaceOccurrencesOfString:@">" withString:@"&gt;" options:0 range:NSMakeRange(0, [escapedString length])];
	[escapedString replaceOccurrencesOfString:@"&" withString:@"&amp;" options:0 range:NSMakeRange(0, [escapedString length])];
	return escapedString;
}

+ (NSString *)stringByUnescapingXML:(NSString*)theString
{
	NSMutableString *unescapedString = [[theString mutableCopy] autorelease];
	[unescapedString replaceOccurrencesOfString:@"&amp;" withString:@"&" options:0 range:NSMakeRange(0, [unescapedString length])];
	[unescapedString replaceOccurrencesOfString:@"&quot;" withString:@"\"" options:0 range:NSMakeRange(0, [unescapedString length])];
	[unescapedString replaceOccurrencesOfString:@"&apos;" withString:@"'" options:0 range:NSMakeRange(0, [unescapedString length])];
	[unescapedString replaceOccurrencesOfString:@"&lt;" withString:@"<" options:0 range:NSMakeRange(0, [unescapedString length])];
	[unescapedString replaceOccurrencesOfString:@"&gt;" withString:@">" options:0 range:NSMakeRange(0, [unescapedString length])];
	return unescapedString;
}


/*
 
+ (UIImage *)fixOrientationImage:(UIImage*)initImage {
    
    // No-op if the orientation is already correct
    if (initImage.imageOrientation == UIImageOrientationUp) return initImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (initImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, initImage.size.width, initImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, initImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, initImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (initImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, initImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, initImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, initImage.size.width, initImage.size.height,
                                             CGImageGetBitsPerComponent(initImage.CGImage), 0,
                                             CGImageGetColorSpace(initImage.CGImage),
                                             CGImageGetBitmapInfo(initImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (initImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,initImage.size.height,initImage.size.width), initImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,initImage.size.width,initImage.size.height), initImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
*/

+(UIImage*)imageByRotatingImage:(UIImage*)initImage  
{
    CGImageRef imgRef = initImage.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient =  initImage.imageOrientation;
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
    
    /*
    
      CGFloat scaleRatio = 1;  
    
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
     
     */
    
}


+(UIImage*)getRightUIImage:(UIImage*)largeImage{
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"XZWHighQuality"]) {
        
        
        
        return [XZWUtil convertToSmallSizeFromUIImage:largeImage];
        
    }else {
        
        NSData  *data =  UIImageJPEGRepresentation(largeImage, 1.f);
        
//        UIImage *targetImage = [UIImage imageWithData:data ];
//        
//        data = UIImagePNGRepresentation(targetImage);
        
        
        return [UIImage imageWithData:data ];
    }
    
}


+(UIImage*)convertToSmallSizeFromUIImage:(UIImage*)largeImage{
    
    NSData  *data =  UIImageJPEGRepresentation(largeImage, 1.f);
    
    
    
    NSInteger size = data.length;
    
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSLog(@"size %d",size);
    
    UIImage *targetImage = nil;
    
    
    if ([data length] > SmallImageSize) {
        
        while ([data length] > SmallImageSize && compression > maxCompression)
        {
            compression -= 0.1;
            data = UIImageJPEGRepresentation(largeImage, compression);
        }
        
    }
    
    
    
    
    
//    if (size >  SmallImageSize ) {
//        
//        float ratio = SmallImageSize / size ;
//        
//        targetImage = [UIImage imageWithData:UIImageJPEGRepresentation(largeImage, ratio) ];
//        
//        NSLog(@"ratio %f",ratio);
//        
//    }else {
//        
//        targetImage = largeImage;
//    }
//    
    
    targetImage = [UIImage imageWithData:data ];
    
    data =  UIImageJPEGRepresentation(targetImage, 1.f);
    
   // data = UIImagePNGRepresentation(targetImage);
    
    size = data.length;

    NSLog(@"last-> %d",size);
    
    return targetImage;
}

+(NSString*)getDataBase{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"XZW.db"];
     
    NSLog(@"dbPath %@",dbPath);
    return dbPath;
}


+(NSString*)getMyPath{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [paths objectAtIndex:0];
     
    
    return documentDirectory;
}


+(NSArray*)findAstro:(NSString*)dateString{
     
    
    int d = [dateString intValue];
    
    NSArray *astroArray = @[@[@"0321",@"0420",@"白羊座"], @[@"0421",@"0521",@"金牛座"],  @[@"0522",@"0621",@"双子座"], @[@"0622",@"0722",@"巨蟹座"], @[@"0723",@"0822",@"狮子座"], @[@"0823",@"0923",@"处女座"], @[@"0924",@"1023",@"天秤座"], @[@"1024",@"1122",@"天蝎座"], @[@"1123",@"1221",@"射手座"], @[@"1222",@"1231",@"摩羯座"], @[@"0101",@"0120",@"摩羯座"],
                            @[@"0121",@"0219",@"水瓶座"], @[@"0220",@"0320",@"双鱼座"]  ];
    
    
    
    for (int i = 0; i < [astroArray count]; i++) {
        
         
        
		if (d >= [astroArray[i][0] intValue] && d <= [astroArray[i][1] intValue]) {
            
            
			int said=(i>9?i -1 :i);
			return @[[NSNumber numberWithInt:said] ,astroArray[i][2]];//二维数级:ID,星座名
		}
	}
    
    return  @[@-1,@-1 ];
}



+(NSString*)judgeChatTimeBySendTime:(NSString*)sendTimerString{
    
    NSDateFormatter *dateFormat =[[[NSDateFormatter alloc] init]  autorelease];
    dateFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss";
     
    return [dateFormat stringFromDate:[NSDate   dateWithTimeIntervalSince1970:[sendTimerString longLongValue]]];
    
}


+(NSString*)judgeTimeBySendTime:(NSDate*)sendTime{
    
    
    
    NSTimeInterval timeInterval = 0 -[sendTime timeIntervalSinceNow];
       
    if (timeInterval  <= 60) {
        
        return  @"刚刚";
    }else if (timeInterval  <= 3600){
        
        timeInterval  = ABS(timeInterval);
        return [NSString  stringWithFormat:@"%d分钟前",(int)(timeInterval / 60) ];
        
    }else if (timeInterval  <= 3600 * 24 ){
        
        
        timeInterval  = ABS(timeInterval);
        return [NSString  stringWithFormat:@"%d小时前",(int)(timeInterval / 3600) ];
        
    }else if (timeInterval  <= 3600 * 24 *2 ){
        
        
        return [NSString  stringWithFormat:@"昨天"  ];
        
    }else if(timeInterval  <= 3600 * 24 * 20 ){
        
        
        timeInterval  = ABS(timeInterval);
         
        
        return [NSString  stringWithFormat:@"%d天前",(int) (timeInterval / 3600  / 24) ];
        
    }else {
        
        NSDateFormatter *dateFormat =[[[NSDateFormatter alloc] init]  autorelease];
        dateFormat.dateFormat = @"yyyy-MM-dd";
        
        return [dateFormat stringFromDate:sendTime];
    }
    
}



+(BOOL)checkLogin{
    
    
    BOOL login = false;

    
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        
        if ([cookie.name   isEqualToString:@"T3_TSV3_LOGGED_USER"]) {
            
            login = true;
        }
        
        
        
    }
    
    return login ;
}


+(UIColor*)setColorByRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue{
    
    return [UIColor colorWithRed:red / 255 green:green /255 blue:blue / 255 alpha:1.0f];
    
}


+(UIColor*)xzwRedColor{
    
    
    return [UIColor colorWithRed:225.f / 255 green:66.f /255 blue: 120.f / 255 alpha:1.0f];
}


@end
