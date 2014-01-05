//
//  XZWAstrolabeView.h
//  XZW
//
//  Created by Dee on 13-8-23.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XZWAstrolableDataSource <NSObject>

@required

-(double)astrolableAst;

-(NSArray*)getDataArray;



@end


@interface XZWAstrolabeView : UIView{
    
    
    
    double k ;
    double am,srota,cpoint;
    
    NSMutableArray *dot;
    NSArray *colorArray;
    NSMutableArray *DegreeArr;
    NSMutableArray *aspect ;
}


@property (assign,nonatomic) id<XZWAstrolableDataSource> dataSource;


@end
