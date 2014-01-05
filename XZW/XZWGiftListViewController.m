//
//  XZWGiftListViewController.m
//  XZW
//
//  Created by dee on 13-9-29.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWGiftListViewController.h"
#import "XZWUtil.h"
#import "JSONKit.h"
#import <SDWebImage/UIButton+WebCache.h>

#import "MBProgressHUD.h"

@interface XZWGiftListViewController () <UIScrollViewDelegate,UIAlertViewDelegate>{
    
    ASIHTTPRequest *giftCatelogRequest;
    
    ASIHTTPRequest *giftListRequest;
    
    ASIHTTPRequest *sendRequest;
    
    NSMutableArray *catelogArray,*detailArray;
    
    MBProgressHUD *hud;
    
    BOOL isLoading;
    
    BOOL isFinished;
    
    int current;
    
    int totalPage;
    
    UIView *footerView;
}

@end

@implementation XZWGiftListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}




- (id)initWithName:(NSString*)nameString andUser:(int)theUserID{
    self = [super init];
    if (self) {
        // Custom initialization
        userID = theUserID;
        usernameString = nameString;
        [usernameString  retain];
        
        catelogArray = [[NSMutableArray alloc]   init];
        detailArray = [[NSMutableArray alloc]   init];
        
        current = 1;
        
        
    }
    return self;
}

 

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"挑选礼物";
    
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];

    
    
    UILabel *sendTips = [[UILabel alloc]   initWithFrame:CGRectMake(10, 10, 200, 30)];
    sendTips.text = @"挑选一个礼物送给";
    sendTips.font = [UIFont systemFontOfSize:16];
    [sendTips setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:sendTips];
    [sendTips release];
    
    sendTips = [[UILabel alloc]   initWithFrame:CGRectMake(140, 9, 220, 30)];
    sendTips.text = usernameString;
    sendTips.font = [UIFont systemFontOfSize:17];
    sendTips.textColor = [XZWUtil xzwRedColor];
    [sendTips setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:sendTips];
    [sendTips release];
    
    
    catelogUSV = [[UIScrollView alloc]  initWithFrame:CGRectMake(10, 40, 300, 30)];
    catelogUSV.showsHorizontalScrollIndicator = catelogUSV.showsVerticalScrollIndicator = false;
    [self.view addSubview:catelogUSV];
    [catelogUSV release];
    
    
    contentUSV = [[UIScrollView alloc]  initWithFrame:CGRectMake(10, 80, 300, TotalScreenHeight - 64 - 80)];
    contentUSV.showsHorizontalScrollIndicator = contentUSV.showsVerticalScrollIndicator = false;
    contentUSV.delegate = self;
    [self.view addSubview:contentUSV];
    [contentUSV release];
    
    
    footerView = [[[UIView alloc]  initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];
    [contentUSV  addSubview:footerView];
    
    UILabel *ul = [[UILabel alloc]  initWithFrame:CGRectMake(0, 0, 320, 40)];
    ul.text = @"加载中...";
    ul.backgroundColor = [UIColor clearColor];
    ul.textAlignment = UITextAlignmentCenter ;
    [footerView addSubview:ul];
    [ul release];
    
    UIActivityIndicatorView *uaiv = [[UIActivityIndicatorView alloc]  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    uaiv.frame = CGRectMake(95, 5, 30, 30);
    [footerView addSubview:uaiv];
    [uaiv release];
    [uaiv startAnimating];
    
    
    UIImageView *giftLine = [[UIImageView alloc]   initWithFrame:CGRectMake(0, 72, 320, 1)];
    [giftLine setImage:[UIImage imageNamed:@"lines1"]];
    [self.view addSubview:giftLine];
    [giftLine release];
    
    
    footerView.hidden = true;
    
    
    
    //
    
    
    
    hud = [[MBProgressHUD alloc]  initWithView:self.view];
    [self.navigationController.view addSubview:hud];
    [hud release];

    
    
    
    giftCatelogRequest =  [XZWNetworkManager asiWithLink:XZWGiftCategory postDic:nil completionBlock:^{
        
        NSDictionary *responseDic = [[giftCatelogRequest responseString]    objectFromJSONString];
        
        
        int totalWidth = 0.f;
        
        if ([responseDic[@"status"]   intValue]  == 1  ) {
             
            [catelogArray   setArray:responseDic[@"data"]];
            
            
            for (int i = 0 ; i < [catelogArray count]; i++) {
                
                
                UIButton *catelogButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [catelogButton setTag:i+1];
                [catelogButton addTarget:self action:@selector(cateAction:) forControlEvents:UIControlEventTouchUpInside];
                //  [catelogButton titleLabel].font = [UIFont systemFontOfSize:16];
                [catelogButton titleLabel].font = [UIFont systemFontOfSize:15];
                [catelogButton  setTitle:catelogArray[i][@"name"] forState:UIControlStateNormal];
                [catelogButton  setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                [catelogButton  setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [catelogButton    setImage:nil forState:UIControlStateNormal];
                [catelogButton    setBackgroundImage:[[UIImage imageNamed:@"s_block"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateSelected];
                catelogButton.frame = CGRectMake(totalWidth , 0, 44, 20);
                [catelogButton  sizeToFit];
                catelogButton.titleLabel.textAlignment = UITextAlignmentCenter;
                [catelogUSV addSubview:catelogButton];
                
                
                totalWidth += CGRectGetWidth(catelogButton.frame) + 10 ;
                
                
                if (i==0) {
                    
                    catelogButton.selected = true;
                }
                
                
            }
            
            
            [catelogUSV   setContentSize:CGSizeMake(totalWidth, CGRectGetHeight(catelogUSV.frame))];
            
            
            
        }
        
        if ([catelogArray count] ==0) {
            
            return  ;
        }
        
        
        
        giftListRequest =  [XZWNetworkManager asiWithLink:[XZWSearchGift stringByAppendingFormat:@"&categoryid=%@&p=%d",catelogArray[0][@"id"],current] postDic:nil completionBlock:^{
            
            
            
            
            for (UIView *subview in [contentUSV subviews]) {
                if (subview != footerView) {
                    
                    [subview  removeFromSuperview];
                }
            }
             
            
            
            
            NSDictionary *responseDic = [[giftListRequest responseString]    objectFromJSONString];
            
            
            
            totalPage = [[[responseDic   objectForKey:@"data"]   objectForKey:@"totalPages"]  intValue];
            
            [detailArray   setArray:responseDic[@"data"][@"data"] ];
            
            for (int i = 0; i < [responseDic[@"data"][@"data"]  count]; i++  ) {
                
                UIButton *dataButton = [UIButton buttonWithType:UIButtonTypeCustom];
                dataButton.exclusiveTouch = true;
                dataButton.frame = CGRectMake(8 + 75 * (i % 4 ) , 10 + 110 * (i / 4 )   , 60, 60);
                dataButton.tag = i + 1;
               // [dataButton setTitle:responseDic[@"data"][@"data"][i][@"name"] forState:UIControlStateNormal];
                [dataButton  setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@apps/gift/Tpl/default/Public/gift/%@",XZWHost,[responseDic[@"data"][@"data"][i]  objectForKey:@"img"]]] forState:UIControlStateNormal];
                [dataButton  addTarget:self action:@selector(sendGift:) forControlEvents:UIControlEventTouchUpInside];
                [contentUSV addSubview:dataButton];
                
                UILabel *nameUL = [[UILabel alloc]   initWithFrame:CGRectMake(0, CGRectGetHeight(dataButton.frame)  , 60, 25)];
                nameUL.textAlignment = UITextAlignmentCenter ;
                nameUL.adjustsFontSizeToFitWidth = true;
                nameUL.font = [UIFont systemFontOfSize:15];
                nameUL.backgroundColor = [UIColor clearColor];
                nameUL.textColor = [XZWUtil xzwRedColor];
                nameUL.text = responseDic[@"data"][@"data"][i][@"name"];
                [dataButton   addSubview:nameUL];
                [nameUL release];
                
                nameUL = [[UILabel alloc]   initWithFrame:CGRectMake(5, CGRectGetHeight(dataButton.frame) + 20, 60, 25)];
                nameUL.backgroundColor = [UIColor clearColor];
                nameUL.textColor = [UIColor grayColor];
                nameUL.font = [UIFont systemFontOfSize:13];
                nameUL.text = [responseDic[@"data"][@"data"][i][@"price"]   stringByAppendingString:@" 金币"] ;
                [dataButton   addSubview:nameUL];
                [nameUL release];
            
                
                
                
            }
            
            
            
            [contentUSV   setContentSize:CGSizeMake( CGRectGetWidth(contentUSV.frame),  110 *   ceil((CGFloat)[responseDic[@"data"][@"data"]  count] / 4) + 55  )];
            
            
            if ([responseDic[@"data"][@"data"]  count] < 20  ||  current == totalPage ) {
                
                isFinished = true;
                footerView.hidden = true;
                [contentUSV   setContentSize:CGSizeMake( CGRectGetWidth(contentUSV.frame), 110 *   ceil([responseDic[@"data"][@"data"]  count] / 4) + 5 )];
                
            }else {
                
                isFinished = false;
                footerView.frame = CGRectMake(0, contentUSV.contentSize.height - 40 , 320, 40);
                footerView.hidden = false;
            }
            
            
            
        } failedBlock:nil];
        
        
        
  

        
        
        
        ;} failedBlock:nil];
    
}

-(void)sendGift:(UIButton*)sender{
    
         
    
   UIAlertView *alertView = [[[UIAlertView alloc]  initWithTitle:@"确定要送以下礼物吗？" message:[NSString stringWithFormat:@"%@ %@金币",detailArray[sender.tag - 1][@"name"], detailArray[sender.tag - 1][@"price"] ] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] autorelease]   ;
    
    alertView.tag = sender.tag - 1;
    
    [alertView  show];
    
    
}

#pragma mark - alertview


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (buttonIndex != alertView.cancelButtonIndex) {
        
        
        hud.labelText = @"正在赠送，请稍候...";
        [hud  show:true];
        
        NSDictionary *argDic = @{@"fri_ids":[NSString stringWithFormat:@"%d",userID],@"sendWay":@"1",@"giftId":detailArray[alertView.tag][@"id"],@"sendInfo":@"" };
         
        
        sendRequest = [XZWNetworkManager asiWithLink:XZWSendGift   postDic:argDic completionBlock:^{
            
            NSDictionary *responseDic = [[sendRequest  responseString]  objectFromJSONString];
            
             
            
            if ([responseDic[@"status"]  intValue] == 1) {
                
                
                hud.labelText = @"赠送成功!";
                
                [hud  hide:true afterDelay:.6f];
                
            }else {
                
                
                hud.labelText = responseDic[@"info"];
                [hud  hide:true afterDelay:1.f];
            };
            

            
            
            
            ;} failedBlock:^{
        
                
                hud.labelText = @"赠送失败!";
                [hud  hide:true afterDelay:1.f];
        
        }];
        
        
    }
    
    
}

-(void)cateAction:(UIButton*)sender{
    
    
    if (sender.selected) {
        
        
        return ;
    }
    
    
      UIView *theSuperView = (UIView *)[sender  superview];
    
    for (UIView *subView in theSuperView.subviews) {
        
        if ([subView isKindOfClass:[UIButton   class]] && subView != sender) {
            
            [(UIButton *)subView   setSelected:false];
            
        }
        
        
    }
    
    sender.selected = true;
    
    
    
    current = 1;
    
    clickTag = sender.tag - 1;
    
    
    if (isLoading) {
         
        [giftListRequest cancel];
        giftListRequest = nil;
    }
    
    isLoading = true;
    
    giftListRequest =  [XZWNetworkManager asiWithLink:[XZWSearchGift stringByAppendingFormat:@"&categoryid=%@&p=%d",catelogArray[clickTag][@"id"],current] postDic:nil completionBlock:^{
        
        
        
        for (UIView *subview in [contentUSV subviews]) {
            if (subview != footerView) {
                
                [subview  removeFromSuperview];
            }
        }
        
        
        
        
        
        NSDictionary *responseDic = [[giftListRequest responseString]    objectFromJSONString];
        
          [detailArray   setArray:responseDic[@"data"][@"data"] ];
        
        totalPage = [[[responseDic   objectForKey:@"data"]   objectForKey:@"totalPages"]  intValue];
        
        
        for (int i = 0; i < [responseDic[@"data"][@"data"]  count]; i++  ) {
            
            UIButton *dataButton = [UIButton buttonWithType:UIButtonTypeCustom];
            dataButton.exclusiveTouch = true;
            dataButton.frame = CGRectMake(8 + 75 * (i % 4 ) , 10 + 110 * (i / 4 )   , 60, 60);
            dataButton.tag = i + 1;
            // [dataButton setTitle:responseDic[@"data"][@"data"][i][@"name"] forState:UIControlStateNormal];
            [dataButton  setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@apps/gift/Tpl/default/Public/gift/%@",XZWHost,[responseDic[@"data"][@"data"][i]  objectForKey:@"img"]]] forState:UIControlStateNormal];
            [dataButton  addTarget:self action:@selector(sendGift:) forControlEvents:UIControlEventTouchUpInside];
            [contentUSV addSubview:dataButton];
            
            UILabel *nameUL = [[UILabel alloc]   initWithFrame:CGRectMake(0, CGRectGetHeight(dataButton.frame)  , 60, 25)];
            nameUL.textAlignment = UITextAlignmentCenter ;
            nameUL.adjustsFontSizeToFitWidth = true;
            nameUL.font = [UIFont systemFontOfSize:15];
            nameUL.backgroundColor = [UIColor clearColor];
            nameUL.textColor = [XZWUtil xzwRedColor];
            nameUL.text = responseDic[@"data"][@"data"][i][@"name"];
            [dataButton   addSubview:nameUL];
            [nameUL release];
            
            nameUL = [[UILabel alloc]   initWithFrame:CGRectMake(5, CGRectGetHeight(dataButton.frame) + 20, 60, 25)];
            nameUL.backgroundColor = [UIColor clearColor];
            nameUL.textColor = [UIColor grayColor];
            nameUL.font = [UIFont systemFontOfSize:13];
            nameUL.text = [responseDic[@"data"][@"data"][i][@"price"]   stringByAppendingString:@" 金币"] ;
            [dataButton   addSubview:nameUL];
            [nameUL release];
            
            
            
            
        }
        
        
        
        [contentUSV   setContentSize:CGSizeMake( CGRectGetWidth(contentUSV.frame),  110 *   ceil((CGFloat)[responseDic[@"data"][@"data"]  count] / 4) + 55  )];
        
        
        if ([responseDic[@"data"][@"data"]  count] < 20  ||  current == totalPage ) {
            
            isFinished = true;
            footerView.hidden = true;
            [contentUSV   setContentSize:CGSizeMake( CGRectGetWidth(contentUSV.frame), 110 *   ceil([responseDic[@"data"][@"data"]  count] / 4) + 5 )];
            
        }else {
            
            isFinished = false;
            footerView.frame = CGRectMake(0, contentUSV.contentSize.height - 40 , 320, 40);
            footerView.hidden = false;
        }
        

        
        isLoading = false;
        
    } failedBlock:^{
        isLoading = false ;
    
    }];
    
    
    
}

#pragma mark - next


- (void)loadNextPage{
    
    
     
    
    if (isLoading) {
        
        
        return ;
    }
    
    
    if (isFinished) {
        
        return ;
    }
    
    if (totalPage  <=  current) {
        
        
        isFinished = true;
        
        
        footerView.hidden = true;
        
        
        return ;
    }
    
    
    
    [XZWNetworkManager cancelAndReleaseRequest:giftListRequest];
    
    
    isLoading = true;
    
    giftListRequest =  [XZWNetworkManager asiWithLink:[XZWSearchGift stringByAppendingFormat:@"&categoryid=%@&p=%d",catelogArray[clickTag][@"id"],current + 1] postDic:nil completionBlock:^{
        
         
        
        
        NSDictionary *responseDic = [[giftListRequest responseString]    objectFromJSONString];
        
          [detailArray   addObjectsFromArray:responseDic[@"data"][@"data"] ];
        
        current ++ ;
        
        for (int i = 0; i < [responseDic[@"data"][@"data"]  count]; i++  ) {
             
            
            UIButton *dataButton = [UIButton buttonWithType:UIButtonTypeCustom];
            dataButton.exclusiveTouch = true;
            dataButton.frame = CGRectMake(8 + 75 * ( ((current - 1) * 20 +  i) % 4 )  , 10 + 110 * ( ((current - 1) * 20 +  i) / 4 )   , 60, 60);
            dataButton.tag = ((current - 1) * 20 +  i) + 1;
            [dataButton setTitle:responseDic[@"data"][@"data"][i][@"name"] forState:UIControlStateNormal];
            [dataButton  setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@apps/gift/Tpl/default/Public/gift/%@",XZWHost,[responseDic[@"data"][@"data"][i]  objectForKey:@"img"]]] forState:UIControlStateNormal];
            [dataButton  addTarget:self action:@selector(sendGift:) forControlEvents:UIControlEventTouchUpInside];
            [contentUSV addSubview:dataButton];
            
             
            
            UILabel *nameUL = [[UILabel alloc]   initWithFrame:CGRectMake(0, CGRectGetHeight(dataButton.frame)  , 60, 25)];
            nameUL.textAlignment = UITextAlignmentCenter ;
            nameUL.adjustsFontSizeToFitWidth = true;
            nameUL.font = [UIFont systemFontOfSize:15];
            nameUL.backgroundColor = [UIColor clearColor];
            nameUL.textColor = [XZWUtil xzwRedColor];
            nameUL.text = responseDic[@"data"][@"data"][i][@"name"];
            [dataButton   addSubview:nameUL];
            [nameUL release];
            
            nameUL = [[UILabel alloc]   initWithFrame:CGRectMake(5, CGRectGetHeight(dataButton.frame) + 20, 60, 25)];
            nameUL.backgroundColor = [UIColor clearColor];
            nameUL.textColor = [UIColor grayColor];
            nameUL.font = [UIFont systemFontOfSize:13];
            nameUL.text = [responseDic[@"data"][@"data"][i][@"price"]   stringByAppendingString:@" 金币"] ;
            [dataButton   addSubview:nameUL];
            [nameUL release];
            
        }
        
        
        
        
        [contentUSV   setContentSize:CGSizeMake( CGRectGetWidth(contentUSV.frame), 110 *   ceil(((CGFloat)[responseDic[@"data"][@"data"]  count]  + ((current - 1) * 20 ) )  / 4) + 55 )];
        
        if ([responseDic[@"data"][@"data"]  count] < 20 || current == totalPage ) {
            
            isFinished = true;
            footerView.hidden = true;
            [contentUSV   setContentSize:CGSizeMake( CGRectGetWidth(contentUSV.frame), 110 *   ceil(([responseDic[@"data"][@"data"]  count]  + ((current - 1) * 20 ) )  / 4) + 5 )];
        }else {
            
            isFinished = false;
            footerView.frame = CGRectMake(0, contentUSV.contentSize.height - 40 , 320, 40);
            footerView.hidden = false;
        }
        
        
    
        
        
        
        isLoading = false;
        
        
    } failedBlock:^{
        
        isLoading = false;}];
    
    
    
    
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    
    if (scrollView.contentOffset.y +scrollView.frame.size.height > scrollView.contentSize.height +5) {
        
        [self performSelector:@selector(loadNextPage)];
        
    }
    
}


#pragma mark -

-(void)dealloc{
    
    
    [usernameString  release];
    [catelogArray release];
    
    [XZWNetworkManager cancelAndReleaseRequest:giftCatelogRequest];
    [XZWNetworkManager cancelAndReleaseRequest:giftListRequest];
    [XZWNetworkManager cancelAndReleaseRequest:sendRequest];
    
    [super dealloc];
}


-(void)goBack{
    
    [self.navigationController popViewControllerAnimated:true];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
