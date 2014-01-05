//
//  XZWCreateQuanViewController.m
//  XZW
//
//  Created by dee on 13-10-11.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWCreateQuanViewController.h"
#import "XZWNetworkManager.h"
#import "MBProgressHUD.h"
#import "GKImagePicker.h"


#define MBProgessHud 8888


@interface XZWCreateQuanViewController ()<UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate,GKImagePickerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    UITextField *quanNameUTF,*quanCatalogUTF;
    
    UIImageView *quanImageView;
    
    UITextView *descriptionUTV;
    
    ASIHTTPRequest *quanCategoryRequest,*createQuanRequest;
    
    NSMutableDictionary *categoryDic;
    
    
    
    UIPickerView *categoryPickView;
    
    UIButton *imageBtn;
    
    
    
    
}
@property (nonatomic, retain) GKImagePicker *imagePicker;

@end

@implementation XZWCreateQuanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)dealloc{
    
    [categoryDic release];
    [_imagePicker release];
    [super dealloc];
}

-(void)pop{
    
    [self.navigationController popViewControllerAnimated:true];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title =  @"新建圈子";
    
    
    categoryDic = [[NSMutableDictionary alloc]  init];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];

    
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];
    
    
    
    
    listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self action:@selector(createquan) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"option"] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];
    
    [self initView];
    
    
}

