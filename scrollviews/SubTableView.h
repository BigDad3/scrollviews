//
//  SubTableView.h
//  scrollviews
//
//  Created by gaowei on 2016/10/20.
//  Copyright © 2016年 xes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubTableView : UITableView

@property(nonatomic, assign) NSInteger position;

-(void)setScrollViewContentOffSet:(CGPoint)point;

@end
