//
//  XZWIssueDetailViewController.m
//  XZW
//
//  Created by dee on 13-9-25.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWIssueDetailViewController.h"
#import "XZWUtil.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "XZWNetworkManager.h"
#import "XZWTopContentCell.h"
#import "RCLabel.h"
#import "XZWButton.h"
#import "MBProgressHUD.h"

#define kMBProgessHud 999

@interface XZWIssueDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate,XZWTopContentCellDelegate,UIGestureRecognizerDelegate>{
    
    
    NSMutableDictionary *issueDic;
    
    UITableView *issueUTV;
    
    NSMutableArray *commentArray;
     
    NSMutableArray *additionalArray;
    
    ASIHTTPRequest *commentRequest;
    
    ASIHTTPRequest *joinRequest;
     
    ASIHTTPRequest *replyRequest;
    
    ASIHTTPRequest *likeRequest;
    
    UITapGestureRecognizer *tap;
    
    
    BOOL isLoading;
    
    BOOL isFinished;
    
    int current;
    
    int totalPage;
    
    
    UITextView *commendUTV;
    
    
    UIView *replyView;
    
    UITextField *replyUTF;
    
    
    int postID,toID;
    
    int postIndex;
    
    
    BOOL isFromFeed;
    
    int addedPost;
    
}

@end

@implementation XZWIssueDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (id)initWithFeedDic:(NSDictionary*)theIssueDic
{
    self = [super init];
    if (self) {
        // Custom initialization
        
        isFromFeed = true;
        
        issueDic = [[NSMutableDictionary alloc]  initWithDictionary:theIssueDic];
        
        commentArray = [[NSMutableArray alloc]  init];
        
        additionalArray = [[NSMutableArray alloc]  init];
        
    }
    return self;
}



- (id)initWithDic:(NSDictionary*)theIssueDic
{
    self = [super init];
    if (self) {
        // Custom initialization
        issueDic = [[NSMutableDictionary alloc]  initWithDictionary:theIssueDic];
    
        commentArray = [[NSMutableArray alloc]  init];
        
        additionalArray = [[NSMutableArray alloc]  init];
        
    }
    return self;
}


-(void)dealloc{
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [issueDic release];
    [commentArray release];
    [additionalArray  release];
    [super dealloc];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title =  @"讨论";
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];
    
    [self initView];
}




-(void)handleTap{
    
    [self.view endEditing:true];
}



-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
     
    
    return true;
}
 



-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
 
//    if([[otherGestureRecognizer.view description]  hasPrefix:@"<UITableViewCell"]){
//        
//        
//        
//        return false;
//    }
    
    
    return true;
    
}

