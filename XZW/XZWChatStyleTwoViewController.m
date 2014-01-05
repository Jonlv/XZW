//
//  XZWChatStyleTwoViewController.m
//  XZW
//
//  Created by dee on 13-12-30.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWChatStyleTwoViewController.h"
#import "XZWChatCell.h"
#import "XZWDBOperate.h"
#import "XZWNetworkManager.h"
#import "IIViewDeckController.h"

@interface XZWChatStyleTwoViewController ()<UITableViewDataSource,UITableViewDelegate,IIViewDeckControllerDelegate,UITextFieldDelegate,XZWChatDelegate>{
    
    UITableView *chatTableView;
    
    int userID,listID;
    
    NSString *chatNameString,*avatarLinkString;
    
    NSMutableArray  *chatArray;
    
    
    UIView *replyView;
    
    UITextField *replyUTF;
    
    
    ASIHTTPRequest *getChatRequest;
    
    ASIHTTPRequest *sendRequest;
    
    
    BOOL isGettingChat;
    
    BOOL gettingNextPage;
    
    BOOL goOut;
    
}

@property (nonatomic,retain) NSString *chatNameString;
@property (nonatomic,retain) NSString *avatarLinkString;

@end

@implementation XZWChatStyleTwoViewController
@synthesize chatNameString,avatarLinkString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(id)initWithUserID:(int)theUserID nameString:(NSString *)nameString avatarString:(NSString *)avatarString andChatID:(int)chatID{
    
    self = [self initWithUserID:theUserID nameString:nameString avatarString:avatarString];
    
    listID = chatID ;
    
    if (self) {
        
    }
    
    return self;
}


-(id)initWithUserID:(int)theUserID nameString:(NSString*)nameString avatarString:(NSString*)avatarString{
    self = [super init];
    if (self) {
        // Custom initialization
        listID = -1 ;
        userID = theUserID;
        
        self.chatNameString = nameString ;
        self.avatarLinkString =  avatarString;
        
        chatArray = [[NSMutableArray alloc] init];
        
        
        self.title = [NSString stringWithFormat:@"与%@对话",nameString];
        
    }
    return self;
    
}



-(void)dealloc{
    
    
    NSLog(@"chatview dealloc");
    [ chatArray release];
    [chatNameString  release];
    [avatarLinkString release];
    
    [super dealloc];
}




//#pragma mark -
//
//-(void)viewWillAppear:(BOOL)animated{
//
//    self.viewDeckController.panningMode = IIViewDeckFullViewPanning;
//
//
//    [super viewWillAppear:animated];
//}
//
//
//-(void)viewWillDisappear:(BOOL)animated{
//
//    self.viewDeckController.panningMode = IIViewDeckNoPanning;
//
//    [super viewWillDisappear:animated];
//}


#pragma mark -


- (BOOL)viewDeckController:(IIViewDeckController*)viewDeckController shouldPan:(UIPanGestureRecognizer*)panGestureRecognizer{
    
    
    return true;
}


//- (BOOL)viewDeckController:(IIViewDeckController*)viewDeckController shouldOpenViewSide:(IIViewDeckSide)viewDeckSide{
//
//    if (viewDeckSide == IIViewDeckRightSide){
//
//        return true;
//    }else {
//
//        return false;
//    }
//
//
//}

-(void)viewDidDisappear:(BOOL)animated{
    
    
    self.navigationController.viewDeckController.panningMode = IIViewDeckNoPanning;
    [super viewDidDisappear:animated];
}

-(void)changeUser:(int)theUserID username:(NSString*)theUserName{
    
    userID = theUserID ;
    
    /// listID =  -2 ;
    
    listID = [XZWDBOperate getListIDFromUserID:theUserID];
    
    
    self.title = [NSString stringWithFormat:@"与%@对话",theUserName];
    
    
    
    [NSThread  cancelPreviousPerformRequestsWithTarget:self];
    
    
    [chatArray  removeAllObjects];
    
    [chatTableView reloadData];
    
    [XZWDBOperate getChatArrayForUserID:theUserID andBlock:^(NSArray *theArray){
        
        [chatArray   setArray:theArray];
        
        
        
        [chatTableView reloadData];
        
        
        if ([chatArray  count] == 0 ) {
            
            [self getFriendChat];
            
            
        }else {
            
            
            [chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[theArray count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:false];
            
            [self getFriendChat];
        }
        
        
        
        
    }  ];
    
}

 
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
        //self.navigationController.viewDeckController.delegate = self;
    //    self.viewDeckController.panningMode = IIViewDeckFullViewPanning;
    //
    //
    //    self.navigationController.viewDeckController.panningMode = IIViewDeckFullViewPanning;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self  action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];
    
    
    listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self  action:@selector(myToggleRightView) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"frd"] forState:UIControlStateNormal];
    
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];
    
    
    [self initView];
    
    
    
    
    
    
    
    
    if (listID == -1) {
        
        
        [XZWDBOperate getChatArrayForUserID:userID andBlock:^(NSArray *theArray){
            
            [chatArray   setArray:theArray];
            
            
            if ([chatArray  count] ==0 ) {
                
                [self getChat];
                
                
                [self getFriendChat];
               // [self performSelector:@selector(getFriendChat) withObject:nil afterDelay:10.f];
                
                
            }else {
                
                [chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatArray count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:false];
                
                [self getFriendChat];
            }
            
            
            
            
        }  ];
        
        
    }else {
        
        [XZWDBOperate getChatArrayForChatID:listID andUserID:userID  andBlock:^(NSArray *theArray){
            
            [chatArray   setArray:theArray];
            
            
            if ([chatArray  count] ==0 ) {
                
                [self getChat];
                
               // [self performSelector:@selector(getFriendChat) withObject:nil afterDelay:10.f];
                
                [self getFriendChat];
                
            }else {
                
                [chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatArray count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:false];
                
                [self getFriendChat];
            }
            
            
            
            
        }  ];
        
        
    }
    
    
    
    
    
    
    
    
}