-(void)initView{
    
    UIImageView *backgroundUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(10, 10, 300, 302)];
    backgroundUIV.image = [[UIImage imageNamed:@"corner"]  stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    backgroundUIV.userInteractionEnabled = true;
    [self.view addSubview:backgroundUIV];
    [backgroundUIV release];
    
     
    UIImageView *lineView = [[UIImageView alloc]  initWithFrame:CGRectMake(1, 40, 297, 1)];
    [lineView  setImage:[UIImage imageNamed:@"lines3"]];
    [lineView setBackgroundColor:[UIColor grayColor]];
    [backgroundUIV addSubview:lineView];
    [lineView release];
    
    UILabel *tipsUL = [[UILabel alloc]   initWithFrame:CGRectMake(7, 9, 150, 30)];
    tipsUL.text = @"名称:";
    tipsUL.backgroundColor = [UIColor clearColor];
    [backgroundUIV addSubview:tipsUL];
    [tipsUL release];
    
    quanNameUTF = [[UITextField alloc]  initWithFrame:CGRectMake(50, 13, 200, 30)];
    quanNameUTF.delegate = self;
    quanNameUTF.placeholder = @"请输入圈子名称";
    [backgroundUIV addSubview:quanNameUTF]; 
    [quanNameUTF release];
    
    
    tipsUL = [[UILabel alloc]   initWithFrame:CGRectMake(7, 45, 150, 30)];
    tipsUL.text = @"分类:";
    tipsUL.backgroundColor = [UIColor clearColor];
    [backgroundUIV addSubview:tipsUL];
    [tipsUL release];
    
    
    lineView = [[UIImageView alloc]  initWithFrame:CGRectMake(1, 80, 297, 1)];
    [lineView  setImage:[UIImage imageNamed:@"lines3"]];
    [lineView setBackgroundColor:[UIColor grayColor]];
    [backgroundUIV addSubview:lineView];
    [lineView release];
    
    
    UIButton *showQuan = [UIButton buttonWithType:UIButtonTypeCustom];
    showQuan.frame = CGRectMake(50, 45, 250, 30);
    [showQuan addTarget:self
                 action:@selector(showQuanAction) forControlEvents:UIControlEventTouchUpInside];
    [backgroundUIV addSubview:showQuan];
    
    
    quanCatalogUTF = [[UITextField alloc]  initWithFrame:CGRectMake(50, 50, 200, 30)];
    [backgroundUIV addSubview:quanCatalogUTF];
    quanCatalogUTF.text = @"明星粉丝 - 内地";
    quanCatalogUTF.userInteractionEnabled = false;
    [quanCatalogUTF release];
    
    
    UIImageView *tempUIV = [[UIImageView alloc]  initWithFrame:CGRectMake(220, 8, 9, 14)];
    tempUIV.image = [UIImage imageNamed:@"rtarrow"];
    [showQuan addSubview:tempUIV];
    [tempUIV release];

         
    imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageBtn.frame = CGRectMake(10, 90, 280, 90);
    [imageBtn  addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
    [imageBtn setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
    [backgroundUIV addSubview:imageBtn];
    
    
    UIImageView *tipUIV = [[UIImageView alloc]  initWithImage:[UIImage imageNamed:@"add_icon"]];
    [tipUIV setCenter:CGPointMake(140, 35)];
    [imageBtn addSubview:tipUIV];
    [tipUIV release];
    
    
    tipsUL = [[UILabel alloc]   initWithFrame:CGRectMake(10, 60, 280, 25)];
    tipsUL.text = @"请上传一张封面图片";
    tipsUL.font = [UIFont systemFontOfSize:13];
    tipsUL.textColor = [UIColor grayColor];
    tipsUL.textAlignment = UITextAlignmentCenter;
    tipsUL.backgroundColor = [UIColor clearColor];
    [imageBtn addSubview:tipsUL];
    [tipsUL release];
    
    
    
    quanImageView = [[UIImageView alloc]  initWithFrame:CGRectMake(10, 90, 280, 90)];
    quanImageView.contentMode = UIViewContentModeScaleAspectFill;
    quanImageView.clipsToBounds = true;
    [backgroundUIV addSubview:quanImageView];
    [quanImageView release];
    
    
    
    
    lineView = [[UIImageView alloc]  initWithFrame:CGRectMake(1, 190, 297, 1)];
    [lineView  setImage:[UIImage imageNamed:@"lines3"]];
    [lineView setBackgroundColor:[UIColor grayColor]];
    [backgroundUIV addSubview:lineView];
    [lineView release];
    
    
    
    tipsUL = [[UILabel alloc]   initWithFrame:CGRectMake(7, 195, 150, 30)];
    tipsUL.text = @"简介:";
    tipsUL.backgroundColor = [UIColor clearColor];
    [backgroundUIV addSubview:tipsUL];
    [tipsUL release];
    
    
    
    descriptionUTV = [[UITextView alloc]  initWithFrame:CGRectMake(50, 197, 245, 70)];
    descriptionUTV.delegate = self;
    descriptionUTV.font = [UIFont systemFontOfSize:14];
    [backgroundUIV addSubview:descriptionUTV];
    [descriptionUTV release];
    
    
    categoryPickView = [[UIPickerView alloc]  initWithFrame:CGRectMake(0, TotalScreenHeight, 320, 216.0)];
    categoryPickView.showsSelectionIndicator = true;
    [self.view addSubview:categoryPickView];
    [categoryPickView release];
    
    
    
    MBProgressHUD *mbProgessHud = [[MBProgressHUD alloc]  initWithView:self.view];
    mbProgessHud.tag = MBProgessHud;
    mbProgessHud.labelText = @"加载中...";
    [self.view addSubview:mbProgessHud];
    [mbProgessHud release];
    
    
     
    
    
    if ([[NSFileManager defaultManager]   fileExistsAtPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"XZWQuan"]]) {
        
        [categoryDic setDictionary:[NSDictionary dictionaryWithContentsOfFile:[NSTemporaryDirectory() stringByAppendingPathComponent:@"XZWQuan"]]];
        
        categoryPickView.delegate = self;
        categoryPickView.dataSource = self;
        
    }else {
        
        
    }
    
    quanCategoryRequest = [XZWNetworkManager asiWithLink:XZWQuanZiCatelog postDic:nil completionBlock:^{
        
        if ([[[quanCategoryRequest responseString]  objectFromJSONString][@"status"]     intValue] == 1) {
            
            
            [categoryDic   setDictionary:[[[quanCategoryRequest responseString]  objectFromJSONString] objectForKey:@"data"]];
         
            [categoryDic  writeToFile:[NSTemporaryDirectory() stringByAppendingPathComponent:@"XZWQuan"] atomically:true];
            
            categoryPickView.delegate = self;
            categoryPickView.dataSource = self;
           
        }else {
        
            
            
        }
        
        
        
        ;} failedBlock:^{ ;}];
    
    
}



-(void)addImage{
    
    
    self.imagePicker = [[GKImagePicker alloc] init];
    self.imagePicker.cropSize = CGSizeMake(320, 91);
    self.imagePicker.delegate = self;
    
    
        
    [self presentModalViewController:self.imagePicker.imagePickerController animated:YES];
    [_imagePicker release];
    
    
    
    
    return ;
    
    //
    
    NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
    
    imagePickerController.allowsEditing = true;
    
    imagePickerController.sourceType = sourceType;
    
    [self.navigationController presentViewController:imagePickerController animated:YES completion:^{}];
    
    [imagePickerController release];

    
}



# pragma mark -
# pragma mark GKImagePicker Delegate Methods

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
 //   self.imgView.image = image;
   
    
   
    quanImageView.image = image;
    
     
    [self hideImagePicker];
}

