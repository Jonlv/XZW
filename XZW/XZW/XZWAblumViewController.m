//
//  XZWAblumViewController.m
//  XZW
//
//  Created by dee on 13-9-26.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWAblumViewController.h"
#import "XZWNetworkManager.h"
#import "XZWButton.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "GoodsGalleryViewController.h"

#import "MBProgressHUD.h"

@interface XZWAblumViewController ()<UITableViewDataSource,UITableViewDelegate>{


    ASIHTTPRequest *delRequest;

    NSMutableArray *picArray, *editArray;

    UITableView *myTableView;

    ASIHTTPRequest *picRequest;

    int userID;

    int current;

    BOOL isLoading,isFinished;


    BOOL isEditing;

    UIView *editView;

    MBProgressHUD *hud;
}

@end

@implementation XZWAblumViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithUserID:(int)theUserID
{
    self = [super init];
    if (self) {
        // Custom initialization

        picArray = [[NSMutableArray alloc] init ];//WithArray:thePicArray];

        editArray = [[NSMutableArray alloc] init];

        for (int i = 0; i < [picArray count]; i++) {
            [editArray addObject:@false];
        }

        userID = theUserID ;
    }

    return self;
}

- (void)dealloc
{
    [picArray release];
    [editArray release];

    [super dealloc];
}


- (void)selectAll
{
    [editArray  removeAllObjects];

    for (id object in picArray) {

        [editArray addObject:@true];
    }

    [myTableView reloadData];
}


