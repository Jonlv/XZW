//
//  XZWZodiacResultViewController.m
//  XZW
//
//  Created by Dee on 13-8-27.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWZodiacResultViewController.h"
#import "XZWUtil.h"
#import "JSONKit.h"
#import "XZWZodiacData.h"


@interface XZWZodiacResultViewController (){
    
    
    UIView *arrowView;
    
    UIScrollView *mainUSV;
    UIScrollView *upMainUSV;
    
    NSMutableArray *dataArray;
    
    NSString *wholeDateString;
    
    int astroIndex;
    
    int upAstroIndex;
}

@end

@implementation XZWZodiacResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(id)initWithSunIndex:(int)sunIndex upIndex:(int)upIndex wholeString:(NSString*)theWholeString{
    self = [super init];
    if (self) {
        // Custom initialization
         
        dataArray = [[NSMutableArray alloc]  init];
        
        upAstroIndex = upIndex;
        
        astroIndex =  sunIndex;
        
        wholeDateString = theWholeString;
        [wholeDateString  retain];
        
    }
    return self;
}

-(id)initWithDateString:(NSString*)dateString wholeString:(NSString*)theWholeString{
    self = [super init];
    if (self) {
        // Custom initialization
        
        
        dataArray = [[NSMutableArray alloc]  init];
        
        upAstroIndex = -1;
        
        astroIndex =  [[[XZWUtil findAstro:dateString]  objectAtIndex:0]  intValue];
        
        wholeDateString = theWholeString;
        [wholeDateString  retain];
    }
    return self;
}

-(void)dealloc{
    
    [wholeDateString release];
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"星座查询";
    
    self.view.backgroundColor = [UIColor colorWithHex:0x4c4c4c];
    
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self loadData];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if (upAstroIndex == -1) {
                
                [self initView];
                
            }else {
                
                
                [self initUpView];
                [self initView];
            }
            
            
        });
        
        ;
    });
    
    
    
}

#pragma mark - 

-(void)upAction{
    
    upMainUSV.hidden = false;
    mainUSV.hidden = true;
    [UIView animateWithDuration:.3f animations:^{ arrowView.frame =  CGRectMake(100, 35, 100, 10) ;}];
}



-(void)sunAction{
    
    
    upMainUSV.hidden = true;
    mainUSV.hidden = false;
    
    [UIView animateWithDuration:.3f animations:^{ arrowView.frame =  CGRectMake(0, 35, 100, 10) ;}];
}


-(void)goBack{
    
    [self.navigationController popViewControllerAnimated:true];
}


-(void)loadData{
    
    [dataArray  setArray:[[NSString stringWithContentsOfFile:[[NSBundle mainBundle]  pathForResource:@"AstroQueryData" ofType:nil] encoding:NSUTF8StringEncoding error:nil] objectFromJSONString]];
    
    
    
}