-(void)initView{
     
    
    issueUTV  = [[UITableView alloc]   initWithFrame:CGRectMake(0, 0, 320, TotalScreenHeight - 64 )];
    issueUTV.delegate =  self;
    issueUTV.dataSource = self;
    issueUTV.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]; 
    [self.view addSubview:issueUTV];
    [issueUTV release];
    
    
    
    tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap)];
  //  tap.delegate = self;
    [issueUTV addGestureRecognizer:tap];
    [tap   release];
    
    
    
    if (BelowiOS6) {
    
     tap.enabled = false;
     
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 110)];
    headerView.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
     
    UIImageView *headerUIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 110)];
    [headerUIV   setImageWithURL: [NSURL URLWithString: [XZWHost stringByAppendingFormat:@"data/upload/%@",[issueDic objectForKey:@"cover"]]  ]];
    [headerView addSubview:headerUIV];
    [headerUIV release];
    
    
    UILabel *myLabel = [[UILabel alloc]  initWithFrame:CGRectMake(10, 18, 220, 15)];
    myLabel.backgroundColor = [UIColor clearColor];
    myLabel.numberOfLines = 1;
    myLabel.font = [UIFont systemFontOfSize:14];
    myLabel.textColor = [UIColor whiteColor];
    myLabel.text =  [[[issueDic[@"effectDate"]   stringByReplacingOccurrencesOfString:@"-" withString:@"年" options:NSCaseInsensitiveSearch range:NSMakeRange(3, 2)] stringByReplacingOccurrencesOfString:@"-" withString:@"月" options:NSCaseInsensitiveSearch range:NSMakeRange(5, 3)]   stringByAppendingString:@"日讨论话题"]  ;
    myLabel.highlightedTextColor = [UIColor whiteColor];
    [headerUIV addSubview:myLabel];
    [myLabel release];
    
    
    
    myLabel = [[UILabel alloc]  initWithFrame:CGRectMake(10, 40, 300, 40)];
    myLabel.tag = 3335;
    myLabel.backgroundColor = [UIColor clearColor];
    myLabel.numberOfLines = 0;
    myLabel.font = [UIFont boldSystemFontOfSize:20];
    myLabel.text = isFromFeed ?  [issueDic[@"discuss_name"]   description] : [issueDic[@"title"]   description];
    myLabel.shadowColor = [[UIColor blackColor]  colorWithAlphaComponent:.5f];
    myLabel.shadowOffset = CGSizeMake(1, 1);
    myLabel.textColor = [UIColor whiteColor];
    [headerUIV addSubview:myLabel];
    [myLabel release];
    
    
    
    UIImageView *discussUIV = [[UIImageView alloc]  initWithFrame:CGRectMake(7.50, 120, 305, 88)];
    discussUIV.image = [[UIImage imageNamed:@"discussbox"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    [headerView addSubview:discussUIV];
    [discussUIV release];
    
    UILabel *tipsUL = [[UILabel alloc]  initWithFrame:CGRectMake(10, 10, 285, 40)];
    tipsUL.numberOfLines = 0;
    tipsUL.textColor = [UIColor grayColor];
    tipsUL.text = isFromFeed ?  [issueDic[@"explain"]   description] :[[issueDic   objectForKey:@"explain"] description];
    tipsUL.backgroundColor = [UIColor clearColor];
    [discussUIV addSubview:tipsUL];
    [tipsUL release];
    [tipsUL  sizeThatFits:CGSizeMake(285, 40)];
    [tipsUL  sizeToFit];
    
    
    if (CGRectGetHeight(tipsUL.frame) > 58){
        
        discussUIV.frame = CGRectMake(8, 120, 305, CGRectGetHeight(tipsUL.frame) +30 );
        
    }
    
    
    
    
    UIImageView *bottomUIV = [[UIImageView alloc]   initWithImage: [[UIImage imageNamed:@"discussboxbt"]  stretchableImageWithLeftCapWidth:12 topCapHeight:12]];
    bottomUIV.frame = CGRectMake(8.5, CGRectGetMaxY(discussUIV.frame) - 10, 304, 148);
    [headerView addSubview:bottomUIV];
    [bottomUIV release];
    
    
    [headerUIV insertSubview:bottomUIV belowSubview:discussUIV];
    
    
    UIImageView *cornerUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(20, CGRectGetMaxY(discussUIV.frame) , 280, 90)];
    cornerUIV.image = [[UIImage imageNamed:@"corner"]  stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    [headerView addSubview:cornerUIV];
    [cornerUIV release];
    
    
    
    commendUTV = [[UITextView alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(discussUIV.frame) + 10, 270, 70)];
    commendUTV.delegate = self;
    [headerView addSubview:commendUTV];
    [commendUTV release];
    
    
    headerView.frame = CGRectMake(0, 0, 320, CGRectGetMaxY(bottomUIV.frame) + 10);
    
    
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(229,  CGRectGetMaxY(bottomUIV.frame) - 40 , 64, 24);
    [loginButton  setBackgroundImage:[UIImage imageNamed:@"regist" ] forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [loginButton   setTitle:@"参与" forState:UIControlStateNormal];
    [loginButton  addTarget:self action:@selector(join) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:loginButton];
    
    
    
    issueUTV.tableHeaderView = [headerView  autorelease];
    
    
    
    ///
    
    replyView = [[UIView alloc]   initWithFrame:CGRectMake(0, TotalScreenHeight, 320, 44)];
  //  replyView.backgroundColor = [[UIColor blackColor]  colorWithAlphaComponent:.5f];
  //  replyView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"reply"]];
    [self.view addSubview:replyView];
    [replyView release];
    
    
    UIImageView *replyBackgroundView = [[UIImageView alloc]   initWithImage:[UIImage imageNamed:@"reply"]];
    [replyView addSubview:replyBackgroundView];
    [replyBackgroundView release];
    
    UIImageView *textUIV = [[UIImageView alloc]  initWithFrame:CGRectMake(8, 7, 238, 29)];
    textUIV.image = [UIImage imageNamed:@"reply_boxin"];
    [replyView addSubview:textUIV];
    [textUIV release];
    
    replyUTF = [[UITextField alloc]  initWithFrame:CGRectMake(12, 11, 220, 24)];
    replyUTF.delegate = self;
    [replyView addSubview:replyUTF];
    [replyUTF release];
    
    UIButton *replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [replyButton  setTitle:@"回复" forState:UIControlStateNormal];
    [replyButton setBackgroundImage:[UIImage imageNamed:@"reply_btn"] forState:UIControlStateNormal];
    [replyView addSubview:replyButton];
    [replyButton  addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
    [replyButton  setFrame:CGRectMake(253, 7, 60, 29)];
    
    
    
    
    ///
    
    MBProgressHUD *mbProgessHud = [[MBProgressHUD alloc]  initWithView:self.view];
    mbProgessHud.tag = kMBProgessHud;
    mbProgessHud.labelText = @"加载中...";
    [self.view addSubview:mbProgessHud];
    [mbProgessHud release];
    
    
    
    ///
    
    current = 0 ;
    totalPage = 2;
    
    
    
    [self loadNewPage];
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
         
    
}

#pragma mark -
#pragma mark Responding to keyboard events


-(void)moveInputBarWithKeyboardHeight:(CGFloat)height withDuration:(int)duration{
         

//    if (replyUTF.editing) {
//         
//        replyView.hidden = false;
//        
//        replyView.frame = CGRectMake(0, TotalScreenHeight - 64 - height -44, 320, 44);
//    }
    
    
   replyView.frame = CGRectMake(0, TotalScreenHeight - 64 - height - 44, 320, 44);
}



- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [self moveInputBarWithKeyboardHeight:keyboardRect.size.height withDuration:animationDuration];
    
    
   
    
    if (BelowiOS6) {
        
        tap.enabled = true;
    }
    
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [self moveInputBarWithKeyboardHeight:-44 withDuration:animationDuration];
    
    
    if (BelowiOS6) {
        
    
        tap.enabled = false;
        
    }
}


#pragma mark - textview

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    
    replyView.hidden = true;
    
}







-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    
    if ([commentArray  count] == 0) {
        
        
        
        UIView *footview = [[[UIView alloc]  initWithFrame:CGRectMake(0, 0, 320, 320)]  autorelease];
        
        [issueUTV  setTableFooterView:footview];
        
    }
    
//    [self moveInputBarWithKeyboardHeight:-44 withDuration:0.f];
    
    [issueUTV scrollRectToVisible:CGRectMake(0, CGRectGetMaxY(textView.frame) -100, 320, TotalScreenHeight - 64 -50) animated:false];
    
    return true;
}


-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    [issueUTV  setTableFooterView:nil];
    
    return true;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    replyView.hidden = false;
    
}



-(void)showReplyView:(XZWButton*)button{
    
    
    //replyView.frame = CGRectMake(0, TotalScreenHeight , 320, 44);
    
     
    
    [issueUTV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag + addedPost inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:true];
    
    [replyUTF  becomeFirstResponder];
    
    
    replyUTF.text = @"";
    
    replyUTF.placeholder = [NSString stringWithFormat:@"回复:%@",commentArray[button.tag + addedPost][@"comment"][button.buttonTag][@"fromUname"]];
    
    postIndex = button.tag + addedPost;
     
    
    postID =  [commentArray[button.tag + addedPost][@"post_id"]   intValue];
    toID =   [commentArray[button.tag + addedPost][@"comment"][button.buttonTag][@"fromUid"]  intValue];
    
    
}




#pragma mark - join

