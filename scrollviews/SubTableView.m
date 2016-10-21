//
//  SubTableView.m
//  scrollviews
//
//  Created by gaowei on 2016/10/20.
//  Copyright © 2016年 xes. All rights reserved.
//

#import "SubTableView.h"

@implementation SubTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


@end
