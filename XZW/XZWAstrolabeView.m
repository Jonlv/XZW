//
//  XZWAstrolabeView.m
//  XZW
//
//  Created by Dee on 13-8-23.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWAstrolabeView.h"
#import "XZWUtil.h"

 


static const CGFloat XZWWidth = 274.f;

static const CGFloat XZWHeight = 274.f;

float RadiantoDegree(float radian)
{
	return ((radian / M_PI) * 180.0f);
}

float DegreetoRadian(float degree)
{
	return ((degree / 180.0f) * M_PI);
}


@implementation XZWAstrolabeView
@synthesize dataSource;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        dot = [[NSMutableArray array] retain];
        
        aspect = [[NSMutableArray array] retain];
        
        colorArray = [[NSArray arrayWithObjects:
                      @[[UIColor colorWithHex:0xff0000] ,[UIColor colorWithHex:0x4499ff]  ,[UIColor colorWithHex:0x339900] ,[UIColor colorWithHex:0xffff00] ,[UIColor colorWithHex:0xff0000] ,[UIColor colorWithHex:0xff0000] ,[UIColor colorWithHex:0xffff00] ,[UIColor colorWithHex:0x339900] ,[UIColor colorWithHex:0x4499ff] ,[UIColor colorWithHex:0x4499ff]   ,[UIColor colorWithHex:0xff0000]  ,
                       [UIColor colorWithHex:0xffff00]
                       // [UIColor colorWithHex:0x4499ff]
                       
                       ],
                      
                      @[ [UIColor colorWithHex:0x0000ff]  ,[UIColor colorWithHex:0x3399ff] ,[UIColor colorWithHex:0xff3b3b] ,[UIColor colorWithHex:0x339900] ,[UIColor colorWithHex:0x00ffbb] ]  ,  nil]  retain];
        
        DegreeArr = [[NSMutableArray arrayWithObjects:@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0, nil]  retain];
        ;
        
    }
    return self;
}


-(void)dealloc{
    
    
    [dot release];
    [aspect release];
    [colorArray release];
    [DegreeArr release];
    
    [super dealloc];
}



-(void)setDataSource:(id<XZWAstrolableDataSource>)theDataSource{
    
    
    dataSource = theDataSource;
    
    [self drawAll];
    
}


