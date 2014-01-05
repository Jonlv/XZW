//
//  XZWCateDetailViewController.m
//  XZW
//
//  Created by dee on 13-11-8.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWCateDetailViewController.h"
#import "XZWDBOperate.h"
#import "XZWDescriptionDetailViewController.h"

@interface XZWCateDetailViewController ()<UIScrollViewDelegate>{
    
    
    NSMutableArray *cateArray;
    UILabel *centerUL ;
    UIScrollView *usv ;
    
    NSString *cateString;
    
    int currentPage;
    
}

@end

@implementation XZWCateDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(id)initWithCateDetail:(NSDictionary*)cateDetail{
    
    self = [super init];
    if (self) {
        
        // Custom initialization
        
        cateArray =  [[NSMutableArray alloc]  init];
        
        //[XZWDBOperate getDreamNameFromCat:cateDetail[@"cate"]];
        
        
        cateString = [cateDetail[@"cate"]   retain];
        
        
        UILabel *astroUL = [[UILabel alloc]  initWithFrame:CGRectMake(10, 5, 320, 30)];
        astroUL.textColor = [UIColor grayColor];
        astroUL.text = cateDetail[@"cate"]; 
        astroUL.backgroundColor = [UIColor clearColor];
        [self.view addSubview:astroUL];
        [astroUL release];
        
        
        
    }
    return self;
    
}

-(void)dealloc{
    
    [cateString release];
    
    [cateArray  release];
    [super dealloc];
}


-(void)pop{
    
    [self.navigationController  popViewControllerAnimated:true];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"周公解梦";
    
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self  action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];

    
    
    
    usv = [[UIScrollView alloc]   initWithFrame:CGRectMake(0, 40, 320, TotalScreenHeight - 40 - 64 - 25 - 10 )];
    [usv setAlwaysBounceHorizontal:false];
    //usv.delegate = self;
    [usv setAlwaysBounceVertical:false];
    usv.showsHorizontalScrollIndicator = false;
    usv.showsVerticalScrollIndicator = false;
    [self.view addSubview:usv];
    [usv release];
    
    
    
    [XZWDBOperate   getDreamNameFromCat:cateString andBlock:^(NSArray *theArray){
        
        [cateArray   setArray:theArray];
        
        
       [self initView];
        
    }
     
     ];
    
}


