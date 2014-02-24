//
//  XZWMainViewController.m
//  XZW
//
//  Created by Dee on 13-8-27.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWMainViewController.h"
#import "IIViewDeckController.h"
#import "XZWUtil.h"
#import "Interface.h"
#import "XZWStarView.h"
#import "RCLabel.h"
#import "XZWZodiacData.h"
#import "XZWSelectSkinViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "XZWMyProfileViewController.h"
#import "XZWIssueDetailViewController.h"
#import "XZWVistorsViewController.h"
#import "XZWFriendBirthdayViewController.h"
#import "XZWDBOperate.h"
#import "XZWFortuneResultViewController.h"

@interface XZWMainViewController (){


    UIScrollView *fortuneUSV,*astroUSV; //星座 usv;

    UIScrollView *mainUSV;

    ASIHTTPRequest *funtuneRequest;

    BOOL funtuneLoading;

    UIImageView *backUIV;

    //  NSString *st;

    ASIHTTPRequest *mainRequest;

    BOOL mainLoading;

    UILabel *issueUL;
    UILabel *tipTitleUL,*tipsDesUL;

    NSDictionary *tempDic;
}

@end

@implementation XZWMainViewController

static const float XZWDegreeToPiex =  135.f/30.5f; // (像素 每天)

static const int XZWActiveStartTag = 9999;

static const int XZWSameZodiacStartTag = 999;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loginFinish
{
    self.title = [NSString stringWithFormat:@"您好,%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"username"]];


    for( UIView *subview in mainUSV.subviews ){

        [subview  removeFromSuperview];
        subview = nil;

    }

    [self initView];


    //    if ( [[[NSUserDefaults standardUserDefaults] objectForKey:@"oldUserID"]  intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]  intValue]){
    //
    //
    //    }
}

-(void)dealloc
{

    if (mainLoading) {
        [mainRequest cancel];

    }

    if (funtuneLoading) {
        [funtuneRequest cancel];
    }

    if (tempDic) {
        [tempDic  release];
        tempDic = nil;
    }




    [super dealloc];
}



#pragma mark -

-(void)viewWillAppear:(BOOL)animated
{

    self.viewDeckController.panningMode = IIViewDeckFullViewPanning;


    [super viewWillAppear:animated];
}


-(void)viewWillDisappear:(BOOL)animated
{

    self.viewDeckController.panningMode = IIViewDeckNoPanning;

    [super viewWillDisappear:animated];
}


#pragma mark -


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.


    self.title = [NSString stringWithFormat:@"您好,%@",[[[NSUserDefaults standardUserDefaults] valueForKey:@"username"]  description]];



    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFinish) name:XZWLoginNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkinAction:) name:XZWChangeSkinNotification object:nil];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];


    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self action:@selector(toggleView) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"function"] forState:UIControlStateNormal];


    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];

    listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self action:@selector(selectSkin) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"skin"] forState:UIControlStateNormal];


    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];





#pragma mark - self.view

    mainUSV = [[UIScrollView alloc]  initWithFrame:CGRectMake(0, 0, 320, TotalScreenHeight - 64)];
    mainUSV.showsHorizontalScrollIndicator = mainUSV.showsVerticalScrollIndicator = false;
    [self.view  addSubview: mainUSV ];
    [mainUSV release];


    [self initView];

}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

-(void)selectSkin{

    XZWSelectSkinViewController *selectSkin = [[XZWSelectSkinViewController alloc]  init];
    [self.navigationController pushViewController:selectSkin animated:true];
    [selectSkin release];

}

-(void)changeSkinAction:(UIButton*)sender{



    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"Skin"] >= 0 ) {


        backUIV.image = [UIImage imageNamed:[NSString stringWithFormat:@"indeximg_%d",[[NSUserDefaults standardUserDefaults] integerForKey:@"Skin"] + 1 ]];

    }else {

        backUIV.image = [UIImage imageWithContentsOfFile:[[XZWUtil getMyPath] stringByAppendingPathComponent:@"skin.png" ]];


    }


}


#pragma mark -