-(void)join{
    
    
    if ([@""  isEqualToString:commendUTV.text]) {
        
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请先填写内容" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        
        return ;
    }
    
    
    
    [self.view endEditing:true];
    
    MBProgressHUD *hud =  (MBProgressHUD *) [self.view viewWithTag:kMBProgessHud];
    
    hud.labelText = @"加载中...";
    
    [hud show:true];

    
    
    joinRequest =  [XZWNetworkManager asiWithLink:XZWJoinDiscuss postDic:@{ @"dis_id": ( isFromFeed ?issueDic[@"dis_id"]   : issueDic[@"id"] ), @"content": [commendUTV.text   stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]} completionBlock:^{
     
        
        
        NSDictionary *responseDic = [[joinRequest  responseString]  objectFromJSONString];
         
         
        
        if ([responseDic[@"status"]     intValue] == 1 ) {
            
            [hud  setLabelText:@"发表成功"];
            
            [hud hide:true afterDelay:.6f];
            
            
            
            if ([commentArray  count] > 0) {
                 [commentArray  insertObject:@{@"post_id": [responseDic[@"data"] isKindOfClass:[NSDictionary class]]?[responseDic[@"data"][@"post_id"] description] : @"" ,@"avatar":[[[NSUserDefaults standardUserDefaults] valueForKey:@"avatar"] description],@"comments":@"0",@"diggs":@"0",@"time":[NSString stringWithFormat:@"%f",[[NSDate new] timeIntervalSince1970]],@"uid":[[NSUserDefaults standardUserDefaults] valueForKey:@"userID"],@"uname":[[NSUserDefaults standardUserDefaults] valueForKey:@"username"],@"is_digg":@"0",@"content": commendUTV.text     } atIndex:0];
                
            }else {
                
                 [commentArray  addObject:@{@"post_id": [responseDic[@"data"] isKindOfClass:[NSDictionary class]]?[responseDic[@"data"][@"post_id"] description] : @"" ,@"avatar":[[[NSUserDefaults standardUserDefaults] valueForKey:@"avatar"] description],@"comments":@"0",@"diggs":@"0",@"time":[NSString stringWithFormat:@"%f",[[NSDate new] timeIntervalSince1970]],@"uid":[[NSUserDefaults standardUserDefaults] valueForKey:@"userID"],@"uname":[[NSUserDefaults standardUserDefaults] valueForKey:@"username"],@"is_digg":@"0",@"content": commendUTV.text   } ];
            }
            
           
            
            
            
            
            
            [additionalArray removeAllObjects];
            
            
            for (int i = 0; i < [commentArray count]; i++) {
                
                [additionalArray addObject:@{@"view":[UIView new]  }];
                
                
                [self reloadViewForIndex:i];
                
            }
            
         //   [additionalArray  insertObject:@{@"view":[UIView new]  } atIndex:0 ];
            
            [issueUTV reloadData];
            
            
        }else {
            
            [hud  setLabelText:[[joinRequest responseString]  objectFromJSONString][@"info"]];
            [hud hide:true afterDelay:.8f];
            
        }
        
        
        
    
    
    } failedBlock:^{
        
        
        
        hud.labelText = @"发表失败";
       [hud hide:true afterDelay:.8f];
        
        
    }];
    
    
    
    
}

#pragma mark - action 

-(void)replyAction:(UIButton*)button{
    
      
    
      
    
    if ([@""  isEqualToString:replyUTF.text]) {
        
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请先填写内容" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        
        return ;
    }
    
    [self.view endEditing:true];
    
    
    MBProgressHUD *hud =  (MBProgressHUD *) [self.view viewWithTag:kMBProgessHud];
    
    hud.labelText = @"加载中...";
    
    [hud show:true];
 
    
    
    replyRequest = [XZWNetworkManager asiWithLink:XZWAddCommentDiscuss postDic:@{ @"post_id":[NSString stringWithFormat:@"%d",postID] , @"toUid": [NSString stringWithFormat:@"%d",toID] , @"content": [replyUTF.text   stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]} completionBlock:^{
        
        
        
        NSDictionary *responseDic = [[replyRequest  responseString]  objectFromJSONString];
        
        
        
        if ([responseDic[@"status"]     intValue] == 1 ) {
            
            [hud  setLabelText:@"发表成功"];
            [hud hide:true afterDelay:.6f];
             
            
            NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:commentArray [postIndex]] ;
            
            
            
            NSMutableArray *diggArray;
            
            if (tempDic[@"comment"]) {
                
                diggArray = [NSMutableArray arrayWithArray:tempDic[@"comment"]];
                
            }else {
                
                
                diggArray = [NSMutableArray array];
                
            }
            
            
            NSString *replyString = replyUTF.text;
            
            [diggArray insertObject:@{@"fromUid":[[NSUserDefaults standardUserDefaults]   objectForKey:@"userID"] , @"fromUname": [[NSUserDefaults standardUserDefaults]   objectForKey:@"username"],
             
             @"toUname" : toID == 0 ? @"" : [replyUTF.placeholder    stringByReplacingOccurrencesOfString:@"回复:" withString:@""],
             @"toUid" : [NSString stringWithFormat:@"%d",toID ],@"content" : replyString
             
             
             }   atIndex:0];
            
            
            [tempDic   setObject:diggArray forKey:@"comment"];
              
            
            [commentArray   replaceObjectAtIndex:postIndex withObject:tempDic];
            
            
            
            [self reloadViewForIndex:postIndex];
            
            
            [issueUTV reloadData];
            
            
            replyUTF.text = @"";

            
            
        }else {
            
            [hud  setLabelText:[[replyRequest responseString]  objectFromJSONString][@"info"]];
            [hud hide:true afterDelay:.8f];
            
        }
        
        
        
        
        
    } failedBlock:^{
        
        
        
        hud.labelText = @"发表失败";
        [hud hide:true afterDelay:.8f];
        
        
    }];

    
    
}


#pragma mark -