-(void)initUpView{
    
    
    UIButton *sunButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sunButton.frame = CGRectMake(100, 0, 100, 44);
    [sunButton   addTarget:self action:@selector(upAction) forControlEvents:UIControlEventTouchUpInside];
    [sunButton  setTintColor:[UIColor grayColor]];
    [sunButton  setTitle:@"上升星座" forState:UIControlStateNormal];
    [self.view addSubview:sunButton];
    
    
    
    
    upMainUSV = [[UIScrollView alloc]  initWithFrame:CGRectMake(0, 44, 320, TotalScreenHeight - 64 - 44)];
    upMainUSV.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    [self.view addSubview:upMainUSV];
    [upMainUSV release];
    
    upMainUSV.hidden = true;
    
    UIImageView *backgroundUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(10, 80, 300, 85)];
    backgroundUIV.image = [[UIImage imageNamed:@"corner"]  stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    [upMainUSV addSubview:backgroundUIV];
    [backgroundUIV release];
    
    
    UILabel *dateUL = [[UILabel alloc]   initWithFrame:CGRectMake(10, 10, 300, 30)];
    [dateUL  setText:wholeDateString];
    dateUL.adjustsFontSizeToFitWidth = true;
    dateUL.textColor = [UIColor grayColor];
    dateUL.backgroundColor = [UIColor clearColor];
    [upMainUSV addSubview:dateUL];
    [dateUL release];
    
    UILabel *dataUL = [[UILabel alloc]   initWithFrame:CGRectMake(10, 40, 300, 30)];
    dataUL.backgroundColor = [UIColor clearColor];
    dataUL.textColor = [XZWUtil xzwRedColor];
    [dataUL  setText:[[[dataArray objectAtIndex:0]    objectAtIndex:upAstroIndex]   objectAtIndex:4]];
    [upMainUSV addSubview:dataUL];
    [dataUL release];
    
    dataUL = [[UILabel alloc]   initWithFrame:CGRectMake(10, 40, 300, 30)];
    dataUL.backgroundColor = [UIColor clearColor];
    dataUL.textColor = [UIColor grayColor];
    dataUL.textAlignment = UITextAlignmentRight;
    [dataUL  setText:[[[dataArray objectAtIndex:0]    objectAtIndex:upAstroIndex]   objectAtIndex:1]];
    [upMainUSV addSubview:dataUL];
    [dataUL release];
    
    
//    dataUL = [[UILabel alloc]   initWithFrame:CGRectMake(8, 3, 300, 30)];
//    dataUL.backgroundColor = [UIColor clearColor];
//    dataUL.textColor = [UIColor grayColor];
//    [dataUL  setText:[NSString stringWithFormat:@"星座特点:%@",[[[dataArray objectAtIndex:0]    objectAtIndex:upAstroIndex]   objectAtIndex:3]]];
//    [backgroundUIV addSubview:dataUL];
//    [dataUL release];
//    
//    
//    
//    dataUL = [[UILabel alloc]   initWithFrame:CGRectMake(8, 3, 281, 30)];
//    dataUL.backgroundColor = [UIColor clearColor];
//    dataUL.textColor = [UIColor grayColor];
//    dataUL.textAlignment = UITextAlignmentRight;
//    [dataUL  setText:[NSString stringWithFormat:@"四象属性:%@",[[[[dataArray objectAtIndex:0]    objectAtIndex:upAstroIndex]   objectAtIndex:5]    objectAtIndex:0]]];
//    [backgroundUIV addSubview:dataUL];
//    [dataUL release];
//    
//    
//    dataUL = [[UILabel alloc]   initWithFrame:CGRectMake(8, 33, 300, 30)];
//    dataUL.backgroundColor = [UIColor clearColor];
//    dataUL.textColor = [UIColor grayColor];
//    [dataUL  setText:[NSString stringWithFormat:@"掌管宫位:%@",[[[[dataArray objectAtIndex:0]    objectAtIndex:upAstroIndex]   objectAtIndex:5]    objectAtIndex:1]]];
//    [backgroundUIV addSubview:dataUL];
//    [dataUL release];
//    
//    
//    
//    dataUL = [[UILabel alloc]   initWithFrame:CGRectMake(8, 33, 281, 30)];
//    dataUL.backgroundColor = [UIColor clearColor];
//    dataUL.textColor = [UIColor grayColor];
//    dataUL.textAlignment = UITextAlignmentRight;
//    [dataUL  setText:[NSString stringWithFormat:@"阴阳属性:%@",[[[[dataArray objectAtIndex:0]    objectAtIndex:upAstroIndex]   objectAtIndex:5]    objectAtIndex:2]]];
//    [backgroundUIV addSubview:dataUL];
//    [dataUL release];
//    
//    
//    
//    
//    dataUL = [[UILabel alloc]   initWithFrame:CGRectMake(8, 63, 281, 30)];
//    dataUL.backgroundColor = [UIColor clearColor];
//    dataUL.textColor = [UIColor grayColor];
//    [dataUL  setText:[NSString stringWithFormat:@"最大特征:%@",[[[[dataArray objectAtIndex:0]    objectAtIndex:upAstroIndex]   objectAtIndex:5]    objectAtIndex:3]]];
//    [backgroundUIV addSubview:dataUL];
//    [dataUL release];
//    
//    
//    
//    dataUL = [[UILabel alloc]   initWithFrame:CGRectMake(8, 63, 281, 30)];
//    dataUL.backgroundColor = [UIColor clearColor];
//    dataUL.textColor = [UIColor grayColor];
//    dataUL.textAlignment = UITextAlignmentRight;
//    [dataUL  setText:[NSString stringWithFormat:@"主管行星:%@",[[[[dataArray objectAtIndex:0]    objectAtIndex:upAstroIndex]   objectAtIndex:5]    objectAtIndex:4]]];
//    [backgroundUIV addSubview:dataUL];
//    [dataUL release];
//    
//    
//    dataUL = [[UILabel alloc]   initWithFrame:CGRectMake(8, 93, 281, 30)];
//    dataUL.backgroundColor = [UIColor clearColor];
//    dataUL.textColor = [UIColor grayColor];
//    [dataUL  setText:[NSString stringWithFormat:@"幸运颜色:%@",[[[[dataArray objectAtIndex:0]    objectAtIndex:upAstroIndex]   objectAtIndex:5]    objectAtIndex:5]]];
//    [backgroundUIV addSubview:dataUL];
//    [dataUL release];
//    
//    
//    dataUL = [[UILabel alloc]   initWithFrame:CGRectMake(8, 123, 281, 30)];
//    dataUL.backgroundColor = [UIColor clearColor];
//    dataUL.textColor = [UIColor grayColor];
//    [dataUL  setText:[NSString stringWithFormat:@"吉祥饰物:%@",[[[[dataArray objectAtIndex:0]    objectAtIndex:upAstroIndex]   objectAtIndex:5]    objectAtIndex:6]]];
//    [backgroundUIV addSubview:dataUL];
//    [dataUL release];
//    
//    
//    
//    dataUL = [[UILabel alloc]   initWithFrame:CGRectMake(8, 153, 281, 30)];
//    dataUL.backgroundColor = [UIColor clearColor];
//    dataUL.textColor = [UIColor grayColor];
//    [dataUL  setText:[NSString stringWithFormat:@"幸运号码:%@",[[[[dataArray objectAtIndex:0]    objectAtIndex:upAstroIndex]   objectAtIndex:5]    objectAtIndex:7]]];
//    [backgroundUIV addSubview:dataUL];
//    [dataUL release];
//    
//    
//    
//    dataUL = [[UILabel alloc]   initWithFrame:CGRectMake(8, 153, 281, 30)];
//    dataUL.backgroundColor = [UIColor clearColor];
//    dataUL.textColor = [UIColor grayColor];
//    dataUL.textAlignment = UITextAlignmentRight;
//    [dataUL  setText:[NSString stringWithFormat:@"开运金属:%@",[[[[dataArray objectAtIndex:0]    objectAtIndex:upAstroIndex]   objectAtIndex:5]    objectAtIndex:8]]];
//    [backgroundUIV addSubview:dataUL];
//    [dataUL release];
//    
//    
//    UIView *lineView = [[UIView alloc]  initWithFrame:CGRectMake(1, 183, 297, 1)];
//    lineView.backgroundColor = [UIColor colorWithHex:0xf1f1f1];
//    [backgroundUIV addSubview:lineView];
//    [lineView release];
//    
//    
    dataUL = [[UILabel alloc]   initWithFrame:CGRectMake(8, 186 - 183, 281, 30)];
    dataUL.backgroundColor = [UIColor clearColor];
    dataUL.textColor = [UIColor grayColor];
    dataUL.adjustsFontSizeToFitWidth = true;
    [dataUL  setText:[NSString stringWithFormat:@"表现:%@",[[[[dataArray objectAtIndex:1]    objectAtIndex:1]   objectAtIndex:upAstroIndex]    objectAtIndex:0]]];
    [backgroundUIV addSubview:dataUL];
    [dataUL release];
    
    dataUL = [[UILabel alloc]   initWithFrame:CGRectMake(8, 216 - 183, 281, 30)];
    dataUL.backgroundColor = [UIColor clearColor];
    dataUL.textColor = [UIColor grayColor];
    dataUL.adjustsFontSizeToFitWidth = true;
    [dataUL  setText:[NSString stringWithFormat:@"优点:%@",[[[[dataArray objectAtIndex:1]    objectAtIndex:1]   objectAtIndex:upAstroIndex]    objectAtIndex:1]]];
    [backgroundUIV addSubview:dataUL];
    [dataUL release];
    
    
    dataUL = [[UILabel alloc]   initWithFrame:CGRectMake(8, 246 - 183, 281, 30)];
    dataUL.backgroundColor = [UIColor clearColor];
    dataUL.textColor = [UIColor grayColor];
    dataUL.adjustsFontSizeToFitWidth = true;
    [dataUL  setText:[NSString stringWithFormat:@"缺点:%@",[[[[dataArray objectAtIndex:1]    objectAtIndex:1]   objectAtIndex:upAstroIndex]    objectAtIndex:2]]];
    [backgroundUIV addSubview:dataUL];
    [dataUL release];
    
    
    
    
    
    
    
    backgroundUIV.frame =  CGRectMake(10, 80, 300, CGRectGetMaxY(dataUL.frame) + 5);
    
    CGFloat height = CGRectGetMaxY(backgroundUIV.frame) + 15;
    
    backgroundUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(10, height, 300, 85)];
    backgroundUIV.image = [[UIImage imageNamed:@"corner"]  stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    [upMainUSV addSubview:backgroundUIV];
    [backgroundUIV release];
    
    
    UILabel *tipsUL = [[UILabel alloc]   initWithFrame:CGRectMake(10,  3, 200, 25)];
    [tipsUL setBackgroundColor:[UIColor clearColor]];
    [tipsUL setText:@"基本特质:"];
    [tipsUL setTextColor:[XZWUtil xzwRedColor]];
    [backgroundUIV addSubview:tipsUL];
    [tipsUL release];
    
    
    
    UILabel *resultUL = [[UILabel alloc]  initWithFrame:CGRectMake(10, 6 , 280, 25)];
    [resultUL setBackgroundColor:[UIColor clearColor]];
    resultUL.numberOfLines = 0 ;
    resultUL.font = [UIFont systemFontOfSize:15];
    [resultUL setText:[@"                    " stringByAppendingString:[[[[dataArray objectAtIndex:1]    objectAtIndex:1]   objectAtIndex:upAstroIndex]    objectAtIndex:3]]];
    [resultUL setTextColor:[UIColor grayColor]];
    [backgroundUIV addSubview:resultUL];
    [resultUL sizeThatFits:CGSizeMake(280, 2000)];
    [resultUL  release];
    [resultUL   sizeToFit];
    
    
    
    tipsUL = [[UILabel alloc]   initWithFrame:CGRectMake(10, CGRectGetMaxY(resultUL.frame) + 23, 200, 25)];
    tipsUL.numberOfLines = 0 ;
    [tipsUL setBackgroundColor:[UIColor clearColor]];
    [tipsUL setText:@"具体特质:"];
    [tipsUL setTextColor:[XZWUtil xzwRedColor]];
    [backgroundUIV addSubview:tipsUL];
    [tipsUL release];
    
    
    resultUL = [[UILabel alloc]  initWithFrame:CGRectMake(10, CGRectGetMaxY(resultUL.frame) + 26, 280, 25)];
    resultUL.numberOfLines = 0 ;
    resultUL.font = [UIFont systemFontOfSize:15];
    [resultUL setBackgroundColor:[UIColor clearColor]];
    [resultUL setText:[@"                    " stringByAppendingString:[[[[dataArray objectAtIndex:1]    objectAtIndex:1]   objectAtIndex:upAstroIndex]    objectAtIndex:4]] ];
    [resultUL setTextColor:[UIColor grayColor]];
    [backgroundUIV addSubview:resultUL];
    [resultUL sizeThatFits:CGSizeMake(280, 2000)];
    [resultUL  release];
    [resultUL   sizeToFit];
    
    
    tipsUL = [[UILabel alloc]   initWithFrame:CGRectMake(10, CGRectGetMaxY(resultUL.frame) + 23, 200, 25)];
    tipsUL.numberOfLines = 0 ;
    [tipsUL setBackgroundColor:[UIColor clearColor]];
    [tipsUL setText:@"个性盲点:"];
    [tipsUL setTextColor:[XZWUtil xzwRedColor]];
    [backgroundUIV addSubview:tipsUL];
    [tipsUL release];
    
    
    resultUL = [[UILabel alloc]  initWithFrame:CGRectMake(10, CGRectGetMaxY(resultUL.frame) + 26, 280, 25)];
    resultUL.numberOfLines = 0 ;
    resultUL.font = [UIFont systemFontOfSize:15];
    [resultUL setBackgroundColor:[UIColor clearColor]];
    [resultUL setText:[@"                    " stringByAppendingString:[[[[dataArray objectAtIndex:1]    objectAtIndex:1]   objectAtIndex:upAstroIndex]    objectAtIndex:6]] ];
    [resultUL setTextColor:[UIColor grayColor]];
    [backgroundUIV addSubview:resultUL];
    [resultUL sizeThatFits:CGSizeMake(280, 2000)];
    [resultUL  release];
    [resultUL   sizeToFit];
    
    
    tipsUL = [[UILabel alloc]   initWithFrame:CGRectMake(10, CGRectGetMaxY(resultUL.frame) + 23, 200, 25)];
    tipsUL.numberOfLines = 0 ;
    [tipsUL setBackgroundColor:[UIColor clearColor]];
    [tipsUL setText:@"总结:"];
    [tipsUL setTextColor:[XZWUtil xzwRedColor]];
    [backgroundUIV addSubview:tipsUL];
    [tipsUL release];
    
    resultUL = [[UILabel alloc]  initWithFrame:CGRectMake(10, CGRectGetMaxY(resultUL.frame) + 26, 280, 25)];
    resultUL.numberOfLines = 0 ;
    resultUL.font = [UIFont systemFontOfSize:15];
    [resultUL setBackgroundColor:[UIColor clearColor]];
    [resultUL setText:[@"          " stringByAppendingString:[[[dataArray objectAtIndex:0]    objectAtIndex:upAstroIndex]   objectAtIndex:6]] ];
    [resultUL setTextColor:[UIColor grayColor]];
    [backgroundUIV addSubview:resultUL];
    [resultUL sizeThatFits:CGSizeMake(280, 2000)];
    [resultUL  release];
    [resultUL   sizeToFit];
    
    backgroundUIV.frame = CGRectMake(10, height, 300, CGRectGetMaxY(resultUL.frame ) + 10 );
    
    [upMainUSV  setContentSize:CGSizeMake(320, CGRectGetMaxY(backgroundUIV.frame) + 15)];
    
}



