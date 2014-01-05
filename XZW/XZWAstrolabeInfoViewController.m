//
//  XZWAstrolabeInfoViewController.m
//  XZW
//
//  Created by dee on 13-8-30.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWAstrolabeInfoViewController.h"
#import "XZWUtil.h"
#import "XZWZodiacData.h"
@interface XZWAstrolabeInfoViewController (){
    
    
    UIScrollView *mainUSV;
    NSArray *dataArray;
}

@end

@implementation XZWAstrolabeInfoViewController



-(id)initWithArray:(NSArray*)theDataArray{
    
    self = [super init];
    if (self) {
        // Custom initialization
        
        dataArray =theDataArray;
        [dataArray retain];
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
    
    self.title = @"星盘信息";
    
    
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
     
    [self initView];
    
}

#pragma mark - 


-(void)goBack{
    
    [self.navigationController popViewControllerAnimated:true];
}


-(void)initView{
     
    mainUSV = [[UIScrollView alloc]  initWithFrame:CGRectMake(0, 0, 320, TotalScreenHeight - 64)];
    mainUSV.showsHorizontalScrollIndicator = mainUSV.showsVerticalScrollIndicator = false;
    [self.view addSubview:mainUSV];
    [mainUSV release];

    
    UIImageView *backgroundUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(10, 10, 300, 302)];
    backgroundUIV.image = [[UIImage imageNamed:@"corner"]  stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    [mainUSV addSubview:backgroundUIV];
    [backgroundUIV release];
    
    
    NSMutableArray *planet =  [NSMutableArray arrayWithArray:[dataArray  objectAtIndex:0]] ;
    
    NSArray *house = [dataArray  objectAtIndex:1];
    
    double am = [[dataArray  objectAtIndex:3]  doubleValue];
    
    NSArray *aspect = [dataArray  objectAtIndex:2];
    
    CGFloat height = 10;
    
    for (int i=0;i < 10 + am * 2 ;i++) {
         
        
        UILabel *theLabel = [[UILabel alloc]  initWithFrame:CGRectMake(10, 10 + 30 *i , 300, 30)];
        theLabel.backgroundColor = [UIColor clearColor];
        theLabel.text =  [NSString stringWithFormat:@"%@: %@ %@ %@", [[XZWZodiacData getNameArray]  objectAtIndex:i],[XZWZodiacData zodiac: [planet[i]  floatValue]], [XZWZodiacData degree:[planet[i] doubleValue]],i< 10? [NSString stringWithFormat:@"第%d宫", [house[1][i]  intValue]+1]:@""] ;
        theLabel.textColor = [UIColor grayColor];
        [backgroundUIV addSubview:theLabel];
        [theLabel release];
          
	}
    
    
    height +=  (10 + am * 2) * 30 + 10;
    
    backgroundUIV.frame = CGRectMake(10, 10, 300, (10 + am * 2) * 30 + 10);
    
    
    backgroundUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(10, CGRectGetMaxY(backgroundUIV.frame) + 10, 300, 12 * 30 +20)];
    backgroundUIV.image = [[UIImage imageNamed:@"corner"]  stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    [mainUSV addSubview:backgroundUIV];
    [backgroundUIV release];
    
    for (int i=0; i<12; i++) {
         
        UILabel *theLabel = [[UILabel alloc]  initWithFrame:CGRectMake(10, 10 + 30 *i , 300, 30)];
        theLabel.backgroundColor = [UIColor clearColor]; 
        theLabel.text =  [NSString stringWithFormat:@"第%d宫 %@ %@ %@",i+1,[XZWZodiacData zodiac: [house[0][i]  floatValue]], [XZWZodiacData degree:[house[0][i]  floatValue]],i%3==0? [NSString stringWithFormat:@"(%@)", [[XZWZodiacData getAnglesArray] objectAtIndex: (int)i/3]]:@""] ;
        theLabel.textColor = [UIColor grayColor];
        [backgroundUIV addSubview:theLabel];
        [theLabel release];
  
	}
    
    
    
    height +=  12 * 30 + 10;
    
       
    
    
    backgroundUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(10, CGRectGetMaxY(backgroundUIV.frame) + 10, 300, [aspect count] * 30 +20)];
    backgroundUIV.image = [[UIImage imageNamed:@"corner"]  stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    [mainUSV addSubview:backgroundUIV];
    [backgroundUIV release];
     
    
    for (int i=0; i< [aspect count]; i++) {
        
        double pt1 = [aspect[i][0] doubleValue] ;
        double pt2 = [aspect[i][1] doubleValue] ;
        
        UILabel *theLabel = [[UILabel alloc]  initWithFrame:CGRectMake(10, 10 + 30 *i , 300, 30)];
        theLabel.backgroundColor = [UIColor clearColor];
        theLabel.text =  [NSString stringWithFormat:@"%@ %@ %@ ",[XZWZodiacData getNameArray][(int)pt1], [XZWZodiacData getTypeArray][ (int)[aspect[i][2]  doubleValue]] ,[XZWZodiacData getNameArray][(int)pt2]  ] ;
        theLabel.textColor = [UIColor grayColor];
        [backgroundUIV addSubview:theLabel];
        [theLabel release];
        
	} 

    [mainUSV    setContentSize:CGSizeMake(320, CGRectGetMaxY( backgroundUIV.frame ) + 10)];


}

#pragma mark -


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