-(void)loadNewPage{
    
    
    if (isLoading) {
        
        
        return ;
    }
    
    
    if (isFinished) {
        
        return ;
    }
    
    
    if (totalPage  <=  current) {
        
        
        isFinished = true;
        
        
        
        [issueUTV.tableFooterView   setHidden:true];
        issueUTV.tableFooterView = nil;
        
        
        return ;
    }
    
    [XZWNetworkManager cancelAndReleaseRequest:commentRequest];
    
    
    
    commentRequest =   [XZWNetworkManager asiWithLink:[XZWCYDiscuss  stringByAppendingFormat:@"&dis_id=%@&p=%d", isFromFeed ?  [issueDic[@"dis_id"]   description] :[issueDic objectForKey:@"id"] ,current + 1] postDic:nil completionBlock:nil failedBlock:nil];
    
    
    
    
    isLoading = true;
    
    [commentRequest setCompletionBlock:^{
        
        
        
        
        NSDictionary *responseDic = [[commentRequest  responseString]  objectFromJSONString];
        
        
        if ([[responseDic  objectForKey:@"status"] intValue]  == 1) {
            
            
            NSArray *tempArray = [responseDic  objectForKey:@"data"][@"data"] ;
            
            NSLog(@"tempArray %@",tempArray);
            
            
            totalPage = [[[[commentRequest responseData]   objectFromJSONData][@"data"]   objectForKey:@"totalPages"]  intValue];
            
            current = [[[[commentRequest responseData]   objectFromJSONData][@"data"]   objectForKey:@"nowPage"]  intValue] ;
             
            
            for (int i = 0; i < [tempArray count]; i++) {
                
                float height  = 11.f;
                
                
                UIView *tempView = [[[UIView alloc]  initWithFrame:CGRectMake(0, 0, 320, 40)]  autorelease];
                
                
                UIImageView *backGroundUIV = [[UIImageView alloc] initWithFrame:CGRectMake(60, 0, 246, 300)];
                [backGroundUIV  setImage:[[UIImage imageNamed:@"uparrow"]  stretchableImageWithLeftCapWidth:60 topCapHeight:13]];
                backGroundUIV.userInteractionEnabled = true;
                [tempView   addSubview:backGroundUIV];
                [backGroundUIV release];
                
                
                if ([[tempArray   objectAtIndex:i]  objectForKey:@"digg"] ) {
                    
                    
                    UIImageView *heartUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(5, 11, 16, 13)];
                    heartUIV.image = [UIImage imageNamed:@"zan2"];
                    [backGroundUIV addSubview:heartUIV];
                    [heartUIV  release];
                    
                    
                    UILabel *personUL = [[UILabel alloc]   initWithFrame:CGRectMake(27, 7, 220, 20)];
                    personUL.backgroundColor = [UIColor clearColor];
                    personUL.font = [UIFont systemFontOfSize:13];
                    [backGroundUIV addSubview:personUL];
                    [personUL release];
                    
                    
                    NSMutableString *muString = [[[NSMutableString alloc]   init] autorelease];
                    
                    for (int j = 0 ; j < [[[tempArray   objectAtIndex:i]  objectForKey:@"digg"]   count]; j++) {
                        
                        
                        [muString    appendFormat:@"%@,",[[[tempArray   objectAtIndex:i]  objectForKey:@"digg"][j] objectForKey:@"uname"]];
                        
                    }
                    
                    [muString  deleteCharactersInRange:NSMakeRange(muString.length-1, 1)];
                    
                    
                    personUL.text = muString;
                    personUL.textColor = [XZWUtil xzwRedColor];
                    
                    
                    
                    height += 20;
                }
                
                
                
                
                if ([[tempArray   objectAtIndex:i]  objectForKey:@"comment"]   ) {
                    
                    
                    
                    for (int j =0 ; j < [[[tempArray   objectAtIndex:i]  objectForKey:@"comment"]  count]; j++) {
                        
                        
                        if ([[[[tempArray   objectAtIndex:i]  objectForKey:@"comment"][j] objectForKey:@"toUname"]  isEqualToString:@""]) {
                            
                            
                            UILabel *nameUL = [[[UILabel alloc]   initWithFrame:CGRectMake(5, height, 320, 20)] autorelease];
                            nameUL.text =  [[[[tempArray   objectAtIndex:i]  objectForKey:@"comment"][j] objectForKey:@"fromUname"] stringByAppendingString:@": "];
                            nameUL.font = [UIFont systemFontOfSize:13];
                            nameUL.textColor = [XZWUtil xzwRedColor];
                            nameUL.backgroundColor = [UIColor clearColor];
                            [backGroundUIV   addSubview:nameUL];
                            
                            [nameUL  sizeToFit];
                            
                            
                            
                            UILabel  *tempUL = [[[UILabel alloc]   initWithFrame:CGRectMake(CGRectGetMaxX(nameUL.frame)   , height, 253 - CGRectGetMaxX(nameUL.frame), 30)]  autorelease];
                      
                            tempUL.text = [NSString stringWithFormat:@" %@",[[[tempArray   objectAtIndex:i]  objectForKey:@"comment"][j]  objectForKey:@"content"]];
                            tempUL.numberOfLines = 0 ;
                            tempUL.font = [UIFont systemFontOfSize:13];
                            tempUL.textColor = [UIColor grayColor];
                            tempUL.backgroundColor = [UIColor clearColor];
                            [tempUL   sizeThatFits:CGSizeMake(253 - CGRectGetMaxX(nameUL.frame), 1000)];
                            [tempUL   sizeToFit];
                            [backGroundUIV  addSubview:tempUL];
                            
                            
                            
                            XZWButton *xzwButton = [XZWButton buttonWithType:UIButtonTypeCustom];
                            [xzwButton addTarget:self action:@selector(showReplyView:) forControlEvents:UIControlEventTouchUpInside];
                            [xzwButton  setImage:[UIImage imageNamed:@"tm"] forState:UIControlStateNormal];
                            [xzwButton  setBackgroundImage:[[UIImage imageNamed:@"light"] stretchableImageWithLeftCapWidth:2 topCapHeight:2] forState:UIControlStateHighlighted];
                            xzwButton.tag = [commentArray count] + i ;
                            xzwButton.buttonTag = j;
                            [xzwButton setFrame:CGRectMake(3, height, 240 , CGRectGetHeight(tempUL.frame))];
                             [backGroundUIV  addSubview:xzwButton];
                             
                            
                            height = CGRectGetMaxY(tempUL.frame);
                        
                        }else {
                            
//                            UILabel *nameUL = [[[UILabel alloc]   initWithFrame:CGRectMake(5, height, 320, 20)] autorelease];
//                            nameUL.text =  [[[[tempArray   objectAtIndex:i]  objectForKey:@"comment"][j] objectForKey:@"fromUname"] stringByAppendingString:@""];
//                            nameUL.font = [UIFont systemFontOfSize:13];
//                            nameUL.textColor = [XZWUtil xzwRedColor];
//                            nameUL.backgroundColor = [UIColor clearColor];
//                            [backGroundUIV   addSubview:nameUL];
//                            
//                            [nameUL  sizeToFit];
//                            
//                             
//                            
//                            RCLabel *sendLabel = [[[RCLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameUL.frame)  , height, 253 - CGRectGetMaxX(nameUL.frame), 30)]  autorelease];
//                            
//                            RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle: [NSString stringWithFormat:@"<font size=13 color='#919191'>回复<font><font size=13 color='#e14278'>%@</font><font size=13 color='#919191'>%@<font>",[[[tempArray   objectAtIndex:i]  objectForKey:@"comment"][j] objectForKey:@"toUname"] ,[[[tempArray   objectAtIndex:i]  objectForKey:@"comment"][j]  objectForKey:@"content"]] ];
//                            sendLabel.componentsAndPlainText = componentsDS;
//                            
//                            CGSize optimumSize = CGSizeZero ;
//                            
//                            optimumSize = [sendLabel optimumSize];
//                            
//                            CGRect myframe = sendLabel.frame ;
//                            myframe.size.height = optimumSize.height;
//                            sendLabel.frame = myframe ;
//
//                            
//                            [backGroundUIV  addSubview:sendLabel];
                            
                            RCLabel *sendLabel = [[[RCLabel alloc] initWithFrame:CGRectMake(3  , height, 253  , 30)]  autorelease];
                            
                            RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle: [NSString stringWithFormat:@"<font size=13 color='#e14278'>%@</font><font size=13 color='#919191'> 回复 <font><font size=13 color='#e14278'>%@</font><font size=13 color='#919191'>%@<font>",[[[tempArray   objectAtIndex:i]  objectForKey:@"comment"][j] objectForKey:@"fromUname"],[[[tempArray   objectAtIndex:i]  objectForKey:@"comment"][j] objectForKey:@"toUname"] ,[[[tempArray   objectAtIndex:i]  objectForKey:@"comment"][j]  objectForKey:@"content"]] ];
                            sendLabel.componentsAndPlainText = componentsDS;
                            
                            CGSize optimumSize = CGSizeZero ;
                            
                            optimumSize = [sendLabel optimumSize];
                            
                            CGRect myframe = sendLabel.frame ;
                            myframe.size.height = optimumSize.height;
                            sendLabel.frame = myframe ;
                            
                            
                            [backGroundUIV  addSubview:sendLabel];
                            

//                            
                            
                            
                            XZWButton *xzwButton = [XZWButton buttonWithType:UIButtonTypeCustom];
                            [xzwButton  setImage:[UIImage imageNamed:@"tm"] forState:UIControlStateNormal];
                            [xzwButton  setBackgroundImage:[[UIImage imageNamed:@"light"] stretchableImageWithLeftCapWidth:2 topCapHeight:2] forState:UIControlStateHighlighted];
                            [xzwButton addTarget:self action:@selector(showReplyView:) forControlEvents:UIControlEventTouchUpInside];
                            xzwButton.tag = [commentArray count] + i ;
                            xzwButton.buttonTag = j;
                            [xzwButton setFrame:CGRectMake(3, height, 240 , CGRectGetHeight(sendLabel.frame))];
                            [backGroundUIV  addSubview:xzwButton];
                            
                            height = CGRectGetMaxY(sendLabel.frame);
                            
                            
                            
                            
                        }
                        
                 
                        
                        
                        
                    }
                    
                    
                }
                
                
                
                
                if (height == 11.f) {
                    
                    tempView.frame = CGRectMake(0, 0, 320, 0);
                    backGroundUIV.frame = CGRectMake(60, 0, 246, 0);
                    
                    [additionalArray addObject:@{@"view":tempView  }];
                    
                    
                    
                    
                }else
                {
                    
                    tempView.frame = CGRectMake(0, 0, 320, height + 5);
                    backGroundUIV.frame = CGRectMake(60, 0, 246, height +5);
                    
                    [additionalArray addObject:@{@"view":tempView  }];
                }
                
                
                
                
                
            }
            
            

            
            
            [commentArray  addObjectsFromArray:tempArray];
            
            
            
            if ([commentArray  count] == 0) {
                
                
                if (current == 1 ) {
                    
                    issueUTV.separatorStyle = UITableViewCellSelectionStyleNone;
                    
                    
                    
                }
                
                issueUTV.separatorColor = [UIColor clearColor];
                
            }else {
                
                
                
                 
                
                if ([commentArray  count] < 20) {
                    
                    
                    
                    
                    
                    
                }else {
                    
                    
                    
                    UIView *footerView = [[[UIView alloc]  initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];
                    [issueUTV setTableFooterView:footerView];
                    
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
                    
                }
                
                
                
                
                
                
            }
            
            
            [issueUTV reloadData];
            
            
        }else{
            
            issueUTV.separatorStyle = UITableViewCellSelectionStyleNone;
            
            

        }
        
        
        isLoading = false;
        
    }];
    [commentRequest setFailedBlock:^{
        
         
        isLoading = false;
        
        
    }];
    
    
}


