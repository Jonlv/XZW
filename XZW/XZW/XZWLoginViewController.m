//
//  XZWLoginViewController.m
//  XZW
//
//  Created by dee on 13-9-9.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWLoginViewController.h"
#import "XZWRegisterViewController.h"
#import "XZWNetworkManager.h"
#import "Interface.h"
#import "JSONKit.h"
#import "IIViewDeckController.h"
#import "XZWMenuViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "XZWMainViewController.h"
#import "XZWDBOperate.h"

@interface XZWLoginViewController () <UIAlertViewDelegate> {
	UITextField *emailUTF, *passwordUTF;
	ASIHTTPRequest *loginRequest;
}

@end

@implementation XZWLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void)viewDidLoad {
	self.title =  @"登录";

	[super viewDidLoad];


    //    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    listButton.frame = CGRectMake(0, 0, 23, 20);
    //    [listButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    //    [listButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    //
    //
    //    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];


	[self initView];
	// Do any additional setup after loading the view.
}

- (void)initView {
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];


	UILabel *emailUL = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, 320, 25)];
	emailUL.text = @"邮箱或ID";
	emailUL.textColor = [UIColor grayColor];
	[emailUL setBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:emailUL];
	[emailUL release];

	UIImageView *utfBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"registbox"]];
	utfBackground.frame = CGRectMake(20, 50, 278, 32);
	[self.view addSubview:utfBackground];
	[utfBackground release];

	emailUTF = [[UITextField alloc] initWithFrame:CGRectMake(25, 55, 220, 22)];
	emailUTF.text = @"";
	emailUTF.returnKeyType = UIReturnKeyDone;
	emailUTF.delegate = self;
	emailUTF.backgroundColor = [UIColor clearColor];
	[self.view addSubview:emailUTF];
	[emailUTF release];




	emailUL = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, 320, 25)];
	emailUL.text = @"密码";
	emailUL.textColor = [UIColor grayColor];
	[emailUL setBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:emailUL];
	[emailUL release];



	utfBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"registbox"]];
	utfBackground.frame = CGRectMake(20, 115, 278, 32);
	[self.view addSubview:utfBackground];
	[utfBackground release];

	passwordUTF = [[UITextField alloc] initWithFrame:CGRectMake(25, 120, 190, 22)];
	passwordUTF.text = @"";
	passwordUTF.returnKeyType = UIReturnKeyDone;
	passwordUTF.delegate = self;
	passwordUTF.secureTextEntry = true;
	passwordUTF.backgroundColor = [UIColor clearColor];
	[self.view addSubview:passwordUTF];
	[passwordUTF release];


	UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
	loginButton.frame = CGRectMake(129, 163, 64, 24);
	[loginButton setBackgroundImage:[UIImage imageNamed:@"regist"] forState:UIControlStateNormal];
	loginButton.titleLabel.font = [UIFont systemFontOfSize:14];
	[loginButton setTitle:@"登录" forState:UIControlStateNormal];
	[loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:loginButton];

	loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
	loginButton.frame = CGRectMake(25, 163, 64, 24);
	[loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	loginButton.titleLabel.font = [UIFont systemFontOfSize:14];
	[loginButton setTitle:@"点击注册" forState:UIControlStateNormal];
	[loginButton addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:loginButton];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.view endEditing:true];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self.view endEditing:true];

	return true;
}

- (void)registerAction {
	XZWRegisterViewController *registerVC = [[XZWRegisterViewController alloc]   init];
	[self.navigationController pushViewController:registerVC animated:true];
	[registerVC release];
}

- (void)goBack {
	[self dismissModalViewControllerAnimated:true];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
	[self goBack];
}

- (void)loginAction {

    if (emailUTF.text.length > 0 && passwordUTF.text.length > 0) {
        loginRequest = [XZWNetworkManager asiWithLink:XZWLogin postDic:[NSDictionary dictionaryWithObjectsAndKeys:emailUTF.text, @"login_email", passwordUTF.text, @"login_password", @"1", @"login_remember", nil] completionBlock: ^{
            NSDictionary *responceDic = [[loginRequest responseString]   objectFromJSONString];



            //    [self goBack];

            if ([[responceDic objectForKey:@"status"]   intValue] == 0) {
                [[[[UIAlertView alloc] initWithTitle:nil message:[responceDic objectForKey:@"info"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil]  autorelease]  show];
            }
            else {
                if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]) {
                    //两次登录是不同的人
                    if ([[[responceDic objectForKey:@"data"] objectForKey:@"uid"] intValue] != [[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] intValue]) {
                        //[XZWDBOperate removeAllRecords];
                    }


                    //	            [[NSUserDefaults standardUserDefaults] setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] forKey:@"oldUserID"];
                }
                else {
                    //	            [[NSUserDefaults standardUserDefaults] setObject:[[responceDic objectForKey:@"data"] objectForKey:@"uid"] forKey:@"oldUserID"];


                    //[XZWDBOperate removeAllRecords];
                }


                [[NSUserDefaults standardUserDefaults] setObject:[[responceDic objectForKey:@"data"] objectForKey:@"uid"] forKey:@"userID"];


                [[NSUserDefaults standardUserDefaults] setObject:[[responceDic objectForKey:@"data"] objectForKey:@"uname"] forKey:@"username"];

                [[NSUserDefaults standardUserDefaults] setObject:[[responceDic objectForKey:@"data"] objectForKey:@"avatar"] forKey:@"avatar"];

                [[NSUserDefaults standardUserDefaults] setObject:[[responceDic objectForKey:@"data"] objectForKey:@"constellation"] forKey:@"constellation"];




                [[NSUserDefaults standardUserDefaults]  synchronize];




                [[NSNotificationCenter defaultCenter] postNotificationName:XZWLoginNotification object:nil];

                UIAlertView *dismissUAV = [[[UIAlertView alloc] initWithTitle:nil message:[responceDic objectForKey:@"info"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil]  autorelease];
                [dismissUAV   show];
                
                double delayInSeconds = 0.4f;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                    if (dismissUAV) {
                        [dismissUAV dismissWithClickedButtonIndex:0 animated:true];
                    }
                    
                    [self goBack];
                });
            }
        } failedBlock:^{
            UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:nil message:@"网络异常，请确认网络连接正常后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [dialog show];
        }];
    } else {
        NSString* message;
        if (emailUTF.text.length == 0) {
            message = @"邮箱或ID不能为空";
        } else {
            message = @"密码不能为空";
        }
        UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [dialog show];
    }
}

- (void)dealloc {
	[XZWNetworkManager cancelAndReleaseRequest:loginRequest];

	[super dealloc];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
