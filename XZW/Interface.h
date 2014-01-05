//
//  Interface.h
//  XZW
//
//  Created by Dee on 13-8-27.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#ifndef XZW_Interface_h
#define XZW_Interface_h

//#define XZWHost [NSString stringWithFormat:@""]

//#define Register [NSString stringWithFormat:@"%@index.php?app=public&mod=Xzwregister&act=doStep1",XZWHost]
//
//#define Login [NSString stringWithFormat:@"%@index.php?app=public&mod=Xzwpassport&act=doLogin",XZWHost]
//
//#define Dynamic [NSString stringWithFormat:@"%@index.php?app=public&mod=Xzwindex&act=myFeed",XZWHost]
//
//#define FriendDynamic [NSString stringWithFormat:@"%@index.php?app=public&mod=Xzwpassport&act=doLogin",XZWHost]


//[[NSUserDefaults standardUserDefaults] boolForKey:@"XZWHighQuality"] [[NSUserDefaults standardUserDefaults] boolForKey:@"XZWNewMessage"] [[NSUserDefaults standardUserDefaults] boolForKey:@"XZWShake"] [[NSUserDefaults standardUserDefaults] boolForKey:@"XZWAutoCheck"];
// [[NSUserDefaults standardUserDefaults] boolForKey:@"XZWNewComment"] // 评论
// [[NSUserDefaults standardUserDefaults] boolForKey:@"XZWNewFriend"] //好友
// [[NSUserDefaults standardUserDefaults] boolForKey:@"XZWPush"] 推送
//  [[NSUserDefaults standardUserDefaults] boolForKey:@"XZWNewMessage"]  私信
//  [[NSUserDefaults standardUserDefaults] boolForKey:@"XZWValidation"] // 加入圈子验证
//  [[NSUserDefaults standardUserDefaults] integerForKey:@"XZWNewsInterval"] //新消息


#define XZWTotalSkins   13


#define XZWChangeCollectNotification   @"ChangeCollectNotification"

#define XZWSendSuccessNotification   @"SendSuccessNotification"

#define XZWLogOutNotification   @"LogOutNotification"

#define XZWNewMessageNotification   @"NewMessageNotification"  

#define XZWChangeSkinNotification   @"ChangeSkinNotification"
//登录
#define XZWLoginNotification   @"LoginNotification"
//刷新
#define XZWRefreshProfileNotification   @"RefreshProfileNotification"
//修改
#define XZWModifyProfileNotification   @"ModifyProfileNotification"
 
 

#define XZWGetFortuneByOne  @"http://act.xingzuowu.com/m_app/getfortune.php?limit=1&id="
 
#define XZWGetFortune  @"http://act.xingzuowu.com/m_app/getfortune.php?id="  

#define XZWHost  @"http://snsapp.xingzuowu.com:999/"  




#define XZWMain  [NSString stringWithFormat:@"%@index.php?app=public&mod=Xzwindex&act=home",XZWHost]

#define XZWRegister  [NSString stringWithFormat:@"%@index.php?app=public&mod=Xzwregister&act=doStep1",XZWHost]  

#define XZWLogin  [NSString stringWithFormat:@"%@index.php?app=public&mod=Xzwpassport&act=doLogin",XZWHost]  

#define XZWDynamic  [NSString stringWithFormat:@"%@index.php?app=public&mod=Xzwindex&act=myFeed",XZWHost]  

#define XZWFriendDynamic  [NSString stringWithFormat:@"%@index.php?app=public&mod=Xzwindex&act=index",XZWHost]  

#define XZWFriendList  [NSString stringWithFormat:@"%@index.php?app=public&mod=Xzwindex&act=following",XZWHost]  

#define XZWSearchUser  [NSString stringWithFormat:@"%@index.php?app=public&mod=Xzwindex&act=searchUser",XZWHost]  

#define XZWUserInfo  [NSString stringWithFormat:@"%@index.php?app=public&mod=Xzwindex&act=UserInformation",XZWHost]  

#define XZWModifyProfile  [NSString stringWithFormat:@"%@index.php?app=public&mod=Xzwindex&act=doSaveProfile",XZWHost]  

#define XZWPostFeed  [NSString stringWithFormat:@"%@index.php?app=group&mod=Xzwindex&act=PostFeed",XZWHost]  

