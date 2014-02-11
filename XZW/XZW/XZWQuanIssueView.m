//
//  XZWQuanIssueView.m
//  XZW
//
//  Created by dee on 13-10-22.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWQuanIssueView.h"
#import "MBProgressHUD.h"
#import "XZWQuanIssueTopCell.h"
#import "GoodsGalleryViewController.h"
 
#define kMBProgessHud 889

@implementation XZWQuanIssueView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame andQuanID:(int)theQuanID
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        quanID = theQuanID ;
        
        commentArray = [[NSMutableArray alloc]  init];
        
        additionalArray = [[NSMutableArray alloc]  init];
        
        
        issueUTV  = [[UITableView alloc]   initWithFrame:self.bounds];
        issueUTV.delegate =  self;
        issueUTV.dataSource = self;
        issueUTV.separatorStyle = UITableViewCellSeparatorStyleNone;
        issueUTV.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
        [self addSubview:issueUTV];
        [issueUTV release];
        
        
        
        
        refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - issueUTV.bounds.size.height, self.frame.size.width, issueUTV.bounds.size.height)];
        refreshView.delegate = self;
        [issueUTV addSubview:refreshView];
        [refreshView release];
        
        [refreshView refreshLastUpdatedDate];
        
        
        
         tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap)];
        [issueUTV addGestureRecognizer:tap];
        [tap   release];

        if (BelowiOS6) {
            
            tap.enabled = false;
            
        }
        
        
        replyView = [[UIView alloc]   initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame), 320, 44)];
        [self addSubview:replyView];
        [replyView release];
        
        
        UIImageView *replyBackgroundView = [[UIImageView alloc]   initWithImage:[UIImage imageNamed:@"reply"]];
        [replyView addSubview:replyBackgroundView];
        [replyBackgroundView release];
        
        UIImageView *textUIV = [[UIImageView alloc]  initWithFrame:CGRectMake(8, 7, 238, 29)];
        textUIV.image = [UIImage imageNamed:@"reply_boxin"];
        [replyView addSubview:textUIV];
        [textUIV release];
        
        replyUTF = [[UITextField alloc]  initWithFrame:CGRectMake(12, 11, 220, 24)];
        [replyView addSubview:replyUTF];
        [replyUTF release];
        
        UIButton *replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [replyButton  setTitle:@"回复" forState:UIControlStateNormal];
        [replyButton setBackgroundImage:[UIImage imageNamed:@"reply_btn"] forState:UIControlStateNormal];
        [replyView addSubview:replyButton];
        [replyButton  addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
        [replyButton  setFrame:CGRectMake(253, 7, 60, 29)];
        
        

        
        
        MBProgressHUD *mbProgessHud = [[MBProgressHUD alloc]  initWithView:self];
        mbProgessHud.tag = kMBProgessHud;
        mbProgessHud.labelText = @"加载中...";
        [self addSubview:mbProgessHud];
        [mbProgessHud release];
        
        
        
        ///
        
        current = 0 ;
        totalPage = 2;

        
        [self loadNewPage];
        
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardDidShowNotification object:nil];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadFirst) name:XZWSendSuccessNotification object:nil];
        
        
    }
    return self;
}


 

-(void)loadFirst{
    
    
    current = 0 ;
    totalPage = 2;
    
    [commentArray  removeAllObjects];
    [additionalArray removeAllObjects];
    
    [issueUTV reloadData];
    
    
    MBProgressHUD *hud =  (MBProgressHUD *) [self viewWithTag:kMBProgessHud];
    
    hud.labelText = @"加载中...";
    
    [hud show:true];
    
    
    
    
    [self loadNewPage];
}


#pragma mark -


-(void)handleTap{
    
    
    [self endEditing:true];
}



#pragma mark -
#pragma mark Responding to keyboard events


-(void)moveInputBarWithKeyboardHeight:(CGFloat)height withDuration:(int)duration{
    
    
    if (replyUTF.editing) {
        
         
        
        replyView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - height - 44, 320, 44);
        
    }
    
    
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
    
    [self moveInputBarWithKeyboardHeight: -44 withDuration:animationDuration];
    
    
    if (BelowiOS6) {
        
        
        tap.enabled = false;
        
    }
}




