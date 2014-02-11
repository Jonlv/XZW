//
//  XZWAstrolabeViewController.h
//  XZW
//
//  Created by Dee on 13-8-27.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//   星盘测试

#import <UIKit/UIKit.h>

#import "XZWSelectDateView.h"



@interface XZWAstrolabeViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,XZWSelectDateViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
    
    
    UIButton *daylightBtn;
    
    UIButton *showAscButton;
    
}



@end
