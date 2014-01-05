//
//  XZWMyProfileViewController.h
//  XZW
//
//  Created by dee on 13-9-10.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCImagePickerController.h"

@interface XZWMyProfileViewController : UIViewController<ELCImagePickerControllerDelegate, UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>



@property (nonatomic, copy) NSArray *chosenImages;


-(id)initUserID:(int)userIDArg;

@end