#define XZWUploadImage  [NSString stringWithFormat:@"%@index.php?app=public&mod=Xzwindex&act=saveImage&attach_type=feed_image&upload_type=image&thumb=1&width=100&height=100&cut=1",XZWHost]  

#define XZWDelPhoto   [NSString stringWithFormat:@"%@index.php?app=photo&mod=Xzwindex&act=delPhoto",XZWHost] 


#define XZWGiftCategory  [NSString stringWithFormat:@"%@index.php?app=gift&mod=Xzwindex&act=giftCategory",XZWHost]  

#define XZWSearchGift  [NSString stringWithFormat:@"%@index.php?app=gift&mod=Xzwindex&act=searchGift",XZWHost]  

#define XZWGiftBox  [NSString stringWithFormat:@"%@index.php?app=gift&mod=Xzwindex&act=giftBox",XZWHost]  

#define XZWSendGift  [NSString stringWithFormat:@"%@index.php?app=gift&mod=Xzwindex&act=send",XZWHost]  




#define XZWSaveAvatar  [NSString stringWithFormat:@"%@index.php?app=public&mod=Xzwindex&act=doSaveAvatar",XZWHost]

#define XZWUploadToAlbum  [NSString stringWithFormat:@"%@index.php?app=photo&mod=Xzwindex&act=upload",XZWHost]

#define XZWGetAlbum  [NSString stringWithFormat:@"%@index.php?app=photo&mod=Xzwindex&act=getPhoto",XZWHost]


#define XZWSayHello  [NSString stringWithFormat:@"%@index.php?app=public&mod=xzwIndex&act=addDtinfo",XZWHost]

#define XZWTurnLike  [NSString stringWithFormat:@"%@index.php?app=public&mod=xzwIndex&act=turnLike",XZWHost]


#define XZWLocationList  [NSString stringWithFormat:@"%@index.php?app=public&mod=Xzwindex&act=locationList",XZWHost]


/// Discuss


#define XZWGetDiscuss  [NSString stringWithFormat:@"%@index.php?app=discuss&mod=Xzwindex&act=getDiscuss",XZWHost]

#define XZWJoinDiscuss [NSString stringWithFormat:@"%@index.php?app=discuss&mod=Xzwindex&act=postDiscuss",XZWHost]

#define XZWCYDiscuss [NSString stringWithFormat:@"%@index.php?app=discuss&mod=Xzwindex&act=getCYList",XZWHost]

#define XZWTurnDiggDiscuss [NSString stringWithFormat:@"%@index.php?app=discuss&mod=Xzwindex&act=turnDigg",XZWHost]

#define XZWAddCommentDiscuss [NSString stringWithFormat:@"%@index.php?app=discuss&mod=Xzwindex&act=addComment",XZWHost]


//// 圈子

#define XZWQuanZiList  [NSString stringWithFormat:@"%@index.php?app=group&mod=Xzwindex&act=getGroup",XZWHost]

#define XZWQuanZiMember [NSString stringWithFormat:@"%@index.php?app=group&mod=xzwindex&act=getMember",XZWHost]

#define XZWQuanZiInfo [NSString stringWithFormat:@"%@index.php?app=group&mod=xzwindex&act=getGroupInfo",XZWHost]

#define XZWQuanZiCatelog [NSString stringWithFormat:@"%@index.php?app=group&mod=xzwindex&act=getCategory",XZWHost]

#define XZWQuanZiPostHt [NSString stringWithFormat:@"%@index.php?app=group&mod=Xzwindex&act=postHt",XZWHost]

#define XZWCreateQuanZi [NSString stringWithFormat:@"%@index.php?app=group&mod=xzwindex&act=doAddGroup",XZWHost]

#define XZWLikeQuanZi [NSString stringWithFormat:@"%@index.php?app=group&mod=xzwindex&act=turnLike",XZWHost]

#define XZWJoinQuanZi [NSString stringWithFormat:@"%@index.php?app=group&mod=xzwindex&act=joinGroup",XZWHost]

#define XZWOutQuanZi [NSString stringWithFormat:@"%@index.php?app=group&mod=xzwindex&act=quitGroup",XZWHost]