- (void)hideImagePicker{
 
    
    
        [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
        
     
}

# pragma mark -
# pragma mark UIImagePickerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
   
}



#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    
	[picker dismissViewControllerAnimated:YES completion:^{
        
        
        
        
    }];
    
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    quanImageView.image = image;

   // imageBtn.hidden = true;
    
    
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        
        
        
    }];
    
}


#pragma mark -

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    [UIView animateWithDuration:.3f animations:^{
        categoryPickView.frame =  CGRectMake(0, TotalScreenHeight, 320, 216.0);
        
        [self.view setFrame:CGRectMake(0, 0, 320, TotalScreenHeight)];
    }];
    
    
}


-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    [UIView animateWithDuration:.3f animations:^{
        
        categoryPickView.frame =  CGRectMake(0, TotalScreenHeight, 320, 216.0);
        [self.view setFrame:CGRectMake(0, -104, 320, TotalScreenHeight)];
    }];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [UIView animateWithDuration:.3f animations:^{
        
        [self.view setFrame:CGRectMake(0, 0, 320, TotalScreenHeight)];
    }];
    
    [self.view endEditing:true];
    
    return true;
}


-(void)textViewDidEndEditing:(UITextView *)textView{
    
    
    [UIView animateWithDuration:.3f animations:^{
        
        [self.view setFrame:CGRectMake(0, 0, 320, TotalScreenHeight)];
    }];
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:true];
    
    [UIView animateWithDuration:.3f animations:^{
        
        [self.view setFrame:CGRectMake(0, 0, 320, TotalScreenHeight)];
        categoryPickView.frame =  CGRectMake(0, TotalScreenHeight, 320, 216.0);
    }];
    

}


-(void)showQuanAction{

    
    [UIView animateWithDuration:.3f animations:^{
        
        [self.view setFrame:CGRectMake(0, 0, 320, TotalScreenHeight)];
        
        categoryPickView.frame =  CGRectMake(0, TotalScreenHeight- 64 -216.0 , 320, 216.0);
    }];
    
    
    [self.view endEditing:true];
}