-(void)loadUSVView{
    
    
    
    int countPerPage =    floor( usv.bounds.size.height / 40  )   * 3;
    
    
    for (UIView *uv in [usv subviews]) {
        
        [uv removeFromSuperview];
        
    }
    
    //上一页全部。
    int last = (((currentPage - 1) >= 0 ?(currentPage -1) :  0 )  * countPerPage);
    // 现在的这页。
    int left = [cateArray count] - last ;
    
    
//    if (left < 0) {
//        
//        left =   countPerPage - ABS(left) ;
//    }
    
    int count =   left >= countPerPage ? countPerPage :  left ;
    
     
    
    //int count = [cateArray count] - left >= countPerPage ? countPerPage : [cateArray count] - left ;
    
    
    for (int i = 0 ;  i < count ; i++) {
         
        
        UIButton *cateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        cateButton.tag = last +  i   ;
        [cateButton  setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        //cateButton.frame = CGRectMake( page * 320 + 5 + 105 * (i % 3) ,  (( i - page * countPerPage ) / 3) * 40   , 100, 30);
        cateButton.frame = CGRectMake(105 * (i % 3) + 5 ,   (( i   ) / 3) * 40 , 100  , 30  );
        [cateButton  setTitle:cateArray[i + last] forState:UIControlStateNormal];
        [cateButton addTarget:self action:@selector(nameAction:) forControlEvents:UIControlEventTouchUpInside];
        [usv addSubview:cateButton];
        
    }
    
    
    int totalPage =  ceil( (float)[cateArray count]  / countPerPage );
    
      centerUL.text = [NSString stringWithFormat:@" %d / %d",   currentPage , totalPage  ];
}

-(void)initView{
    
    
    currentPage = 1;
 
    
    UIImageView *myUIV ;
    
    if (IS_iPhone5) {
        
        
        myUIV = [[UIImageView alloc]  initWithFrame:CGRectMake(13, TotalScreenHeight - 64 - 50   , 293, 25)];
        myUIV.image = [UIImage imageNamed:@"pagebg"];
        myUIV.userInteractionEnabled = true;
        [self.view addSubview:myUIV];
        [myUIV  release];
        
    }else {
        
        
        myUIV = [[UIImageView alloc]  initWithFrame:CGRectMake(13, TotalScreenHeight - 64 - 48   , 293, 25)];
        myUIV.image = [UIImage imageNamed:@"pagebg"];
        myUIV.userInteractionEnabled = true;
        [self.view addSubview:myUIV];
        [myUIV  release];
        
    }
    
    
    
    
    centerUL = [[UILabel alloc]   initWithFrame:CGRectMake(-15, 0, 320, 25)];
    centerUL.backgroundColor = [UIColor clearColor];
    centerUL.textAlignment = UITextAlignmentCenter;
    centerUL.text = [NSString stringWithFormat:@" %d / %d",   (int)(usv.contentOffset.x / usv.frame.size.width) + 1 , (int)(usv.contentSize.width / usv.frame.size.width) ];
    [myUIV addSubview:centerUL];
    [centerUL release];
    
    UIButton *leftPageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftPageButton setTitle:@"上一页" forState:UIControlStateNormal];
    [leftPageButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [leftPageButton addTarget:self action:@selector(goLeft) forControlEvents:UIControlEventTouchUpInside];
    leftPageButton.frame = CGRectMake(0, 0, 100, 25);
    [myUIV addSubview:leftPageButton];
    
    
    
    
    leftPageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftPageButton setTitle:@"下一页" forState:UIControlStateNormal];
    [leftPageButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [leftPageButton addTarget:self action:@selector(goRight) forControlEvents:UIControlEventTouchUpInside];
    leftPageButton.frame = CGRectMake(190, 0, 100, 25);
    [myUIV addSubview:leftPageButton];
    

    
    
    [self loadUSVView];
    
    
//    int countPerPage =    floor( usv.bounds.size.height / 40  )   * 3;
//    int totalPage =  ceil( (float)[cateArray count]  / countPerPage );
//    
//    centerUL.text = [NSString stringWithFormat:@" %d / %d",   currentPage , totalPage  ];
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
   // centerUL.text = [NSString stringWithFormat:@" %d / %d",   (int)(usv.contentOffset.x / usv.frame.size.width) + 1 , (int)(usv.contentSize.width / usv.frame.size.width) ];
    
    
}


-(void)nameAction:(UIButton*)actionButton{
    
    
    
    NSDictionary *dic = [XZWDBOperate getKeyFrom:cateArray[actionButton.tag]];
    
    XZWDescriptionDetailViewController *dvc = [[XZWDescriptionDetailViewController alloc]  initWithDic:dic];
    [self.navigationController pushViewController:dvc animated:true];
    [dvc release];
    
    
}



-(void)goLeft{
    
    currentPage -- ;
    
    if (currentPage < 1) {
        
        currentPage = 1;
        
        return ;
    }
    
    
   // int countPerPage =    floor( usv.bounds.size.height / 40  )   * 3;
  //  ceil( (float)[cateArray count]  / countPerPage );
    
    
    [self loadUSVView];
    
   // [usv scrollRectToVisible:CGRectMake(  ((int)(usv.contentOffset.x / usv.frame.size.width) -  1 ) * 320   , 0, 320, 200) animated:false];
}

-(void)goRight{
    
    
    currentPage ++ ;
    
    
    int countPerPage =    floor( usv.bounds.size.height / 40  )   * 3;
    
    int totalPage =  ceil( (float)[cateArray count]  / countPerPage );
    
    if (currentPage > totalPage) {
        
        currentPage = totalPage;
        
        return ;
    }
    
    
    
    
    [self loadUSVView];
    
   // [usv scrollRectToVisible:CGRectMake(  ((int)(usv.contentOffset.x / usv.frame.size.width) + 1 ) * 320   , 0, 320, 200) animated:false];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
