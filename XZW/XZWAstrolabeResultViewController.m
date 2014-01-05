//
//  XZWAstrolabeResultViewController.m
//  XZW
//
//  Created by Dee on 13-8-27.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWAstrolabeResultViewController.h"
#import "XZWUtil.h"
#import "XZWAstrolabeDivinationViewController.h"
#import "XZWAstrolabeInfoViewController.h"
#import "UIButton+Extensions.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import <ShareSDK/ShareSDK.h>

@interface XZWAstrolabeResultViewController (){
    
    UIScrollView *mainUSV;
   
}
 
@end

@implementation XZWAstrolabeResultViewController
@synthesize savedArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(id)initWithAstrolabeDic:(NSDictionary*)theDictionary{
    
     XZWZodiac *xzwZodiac = [[[XZWZodiac alloc]  init] autorelease];
    [xzwZodiac setYear: [[theDictionary  objectForKey:@"year"]  intValue] month:[[theDictionary  objectForKey:@"month"]  intValue] day:[[theDictionary  objectForKey:@"day"]  intValue] hour:[[theDictionary  objectForKey:@"hour"]  intValue] minute:[[theDictionary  objectForKey:@"minute"]  intValue] daylight:[[theDictionary  objectForKey:@"daylight"]  intValue] timezone:[[theDictionary  objectForKey:@"timezone"]  intValue] longitude:[[theDictionary  objectForKey:@"longitude"]  doubleValue] latitude:[[theDictionary  objectForKey:@"latitude"]  doubleValue] am:[[theDictionary  objectForKey:@"am"]  doubleValue] sml:[[theDictionary  objectForKey:@"sml"]  doubleValue]];
    
    self = [self initZodiac:xzwZodiac andName:[theDictionary  objectForKey:@"name"] andBirthday:[theDictionary  objectForKey:@"birthday"] birthLoc:[theDictionary  objectForKey:@"locString"] birthPosi:[NSString stringWithFormat:@"%g,%g",[[theDictionary  objectForKey:@"longitude"]  doubleValue],[[theDictionary  objectForKey:@"latitude"]  doubleValue]] timeZone:[theDictionary  objectForKey:@"timezoneString"]];
    self.savedArray = @[[theDictionary  objectForKey:@"name"],[theDictionary  objectForKey:@"year"],[theDictionary  objectForKey:@"month"],   [theDictionary  objectForKey:@"day"], [theDictionary  objectForKey:@"hour"],[theDictionary  objectForKey:@"minute"],[theDictionary  objectForKey:@"daylight"], [theDictionary  objectForKey:@"timezone"], [theDictionary  objectForKey:@"longitude"], [theDictionary  objectForKey:@"latitude"], [theDictionary  objectForKey:@"am"], [theDictionary  objectForKey:@"sml"]];
    return self;
    
}


-(id)initZodiac:(XZWZodiac*)zodiac andName:(NSString*)nameString andBirthday:(NSString*)birthday birthLoc:(NSString*)birthLoc birthPosi:(NSString*)birthPosi timeZone:(NSString*)birthTimeZoneString{
    
    self = [super init ];
    if (self) {
        // Custom initialization
        
         
        
        nickNameString = nameString;
        [nickNameString  retain];
        
        bornDate = birthday;
        [bornDate retain];
        
        bornLoc = birthLoc;
        [bornLoc retain];
        
        positionString = birthPosi;
        [positionString retain];
        
        timeZoneString = birthTimeZoneString;
        [timeZoneString retain];
        
        
        dataArray = [[NSArray alloc]  initWithObjects:[zodiac getPlanet],[zodiac getHouse],[zodiac getAspect] ,[NSNumber numberWithDouble:[zodiac getAm]] ,[NSNumber numberWithDouble:[zodiac getT]] ,[NSNumber numberWithDouble:[zodiac getK]] ,  nil];
     
        
        astVaule = [zodiac getAst];
    }
    return self;
    
}

-(void)dealloc{
    
    [savedArray  release];
    [bornDate  release];
    [bornLoc release];
    [positionString release];
    [timeZoneString release];
    
    [nickNameString  release];
    [dataArray  release];
    [super  dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"星盘占卜";
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
  
    
    
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];
    
    
    listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self  action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];
    


    [self initView];
    
    
     
}