// 初始化主页的第二部分--星座运势，包括“整体运势”“爱情运势”“事业学业”“财富运势”
-(void)regen{


    for (UIView *subview in [astroUSV subviews]) {

        [subview removeFromSuperview];
        subview = nil;

    }




    int constellation = [[[NSUserDefaults standardUserDefaults]      objectForKey:@"constellation"]  intValue];


    funtuneLoading = true;

    // 注意一个很大的completionBlock
    funtuneRequest = [XZWNetworkManager asiWithLink:[NSString stringWithFormat:@"%@%d",XZWGetFortuneByOne,constellation + 1] postDic:nil completionBlock:^{



        funtuneLoading = false;

        NSDictionary *dataDic =  [[funtuneRequest  responseString]  objectFromJSONString][0];



        NSArray *astroPicArray =  @[@"baiyang", @"jinniu",@"shuangzi",@"juxie",@"shizi",@"chunv",@"tiancheng",@"tianxie",@"sheshou",@"mojie",@"shuiping",@"shuangyu"];

        //    NSArray *descriptionArray = @[@"运势概述",@"爱情运势",@"事业学业",@"财富运势",@"",@"",@"",@"" ];
        //
        //    NSArray *tipsArray = @[@"旁门左道不可信,如果有跟你宣传不实或者虚无缥缈的内容，记得听听就好，不可相信，否则就会上了人家的当。",@"两人相处需要循序渐进，你火辣的性格一下子就能上升到极点，但别忘了对方可是个含蓄的人。",@"向来做事风格大胆的你，敢走不寻常路，风险也大，但你应变能力够强，能消除工作上遇到的障碍",@"小露钱财，如若不及时控制，很容易就出现资金周转不灵",@"吃苦的可是自己哟～",@"",@"",@"" ];
        //
        for (int i = 0 ; i < 4; i++) {

            UIView *astroFortView = [[UIView alloc]   initWithFrame:CGRectMake(i * 320, 0, 320, 320)];
            [astroUSV addSubview:astroFortView];
            [astroFortView release];



            UIButton *fortuneButton = [UIButton buttonWithType:UIButtonTypeCustom];
            fortuneButton.frame = CGRectMake(0, 0, 90, 120);
            [fortuneButton addTarget:self action:@selector(fortuneAction) forControlEvents:UIControlEventTouchUpInside];
            [astroFortView addSubview:fortuneButton];


            UIImageView  *astroUIV = [[UIImageView alloc]   initWithImage:[UIImage imageNamed: astroPicArray[constellation]]];
            astroUIV.center = CGPointMake(40,54);
            [astroFortView addSubview:astroUIV];
            [astroUIV release];


            UILabel *astroFortune =[[UILabel alloc]  initWithFrame:CGRectMake(8, 80, 120, 40)];
            astroFortune.textColor = [UIColor grayColor];
            astroFortune.font = [UIFont boldSystemFontOfSize:14];
            astroFortune.textColor = [XZWUtil xzwRedColor];
            astroFortune.text = [[XZWZodiacData getSignArray][constellation]   stringByAppendingString:@"运势"];
            astroFortune.backgroundColor = [UIColor clearColor];
            [astroFortView addSubview:astroFortune];
            [astroFortune release];



            UIImageView *backgroundUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(90, 5, 215, 114)];
            backgroundUIV.image = [[UIImage imageNamed:@"corner"]  stretchableImageWithLeftCapWidth:12 topCapHeight:12];
            [astroFortView addSubview:backgroundUIV];
            [backgroundUIV release];


            UILabel *tipsUL = [[UILabel alloc]  initWithFrame:CGRectMake( 10  , 10, 200, 20)];
            [tipsUL setText: dataDic[@"data"][i][@"title"] ];
            tipsUL.textColor = [XZWUtil xzwRedColor];
            tipsUL.font = [UIFont boldSystemFontOfSize:15];
            tipsUL.backgroundColor = [UIColor clearColor];
            [backgroundUIV addSubview:tipsUL];
            [tipsUL release];


            //        tipsUL = [[UILabel alloc]  initWithFrame:CGRectMake( 10  , 35 , 200, 70)];
            //        tipsUL.textColor = [UIColor grayColor];
            //        tipsUL.text = dataDic[@"data"][i][@"val"];
            //        tipsUL.numberOfLines = 0;
            //        tipsUL.font = [UIFont systemFontOfSize:14];
            //        tipsUL.backgroundColor = [UIColor clearColor];
            //        [backgroundUIV addSubview:tipsUL];
            //        [tipsUL release];


            UITextView *utv = [[UITextView alloc]   initWithFrame:CGRectMake( 0  , 30 , 210, 75)];
            utv.backgroundColor = [UIColor clearColor];
            utv.text = dataDic[@"data"][i][@"val"];
            [utv setEditable:false];
            utv.editable = false;
            utv.showsHorizontalScrollIndicator = utv.showsVerticalScrollIndicator = false;
            utv.textColor = [UIColor grayColor];
            utv.font = [UIFont systemFontOfSize:14];
            [backgroundUIV addSubview:utv];
            [utv release];

            backgroundUIV.userInteractionEnabled = true;


            XZWStarView *starview =[[XZWStarView alloc]  initWithFrame:CGRectMake(   75 ,   14, 70, 15) star:[dataDic[@"index"][i][@"star"] intValue] ];
            [backgroundUIV addSubview:starview];
            [starview release];

        }


        [astroUSV  setContentSize:CGSizeMake(320 * 4, CGRectGetHeight(astroUSV.frame))];


        ;} failedBlock:^{
            funtuneLoading = false;
        }];


}