#pragma mark - reload

-(void)reloadViewForIndex:(int)i{
    
    float height  = 11.f;
    
    
    UIView *tempView = [[[UIView alloc]  initWithFrame:CGRectMake(0, 0, 320, 40)]  autorelease];
    
    
    UIImageView *backGroundUIV = [[UIImageView alloc] initWithFrame:CGRectMake(60, 0, 246, 300)];
    [backGroundUIV  setImage:[[UIImage imageNamed:@"uparrow"]  stretchableImageWithLeftCapWidth:60 topCapHeight:13]];
    backGroundUIV.userInteractionEnabled = true;
    [tempView   addSubview:backGroundUIV];
    [backGroundUIV release];
    
    
    if ([[commentArray   objectAtIndex:i]  objectForKey:@"digg"] ) {
        
        
        UIImageView *heartUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(5, 11, 16, 13)];
        heartUIV.image = [UIImage imageNamed:@"zan2"];
        [backGroundUIV addSubview:heartUIV];
        [heartUIV  release];
        
        
        UILabel *personUL = [[UILabel alloc]   initWithFrame:CGRectMake(27, 7, 220, 20)];
        personUL.backgroundColor = [UIColor clearColor];
        personUL.font = [UIFont systemFontOfSize:13];
        [backGroundUIV addSubview:personUL];
        [personUL release];
        
        
        NSMutableString *muString = [[[NSMutableString alloc]   init] autorelease];
        
        for (int j = 0 ; j < [[[commentArray   objectAtIndex:i]  objectForKey:@"digg"]   count]; j++) {
            
            
            [muString    appendFormat:@"%@,",[[[commentArray   objectAtIndex:i]  objectForKey:@"digg"][j] objectForKey:@"uname"]];
            
        }
        
        [muString  deleteCharactersInRange:NSMakeRange(muString.length-1, 1)];
        
        
        personUL.text = muString;
        personUL.textColor = [XZWUtil xzwRedColor];
        
        
        
        height += 20;
    }
    
    
    
    
    if ([[commentArray   objectAtIndex:i]  objectForKey:@"comment"]   ) {
        
        
        
        for (int j = 0 ; j < [[[commentArray   objectAtIndex:i]  objectForKey:@"comment"]  count]; j++) {
            
            
            if ([[[[commentArray   objectAtIndex:i]  objectForKey:@"comment"][j] objectForKey:@"toUname"]  isEqualToString:@""]) {
                
                
                UILabel *nameUL = [[[UILabel alloc]   initWithFrame:CGRectMake(5, height, 320, 20)] autorelease];
                nameUL.text =  [[[[commentArray   objectAtIndex:i]  objectForKey:@"comment"][j] objectForKey:@"fromUname"] stringByAppendingString:@": "];
                nameUL.font = [UIFont systemFontOfSize:13];
                nameUL.textColor = [XZWUtil xzwRedColor];
                nameUL.backgroundColor = [UIColor clearColor];
                [backGroundUIV   addSubview:nameUL];
                
                [nameUL  sizeToFit];
                
                
                
                UILabel  *tempUL = [[[UILabel alloc]   initWithFrame:CGRectMake(CGRectGetMaxX(nameUL.frame)   , height, 253 - CGRectGetMaxX(nameUL.frame), 30)]  autorelease];
                tempUL.text =  [NSString stringWithFormat:@" %@", [[[commentArray   objectAtIndex:i]  objectForKey:@"comment"][j]  objectForKey:@"content"]];
                tempUL.numberOfLines = 0 ;
                tempUL.font = [UIFont systemFontOfSize:13];
                tempUL.textColor = [UIColor grayColor];
                tempUL.backgroundColor = [UIColor clearColor];
                [tempUL   sizeThatFits:CGSizeMake(253 - CGRectGetMaxX(nameUL.frame), 1000)];
                [tempUL   sizeToFit];
                [backGroundUIV  addSubview:tempUL];
                
                
                
                XZWButton *xzwButton = [XZWButton buttonWithType:UIButtonTypeCustom];
                [xzwButton addTarget:self action:@selector(showReplyView:) forControlEvents:UIControlEventTouchUpInside];
                [xzwButton  setImage:[UIImage imageNamed:@"tm"] forState:UIControlStateNormal];
                [xzwButton  setBackgroundImage:[[UIImage imageNamed:@"light"] stretchableImageWithLeftCapWidth:2 topCapHeight:2] forState:UIControlStateHighlighted];
                xzwButton.tag =  i ;
                xzwButton.buttonTag = j;
                [xzwButton setFrame:CGRectMake(3, height, 240 , CGRectGetHeight(tempUL.frame))];
                [backGroundUIV  addSubview:xzwButton];
                
                
                height = CGRectGetMaxY(tempUL.frame);
                
            }else {
                 
                
                RCLabel *sendLabel = [[[RCLabel alloc] initWithFrame:CGRectMake(3  , height, 253  , 30)]  autorelease];
                
                RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle: [NSString stringWithFormat:@"<font size=13 color='#e14278'>%@</font><font size=13 color='#919191'> 回复 <font><font size=13 color='#e14278'>%@</font><font size=13 color='#919191'>%@<font>",[[[commentArray   objectAtIndex:i]  objectForKey:@"comment"][j] objectForKey:@"fromUname"],[[[commentArray   objectAtIndex:i]  objectForKey:@"comment"][j] objectForKey:@"toUname"] ,[[[commentArray   objectAtIndex:i]  objectForKey:@"comment"][j]  objectForKey:@"content"]] ];
                sendLabel.componentsAndPlainText = componentsDS;
                
                CGSize optimumSize = CGSizeZero ;
                
                optimumSize = [sendLabel optimumSize];
                
                CGRect myframe = sendLabel.frame ;
                myframe.size.height = optimumSize.height;
                sendLabel.frame = myframe ;
                
                
                [backGroundUIV  addSubview:sendLabel];
                
                
                //
                
                
                XZWButton *xzwButton = [XZWButton buttonWithType:UIButtonTypeCustom];
                [xzwButton  setImage:[UIImage imageNamed:@"tm"] forState:UIControlStateNormal];
                [xzwButton  setBackgroundImage:[[UIImage imageNamed:@"light"] stretchableImageWithLeftCapWidth:2 topCapHeight:2] forState:UIControlStateHighlighted];
                [xzwButton addTarget:self action:@selector(showReplyView:) forControlEvents:UIControlEventTouchUpInside];
                xzwButton.tag =  i ;//[commentArray count] + i ;
                xzwButton.buttonTag = j;
                [xzwButton setFrame:CGRectMake(3, height, 240 , CGRectGetHeight(sendLabel.frame))];
                [backGroundUIV  addSubview:xzwButton];
                
                height = CGRectGetMaxY(sendLabel.frame);
                
                
                
                
            }
            
            
            
            
            
        }
        
        
    }
    
    
    
    
    if (height == 11.f) {
        
        tempView.frame = CGRectMake(0, 0, 320, 0);
        backGroundUIV.frame = CGRectMake(60, 0, 246, 0);
        
        [additionalArray replaceObjectAtIndex:i withObject:@{@"view":tempView  }];
        
        
        
        
    }else
    {
        
        tempView.frame = CGRectMake(0, 0, 320, height + 5);
        backGroundUIV.frame = CGRectMake(60, 0, 246, height +5);
        
        [additionalArray replaceObjectAtIndex:i withObject:@{@"view":tempView  }];
    }
    
    
}