-(void)drawAll{
    
    NSArray *dictate = @[@4,@3,@2,@1,@0,@2,@3,@9,@5,@6,@7,@8];
    
    UIImageView *backUIV  = [[UIImageView alloc]  initWithImage:[UIImage imageNamed:@"1.png"]];
    backUIV.frame = CGRectMake(0, 0, XZWWidth, XZWHeight);
    [self addSubview:backUIV];
    [backUIV release];
    
     srota = [dataSource  astrolableAst];
    
    NSArray *house = [[dataSource getDataArray]  objectAtIndex:1][0];
    
 //   NSArray *inhouse =[[dataSource getDataArray]  objectAtIndex:1][1];
    
    NSMutableArray *planet =  [NSMutableArray arrayWithArray:[[dataSource getDataArray]  objectAtIndex:0]] ;
    
 //   NSArray *aspect = [[dataSource getDataArray]  objectAtIndex:2];
    
    
    [aspect  setArray:[[dataSource getDataArray]  objectAtIndex:2]];
    
    am = [[[dataSource getDataArray]  objectAtIndex:3]  doubleValue];
    
    
     
    
   // double t = [[[dataSource getDataArray]  objectAtIndex:4]  doubleValue];
    
    
    
     k = [[[dataSource getDataArray]  objectAtIndex:5]  doubleValue];

    
    
    
    // may mo  
    if (srota) {
         
        backUIV.transform = CGAffineTransformRotate(CGAffineTransformIdentity,  DegreetoRadian(srota)
                                                    );
    }
    
     cpoint = XZWWidth / 2;
    
    
    
    for (int i = 0; i < 12 ; i++) {
                 
        UIImage *a_img= [UIImage imageNamed:[NSString stringWithFormat:@"a_%d",i+1]];
        UIImageView *img = [[UIImageView alloc] initWithImage:a_img];
        [self addSubview:img];
        [img release];
        
        double a_width = CGImageGetWidth(a_img.CGImage) / [[UIScreen mainScreen] scale];
        double a_height = CGImageGetHeight(a_img.CGImage)  / [[UIScreen mainScreen] scale];
 
        double radius =  XZWWidth  * 206.f / 460;
        double ase = 0.01745329;
        
        double x=-cos(ase*(i*30+15-srota))*radius+XZWWidth/2-a_width/2;
        double y= sin(ase*(i*30+15-srota))*radius+XZWHeight/2-a_height/2+1;
        
        img.frame = CGRectMake(x, y, a_width, a_height); 
        
        img.transform = CGAffineTransformRotate(CGAffineTransformIdentity, - DegreetoRadian(180-(75-i*30+srota))   );
        
        
        
        
        
        a_img= [UIImage imageNamed:[NSString stringWithFormat:@"b_%d",([dictate[i]  intValue]+1)]];
        img = [[UIImageView alloc] initWithImage:a_img];
        [self addSubview:img];
        [img release];
        
         a_width = CGImageGetWidth(a_img.CGImage)  / [[UIScreen mainScreen] scale];
         a_height = CGImageGetHeight(a_img.CGImage)  / [[UIScreen mainScreen] scale];
        
        radius =  XZWWidth  * 206.f / 460;
         double scale = 0.8;
        
         x=-cos(ase*(i*30+4-srota))*radius+XZWWidth/2-a_width*scale/2+1;
         y= sin(ase*(i*30+4-srota))*radius+XZWHeight/2-a_height*scale/2+1;
        
        img.frame = CGRectMake(x, y, a_width*scale, a_height*scale);
        
        img.transform = CGAffineTransformRotate(CGAffineTransformIdentity, - DegreetoRadian(170-(75-i*30+srota))   );
        
        
        
        a_img= [UIImage imageNamed:[NSString stringWithFormat:@"n_%d",(i+1)]];
        img = [[UIImageView alloc] initWithImage:a_img];
        [self addSubview:img];
        [img release];
        
        double center = [house[(i + 1) % 12]  doubleValue] - [house[i]  doubleValue];
        
        if (center < 0) {
            
            center = 360 + center;
        }
        
        center = [house[i]  doubleValue]+center/ 2-srota;
        
        
        
        a_width = CGImageGetWidth(a_img.CGImage)  / [[UIScreen mainScreen] scale];
        a_height = CGImageGetHeight(a_img.CGImage)  / [[UIScreen mainScreen] scale];
        
        radius =  XZWWidth  * 170.f / 460;
        
        x=-cos(0.01745329*center)*radius+XZWWidth/2-a_width/2+1;;
        y= sin(0.01745329*center)*radius+XZWHeight/2-a_height/2+1;
        
        img.frame = CGRectMake(x, y, a_width, a_height);
        
        img.transform = CGAffineTransformRotate(CGAffineTransformIdentity, - DegreetoRadian(center-270)   );
        
        
        
        
        
        
        /////
        
        
        a_img= [UIImage imageNamed:[NSString stringWithFormat:@"b_%d",([dictate[i]  intValue]+1)]];
        img = [[UIImageView alloc] initWithImage:a_img];
        [self addSubview:img];
        [img release];
        
         center = [house[i]  doubleValue] +5-srota;
          
        
        radius = XZWWidth  * 170.f / 460;
        scale = 0.7;
        
        a_width = CGImageGetWidth(a_img.CGImage)  / [[UIScreen mainScreen] scale];
        a_height = CGImageGetHeight(a_img.CGImage)  / [[UIScreen mainScreen] scale];
         
        
        x=-cos(0.01745329*center)*radius+XZWWidth/2-a_width* scale/2+1;;
        y= sin(0.01745329*center)*radius+XZWHeight/2-a_height* scale/2+1;
        
        img.frame = CGRectMake(x, y, a_width * scale, a_height * scale);
        
        img.transform = CGAffineTransformRotate(CGAffineTransformIdentity, - DegreetoRadian(center-270)   );
        
        
        
        
        
             
        if(i<6) {
            
            UIImageView *theImage,*copyImage;
            
            
            if (i == 0 || i == 3){
                
                 theImage = [[UIImageView alloc]  initWithImage:[UIImage imageNamed:@"lines.png"]];
                [self addSubview:theImage];
                [theImage release];
                
                copyImage = [[UIImageView alloc]  initWithImage:[UIImage imageNamed:@"lines.png"]];
                
                
            }else {
                
                
                theImage = [[UIImageView alloc]  initWithImage:[UIImage imageNamed:@"line.png"]];
                [self addSubview:theImage];
                [theImage release];
                
                copyImage = [[UIImageView alloc]  initWithImage:[UIImage imageNamed:@"line.png"]];
                
                
            }
            
            double a_width,as_width;
            
            a_width =CGImageGetWidth(theImage.image.CGImage)  / [[UIScreen mainScreen] scale]; // *  XZWWidth ;///  460;
            double a_height,as_height;
            
            a_height =CGImageGetHeight(theImage.image.CGImage)  / [[UIScreen mainScreen] scale]; // *  XZWHeight /  460;
             
            
            as_width = CGImageGetWidth(copyImage.image.CGImage)   / [[UIScreen mainScreen] scale] ; //*  XZWWidth // /  460;
            as_height =  CGImageGetHeight(copyImage.image.CGImage)  / [[UIScreen mainScreen] scale]; // *  XZWHeight ///  460;
             
            
            double x = (a_width - as_width) / 2 + (XZWWidth - a_width) /2;
            double y = (a_height -as_height) / 2 + (XZWHeight - a_height) /2;
             
             
            
            theImage.frame = CGRectMake(x, y, a_width    , a_height   );
            
            theImage.center = CGPointMake(XZWWidth /2 , XZWHeight /2);
            
            theImage.transform = CGAffineTransformRotate(CGAffineTransformIdentity, - DegreetoRadian([house[i]  doubleValue] - srota )   );
            
             
//            
//            theImage.transform = CGAffineTransformRotate(CGAffineTransformIdentity, - DegreetoRadian([house[i]  doubleValue] - srota )   );
            
             
        }
        
    }
    
     
    
   
    
    
    
  //  NSMutableArray *tempArray = [[[NSMutableArray alloc]   init]  autorelease];
    
    
    
    NSMutableArray *pindex = [NSMutableArray array];
    
         
    for (int i = 0;  i < 10 + am * 2; i++) {
         
        planet[i] = [NSNumber numberWithDouble:[planet[i]  doubleValue] -  srota ]  ;
         
        double radius =  XZWWidth  * 123.f / 460;
        
        double x = -cos(0.01745329 * [planet[i]  doubleValue]) * radius + cpoint;
        
        double y = sin(0.01745329 * [planet[i]  doubleValue]) * radius + cpoint;
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:x],@"x",[NSNumber numberWithDouble:y],@"y", nil];
        [dot  addObject:dic];
        
        pindex[i] =  [NSNumber numberWithInt:i];
        
    }
     
    
    int flag = 0;
    
    do {
        flag = 0;
        
        for (int i = 0; i< 9 + am * 2 ; i++) {
            
            if ([planet[ [pindex[i+1]   intValue]]  doubleValue] < [planet[ [pindex[i]   intValue]]  doubleValue]) {
                
                NSNumber *temp = pindex[i]  ;
                pindex[i] = pindex[i+1];
                pindex[i+1] = temp;
                flag = 1;
                
            }
            
            
        }
        
        
    } while (flag == 1);
    
    
     
    
    
    DegreeArr[ [pindex[0] intValue] ] = planet[[pindex[0]   intValue] ];
    
    
    for (int i = 1; i < 10 + am * 2; i++) {
         
        
        if ([planet[ [pindex[i]  intValue] ]   doubleValue] - [DegreeArr[[pindex[i -1]  intValue]  ]   doubleValue]   < 10 ) {
            
            DegreeArr[[pindex[i ]  intValue]] =  [NSNumber numberWithDouble:[DegreeArr[[pindex[i -1]  intValue]]  doubleValue]  + 10]   ;
            
            continue ;
        }
        
        
        DegreeArr[  [pindex[i]  intValue] ] = planet[ [pindex[i] intValue] ];
        
        
        
    }
    
    
    
    
    //  draw 
    
    
    for (int i = 0; i < k ; i++) {
         
        
        UIImageView *drawingView = [[UIImageView alloc]  initWithFrame:CGRectMake(0, 0, XZWWidth, XZWHeight)];
        [self addSubview:drawingView];
        [drawingView release];
        
        CGFloat red,green,blue;
        
        UIGraphicsBeginImageContext(drawingView.frame.size);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 1.0);
        CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
        CGContextBeginPath(UIGraphicsGetCurrentContext());
        [(UIColor*)colorArray[1][[aspect[i][2] intValue]]   getRed:&red green:&green blue:&blue alpha:nil];
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(),red, green, blue, 1.0);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), [dot[ [aspect[i][0] intValue]][@"x"]  doubleValue] , [dot[[aspect[i][0]  intValue]][@"y"]  doubleValue]);
        
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), [dot[ [aspect[i][1] intValue]][@"x"]  doubleValue], [dot[ [aspect[i][1] intValue]][@"y"]  doubleValue]);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        
        drawingView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        
    }
    
    
    
    for (int i = 0 ; i < 10 + am * 2; i++) {
        
        UIImage *a_img= [UIImage imageNamed:[NSString stringWithFormat:@"b_%d",(i+1)]];
              
        double radius = XZWWidth   * 138.f / 460;
        double a_width = CGImageGetWidth(a_img.CGImage)  / [[UIScreen mainScreen] scale];
        double a_height = CGImageGetHeight(a_img.CGImage)  / [[UIScreen mainScreen] scale];
        
        
        double x= (int)( -cos(0.01745329* [DegreeArr[i]  doubleValue])*radius + cpoint-a_width/2);
        double y= (int)(sin(0.01745329*[DegreeArr[i]  doubleValue])*radius + cpoint - a_height /2);
        
        
      
        
        
        // drawing 
        UIImageView *drawingView = [[UIImageView alloc]  initWithFrame:CGRectMake(0, 0, XZWWidth, XZWHeight)];
        [self addSubview:drawingView];
        [drawingView release];
        
        CGFloat red,green,blue;
        
        [(UIColor*)colorArray[0][i]   getRed:&red green:&green blue:&blue alpha:nil];
        
        
        UIGraphicsBeginImageContext(drawingView.frame.size);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 1.0);
        CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
        
        
//        CGFloat lengths[4];
//        lengths[0] = 4;
//        lengths[1] = 13 * 2;
//        lengths[2] = 2 * 2;
//        lengths[3] = 1 * 2;
       // CGContextSetLineDash(UIGraphicsGetCurrentContext(), 2.0f, lengths, 2);
        
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(),red, green, blue, 1.0);
        CGContextBeginPath(UIGraphicsGetCurrentContext());
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), x + a_width /2 , y +a_height /2);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), [dot[i][@"x"] floatValue ], [dot[i][@"y"]  floatValue]);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        
        drawingView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        
        UIImageView *img = [[UIImageView alloc] initWithImage:a_img];
        [self addSubview:img];
        [img release];
        
        
        img.frame = CGRectMake(x, y, a_width , a_height );
        
        if (!srota) {
            
            img.transform = CGAffineTransformRotate(CGAffineTransformIdentity, - DegreetoRadian(srota)   );
            
        }
        
        
        
    }
    
    
   

    
    
    
}




 
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//    
//    
//    
//        [super drawRect:rect];
//    
//}
// 

@end