-(void)myToggleRightView{
    
    [self.view endEditing:true];
    [self.viewDeckController toggleRightView];
    
    
}


-(void)pop{
    
    
    goOut = true;
    
    
    [NSThread  cancelPreviousPerformRequestsWithTarget:self];
    
    [self.navigationController popViewControllerAnimated:true];
}



-(void)getNextPage{
    
    if(gettingNextPage){
        
        
        
        return ;
    }
    
    
    gettingNextPage = true;
    
    
    if ([chatArray count] > 0) {
        
        
        if (listID == -1) {
            
            [XZWDBOperate getChatArrayForUserID:userID  andTime:[chatArray[0][@"mtime"] intValue]   andBlock:^(NSArray*tempArray){
                
                int chatCount = [chatArray  count];
                
                NSMutableIndexSet *indexes = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [tempArray count]  )];
                ;
                [chatArray   insertObjects:tempArray atIndexes:indexes];
                
                
                int chatCountNow = [chatArray  count];
                
                
                [chatTableView reloadData];
                
                
                [chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:chatCountNow - chatCount  inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:false];
                
                
                [self performSelector:@selector(enableGetData) withObject:nil afterDelay:.6f];
                
                
            }];
            
        }else {
            
            [XZWDBOperate getChatArrayForChatID:listID andUserID:userID andTime:[chatArray[0][@"mtime"] intValue]   andBlock:^(NSArray*tempArray){
                
                
                
                int chatCount = [chatArray  count];
                
                NSMutableIndexSet *indexes = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [tempArray count]  )];
                ;
                [chatArray   insertObjects:tempArray atIndexes:indexes];
                
                
                int chatCountNow = [chatArray  count];
                
                
                [chatTableView reloadData];
                
                
                [chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:chatCountNow - chatCount  inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:false];
                
                
                [self performSelector:@selector(enableGetData) withObject:nil afterDelay:.6f];
                
                
            }];
            
            
        }
        
        
        
        
        
    } else {
        
        [self performSelector:@selector(enableGetData) withObject:nil afterDelay:.6f];
        
    }
    
    
    //
    
    
    
}

-(void)enableGetData{
    
    gettingNextPage = false;
    
    
}