#pragma mark -

-(void)likeIndex:(int)index{
    
    
    MBProgressHUD *hud =  (MBProgressHUD *) [self.view viewWithTag:kMBProgessHud];
    
    hud.labelText = @"加载中...";
    
    [hud show:true];
    
    
    [self.view endEditing:true];
    
    
    likeRequest = [XZWNetworkManager asiWithLink:[XZWTurnDiggDiscuss  stringByAppendingFormat:@"&post_id=%@",[commentArray   objectAtIndex:index][@"post_id"] ] postDic:nil completionBlock:^{
        
        
        
        NSDictionary *responseDic = [[likeRequest  responseString]  objectFromJSONString];
        
        
        
        if ([responseDic[@"status"]     intValue] == 1 ) {
            
            
           // sender.selected = !sender.selected;
            
            [hud  setLabelText:@"操作成功"];
            [hud hide:true afterDelay:.6f];
            
            
            NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:commentArray [index]] ;
            
            
            [tempDic  setObject:[tempDic[@"is_digg"]  intValue] == 1? @"0":@"1"   forKey:@"is_digg"];
            
        
            
            if ([tempDic[@"is_digg"]  intValue] == 1) {
                
                NSMutableArray *diggArray;
                
                if (tempDic[@"digg"]) {
                    
                    diggArray = [NSMutableArray arrayWithArray:tempDic[@"digg"]];
                    
                }else {
                    
                    
                    diggArray = [NSMutableArray array];
                    
                }
                
                
                [diggArray   addObject:@{@"uid":[[NSUserDefaults standardUserDefaults]   objectForKey:@"userID"] , @"uname": [[NSUserDefaults standardUserDefaults]   objectForKey:@"username"] }  ];
                
                
                if ([diggArray   count] == 0) {
                    
                    [tempDic removeObjectForKey:@"digg"];
                    
                }else {
                    
                    
                    
                    [tempDic  setObject:diggArray forKey:@"digg"];
                }
                
                
                
            }else {
                
                
                // remove
                
                
                if (tempDic[@"digg"]) {
                    
                    
                    NSMutableArray *diggArray = [NSMutableArray arrayWithArray:tempDic[@"digg"]];
                    
                    
                    for (NSDictionary *subDic in tempDic[@"digg"] ) {
                        
                        if ([subDic[@"uid"]  intValue] ==  [[[NSUserDefaults standardUserDefaults]   objectForKey:@"userID"]  intValue]) {
                            
                            [diggArray  removeObject:subDic];
                            
                            break ;
                            
                        }
                        
                        
                    }
                    
                    if ([diggArray   count] == 0) {
                        
                        [tempDic removeObjectForKey:@"digg"];
                        
                    }else {
                        
                        
                        
                        [tempDic  setObject:diggArray forKey:@"digg"];
                    }
                    
                    
                    
                }else {
                    
                    
                }
                
                
               
                
            }
            
            
            
            
            [commentArray   replaceObjectAtIndex:index withObject:tempDic];
            
            
            
            [self reloadViewForIndex:index];
            
            
            [issueUTV reloadData]; 
             
            
            
        }else {
            
            [hud  setLabelText:[[likeRequest responseString]  objectFromJSONString][@"info"]];
            [hud hide:true afterDelay:.8f];
            
        }
        
        
        
        
        
    } failedBlock:^{
        
        
        
        hud.labelText = @"发表失败";
        [hud hide:true afterDelay:.8f];
        
        
    }];
    
    

    
    
    
}