-(void)createquan{
    
    
    if (!categoryDic[@"parent"]) {
        
        [[[[UIAlertView alloc]  initWithTitle:nil message:@"加载数据失败" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil]  autorelease] show];
        
        return ;
    }
    
    [UIView animateWithDuration:.3f animations:^{
        
        [self.view setFrame:CGRectMake(0, 0, 320, TotalScreenHeight)];
        categoryPickView.frame =  CGRectMake(0, TotalScreenHeight, 320, 216.0);
    }];
    
    [self.view endEditing:true];
    
    
    if ([quanNameUTF.text length] <= 0) {
        
        
        [[[[UIAlertView alloc]  initWithTitle:nil message:@"请输入圈子名称" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil]  autorelease] show];
        
        
        return ;
    }

    
    if ([descriptionUTV.text length] <= 0) {
        
        
        [[[[UIAlertView alloc]  initWithTitle:nil message:@"请先输入圈子简介" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil]  autorelease] show];
        
        
        return ;
    }

    
    NSString *cid0 = categoryDic[@"parent"][[categoryPickView selectedRowInComponent:0]][@"id"];
    NSString *cid1 = categoryDic[@"child"][[categoryPickView selectedRowInComponent:0]][@"list"][[categoryPickView selectedRowInComponent:1]][@"id"];
    
    
    MBProgressHUD *hud =  (MBProgressHUD *) [self.view viewWithTag:MBProgessHud];
    hud.labelText = @"创建中...";
    [hud show:true];
    
    
    createQuanRequest = [XZWNetworkManager asiWithLink:XZWCreateQuanZi postDic:@{@"name":[quanNameUTF.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],@"intro": [descriptionUTV.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], @"cid0":cid0,@"cid1":cid1,@"type":@"open"   }  imageData:  UIImageJPEGRepresentation(quanImageView.image,1.f)  andImageKey:@"logo" completionBlock:^{
    
        NSLog(@"%@",[[createQuanRequest  responseString]   objectFromJSONString]);
    
        NSDictionary *dic = [[createQuanRequest  responseString]   objectFromJSONString];
        
        if([dic[@"status"] intValue] == 1   ){
            
            
            [hud setLabelText:dic[@"info"]];
            [hud   hide:true afterDelay:.6f];
            
            
            [self pop];
            
            
        }else {
            
            
            [hud setLabelText:dic[@"info"]];
            [hud   hide:true afterDelay:.8f];
            
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:dic[@"info"] delegate:self cancelButtonTitle:@"好的" otherButtonTitles:@"重新创建",nil];
            [alert show];
            [alert release];

        }
            
    
    
    } failedBlock:^{
    
    
        [hud setLabelText:@"创建失败！"];
        [hud   hide:true afterDelay:.8f];
        
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"创建失败" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:@"重新创建",nil];
        [alert show];
        [alert release];

        
    }];
    
    
    
    
}

#pragma mark - alertview


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex != alertView.cancelButtonIndex) {
        
        [self createquan];
        
        
    }
    
    
}


#pragma mark - PickerView delegate

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *rowString = nil;
    
    switch (component) {
        case 0:
        {
            
            rowString = categoryDic[@"parent"][row][@"title"] ;
        }
            
            break;
            
        default:{
            @try {
                
                rowString = categoryDic[@"child"][[pickerView selectedRowInComponent:0]][@"list"][row][@"title"] ;
            }
            @catch (NSException *exception) {
                
                rowString= @"";
            }
            @finally {
            
            }
            
        }
            break;
    }
    
    
    
    return rowString;
}



-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    

 
    return 110;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    
    int count = 0 ;
    
    switch (component) {
        case 0:
        {
            
            count = [categoryDic[@"parent"]  count];
        }
            break;
            
        default:
        {
            
            count = [categoryDic[@"child"][[pickerView   selectedRowInComponent:0]][@"list"]  count];
        }
            break;
    }
    
 
    return  count;
    
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    
    return 2;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    
    [pickerView reloadAllComponents];
    
    
    quanCatalogUTF.text = [NSString stringWithFormat:@"%@ - %@",categoryDic[@"parent"][[pickerView selectedRowInComponent:0]][@"title"],categoryDic[@"child"][[pickerView selectedRowInComponent:0]][@"list"][[pickerView selectedRowInComponent:1]][@"title"] ];
    
}

#pragma mark -


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

@end
