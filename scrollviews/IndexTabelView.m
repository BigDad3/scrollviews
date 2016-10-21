//
//  IndexTabelView.m
//  scrollviews
//
//  Created by gaowei on 2016/10/20.
//  Copyright © 2016年 xes. All rights reserved.
//

#import "IndexTabelView.h"

@implementation IndexTabelView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setScrollViewContentOffSet:(CGPoint)point
{
    if (![self.mj_header isRefreshing]) {
        [self setContentOffset:point];
    }
}

@end