-(void)commentIndex:(int)index{
    
    
    [issueUTV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:true];
    
    [replyUTF  becomeFirstResponder];
    
    replyUTF.text = @"";
    
    replyUTF.placeholder = [NSString stringWithFormat:@"回复:%@",commentArray[index][@"uname"]];
    
    
    postIndex = index;
    
    
    postID =  [commentArray[index][@"post_id"]   intValue];
    toID =   0;
    
    
    
    return ;
    
    MBProgressHUD *hud =  (MBProgressHUD *) [self.view viewWithTag:kMBProgessHud];
    
    hud.labelText = @"加载中...";
    
    [hud show:true];
    
    
    
    
    return ;
    //
    
    commentRequest = [XZWNetworkManager asiWithLink:XZWAddCommentDiscuss postDic:@{ @"post_id":[NSString stringWithFormat:@"%d",postID] , @"toUid": [NSString stringWithFormat:@"%d",toID] , @"content": [replyUTF.text   stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]} completionBlock:^{
        
        
        
        NSDictionary *responseDic = [[commentRequest  responseString]  objectFromJSONString];
        
        
        if ([responseDic[@"status"]     intValue] == 1 ) {
            
            [hud  setLabelText:@"发表成功"];
            [hud hide:true afterDelay:.6f];
            
            
        }else {
            
            [hud  setLabelText:[[commentRequest responseString]  objectFromJSONString][@"info"]];
            [hud hide:true afterDelay:.8f];
            
        }
        
        
        
        
        
    } failedBlock:^{
        
        
        
        hud.labelText = @"发表失败";
        [hud hide:true afterDelay:.8f];
        
        
    }];
    
}


#pragma mark - 
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    
    if (scrollView == issueUTV) {
        
        if (scrollView.contentOffset.y +scrollView.frame.size.height > scrollView.contentSize.height +5) {
            
            [self performSelector:@selector(loadNewPage)];
            
        }
        
     //   [self.view endEditing:true];
        
    }
    
    
    
    
     
   
}