-(void)unSelectAll{

    [editArray  removeAllObjects];

    for (id object in picArray) {

        [editArray addObject:@false];
    }

    [myTableView reloadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.title = @"个人相册";


    myTableView = [[UITableView alloc]  initWithFrame:CGRectMake(0, 0, 320, TotalScreenHeight - 64) ];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    [self.view addSubview:myTableView];
    [myTableView release];


    UIView *uv = [[UIView alloc]  initWithFrame:myTableView.bounds];
    uv.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    [myTableView  setBackgroundView:uv];
    [uv release];


    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];


    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:listButton] autorelease];



    // 如果是本人，则显示编辑按钮
    if (userID == [[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] intValue]) {

        listButton = [UIButton buttonWithType:UIButtonTypeCustom];
        listButton.frame = CGRectMake(0, 0, 53, 30);
        listButton.contentMode = UIViewContentModeScaleToFill;
        [listButton addTarget:self action:@selector(getEdit:) forControlEvents:UIControlEventTouchUpInside];
        [listButton setBackgroundImage:[[UIImage imageNamed:@"edit_btn"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
        [listButton setTitle:@"编辑" forState:UIControlStateNormal];
        [listButton setTitle:@"取消" forState:UIControlStateSelected];
        listButton.titleLabel.font = [UIFont systemFontOfSize:14];
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];
    }



    //    if ([picArray  count] < 28  ) {
    //
    //        isFinished = true;
    //
    //    }else {
    //
    //
    UIView *footerView = [[[UIView alloc]  initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];
    [myTableView setTableFooterView:footerView];
    // myTableView.tableFooterView.hidden = true;

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
    //
    //
    //    }
    //


    [self loadNextPage];

    //  current =  1;


    editView = [[UIView alloc]  initWithFrame:CGRectMake(0, TotalScreenHeight , 320, 44)];
    [self.view addSubview: editView];
    [editView   release];


    UIImageView *uiv = [[UIImageView alloc]  initWithImage:[UIImage imageNamed:@"bt_bg"]];
    [editView addSubview:uiv];
    [uiv release];


    UIButton *selectAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAllButton.frame = CGRectMake(0, 0, 106, 40);
    [selectAllButton   addTarget:self action:@selector(selectAll) forControlEvents:UIControlEventTouchUpInside];
    [selectAllButton  setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [selectAllButton  setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    selectAllButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [selectAllButton setTitle:@"全选" forState:UIControlStateNormal];
    [editView addSubview:selectAllButton];

    selectAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAllButton.frame = CGRectMake(106, 0, 106, 40);
    [selectAllButton   addTarget:self action:@selector(deleteSelect) forControlEvents:UIControlEventTouchUpInside];
    [selectAllButton  setImageEdgeInsets:UIEdgeInsetsMake(0, -20 , 0, 0)];
    [selectAllButton  setImage:[UIImage imageNamed:@"del"] forState:UIControlStateNormal];
    [selectAllButton  setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [selectAllButton  setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    selectAllButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [selectAllButton setTitle:@"删除" forState:UIControlStateNormal];
    [editView addSubview:selectAllButton];


    selectAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAllButton.frame = CGRectMake(212, 0, 106, 40);
    [selectAllButton   addTarget:self action:@selector(unSelectAll) forControlEvents:UIControlEventTouchUpInside];
    [selectAllButton  setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [selectAllButton  setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    selectAllButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [selectAllButton setTitle:@"取消全选" forState:UIControlStateNormal];
    [editView addSubview:selectAllButton];


    UIImageView *vUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(106, 0, 2, 43)];
    vUIV.image = [UIImage imageNamed:@"vline"];
    [editView addSubview:vUIV];
    [vUIV release];

    vUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(214, 0, 2, 43)];
    [editView addSubview:vUIV];
    vUIV.image = [UIImage imageNamed:@"vline"];
    [vUIV release];


    hud = [[MBProgressHUD alloc]  initWithView:self.view];
    [self.navigationController.view addSubview:hud];
    [hud release];
}


- (void)deleteSelect
{
    NSMutableString *delString = [NSMutableString string];

    for (int i = 0; i < [editArray count]; i++) {

        NSNumber *selectNum = editArray[i];

        if ([selectNum boolValue]) {

            [delString appendFormat:@"%@,", picArray[i][@"id"]];
        }
    }

    int length = delString.length;


    if (length > 0) {

        [delString   deleteCharactersInRange:NSMakeRange(length - 1, 1)];
    }

    [hud show:true];
    hud.labelText = @"删除中...";


    delRequest = [XZWNetworkManager asiWithLink:[XZWDelPhoto stringByAppendingFormat:@"&id=%@",delString] postDic:nil completionBlock:^{

        NSDictionary *responseDic = [[delRequest responseString] objectFromJSONString];

        if ([responseDic[@"status"] intValue] == 1) {

            for (int i = [editArray count] - 1; i >= 0; i--) {

                NSNumber *selectNum = editArray[i];

                if ([selectNum boolValue]) {

                    [picArray removeObjectAtIndex:i];
                    [editArray removeObjectAtIndex:i];
                }
            }

            [myTableView reloadData];
        }

        hud.labelText = responseDic[@"info"];
        [hud hide:true afterDelay:.8f];

        [[NSNotificationCenter defaultCenter] postNotificationName:XZWNotification_AlbumDeleteSuccessfully object:self];

    } failedBlock:^{

        hud.labelText = @"删除失败...";
        [hud hide:true];
    }];
}

- (void)getEdit:(UIButton*)sender
{
    isEditing = !isEditing;

    sender.selected = !sender.selected;

    if (isEditing) {

        editView.frame = CGRectMake(0, TotalScreenHeight - 64 - 44 , 320, 44);
        myTableView.frame =  CGRectMake(0, 0, 320, TotalScreenHeight - 64 - 44);

    } else {

        editView.frame = CGRectMake(0, TotalScreenHeight , 320, 44);
        myTableView.frame =  CGRectMake(0, 0, 320, TotalScreenHeight - 64);
    }

    [myTableView reloadData];
}


#pragma mark -

- (void)selectButton:(XZWButton*)sender {

    if (isEditing) {

        [editArray replaceObjectAtIndex:sender.buttonTag withObject:@(![[editArray objectAtIndex:sender.buttonTag] boolValue])];
        [myTableView reloadData];
    } else {

        GoodsGalleryViewController *goodsGVC = [[GoodsGalleryViewController alloc]  initWithPhotoArray:picArray page:sender.buttonTag];
        [self.navigationController presentModalViewController:goodsGVC animated:true];
        [goodsGVC release];
    }
}

- (void)goBack {

    [XZWNetworkManager cancelAndReleaseRequest:picRequest];
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark -


- (void)loadNextPage
{
    if (isLoading) {
        return;
    }


    if (isFinished) {
        return;
    }


    isLoading = true;

    [XZWNetworkManager cancelAndReleaseRequest:picRequest];

    picRequest  = [XZWNetworkManager asiWithLink:userID == 0?[XZWGetAlbum stringByAppendingFormat:@"&num=28&p=%d",current + 1]:[XZWGetAlbum stringByAppendingFormat:@"&uid=%d&num=28&p=%d", userID, current + 1] postDic:nil completionBlock:^{

        NSDictionary *responseDic = [[picRequest responseString] objectFromJSONString];

        if ([[responseDic objectForKey:@"status"] intValue] == 0) {

        } else {

            current ++ ;

            if ([[[responseDic objectForKey:@"data"] objectForKey:@"data"] count] < 28 ) {
                isFinished = true;
                [myTableView setTableFooterView:nil];
            } else {

            }

            if ([[responseDic  objectForKey:@"data"][@"totalPages"] intValue] <= current ) {
                isFinished = true;
                [myTableView setTableFooterView:nil];
            }


            [picArray addObjectsFromArray:[[responseDic objectForKey:@"data"]  objectForKey:@"data"]];

            for (int i = 0; i < picArray.count; i++) {
                [editArray addObject:@false];
            }


            [myTableView reloadData];
        }

        isLoading = false;

        ;} failedBlock:^{isLoading = false;}];
}


#pragma mark -


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height + 5) {

        [self performSelector:@selector(loadNextPage)];
    }
}


#pragma mark -


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ceil((float)[picArray count] / 4);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * MyCustomCellIdentifier = @"mycell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCustomCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyCustomCellIdentifier] autorelease];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];


        for (int i = 0 ; i < 4; i++) {
            XZWButton *button = [XZWButton buttonWithType:UIButtonTypeCustom];
            button.frame =  CGRectMake(17 + 75 * i, 8, 60, 60);
            button.buttonTag = i;
            button.imageView.contentMode = UIViewContentModeScaleAspectFill;
            [button addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i + 1;
            [cell.contentView addSubview:button];


            UIImageView *uiv = [[UIImageView alloc]   initWithFrame:CGRectMake(40, 6, 14, 14)];
            [uiv  setHighlightedImage:[UIImage imageNamed:@"yselect"]];
            uiv.tag = 33;
            [uiv setImage:[UIImage imageNamed:@"edit_select"]];
            [button addSubview:uiv];
            [uiv release];
        }
    }



    for (int i = 0 ; i < 4 ; i++) {

        XZWButton *button = (XZWButton *)[cell.contentView viewWithTag:i + 1];

        button.buttonTag = indexPath.row * 4 + i;
        if ([picArray count] > i + indexPath.row * 4 ) {

            [button setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@data/upload/%@", XZWHost, [[[[picArray  objectAtIndex:indexPath.row  * 4 + i]  objectForKey:@"savepath"] stringByReplacingOccurrencesOfString:@".jpg" withString:@"_200_200.jpg"]  stringByReplacingOccurrencesOfString:@".png" withString:@"_200_200.png"]]] forState:UIControlStateNormal];
            button.hidden = false;


            if (isEditing) {

                UIImageView *subUIV= (UIImageView *)[button viewWithTag:33];

                subUIV.hidden = false;

                subUIV.highlighted = [[editArray objectAtIndex:indexPath.row * 4 + i]  boolValue];
            } else {

                [button viewWithTag:33].hidden = true;
            }
        } else {

            button.hidden = true;
        }
    }


    return cell;
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