#pragma mark - action

-(void)fortuneAction
{


    XZWFortuneResultViewController *resultViewController = [[XZWFortuneResultViewController alloc]   initWithAstroID:[[[NSUserDefaults standardUserDefaults]      objectForKey:@"constellation"]  intValue] + 1 ];
    [self.navigationController pushViewController:resultViewController animated:true];
    [resultViewController release];
}


#pragma mark - init


-(void)initView
{


    //  mainUSV.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];

    backUIV = [[UIImageView alloc]  initWithFrame:CGRectMake(0, 0, 320, 155)];
    [mainUSV addSubview:backUIV];
    [backUIV release];




    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"Skin"] >= 0 ) {


        backUIV.image = [UIImage imageNamed:[NSString stringWithFormat:@"indeximg_%d",[[NSUserDefaults standardUserDefaults] integerForKey:@"Skin"] + 1 ]];

    }else {

        backUIV.image = [UIImage imageWithContentsOfFile:[[XZWUtil getMyPath] stringByAppendingPathComponent:@"skin.png" ]];


    }



    // int constellation = [[[NSUserDefaults standardUserDefaults]      objectForKey:@"constellation"]  intValue];


    NSCalendar *gregorian = [[[NSCalendar alloc]
                              initWithCalendarIdentifier:NSGregorianCalendar] autorelease];


    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDate *date =    [NSDate date];

    NSDateComponents *comps = [gregorian components:unitFlags fromDate:date];

    [comps setCalendar:gregorian];

    int year = comps.year;
    int month = comps.month;
    int day = comps.day;




    NSString *astrString = [[XZWUtil findAstro:[NSString stringWithFormat:@"%02d%02d",month,day]] objectAtIndex:1];

    UILabel *todayUL = [[UILabel alloc]  initWithFrame:CGRectMake(13, 13, 310, 30)];
    todayUL.backgroundColor = [UIColor clearColor];
    todayUL.textColor = [UIColor whiteColor];
    todayUL.font = [UIFont systemFontOfSize:16];
    [todayUL setText: [NSString stringWithFormat:@"今天出生的朋友是%@",astrString] ];
    [mainUSV addSubview:todayUL];
    [todayUL release];

    todayUL = [[UILabel alloc]  initWithFrame:CGRectMake(13, 40, 310, 30)];
    todayUL.backgroundColor = [UIColor clearColor];
    todayUL.textColor = [UIColor whiteColor];
    todayUL.font = [UIFont systemFontOfSize:16];
    [todayUL setText:[NSString stringWithFormat:@"同时您的%@朋友也可能是今天生日",astrString]];
    [mainUSV addSubview:todayUL];
    [todayUL release];

    UIButton *issueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [issueButton setFrame:CGRectMake(14, 73, 298, 26)];
    [issueButton addTarget:self
                    action:@selector(todayIssue) forControlEvents:UIControlEventTouchUpInside];
    [issueButton   setImage:[UIImage imageNamed:@"t_white"] forState:UIControlStateNormal];
    [mainUSV addSubview:issueButton];


    UIImageView *backgroundView = [[UIImageView alloc]  initWithFrame:CGRectMake(4, 2, 59, 21)];
    backgroundView.image = [UIImage imageNamed:@"t_discuss"];
    [issueButton addSubview:backgroundView];
    [backgroundView  release];


    UILabel *todaysIssueUL = [[UILabel alloc]  initWithFrame:CGRectMake(2, -2, 45, 21)];
    todaysIssueUL.backgroundColor = [UIColor clearColor];
    todaysIssueUL.text = @"今日讨论";
    todaysIssueUL.adjustsFontSizeToFitWidth = true;
    todaysIssueUL.textColor = [UIColor whiteColor];
    [backgroundView addSubview:todaysIssueUL];
    [todaysIssueUL release];


    // 今日讨论的副标题
    issueUL = [[UILabel alloc]   initWithFrame:CGRectMake(70, 0, 200, 21)];
    issueUL.text = @"哪个星座的情商最高？";
    issueUL.backgroundColor = [UIColor clearColor];
    issueUL.textColor = [XZWUtil xzwRedColor];
    [backgroundView addSubview:issueUL];
    [issueUL release];




    fortuneUSV = [[UIScrollView alloc]  initWithFrame:CGRectMake(0, 100, 320, 57)];
    fortuneUSV.delegate = self;
    fortuneUSV.showsHorizontalScrollIndicator = fortuneUSV.showsVerticalScrollIndicator = false;
    [mainUSV addSubview:fortuneUSV];
    [fortuneUSV release];
    [fortuneUSV  setContentSize:CGSizeMake(1380 +280, 57)];



    UIImageView *lineImage = [[UIImageView alloc]   initWithFrame:CGRectMake(-80, 28, 1380 + 480, 4)];
    lineImage.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dotted"]];
    [fortuneUSV addSubview:lineImage];
    [lineImage release];


    //   [ndf setCalendar:gregorian];




    NSDateFormatter *ndf = [[[NSDateFormatter alloc]  init]  autorelease];

    [ndf   setDateFormat:@"yyyyMMdd"];

    NSDate *referenceDate = [ndf dateFromString: [NSString stringWithFormat:@"%d0321",  year  ] ];

    NSArray *astroArray = @[@[@"0321",@"0420",@"白羊座"], @[@"0421",@"0521",@"金牛座"],  @[@"0522",@"0621",@"双子座"], @[@"0622",@"0722",@"巨蟹座"], @[@"0723",@"0822",@"狮子座"], @[@"0823",@"0923",@"处女座"], @[@"0924",@"1023",@"天秤座"], @[@"1024",@"1122",@"天蝎座"], @[@"1123",@"1221",@"射手座"], @[@"1222",@"1231",@"摩羯座"], @[@"0101",@"0120",@"摩羯座"],
                            @[@"0121",@"0219",@"水瓶座"], @[@"0220",@"0320",@"双鱼座"]  ];

    NSTimeInterval interval =  [date timeIntervalSinceDate:referenceDate];





    int nowIntervalDay = (int)interval / 24  /3600;




    for (int i = 0;  i <  [astroArray   count] ; i++) {


        if (i == 10 ) {

            continue ;
        }


        NSDate *theDate =  nil ;


        theDate = [ndf dateFromString: [NSString stringWithFormat:@"%d%@",year, astroArray[i][0]] ];


        if ( [theDate   compare:referenceDate] == NSOrderedAscending    ) {

            theDate = [ndf dateFromString: [NSString stringWithFormat:@"%d%@",year + 1, astroArray[i][0]] ]  ;


        }



        NSTimeInterval interval =  [theDate timeIntervalSinceDate:referenceDate];


        int intervalDay = (int)interval / 24  / 3600;



        if ( ( nowIntervalDay - intervalDay ) <= 31  && ( nowIntervalDay - intervalDay ) >= 0 ) {


            [fortuneUSV scrollRectToVisible:CGRectMake( 23 - 23 + intervalDay * XZWDegreeToPiex, 0, 320, 20) animated:false];

        }





        UIImageView *uiv = [[UIImageView alloc]   initWithFrame:CGRectMake( XZWDegreeToPiex * 30.5 * i , 20, 20, 20)];
        uiv.center = CGPointMake(  23 + intervalDay * XZWDegreeToPiex , 30);
        uiv.image = [UIImage imageNamed:@"round"];
        [fortuneUSV addSubview:uiv];
        [uiv release];


        UILabel *astroUL = [[UILabel alloc]  initWithFrame:CGRectMake(-5, 9, 320, 25)];
        astroUL.text =  [NSString stringWithFormat:@"%@ %@~%@",astroArray[i][2],[NSString stringWithFormat:@"%d.%@" , [[ astroArray[i][0]    substringToIndex:2]   intValue],[ astroArray[i][0]    substringWithRange:NSMakeRange(2, 2)]],[NSString stringWithFormat:@"%d.%@" , [[ astroArray[i][1]    substringToIndex:2]   intValue],[ astroArray[i][1]    substringWithRange:NSMakeRange(2, 2)]]  ] ; //@"白羊座 3.21-4.20";
        astroUL.textColor = [UIColor whiteColor];
        astroUL.font = [UIFont systemFontOfSize:10];
        [astroUL setBackgroundColor:[UIColor clearColor]];
        [uiv addSubview:astroUL];
        [astroUL release];


    }


    BOOL nextYear = false ;

    if ( (month <= 3 && day < 21 )  || ( month <=  2)  ) {

        nextYear = true;
    }


    referenceDate = [ndf dateFromString: [NSString stringWithFormat:@"%d0321",nextYear? year - 1 : year  ] ];

    interval =  [date timeIntervalSinceDate:referenceDate];

    nowIntervalDay = (int)interval / 24  /3600;


    UIImageView *uiv = [[UIImageView alloc]   initWithFrame:CGRectMake( XZWDegreeToPiex * 30.5 * nowIntervalDay , 20, 20, 20)];
    uiv.center = CGPointMake(  23 + nowIntervalDay * XZWDegreeToPiex , 30);
    uiv.image = [UIImage imageNamed:@"in_star"];
    [fortuneUSV addSubview:uiv];
    [uiv release];


    UILabel *astroUL = [[UILabel alloc]  initWithFrame:CGRectMake(-2, -14, 320, 25)];
    astroUL.text =  [NSString stringWithFormat:@"%02d%02d",month,day] ; //@"白羊座 3.21-4.20";
    astroUL.textColor = [UIColor whiteColor];
    astroUL.font = [UIFont systemFontOfSize:10];
    [astroUL setBackgroundColor:[UIColor clearColor]];
    [uiv addSubview:astroUL];
    [astroUL release];







    //////////






    // 首页第二部分，星座运势
    astroUSV = [[UIScrollView alloc]  initWithFrame:CGRectMake(0, 160, 320, 130)];
    astroUSV.showsHorizontalScrollIndicator = astroUSV.showsVerticalScrollIndicator = false;
    astroUSV.decelerationRate = UIScrollViewDecelerationRateFast;
    astroUSV.pagingEnabled = true;
    [mainUSV addSubview:astroUSV];
    [astroUSV release];


    [self regen];



    mainLoading = true;
    
    mainRequest = [XZWNetworkManager asiWithLink:XZWMain postDic:nil completionBlock:^{

        mainLoading = false;

        tempDic = [[mainRequest responseString]  objectFromJSONString];
        [tempDic   retain];



        UIImageView *lineUIV = [[UIImageView alloc]   initWithImage:[UIImage imageNamed:@"dotted1"]];
        lineUIV.frame = CGRectMake(0, CGRectGetMaxY(astroUSV.frame), 320, 1);
        [mainUSV addSubview:lineUIV];
        [lineUIV release];



        UIImageView * backgroundUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(16, CGRectGetMaxY(lineUIV.frame) + 15, 288, 165)];
        backgroundUIV.image = [[UIImage imageNamed:@"corner"]  stretchableImageWithLeftCapWidth:12 topCapHeight:12];
        [mainUSV addSubview:backgroundUIV];
        [backgroundUIV release];


        UIImageView *tipsUIV = [[UIImageView alloc]  initWithImage:[UIImage imageNamed:@"tips"]];
        tipsUIV.frame = CGRectMake(-2, -2, 68, 85);
        [backgroundUIV  addSubview:tipsUIV];
        [tipsUIV release];


        tipTitleUL = [[UILabel alloc]  initWithFrame:CGRectMake(5, 20, 288, 30)];
        tipTitleUL.backgroundColor = [UIColor clearColor];
        [backgroundUIV addSubview:tipTitleUL];
        [tipTitleUL release];
        tipTitleUL.textColor = [XZWUtil xzwRedColor];
        tipTitleUL.textAlignment = UITextAlignmentCenter;
        [tipTitleUL setText:tempDic[@"tips"][@"title"]];


        tipsDesUL = [[UILabel alloc]   initWithFrame:CGRectMake(10 , 60, 270, 30)];
        tipsDesUL.backgroundColor = [UIColor clearColor];
        tipsDesUL.numberOfLines = 0 ;
        tipsDesUL.font = [UIFont systemFontOfSize:14];
        tipsDesUL.textColor = [UIColor grayColor];
        [backgroundUIV addSubview:tipsDesUL];
        tipsDesUL.text = tempDic[@"tips"][@"content"];
        [tipsDesUL release];
        [tipsDesUL  sizeThatFits:CGSizeMake(270, 2000)];
        [tipsDesUL  sizeToFit];

        backgroundUIV.frame = CGRectMake(16, CGRectGetMaxY(lineUIV.frame) + 15, 288, CGRectGetMaxY(tipsDesUL.frame) + 15);



        tipTitleUL.text = tempDic[@"tips"][@"title"];
        tipsDesUL.text = tempDic[@"tips"][@"content"];

        issueUL.text = tempDic[@"discuss"][@"title"];



        lineUIV = [[UIImageView alloc]   initWithImage:[UIImage imageNamed:@"grayline"]];
        lineUIV.frame = CGRectMake(0, CGRectGetMaxY(backgroundUIV.frame) + 15 , 320, 1);
        [mainUSV addSubview:lineUIV];
        [lineUIV release];


        //(start) 圈子活跃的人
        UILabel *quanUL = [[UILabel alloc]   initWithFrame:CGRectMake(0, CGRectGetMaxY(lineUIV.frame) + 5, 320, 25)];
        quanUL.backgroundColor = [UIColor clearColor];
        quanUL.textColor = [UIColor grayColor];
        quanUL.text = @"   圈子活跃的人";
        [mainUSV addSubview:quanUL];
        [quanUL release];



        if ([tempDic[@"active"]  isKindOfClass:[NSArray class]]) {

            for (int i = 0 ; i < ([tempDic[@"active"] count] < 6 ? [tempDic[@"active"] count] :6) ; i++) {

                UIButton *avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
                avatarButton.tag = i;
                [avatarButton addTarget:self action:@selector(active:) forControlEvents:UIControlEventTouchUpInside];
                avatarButton.frame = CGRectMake(9 + 50 * i , CGRectGetMaxY(quanUL.frame) +5, 45, 45);
                avatarButton.layer.cornerRadius = 5;
                avatarButton.layer.masksToBounds = true;
                [avatarButton setImageWithURL:[NSURL URLWithString:tempDic[@"active"][i][@"avatar"]]   forState:UIControlStateNormal];
                [mainUSV addSubview:avatarButton];



                UILabel *nameUL = [[UILabel alloc]  initWithFrame:CGRectMake(9 + 50 * i, CGRectGetMaxY(avatarButton.frame) + 0, 45, 20)];
                nameUL.text = tempDic[@"active"][i][@"uname"];
                nameUL.textAlignment = UITextAlignmentCenter;
                nameUL.font = [UIFont systemFontOfSize:13];
                nameUL.adjustsFontSizeToFitWidth = true;
                nameUL.textColor = [XZWUtil xzwRedColor];
                nameUL.backgroundColor = [UIColor clearColor];
                [mainUSV addSubview:nameUL];
                [nameUL release];

            }

        }
        //(end) 圈子活跃的人


        lineUIV = [[UIImageView alloc]   initWithImage:[UIImage imageNamed:@"dotted1"]];
        lineUIV.frame = CGRectMake(0, CGRectGetMaxY(quanUL.frame) + 70 , 320, 1);
        [mainUSV addSubview:lineUIV];
        [lineUIV release];


        //(start) 同星座的人
        quanUL = [[UILabel alloc]   initWithFrame:CGRectMake(0, CGRectGetMaxY(lineUIV.frame) + 5, 320, 25)];
        quanUL.backgroundColor = [UIColor clearColor];
        quanUL.textColor = [UIColor grayColor];
        quanUL.text = @"   同星座的人";
        [mainUSV addSubview:quanUL];
        [quanUL release];

        if ([tempDic[@"active"]  isKindOfClass:[NSArray class]]) {


            for (int i = 0 ; i < ([tempDic[@"same"] count] < 6 ? [tempDic[@"same"] count] :6) ; i++) {

                UIButton *avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
                avatarButton.tag = i;
                avatarButton.frame = CGRectMake(9 + 50 * i , CGRectGetMaxY(quanUL.frame) + 5, 45, 45);
                avatarButton.layer.cornerRadius = 5;
                [avatarButton addTarget:self action:@selector(same:) forControlEvents:UIControlEventTouchUpInside];
                avatarButton.layer.masksToBounds = true;
                [avatarButton setImageWithURL:[NSURL URLWithString:tempDic[@"same"][i][@"avatar"]]   forState:UIControlStateNormal];
                [mainUSV addSubview:avatarButton];


                UILabel *nameUL = [[UILabel alloc]  initWithFrame:CGRectMake(9 + 50 * i, CGRectGetMaxY(avatarButton.frame) + 0, 45, 20)];
                nameUL.text = tempDic[@"same"][i][@"uname"];
                nameUL.textAlignment = UITextAlignmentCenter;
                nameUL.font = [UIFont systemFontOfSize:13];
                nameUL.adjustsFontSizeToFitWidth = true;
                nameUL.textColor = [XZWUtil xzwRedColor];
                nameUL.backgroundColor = [UIColor clearColor];
                [mainUSV addSubview:nameUL];
                [nameUL release];

            }


        }
        //(end) 同星座的人


        lineUIV = [[UIImageView alloc]   initWithImage:[UIImage imageNamed:@"grayline"]];
        lineUIV.frame = CGRectMake(0, CGRectGetMaxY(quanUL.frame) + 70 , 320, 1);
        [mainUSV addSubview:lineUIV];
        [lineUIV release];


        //(start) 好友生日
        UIImageView *birthdayUIV = [[UIImageView alloc]  initWithFrame:CGRectMake(15, CGRectGetMaxY(lineUIV.frame) + 10, 24, 20)];
        [birthdayUIV setImage:[UIImage imageNamed:@"gift"]];
        [mainUSV addSubview:birthdayUIV];
        [birthdayUIV release];


        quanUL = [[UILabel alloc]   initWithFrame:CGRectMake(40, CGRectGetMaxY(lineUIV.frame) + 10, 320, 20)];
        quanUL.backgroundColor = [UIColor clearColor];
        quanUL.font = [UIFont systemFontOfSize:15];
        quanUL.textColor = [UIColor grayColor];
        quanUL.text = @"好友生日:";
        [mainUSV addSubview:quanUL];
        [quanUL release];


        RCLabel *tempLabel = [[RCLabel alloc] initWithFrame:CGRectMake(105, CGRectGetMaxY(lineUIV.frame) + 10, 320, 20)];
        //tempLabel.lineBreakMode = kCTLineBreakByTruncatingTail;
        RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle: [NSString stringWithFormat:@"<font size=15 color='#e14278'>%@</font><font size=15 color='#919191'>人<font>",tempDic[@"friend_birthday"]] ];
        tempLabel.componentsAndPlainText = componentsDS;
        [mainUSV addSubview:tempLabel];
        [tempLabel release];

        UIButton *birthdayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        birthdayButton.frame = tempLabel.frame;
        [birthdayButton addTarget:self action:@selector(birthdayAction) forControlEvents:UIControlEventTouchUpInside];
        [mainUSV addSubview:birthdayButton];
        //(end) 好友生日


        //(start) 最近访客
        birthdayUIV = [[UIImageView alloc]  initWithFrame:CGRectMake(15, CGRectGetMaxY(lineUIV.frame) + 15 + 28, 24, 20)];
        [birthdayUIV setImage:[UIImage imageNamed:@"visit"]];
        [mainUSV addSubview:birthdayUIV];
        [birthdayUIV release];


        quanUL = [[UILabel alloc]   initWithFrame:CGRectMake(40, CGRectGetMaxY(lineUIV.frame) + 15 + 30, 320, 20)];
        quanUL.backgroundColor = [UIColor clearColor];
        quanUL.textColor = [UIColor grayColor];
        quanUL.font = [UIFont systemFontOfSize:15];
        quanUL.text = @"最近访客:";
        [mainUSV addSubview:quanUL];
        [quanUL release];


        tempLabel = [[RCLabel alloc] initWithFrame:CGRectMake(105, CGRectGetMaxY(lineUIV.frame) + 15 + 30  , 320, 20)];
        //tempLabel.lineBreakMode = kCTLineBreakByTruncatingTail;
        componentsDS = [RCLabel extractTextStyle: [NSString stringWithFormat:@"<font size=15 color='#e14278'>%@</font><font size=15 color='#919191'>人<font>",tempDic[@"visitors"]] ];
        tempLabel.componentsAndPlainText = componentsDS;
        [mainUSV addSubview:tempLabel];
        [tempLabel release];

        birthdayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        birthdayButton.frame = tempLabel.frame;
        [birthdayButton addTarget:self action:@selector(vistorAction) forControlEvents:UIControlEventTouchUpInside];
        [mainUSV addSubview:birthdayButton];
        //(end) 最近访客



        lineUIV = [[UIImageView alloc]   initWithImage:[UIImage imageNamed:@"dotted1"]];
        lineUIV.frame = CGRectMake(0, CGRectGetMaxY(tempLabel.frame)  -30 , 320, 1);
        [mainUSV addSubview:lineUIV];
        [lineUIV release];



        [mainUSV  setContentSize:CGSizeMake(320, CGRectGetMaxY(lineUIV.frame) + 35 )];

    } failedBlock:^{

        mainLoading = false;

    }];



    //////
    /*
     UILabel *tipsUL = [[UILabel alloc]  initWithFrame:CGRectMake(0, 0, 320, 60)];
     tipsUL.backgroundColor = [UIColor clearColor];
     [tipsUL setText:@"运气不好建议不要出远门"];
     [mainUSV addSubview:tipsUL];
     [tipsUL release];

     UILabel *tipsDesc = [[UILabel alloc]  initWithFrame:CGRectMake(0, 0, 320, 110)];
     tipsDesc.text = @"理论发达";
     tipsDesc.backgroundColor = [UIColor clearColor];
     [mainUSV addSubview:tipsDesc];
     [tipsDesc release];



     UILabel *activeUL = [[UILabel alloc]  initWithFrame:CGRectMake(0, 0, 320, 40)];
     activeUL.text = @"圈子活跃的人";
     activeUL.backgroundColor = [UIColor clearColor];
     [mainUSV addSubview:activeUL];
     [activeUL release];

     UILabel *zodiacUL = [[UILabel alloc]  initWithFrame:CGRectMake(0, 0, 320, 40)];
     zodiacUL.text = @"同星座的人";
     zodiacUL.backgroundColor = [UIColor clearColor];
     [mainUSV addSubview:zodiacUL];
     [zodiacUL release];
     */

}