-(void)getFriendChat{
    
    if (goOut) {
        
        return ;
    }
    
    
    if (isGettingChat) {
        
        
        
        [self performSelector:@selector(getFriendChat) withObject:nil afterDelay:10.f];
        
        
        return ;
    }
    
    
    
    NSString *friendChatLink = nil;
    
    if (listID < 0 ) {
        
        friendChatLink = [XZWGetNewSiXin  stringByAppendingFormat:@"&uid=%d",userID];
        
    }else {
        
        friendChatLink = [XZWGetNewSiXin  stringByAppendingFormat: @"&list_id=%d&uid=%d",listID,userID ];
    }
    
    
    
    NSLog(@"friendChatLink %@",friendChatLink);
     
    
    isGettingChat = true;
    
    getChatRequest = [XZWNetworkManager asiWithLink:friendChatLink   postDic:nil completionBlock:^{
        
        NSDictionary *tempDic = [[getChatRequest responseString]   objectFromJSONString];
        
        NSMutableString *mutableString = [NSMutableString string];
        
        if ([tempDic[@"status"]  intValue] == 1) {
            
            
            
            for (int i = 0 ; i < [tempDic[@"data"] count] ; i++) {
                
             BOOL inserted =  [XZWDBOperate mainInsertDataFrom:tempDic[@"data"][i] andUserID:userID];
                
                if (inserted) {
                    
                    [chatArray  addObject:tempDic[@"data"][i]];
                    
                    
                }
                
                
                [mutableString   appendFormat:@"%@,",tempDic[@"data"][i][@"message_id"]];
            }
            
            if (mutableString.length > 0  ) {
                
                [mutableString deleteCharactersInRange:NSMakeRange(mutableString.length - 1, 1)];
                
                
                [XZWNetworkManager asiWithLink:[XZWSetSiXinRead stringByAppendingFormat:@"&uid=%d&message_ids=%@",userID,mutableString] postDic:nil completionBlock:^{} failedBlock:^{}];
                
                
                [chatTableView reloadData];
                
                
            }
            
            
            
            
            
            
            
            
            
            
            //[XZWDBOperate   insertDataFrom:tempDic[@"data"] andUserID:userID];
            
            if ([chatArray  count] > 1  ) {
                
                [chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatArray count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:true];
                
            }
            
        }else {
            
            
            
        }
        
        isGettingChat = false;
        
        [self performSelector:@selector(getFriendChat) withObject:nil afterDelay:10.f];
        
    } failedBlock:^{
        
        
        isGettingChat = false;
        
        [self performSelector:@selector(getFriendChat) withObject:nil afterDelay:10.f];
        
        
        
    }];
    
}




-(void)getChat{
    
    
    
    return ;
    
    NSString *getChatString = nil;
    
    if (listID < 0 ) {
        
        getChatString = [XZWLoadSiXin  stringByAppendingFormat:@"&uid=%d&isPoll=0",userID];
        
    }else {
        
        getChatString = [XZWLoadSiXin  stringByAppendingFormat:@"&list_id=%d&isPoll=0",listID];
    }
    
    if (isGettingChat) {
        [getChatRequest  cancel];
    }
    
    
    getChatRequest = [XZWNetworkManager asiWithLink:getChatString postDic:nil completionBlock:^{
        
        NSLog(@"chat %@",[XZWLoadSiXin  stringByAppendingFormat:@"&list_id=%d&isPoll=0",listID]);
        
        NSDictionary *tempDic = [[getChatRequest responseString]   objectFromJSONString];
        
        
        
        
        if ([tempDic[@"status"]  intValue] == 1) {
            
            [chatArray    addObjectsFromArray:tempDic[@"data"]];
            [chatTableView reloadData];
            
            
            [XZWDBOperate   insertDataFrom:tempDic[@"data"] andUserID:userID];
            
            if ([chatArray  count] > 1  ) {
                
                [chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatArray count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:false];
                
            }
            
            
        ////
            
            
            if ([tempDic[@"data"] count] > 0) {
                
                
                NSArray *xinArray = tempDic[@"data"];
                
                
                
                for (NSDictionary *xinDic in xinArray) {
                    
                    
                    
                }
                
                
                
            }
            
            
            [XZWNetworkManager asiWithLink:XZWSetSiXinRead postDic:@{@"message_ids": @""} completionBlock:^{} failedBlock:^{}  ];
            
            
            
        }else {
            
            
            
        }
        
        
        
    } failedBlock:^{
        
        
        
        
        
    }];
    
    
    
    
    
    
    
    
}


-(void)sendChat{
    
    
     
    
    
    NSString *replyString = replyUTF.text;
    
    
    if (replyString.length == 0 ) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请先输入内容再发送" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        return ;
    }
    
    
    replyUTF.text = @"";
    
    
    NSDictionary *tempDic = @{@"from_uid":  [[NSUserDefaults standardUserDefaults] objectForKey:@"userID" ],@"me":@"1",@"content": replyString ,@"mtime":[NSString stringWithFormat:@"%f", [[NSDate  new] timeIntervalSince1970]],@"list_id":[NSString stringWithFormat:@"%d", listID] };
    
    [chatArray  addObject:tempDic ]  ;
    
    
    [chatTableView reloadData];
    
    
    
    [chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatArray count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:true];
    
    
    ASIFormDataRequest *chatRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:XZWPostSiXin]];
    
    
    NSMutableString *cookieString = [NSMutableString string];
    
    
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        
        if ([cookie.name   isEqualToString:@"PHPSESSID"]) {
            
            [cookieString   appendFormat: @"%@=%@;",cookie.name,cookie.value];
        }
        
    }
    
    [chatRequest  addRequestHeader:@"Cookie" value:cookieString];
    
    [chatRequest  addRequestHeader:@"User-Agent" value:@"Shockwave Flash"];
    
    [chatRequest setPostValue:[NSString stringWithFormat:@"%d",userID] forKey:@"to"];
    [chatRequest setPostValue:[replyString  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"content"];
    
    [chatRequest startAsynchronous];
    
    [chatRequest setCompletionBlock:^{
        
        NSDictionary *responseDic = [[chatRequest responseString]  objectFromJSONString];
        
        
        
        if ([[responseDic  objectForKey:@"status"]    intValue] == 1) {
            
            
            
            
            
            [XZWDBOperate   insertDataFrom:@[tempDic] andUserID:userID];
            
            
        }else {
            
            
            
            
        }
        
        
    }];
    
    [chatRequest setFailedBlock:^{
        
        
        
        
    }];
    
    
    
}