#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
//	isLoading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	isLoading = NO;
	[refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:issueUTV];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    
//    
//    [refreshView egoRefreshScrollViewDidScroll:scrollView];
//    
//    
//    if (scrollView.contentOffset.y +scrollView.frame.size.height > scrollView.contentSize.height +5) {
//        
//        [self loadFirst];
//        
//    }
//    
//}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [refreshView egoRefreshScrollViewDidEndDragging:scrollView];
    
    
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
    
    [self loadFirst];
    
    //	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return isLoading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}



#pragma mark -



#pragma mark - action




-(void)showReplyView:(XZWButton*)button{
    
    
    //replyView.frame = CGRectMake(0, TotalScreenHeight , 320, 44);
    
    
    [issueUTV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:true];
    
    [replyUTF  becomeFirstResponder];
    
    
    replyUTF.text = @"";
    
    replyUTF.placeholder = [NSString stringWithFormat:@"回复:%@",commentArray[button.tag][@"comment"][button.buttonTag][@"fromUname"]];
    
    postIndex = button.tag;
    
    
    postID =  [commentArray[button.tag][@"post_id"]   intValue];
    toID =   [commentArray[button.tag][@"comment"][button.buttonTag][@"fromUid"]  intValue];
    
    
}





-(void)replyAction:(UIButton*)button{
    
    
    
    
    
    if ([@""  isEqualToString:replyUTF.text]) {
        
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请先填写内容" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        
        return ;
    }
    
    [self endEditing:true];
    
    
    MBProgressHUD *hud =  (MBProgressHUD *) [self viewWithTag:kMBProgessHud];
    
    hud.labelText = @"加载中...";
    
    [hud show:true];
    
    
    
    replyRequest = [XZWNetworkManager asiWithLink:XZWQuanAddComment postDic:@{ @"post_id":[NSString stringWithFormat:@"%d",postID] , @"toUid": [NSString stringWithFormat:@"%d",toID] , @"content": [replyUTF.text   stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]} completionBlock:^{
        
        
        
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
            
            [diggArray insertObject:@{@"fromUid":[[NSUserDefaults standardUserDefaults]   objectForKey:@"userID"] , @"fromUname": [[NSUserDefaults standardUserDefaults]   objectForKey:@"username"],
             
             @"toUname" : toID == 0 ? @"" : [replyUTF.placeholder    stringByReplacingOccurrencesOfString:@"回复:" withString:@""],
             @"toUid" : [NSString stringWithFormat:@"%d",toID ],@"content" : replyUTF.text
             
             
             }   atIndex:0];
            
            
            [tempDic   setObject:diggArray forKey:@"comment"];
            
            
            [commentArray   replaceObjectAtIndex:postIndex withObject:tempDic];
            
            
            
            [self reloadViewForIndex:postIndex];
            
            
            [issueUTV reloadData];
            
            
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
    
    
    
    commentRequest =   [XZWNetworkManager asiWithLink:[XZWQuanZiIssue  stringByAppendingFormat:@"&gid=%d&p=%d",quanID ,current + 1] postDic:nil completionBlock:nil failedBlock:nil];
    
    
    NSLog(@"%@~",[XZWQuanZiIssue  stringByAppendingFormat:@"&gid=%d&p=%d",quanID ,current + 1]);
    
    isLoading = true;
    
    [commentRequest setCompletionBlock:^{
        
        
        if (current == 0) {
            
            MBProgressHUD *hud =  (MBProgressHUD *) [self viewWithTag:kMBProgessHud];

            [hud hide:false afterDelay:.8f];
            
            
            [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.f];
        }
        
        
        NSDictionary *responseDic = [[commentRequest  responseString]  objectFromJSONString];
        
          issueUTV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        NSLog(@"responseDic %@",responseDic);
        
        if ([[responseDic  objectForKey:@"status"] intValue]  == 1) {
            
            
            NSArray *tempArray = [responseDic  objectForKey:@"data"][@"data"] ;
            
            
            totalPage = [[responseDic[@"data"]   objectForKey:@"totalPages"]  intValue];
            
            current = [[responseDic[@"data"]   objectForKey:@"nowPage"]  intValue] ;
            
            
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
            
             
                
                
                UILabel *tipsUL = [[UILabel alloc]  initWithFrame:self.bounds];
                [tipsUL setText:[[[commentRequest responseData]   objectFromJSONData]   objectForKey:@"info"]];
                tipsUL.font = [UIFont systemFontOfSize:18];
                tipsUL.textAlignment = UITextAlignmentCenter;
                issueUTV.tableFooterView =tipsUL;
                [tipsUL release];
                
               
               
                
             
            
            
            issueUTV.separatorStyle = UITableViewCellSelectionStyleNone;
            
            
            
        }
        
        
        isLoading = false;
        
    }];
    [commentRequest setFailedBlock:^{
        
        
        isLoading = false;
        
        if (current == 0) {
            
            MBProgressHUD *hud =  (MBProgressHUD *) [self viewWithTag:kMBProgessHud];
            
            [hud hide:false afterDelay:.8f];
            
            
            [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.f];
        }
        
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


-(void)clickPicIndex:(int)index{
    
    if (delegate) {
        
        if ([delegate respondsToSelector:@selector(click:)]) {
            
            [delegate click:[[commentArray objectAtIndex:index]  objectForKey:@"attach_list"]];
        }
        
    }
    
    
}

-(void)likeIndex:(int)index{
    
    
    MBProgressHUD *hud =  (MBProgressHUD *) [self viewWithTag:kMBProgessHud];
    
    hud.labelText = @"加载中...";
    
    [hud show:true];
    
    
    
    likeRequest = [XZWNetworkManager asiWithLink:[XZWQuanTurnDigg  stringByAppendingFormat:@"&post_id=%@",[commentArray   objectAtIndex:index][@"post_id"] ] postDic:nil completionBlock:^{
        
        
        
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
    
    
    if ([[[commentArray objectAtIndex:indexPath.row]  objectForKey:@"attach_list"] count] > 0){
        height += 110;
    }
    
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:additionalArray[indexPath.row]];
    [dic   setObject:@(height + 10) forKey:@"height"];
    
    [additionalArray replaceObjectAtIndex:indexPath.row withObject:dic];
    
    return   height + 10 ;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    static NSString * MyCustomCellIdentifier = @"mycell";
    XZWQuanIssueTopCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCustomCellIdentifier];
    if (cell == nil) {
        cell = [[[XZWQuanIssueTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyCustomCellIdentifier] autorelease];
        
        
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
    
    
    NSString *picImage = nil;
    
    if ([[[commentArray objectAtIndex:indexPath.row]  objectForKey:@"attach_list"] count] > 0) {

        if ( [[[commentArray objectAtIndex:indexPath.row]  objectForKey:@"attach_list"][0]   isKindOfClass:[NSDictionary class]]   ) {
            
            
            picImage =  [NSString stringWithFormat:@"%@data/upload/%@",XZWHost,[[[[[commentArray objectAtIndex:indexPath.row]  objectForKey:@"attach_list"][0]    objectForKey:@"savepath"]  stringByReplacingOccurrencesOfString:@".jpg" withString:@"_200_200.jpg"]  stringByReplacingOccurrencesOfString:@".png" withString:@"_200_200.png"]]   ;
        }else {
            
            picImage = @"";
        }
        
        
        
    }
    
    
    CGFloat height =  [cell    setAvatarURLString:[[commentArray objectAtIndex:indexPath.row]  objectForKey:@"avatar"] name:[[commentArray objectAtIndex:indexPath.row]  objectForKey:@"uname"] description:[[commentArray objectAtIndex:indexPath.row]  objectForKey:@"content"] date:[[commentArray objectAtIndex:indexPath.row]  objectForKey:@"time"] andTag:indexPath.row  andSelect: [[[commentArray objectAtIndex:indexPath.row]  objectForKey:@"is_digg"] intValue] == 1 picImage:picImage ];
    
    
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
    
    
    if (delegate) {
        
        if ([delegate respondsToSelector:@selector(click:)]) {
            
            [delegate click:[[commentArray objectAtIndex:indexPath.row]  objectForKey:@"attach_list"]];
        }
        
    }
    
    
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