-(void)share{
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"Icon" ofType:@"png"];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@""
                                       defaultContent:@"分享 星座屋 http://www.xingzuowu.com"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"星座屋"
                                                  url:@"http://www.xingzuowu.com"
                                          description:INHERIT_VALUE
                                            mediaType:SSPublishContentMediaTypeNews];
    
    
    [publishContent addSinaWeiboUnitWithContent:INHERIT_VALUE image:INHERIT_VALUE];
    
    
    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                         content:INHERIT_VALUE
                                           title:INHERIT_VALUE
                                             url:INHERIT_VALUE
                                           image:INHERIT_VALUE
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    //定制微信朋友圈信息
    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeImage]
                                          content:INHERIT_VALUE
                                            title:INHERIT_VALUE
                                              url:INHERIT_VALUE
                                            image:INHERIT_VALUE
                                     musicFileUrl:INHERIT_VALUE
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    
    id<ISSShareOptions> shareOptions = [ShareSDK simpleShareOptionsWithTitle:@"分享内容" shareViewDelegate:nil];
    
    
    id<ISSContainer> container = [ShareSDK container];
    
       NSArray *shareList = [ShareSDK getShareListWithType: 
                          ShareTypeSinaWeibo,ShareTypeWeixiSession,ShareTypeWeixiTimeline,
                          nil];
     

    
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:true
                       authOptions:nil
                      shareOptions:shareOptions
                            result:nil];
    
    
}

#pragma mark - 