-(void)initView{
    
    
    chatTableView = [[UITableView alloc]  initWithFrame:CGRectMake(0, 0, 320, TotalScreenHeight - 64 - 44)];
    chatTableView.delegate =  self;
    chatTableView.dataSource = self;
    chatTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    chatTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:chatTableView];
    [chatTableView release];
    
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [chatTableView addGestureRecognizer:tap];
    [tap   release];
    
    replyView = [[UIView alloc]   initWithFrame:CGRectMake(0, TotalScreenHeight  - 64 - 44, 320, 44)];
    // replyView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"reply"]];
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
    replyUTF.enablesReturnKeyAutomatically = true;
    replyUTF.returnKeyType = UIReturnKeySend;
    [replyView addSubview:replyUTF];
    [replyUTF release];
    
    UIButton *replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [replyButton  setTitle:@"回复" forState:UIControlStateNormal];
    [replyButton setBackgroundImage:[UIImage imageNamed:@"reply_btn"] forState:UIControlStateNormal];
    [replyView addSubview:replyButton];
    [replyButton  addTarget:self action:@selector(sendChat) forControlEvents:UIControlEventTouchUpInside];
    [replyButton  setFrame:CGRectMake(253, 7, 60, 29)];
    
    
}

#pragma mark UITextfield


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self sendChat];
    
    return true;
}





-(void)handleTap:(UIGestureRecognizer *)gesture
{
    [self.view endEditing:YES];
}



#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    
    if (scrollView.contentOffset.y <  -1  ) {
        
        
        [self getNextPage];
        
    }
    
}

#pragma mark -
#pragma mark Responding to keyboard events


-(void)moveInputBarWithKeyboardHeight:(CGFloat)height withDuration:(int)duration{
    
    
    if (replyUTF.editing) {
        
        [UIView animateWithDuration:.3f animations:^{ replyView.frame = CGRectMake(0, TotalScreenHeight - 64 - height -44, 320, 44);
            
            chatTableView.frame = CGRectMake(0, 0, 320,  CGRectGetMinY(replyView.frame) );
            
            
            if ([chatArray  count] > 1  ) {
                
                [chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatArray count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:true];
                
            }
            
            
        }];
        
        
    }else {
        
        [UIView animateWithDuration:.3f animations:^{ replyView.frame = CGRectMake(0, TotalScreenHeight - 64 - height -44, 320, 44);
            
            chatTableView.frame = CGRectMake(0, 0, 320,  CGRectGetMinY(replyView.frame) );
            
            
        }];
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
    
    [self moveInputBarWithKeyboardHeight:0 withDuration:animationDuration];
}




#pragma mark -


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return  [chatArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *orgin=chatArray[indexPath.row][@"content"];
    CGSize textSize=[orgin sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake((320-HEAD_SIZE-3*INSETS-40), TEXT_MAX_HEIGHT) lineBreakMode:NSLineBreakByWordWrapping];
    return 55+textSize.height+30;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString * MyCustomCellIdentifier = @"mycell";
    XZWChatCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCustomCellIdentifier];
    if (cell == nil) {
        
        cell = [[[XZWChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyCustomCellIdentifier] autorelease];
        
        
    }
    
    [cell setMessage: chatArray[indexPath.row][@"content"] ];
    [cell setTime:chatArray[indexPath.row][@"mtime"]];
    cell.delegate = self;
    cell.row = indexPath.row;
    
    BOOL isME = [chatArray[indexPath.row][@"me"]   intValue] == 1;
    
    
    if (isME) {
        cell.msgStyle = kWCMessageCellStyleMe;
        [cell setHeadImageURL: [[NSUserDefaults standardUserDefaults]   valueForKey:@"avatar"]];
        
    }else {
        
        cell.msgStyle = kWCMessageCellStyleOther;
        [cell setHeadImageURL:avatarLinkString];
    }
    
    
    
    return cell;
}


-(void)chatDelete:(int)row{
    
    
    [XZWDBOperate deleteMessageID:chatArray[row][@"message_id"]];
    
    [chatArray removeObjectAtIndex:row];
    
    [chatTableView beginUpdates];
    [chatTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
    [chatTableView endUpdates];
    
    double delayInSeconds = .3f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [chatTableView reloadData];
    });
    
    
}



@end