#pragma mark -

-(void)birthdayAction{

    XZWFriendBirthdayViewController *friendVC = [[XZWFriendBirthdayViewController alloc]  init];
    [self.navigationController pushViewController:friendVC animated:true];
    [friendVC release];
}

-(void)vistorAction{

    XZWVistorsViewController *friendVC = [[XZWVistorsViewController alloc]  init];
    [self.navigationController pushViewController:friendVC animated:true];
    [friendVC release];

}

#pragma mark -

-(void)todayIssue{


    if (tempDic) {

        XZWIssueDetailViewController *detailVC = [[XZWIssueDetailViewController alloc]  initWithDic:tempDic[@"discuss"]];
        [self.navigationController pushViewController:detailVC animated:true];
        [detailVC release];


    }

}


-(void)active:(UIButton*)sender{

    XZWMyProfileViewController *profileVC = [[XZWMyProfileViewController alloc] initUserID: [tempDic[@"active"][sender.tag][@"uid"]  intValue]];
    [self.navigationController pushViewController:profileVC animated:true];
    [profileVC release];

}

-(void)same:(UIButton*)sender{

    XZWMyProfileViewController *profileVC = [[XZWMyProfileViewController alloc] initUserID: [tempDic[@"same"][sender.tag][@"uid"]  intValue]];
    [self.navigationController pushViewController:profileVC animated:true];
    [profileVC release];
}


#pragma mark -

-(void)toggleView{
    
    
    [self.navigationController.viewDeckController  toggleLeftViewAnimated:true];
}

#pragma mark -

@end