-(void)initView{
    
    self.view.backgroundColor = [UIColor colorWithHex:0x4c4c4c];
    
    UIButton *sunButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sunButton.frame = CGRectMake(0, 0, 100, 44);
    [sunButton   addTarget:self action:@selector(sunAction) forControlEvents:UIControlEventTouchUpInside];
    [sunButton  setTintColor:[UIColor grayColor]];
    [sunButton  setTitle:@"太阳星座" forState:UIControlStateNormal];
    [self.view addSubview:sunButton];
    
    
    
    
    mainUSV = [[UIScrollView alloc]  initWithFrame:CGRectMake(0, 44, 320, TotalScreenHeight - 64 - 44)];
    mainUSV.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    [self.view addSubview:mainUSV];
    [mainUSV release];
    
    
    UIImageView *backgroundUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(10, 80, 300, 85)];
    backgroundUIV.image = [[UIImage imageNamed:@"corner"]  stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    [mainUSV addSubview:backgroundUIV];
    [backgroundUIV release];

    
     
    
    
    arrowView = [[UIView alloc]  initWithFrame:CGRectMake(0, 35, 100, 10)];
    [self.view  addSubview:arrowView];
    [arrowView release];
    
    UIImageView *arrowUIV = [[UIImageView alloc]  initWithImage:[UIImage imageNamed:@"uarrow"]];
    arrowUIV.center = CGPointMake(arrowView.center.x, 2.5);
    [arrowView addSubview:arrowUIV];
    [arrowUIV release];
    
    UIView *redView = [[UIView alloc]  initWithFrame:CGRectMake(0, 40, 320, 4)];
    redView.backgroundColor  = [UIColor colorWithHex:0xfb5c92];
    [self.view  addSubview:redView];
    [redView release];
    
     
    
    
    UILabel *dateUL = [[UILabel alloc]   initWithFrame:CGRectMake(10, 10, 300, 30)];
    [dateUL  setText:wholeDateString];
    dateUL.textColor = [UIColor grayColor];
    dateUL.adjustsFontSizeToFitWidth = true;
    dateUL.backgroundColor = [UIColor clearColor];
    [mainUSV addSubview:dateUL];
    [dateUL release];
    
    UILabel *dataUL = [[UILabel alloc]   initWithFrame:CGRectMake(10, 40, 300, 30)];
    dataUL.backgroundColor = [UIColor clearColor]; 
    dataUL.textColor = [XZWUtil xzwRedColor];
    [dataUL  setText:[[[dataArray objectAtIndex:0]    objectAtIndex:astroIndex]   objectAtIndex:4]];
    [mainUSV addSubview:dataUL];
    [dataUL release];

    dataUL = [[UILabel alloc]   initWithFrame:CGRectMake(10, 40, 300, 30)];
    dataUL.backgroundColor = [UIColor clearColor];
    dataUL.textColor = [UIColor grayColor]; 
    dataUL.textAlignment = UITextAlignmentRight;
    [dataUL  setText:[[[dataArray objectAtIndex:0]    objectAtIndex:astroIndex]   objectAtIndex:1]];
    [mainUSV addSubview:dataUL];
    [dataUL release];
    
    
    dataUL = [[UILabel alloc]   initWithFrame:CGRectMake(8, 3, 300, 30)];
    dataUL.backgroundColor = [UIColor clearColor];
    dataUL.textColor = [UIColor grayColor]; 
    [dataUL  setText:[NSString stringWithFormat:@"星座特点:%@",[[[dataArray objectAtIndex:0]    objectAtIndex:astroIndex]   objectAtIndex:3]]];
    [backgroundUIV addSubview:dataUL];
    [dataUL release];
    
    
    
    dataUL = [[UILabel alloc]   initWithFrame:CGRectMake(8, 3, 281, 30)];
    dataUL.backgroundColor = [UIColor clearColor];
    dataUL.textColor = [UIColor grayColor];
    dataUL.textAlignment = UITextAlignmentRight;
    [dataUL  setText:[NSString stringWithFormat:@"四象属性:%@",[[[[dataArray objectAtIndex:0]    objectAtIndex:astroIndex]   objectAtIndex:5]    objectAtIndex:0]]];
    [backgroundUIV addSubview:dataUL];
    [dataUL release];
    
    
    dataUL = [[UILabel alloc]   initWithFrame:CGRectMake(8, 33, 300, 30)];
    dataUL.backgroundColor = [UIColor clearColor];
    dataUL.textColor = [UIColor grayColor];
    [dataUL  setText:[NSString stringWithFormat:@"掌管宫位:%@",[[[[dataArray objectAtIndex:0]    objectAtIndex:astroIndex]   objectAtIndex:5]    objectAtIndex:1]]];
    [backgroundUIV addSubview:dataUL];
    [dataUL release];
    
    
    
    dataUL = [[UILabel alloc]   initWithFrame:CGRectMake(8, 33, 281, 30)];
    dataUL.backgroundColor = [UIColor clearColor];
    dataUL.textColor = [UIColor grayColor];
    dataUL.textAlignment = UITextAlignmentRight;
    [dataUL  setText:[NSString stringWithFormat:@"阴阳属性:%@",[[[[dataArray objectAtIndex:0]    objectAtIndex:astroIndex]   objectAtIndex:5]    objectAtIndex:2]]];
    [backgroundUIV addSubview:dataUL];
    [dataUL release];
    
    
    
    
    dataUL = [[UILabel alloc]   initWithFrame:CGRectMake(8, 63, 281, 30)];
    dataUL.backgroundColor = [UIColor clearColor];
    dataUL.textColor = [UIColor grayColor];
    [dataUL  setText:[NSString stringWithFormat:@"最大特征:%@",[[[[dataArray objectAtIndex:0]    objectAtIndex:astroIndex]   objectAtIndex:5]    objectAtIndex:3]]];
    [backgroundUIV addSubview:dataUL];
    [dataUL release];
    
    
    
    dataUL = [[UILabel alloc]   initWithFrame:CGRectMake(8, 63, 281, 30)];
    dataUL.backgroundColor = [UIColor clearColor];
    dataUL.textColor = [UIColor grayColor];
    dataUL.textAlignment = UITextAlignmentRight;
    [dataUL  setText:[NSString stringWithFormat:@"主管行星:%@",[[[[dataArray objectAtIndex:0]    objectAtIndex:astroIndex]   objectAtIndex:5]    objectAtIndex:4]]];
    [backgroundUIV addSubview:dataUL];
    [dataUL release];
    
    
    dataUL = [[UILabel alloc]   initWithFrame:CGRectMake(8, 93, 281, 30)];
    dataUL.backgroundColor = [UIColor clearColor];
    dataUL.textColor = [UIColor grayColor]; 
    [dataUL  setText:[NSString stringWithFormat:@"幸运颜色:%@",[[[[dataArray objectAtIndex:0]    objectAtIndex:astroIndex]   objectAtIndex:5]    objectAtIndex:5]]];
    [backgroundUIV addSubview:dataUL];
    [dataUL release];
    
    
    dataUL = [[UILabel alloc]   initWithFrame:CGRectMake(8, 123, 281, 30)];
    dataUL.backgroundColor = [UIColor clearColor];
    dataUL.textColor = [UIColor grayColor]; 
    [dataUL  setText:[NSString stringWithFormat:@"吉祥饰物:%@",[[[[dataArray objectAtIndex:0]    objectAtIndex:astroIndex]   objectAtIndex:5]    objectAtIndex:6]]];
    [backgroundUIV addSubview:dataUL];
    [dataUL release];
    
    
    
    dataUL = [[UILabel alloc]   initWithFrame:CGRectMake(8, 153, 281, 30)];
    dataUL.backgroundColor = [UIColor clearColor];
    dataUL.textColor = [UIColor grayColor];
    [dataUL  setText:[NSString stringWithFormat:@"幸运号码:%@",[[[[dataArray objectAtIndex:0]    objectAtIndex:astroIndex]   objectAtIndex:5]    objectAtIndex:7]]];
    [backgroundUIV addSubview:dataUL];
    [dataUL release];
    
    
    
    dataUL = [[UILabel alloc]   initWithFrame:CGRectMake(8, 153, 281, 30)];
    dataUL.backgroundColor = [UIColor clearColor];
    dataUL.textColor = [UIColor grayColor];
    dataUL.textAlignment = UITextAlignmentRight;
    [dataUL  setText:[NSString stringWithFormat:@"开运金属:%@",[[[[dataArray objectAtIndex:0]    objectAtIndex:astroIndex]   objectAtIndex:5]    objectAtIndex:8]]];
    [backgroundUIV addSubview:dataUL];
    [dataUL release];
    
    
    UIView *lineView = [[UIView alloc]  initWithFrame:CGRectMake(1, 183, 297, 1)];
    lineView.backgroundColor = [UIColor colorWithHex:0xf1f1f1];
    [backgroundUIV addSubview:lineView];
    [lineView release];
    
    
    dataUL = [[UILabel alloc]   initWithFrame:CGRectMake(8, 186, 281, 30)];
    dataUL.backgroundColor = [UIColor clearColor];
    dataUL.textColor = [UIColor grayColor];
    dataUL.adjustsFontSizeToFitWidth = true;
    [dataUL  setText:[NSString stringWithFormat:@"表现:%@",[[[[dataArray objectAtIndex:1]    objectAtIndex:0]   objectAtIndex:astroIndex]    objectAtIndex:0]]];
    [backgroundUIV addSubview:dataUL];
    [dataUL release];
    
    dataUL = [[UILabel alloc]   initWithFrame:CGRectMake(8, 216, 281, 30)];
    dataUL.backgroundColor = [UIColor clearColor];
    dataUL.textColor = [UIColor grayColor];
    dataUL.adjustsFontSizeToFitWidth = true;
    [dataUL  setText:[NSString stringWithFormat:@"优点:%@",[[[[dataArray objectAtIndex:1]    objectAtIndex:0]   objectAtIndex:astroIndex]    objectAtIndex:1]]];
    [backgroundUIV addSubview:dataUL];
    [dataUL release];
    
    
    dataUL = [[UILabel alloc]   initWithFrame:CGRectMake(8, 246, 281, 30)];
    dataUL.backgroundColor = [UIColor clearColor];
    dataUL.textColor = [UIColor grayColor];
    dataUL.adjustsFontSizeToFitWidth = true;
    [dataUL  setText:[NSString stringWithFormat:@"缺点:%@",[[[[dataArray objectAtIndex:1]    objectAtIndex:0]   objectAtIndex:astroIndex]    objectAtIndex:2]]];
    [backgroundUIV addSubview:dataUL];
    [dataUL release];
    
    
    
    
    
    
    
    backgroundUIV.frame =  CGRectMake(10, 80, 300, CGRectGetMaxY(dataUL.frame) + 5);
    
    CGFloat height = CGRectGetMaxY(backgroundUIV.frame) + 15;
    
    backgroundUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(10, height, 300, 85)];
    backgroundUIV.image = [[UIImage imageNamed:@"corner"]  stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    [mainUSV addSubview:backgroundUIV];
    [backgroundUIV release];
    
    
    UILabel *tipsUL = [[UILabel alloc]   initWithFrame:CGRectMake(10,  3, 200, 25)];
    [tipsUL setBackgroundColor:[UIColor clearColor]];
    [tipsUL setText:@"基本特质:"];
    [tipsUL setTextColor:[XZWUtil xzwRedColor]];
    [backgroundUIV addSubview:tipsUL];
    [tipsUL release];
    
    
    
    UILabel *resultUL = [[UILabel alloc]  initWithFrame:CGRectMake(10, 6 , 280, 25)];
    [resultUL setBackgroundColor:[UIColor clearColor]];
    resultUL.numberOfLines = 0 ;
    resultUL.font = [UIFont systemFontOfSize:15];
    [resultUL setText:[@"                    " stringByAppendingString:[[[[dataArray objectAtIndex:1]    objectAtIndex:0]   objectAtIndex:astroIndex]    objectAtIndex:3]]];
    [resultUL setTextColor:[UIColor grayColor]];
    [backgroundUIV addSubview:resultUL];
    [resultUL sizeThatFits:CGSizeMake(280, 2000)];
    [resultUL  release];
    [resultUL   sizeToFit];
    
    
    
    tipsUL = [[UILabel alloc]   initWithFrame:CGRectMake(10, CGRectGetMaxY(resultUL.frame) + 23, 200, 25)];
    tipsUL.numberOfLines = 0 ;
    [tipsUL setBackgroundColor:[UIColor clearColor]];
    [tipsUL setText:@"具体特质:"];
    [tipsUL setTextColor:[XZWUtil xzwRedColor]];
    [backgroundUIV addSubview:tipsUL];
    [tipsUL release];
    
    
    resultUL = [[UILabel alloc]  initWithFrame:CGRectMake(10, CGRectGetMaxY(resultUL.frame) + 26, 280, 25)];
    resultUL.numberOfLines = 0 ;
    resultUL.font = [UIFont systemFontOfSize:15];
    [resultUL setBackgroundColor:[UIColor clearColor]];
    [resultUL setText:[@"                    " stringByAppendingString:[[[[dataArray objectAtIndex:1]    objectAtIndex:0]   objectAtIndex:astroIndex]    objectAtIndex:4]] ];
    [resultUL setTextColor:[UIColor grayColor]];
    [backgroundUIV addSubview:resultUL];
    [resultUL sizeThatFits:CGSizeMake(280, 2000)];
    [resultUL  release];
    [resultUL   sizeToFit];
    
    
    tipsUL = [[UILabel alloc]   initWithFrame:CGRectMake(10, CGRectGetMaxY(resultUL.frame) + 23, 200, 25)];
    tipsUL.numberOfLines = 0 ;
    [tipsUL setBackgroundColor:[UIColor clearColor]];
    [tipsUL setText:@"个性盲点:"];
    [tipsUL setTextColor:[XZWUtil xzwRedColor]];
    [backgroundUIV addSubview:tipsUL];
    [tipsUL release];
    
    
    resultUL = [[UILabel alloc]  initWithFrame:CGRectMake(10, CGRectGetMaxY(resultUL.frame) + 26, 280, 25)];
    resultUL.numberOfLines = 0 ;
    resultUL.font = [UIFont systemFontOfSize:15];
    [resultUL setBackgroundColor:[UIColor clearColor]];
    [resultUL setText:[@"                    " stringByAppendingString:[[[[dataArray objectAtIndex:1]    objectAtIndex:0]   objectAtIndex:astroIndex]    objectAtIndex:6]] ];
    [resultUL setTextColor:[UIColor grayColor]];
    [backgroundUIV addSubview:resultUL];
    [resultUL sizeThatFits:CGSizeMake(280, 2000)];
    [resultUL  release];
    [resultUL   sizeToFit];
    
    
    
    tipsUL = [[UILabel alloc]   initWithFrame:CGRectMake(10, CGRectGetMaxY(resultUL.frame) + 23, 200, 25)];
    tipsUL.numberOfLines = 0 ;
    [tipsUL setBackgroundColor:[UIColor clearColor]];
    [tipsUL setText:@"总结:"];
    [tipsUL setTextColor:[XZWUtil xzwRedColor]];
    [backgroundUIV addSubview:tipsUL];
    [tipsUL release];
    
    
    resultUL = [[UILabel alloc]  initWithFrame:CGRectMake(10, CGRectGetMaxY(resultUL.frame) + 26, 280, 25)];
    resultUL.numberOfLines = 0 ;
    resultUL.font = [UIFont systemFontOfSize:15];
    [resultUL setBackgroundColor:[UIColor clearColor]];
    [resultUL setText:[@"          " stringByAppendingString:[[[dataArray objectAtIndex:0]    objectAtIndex:astroIndex]   objectAtIndex:6]] ];
    [resultUL setTextColor:[UIColor grayColor]];
    [backgroundUIV addSubview:resultUL];
    [resultUL sizeThatFits:CGSizeMake(280, 2000)];
    [resultUL  release];
    [resultUL   sizeToFit];
    
    
    backgroundUIV.frame = CGRectMake(10, height, 300, CGRectGetMaxY(resultUL.frame ) + 10 );

    
    [mainUSV  setContentSize:CGSizeMake(320, CGRectGetMaxY(backgroundUIV.frame) + 15)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