-(void)goBack{
    
    [self .navigationController popViewControllerAnimated:true];
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
    
    backgroundUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(10, 330, 300, 140)];
    backgroundUIV.image = [[UIImage imageNamed:@"corner"]  stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    [mainUSV addSubview:backgroundUIV];
    [backgroundUIV release];
    
    
    UILabel *nickName = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 300, 25)];
    nickName.backgroundColor = [UIColor clearColor];
    nickName.text = [NSString stringWithFormat:@"昵称: %@",nickNameString];
    nickName.textColor = [UIColor grayColor];
    [backgroundUIV addSubview:nickName];
    [nickName release];
    
    nickName = [[UILabel alloc] initWithFrame:CGRectMake(10, 8 + 25, 300, 25)];
    nickName.backgroundColor = [UIColor clearColor];
    nickName.text = [NSString stringWithFormat:@"生日: %@",bornDate];
    nickName.textColor = [UIColor grayColor];
    [backgroundUIV addSubview:nickName];
    [nickName release];
    
    nickName = [[UILabel alloc] initWithFrame:CGRectMake(10, 8 + 50, 300, 25)];
    nickName.backgroundColor = [UIColor clearColor];
    nickName.text = [NSString stringWithFormat:@"出生地: %@",bornLoc];
    nickName.textColor = [UIColor grayColor];
    [backgroundUIV addSubview:nickName];
    [nickName release];
    
    nickName = [[UILabel alloc] initWithFrame:CGRectMake(10, 8 + 75, 300, 25)];
    nickName.backgroundColor = [UIColor clearColor];
    nickName.text = [NSString stringWithFormat:@"经纬度: %@",positionString];
    nickName.textColor = [UIColor grayColor];
    [backgroundUIV addSubview:nickName];
    [nickName release];
    
    
    
    nickName = [[UILabel alloc] initWithFrame:CGRectMake(10, 8 + 100, 300, 25)];
    nickName.backgroundColor = [UIColor clearColor];
    nickName.text = [NSString stringWithFormat:@"时区:%@",timeZoneString];
    nickName.textColor = [UIColor grayColor];
    [backgroundUIV addSubview:nickName];
    [nickName release];
    
    
    
    XZWAstrolabeView *xzwav = [[XZWAstrolabeView alloc]  initWithFrame:CGRectMake(23, 20, 274, 274)];
    xzwav.dataSource = self ;
    [mainUSV addSubview:xzwav];
    [xzwav release];
    
    UIButton *saveAstroButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveAstroButton addTarget:self action:@selector(saveAstro) forControlEvents:UIControlEventTouchUpInside];
    [saveAstroButton setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
    saveAstroButton.frame = CGRectMake(274, 274 , 16, 16);
    [saveAstroButton  setImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
    [mainUSV addSubview:saveAstroButton];
    
    
    
    UIImageView *bottomUIV = [[UIImageView alloc]  initWithFrame:CGRectMake(10, 480, 303, 90)];
    bottomUIV.image = [UIImage imageNamed:@"lable"];
    [mainUSV addSubview:bottomUIV];
    [bottomUIV release];
    
    
    UIButton *astrolabeInfo = [UIButton buttonWithType:UIButtonTypeCustom];
    [astrolabeInfo addTarget:self action:@selector(astrolabeInfoAction) forControlEvents:UIControlEventTouchUpInside];
    astrolabeInfo.frame = CGRectMake(10, 480, 320, 45);
    [astrolabeInfo  setImage:nil forState:UIControlStateNormal];
    [mainUSV addSubview:astrolabeInfo];
    
    
    UILabel *tipUL = [[UILabel alloc]  initWithFrame:CGRectMake(10, 3, 320, 45)];
    tipUL.text = @"星盘信息";
    tipUL.font = [UIFont systemFontOfSize:15];
    tipUL.backgroundColor = [UIColor clearColor];
    tipUL.textColor = [XZWUtil xzwRedColor];
    [astrolabeInfo addSubview:tipUL];
    [tipUL release];
    
    
    
    
    
    UIButton *astrolabeResult = [UIButton buttonWithType:UIButtonTypeCustom];
    [astrolabeResult addTarget:self action:@selector(astrolabeResultAction) forControlEvents:UIControlEventTouchUpInside];
    astrolabeResult.frame = CGRectMake(10, 480 + 45, 320, 45);
    [astrolabeResult  setImage:nil forState:UIControlStateNormal];
    [mainUSV addSubview:astrolabeResult];
    
    tipUL = [[UILabel alloc]  initWithFrame:CGRectMake(10, 0, 320, 45)];
    tipUL.text = @"占算结果";
    tipUL.font = [UIFont systemFontOfSize:15];
    tipUL.backgroundColor = [UIColor clearColor];
    tipUL.textColor = [XZWUtil xzwRedColor];
    [astrolabeResult addSubview:tipUL];
    [tipUL release];
    
    mainUSV.contentSize = CGSizeMake(320, CGRectGetMaxY(astrolabeResult.frame) + 10 );
}

#pragma mark - action

-(void)saveAstro{
     
    
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[XZWUtil getDataBase]];
    
    [queue inDatabase:^(FMDatabase *db) {
        
        NSString *dbString = [NSString stringWithFormat:@"insert into User (name , year , month , day , hour , minute , daylight , timezone , longitude , latitude , am , sml ,birthday  ,locString ,timezoneString ) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@');",savedArray[0],savedArray[1],savedArray[2],savedArray[3], savedArray[4],savedArray[5], savedArray[6],savedArray[7],savedArray[8],savedArray[9],savedArray[10],savedArray[11],bornDate,bornLoc ,timeZoneString];
         
        
        [db executeUpdate:dbString];
        
    }];
    
    
    [[[[UIAlertView alloc]  initWithTitle:nil message:@"已经保存" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease]  show];
}

-(void)astrolabeResultAction{
    
    
    XZWAstrolabeDivinationViewController *astroResult = [[XZWAstrolabeDivinationViewController  alloc]  initWithArray:dataArray];
    [self.navigationController pushViewController:astroResult animated:true];
    [astroResult release];

    
}

-(void)astrolabeInfoAction{
    
    XZWAstrolabeInfoViewController *astroInfo = [[XZWAstrolabeInfoViewController  alloc]  initWithArray:dataArray];
    [self.navigationController pushViewController:astroInfo animated:true];
    [astroInfo release];
    
}

#pragma mark - date


-(NSArray *)getDataArray{
    
    return dataArray;
}

-(double)astrolableAst{
    return astVaule;
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