#define XZWManageQuanZi [NSString stringWithFormat:@"%@index.php?app=group&mod=Xzwindex&act=setMember",XZWHost]

#define XZWQuanZiPost [NSString stringWithFormat:@"%@index.php?app=group&mod=xzwindex&act=PostFeed",XZWHost]

#define XZWQuanZiIssue [NSString stringWithFormat:@"%@index.php?app=group&mod=Xzwindex&act=getHtList",XZWHost]

#define XZWQuanTurnDigg [NSString stringWithFormat:@"%@index.php?app=group&mod=Xzwindex&act=turnDigg",XZWHost]


#define XZWQuanAddComment [NSString stringWithFormat:@"%@index.php?app=group&mod=Xzwindex&act=addComment",XZWHost]



// 

#define XZWNearBy [NSString stringWithFormat:@"%@index.php?app=public&mod=xzwIndex&act=neighborship",XZWHost]


#define XZWVisitorList [NSString stringWithFormat:@"%@index.php?app=public&mod=Xzwindex&act=visitorList",XZWHost]


#define XZWBirthdayList [NSString stringWithFormat:@"%@index.php?app=public&mod=Xzwindex&act=birthdayList",XZWHost]

#define XZWSiXinList [NSString stringWithFormat:@"%@index.php?app=public&mod=Xzwindex&act=SiXinList",XZWHost]

#define  XZWGetDtinfo [NSString stringWithFormat:@"%@index.php?app=public&mod=Xzwindex&act=getDtinfo",XZWHost]

#define  XZWPostSiXin [NSString stringWithFormat:@"%@index.php?app=public&mod=Xzwindex&act=postSiXin",XZWHost]

#define  XZWLoadSiXin [NSString stringWithFormat:@"%@index.php?app=public&mod=Xzwindex&act=loadSiXin_forAndroid",XZWHost]

#define XZWMyDt [NSString stringWithFormat:@"%@index.php?app=public&mod=Xzwindex&act=getDt&type=my",XZWHost]

#define XZWFriendDt [NSString stringWithFormat:@"%@index.php?app=public&mod=Xzwindex&act=getDt&type=friend",XZWHost]

#define XZWQuanDt [NSString stringWithFormat:@"%@index.php?app=group&mod=Xzwindex&act=getDt",XZWHost]

#define XZWContactList [NSString stringWithFormat:@"%@index.php?app=public&mod=Xzwindex&act=ContactList",XZWHost]

#define XZWContactList [NSString stringWithFormat:@"%@index.php?app=public&mod=Xzwindex&act=ContactList",XZWHost]

#define XZWUnreadCount [NSString stringWithFormat:@"%@index.php?app=public&mod=Xzwindex&act=SiXinNewsCount",XZWHost]


/// new  12 30
#define XZWGetNewSiXin  [NSString stringWithFormat:@"%@index.php?app=public&mod=Xzwindex&act=getNewSiXin",XZWHost]

#define XZWSetSiXinRead  [NSString stringWithFormat:@"%@index.php?app=public&mod=Xzwindex&act=setSiXinRead",XZWHost]

#define XZWDelDialog  [NSString stringWithFormat:@"%@index.php?app=public&mod=Xzwindex&act=delDialog",XZWHost]


///

#define XZWGetNewCount [NSString stringWithFormat:@"%@index.php?app=public&mod=Xzwindex&act=getNewCount",XZWHost]

#define XZWFeedBack [NSString stringWithFormat:@"%@index.php?app=public&mod=Xzwother&act=postFeedback",XZWHost]

#define XZWKnowledge @"http://wz.apkcn.com/api.php?id=****&type=cl&p="

#define XZWKnowledgeDetail @"http://wz.apkcn.com/api.php?id=****&type=art"

#define XZWGetCount @"http://wz.apkcn.com/api.php?type=count&id="

#define XZWGetCollectionList @"http://wz.apkcn.com/api.php?type=my&p="


#define XZWAddToCollection [NSString stringWithFormat:@"%@index.php?app=public&mod=Xzwother&act=addCollection&kid=",XZWHost]
 
#define XZWDelCollection [NSString stringWithFormat:@"%@index.php?app=public&mod=Xzwother&act=cancelCollection&kid=",XZWHost]

#endif