#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return  [commentArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if ([additionalArray  objectAtIndex:indexPath.row][@"height"] ) {
        
        return [[additionalArray  objectAtIndex:indexPath.row][@"height"]  floatValue];
    }
    
    CGFloat height = 0.f ;
    
     
    
    if ([[commentArray   objectAtIndex:indexPath.row]  objectForKey:@"digg"] ) {
        
        height += 20;
        
    }
    
    
    if ([[commentArray   objectAtIndex:indexPath.row]  objectForKey:@"comment"]   ) {
        
        
        
        for (int j =0 ; j < [[[commentArray   objectAtIndex:indexPath.row]  objectForKey:@"comment"]  count]; j++) {
            
            
            if ([[[[commentArray   objectAtIndex:indexPath.row]  objectForKey:@"comment"][j] objectForKey:@"toUname"]  isEqualToString:@""]) {
                
                
                UILabel *nameUL = [[[UILabel alloc]   initWithFrame:CGRectMake(5, height, 320, 20)] autorelease];
                nameUL.text =  [[[[commentArray   objectAtIndex:indexPath.row]  objectForKey:@"comment"][j] objectForKey:@"fromUname"] stringByAppendingString:@": "];
                nameUL.font = [UIFont systemFontOfSize:13];
                nameUL.textColor = [XZWUtil xzwRedColor];
                nameUL.backgroundColor = [UIColor clearColor]; 
                
                [nameUL  sizeToFit];
                
                
                UILabel  *tempUL = [[[UILabel alloc]   initWithFrame:CGRectMake(CGRectGetMaxX(nameUL.frame)   , height, 253 - CGRectGetMaxX(nameUL.frame), 30)]  autorelease];
                tempUL.text = [NSString stringWithFormat:@" %@",[[[commentArray   objectAtIndex:indexPath.row]  objectForKey:@"comment"][j]  objectForKey:@"content"]] ;
                tempUL.numberOfLines = 0 ;
                tempUL.font = [UIFont systemFontOfSize:13];
                tempUL.textColor = [UIColor grayColor];
                tempUL.backgroundColor = [UIColor clearColor];
                [tempUL   sizeThatFits:CGSizeMake(253 - CGRectGetMaxX(nameUL.frame), 1000)];
                [tempUL   sizeToFit]; 
                
                
                height = CGRectGetMaxY(tempUL.frame);
                
                
            }else {
                
                UILabel *nameUL = [[[UILabel alloc]   initWithFrame:CGRectMake(5, height, 320, 20)] autorelease];
                nameUL.text =  [[[[commentArray   objectAtIndex:indexPath.row]  objectForKey:@"comment"][j] objectForKey:@"fromUname"] stringByAppendingString:@""];
                nameUL.font = [UIFont systemFontOfSize:13];
                nameUL.textColor = [XZWUtil xzwRedColor];
                nameUL.backgroundColor = [UIColor clearColor]; 
                
                [nameUL  sizeToFit];
                
                
                
           //     RCLabel *sendLabel = [[[RCLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameUL.frame) , height + 3 , 253 - CGRectGetMaxX(nameUL.frame), 30)]  autorelease];
                
                
               // RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle: [NSString stringWithFormat:@"<font size=13 color='#919191'>回复<font><font size=13 color='#e14278'>%@</font><font size=13 color='#919191'>%@<font>",[[[commentArray   objectAtIndex:indexPath.row]  objectForKey:@"comment"][j] objectForKey:@"toUname"] ,[[[commentArray   objectAtIndex:indexPath.row]  objectForKey:@"comment"][j]  objectForKey:@"content"]] ];
             
                RCLabel *sendLabel = [[[RCLabel alloc] initWithFrame:CGRectMake(3  , height + 2, 253  , 30)]  autorelease];

                RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle: [NSString stringWithFormat:@"<font size=13 color='#e14278'>%@</font><font size=13 color='#919191'> 回复 <font><font size=13 color='#e14278'>%@</font><font size=13 color='#919191'>%@<font>",[[[commentArray   objectAtIndex:indexPath.row]  objectForKey:@"comment"][j] objectForKey:@"fromUname"],[[[commentArray   objectAtIndex:indexPath.row]  objectForKey:@"comment"][j] objectForKey:@"toUname"] ,[[[commentArray   objectAtIndex:indexPath.row]  objectForKey:@"comment"][j]  objectForKey:@"content"]] ];
          
              
                sendLabel.componentsAndPlainText = componentsDS;
                
                CGSize optimumSize = CGSizeZero ;
                
                optimumSize = [sendLabel optimumSize];
                
                CGRect myframe = sendLabel.frame ;
                myframe.size.height = optimumSize.height;
                sendLabel.frame = myframe ;
                
                 
                
                height = CGRectGetMaxY(sendLabel.frame);
                
                
                
                
            }
            
            
            
            
            
        }
        
        
    }
    
    
    if (height != 0.f) {
        
        height += 11;
    }
    
    UILabel *tempUL = [[[UILabel alloc]   initWithFrame:CGRectMake(60, 34, 250, 40)]  autorelease];
    tempUL.text = [[commentArray   objectAtIndex:indexPath.row]  objectForKey:@"content"];
    tempUL.numberOfLines = 0 ;
    [tempUL  sizeThatFits:CGSizeMake(250, 3000)];
    [tempUL   sizeToFit];
    
    height += CGRectGetMaxY(tempUL.frame) + 28;
    
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:additionalArray[indexPath.row]];
    [dic   setObject:@(height + 10) forKey:@"height"];
    
    [additionalArray replaceObjectAtIndex:indexPath.row withObject:dic];
    
    return   height + 10 ;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    static NSString * MyCustomCellIdentifier = @"mycell";
    XZWTopContentCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCustomCellIdentifier];
    if (cell == nil) {
        cell = [[[XZWTopContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyCustomCellIdentifier] autorelease];
        
        
        //  background
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
//        
//        UIImageView *lineUIV = [[UIImageView alloc]  initWithFrame:CGRectMake(0, 90, 320, 1)];
//        // lineUIV.image = [UIImage imageNamed:@"ys_line"];
//        lineUIV.backgroundColor = [UIColor blackColor];
//        [cell.contentView addSubview:lineUIV];
//        [lineUIV release];
//        
//        
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor  = [UIColor clearColor];
        
        cell.delegate = self;
    }
    
    
    CGFloat height =  [cell    setAvatarURLString:[[commentArray objectAtIndex:indexPath.row]  objectForKey:@"avatar"] name:[[commentArray objectAtIndex:indexPath.row]  objectForKey:@"uname"] description:[[commentArray objectAtIndex:indexPath.row]  objectForKey:@"content"] date:[[commentArray objectAtIndex:indexPath.row]  objectForKey:@"time"] andTag:indexPath.row  andSelect: [[[commentArray objectAtIndex:indexPath.row]  objectForKey:@"is_digg"] intValue] == 1 ];
    
    
    if([cell.contentView   viewWithTag:1111]){
        [[cell.contentView   viewWithTag:1111] removeFromSuperview];
    }
    
    UIView *additionalView = [additionalArray  objectAtIndex:indexPath.row][@"view"] ;
    additionalView.tag = 1111;
    
    [cell.contentView    addSubview:additionalView];
    
    [additionalView   setFrame:CGRectMake(0, height, CGRectGetWidth(additionalView.frame), CGRectGetHeight(additionalView.frame))];
    
     
         
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
