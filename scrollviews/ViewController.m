//
//  ViewController.m
//  scrollviews
//
//  Created by gaowei on 2016/10/20.
//  Copyright © 2016年 xes. All rights reserved.
//

#import "ViewController.h"
#import "SuperTableView.h"
#import "SubBGScrollView.h"
#import "SubTableView.h"
#import "MJRefresh.h"

#define HEADER_VIEW_HEIGHT 180

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate>
{
    SuperTableView * superTableView;
    SubTableView * subTableView;
    SubTableView * subTableView2;
    SubBGScrollView * subScrollView;
    
    CGRect contentRect;
    
    /*
     //用于记录subTableView的位置 0 在正常状态 1 上滑 2 滑到了最顶端。
     //通过下面函数的设置，来达到让superTabelView和subTabelView都能响应滑动手势的目的
     - (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
     {
     return YES;
     }
     //通过判断两个tableview的位置来设置ContentOffset,从而达到让superTabelView和subTabelView分别滑动的目的
     */
    
    //用于判断上滑下滑
    CGPoint beginPoint;
//    CGPoint subBeginPoint;
    
    //记录当前显示的是哪个subTableview
    NSInteger positionNum;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"title";
    
    contentRect = self.view.frame;
    //contentRect = (origin = (x = 0, y = 0), size = (width = 375, height = 667))
    
    superTableView = [[SuperTableView alloc] initWithFrame:CGRectMake(0, 64, contentRect.size.width, contentRect.size.height-64) style:UITableViewStylePlain];
    [self.view addSubview:superTableView];
    superTableView.position = 0;
    superTableView.backgroundColor = [UIColor redColor];
    superTableView.delegate = self;
    superTableView.dataSource = self;
    superTableView.bounces = NO;
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    beginPoint = CGPointZero;
    
    positionNum = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tempEndFresh
{
    if ([subTableView.mj_header isRefreshing]) {
        [subTableView.mj_header endRefreshing];
    }
    
    if ([subTableView.mj_footer isRefreshing]) {
        [subTableView.mj_footer endRefreshing];
    }
    
    if ([subTableView2.mj_header isRefreshing]) {
        [subTableView2.mj_header endRefreshing];
    }
    
    if ([subTableView2.mj_footer isRefreshing]) {
        [subTableView2.mj_footer endRefreshing];
    }
}

- (void)refreshHeaderAction
{
    [self performSelector:@selector(tempEndFresh) withObject:nil afterDelay:3];
}


- (void)button1Action:(UIButton *)button
{
    positionNum = 0;
    [subScrollView setContentOffset:CGPointMake(0, 0)];
}

- (void)button2Action:(UIButton *)button
{
    positionNum = 1;
    [subScrollView setContentOffset:CGPointMake(subScrollView.frame.size.width, 0)];
}

#pragma mark UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == superTableView) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == superTableView) {
        return 1;
    } else {
        return 20;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == superTableView) {
        NSString * cellStr = @"hotspotTableViewCell";
        
        UITableViewCell * cell;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            cell.backgroundColor = [UIColor clearColor];
        }
        
        if (indexPath.section == 0) {
            cell.backgroundColor = [UIColor whiteColor];
        } else {
            cell.backgroundColor = [UIColor whiteColor];
            
            subScrollView = [[SubBGScrollView alloc] initWithFrame:CGRectMake(0, 0, superTableView.frame.size.width, superTableView.frame.size.height)];
            [cell addSubview:subScrollView];
            subScrollView.bounces = NO;
            [subScrollView setContentSize:CGSizeMake(superTableView.frame.size.width*2, 600)];
//            subScrollView.backgroundColor = [UIColor greenColor];
            subScrollView.pagingEnabled = YES;
            subScrollView.showsHorizontalScrollIndicator = NO;
            
            subTableView = [[SubTableView alloc] initWithFrame:CGRectMake(0, 0, subScrollView.frame.size.width, subScrollView.frame.size.height) style:UITableViewStylePlain];
            [subScrollView addSubview:subTableView];
            subTableView.delegate = self;
            //            hotspotListTableView.scrollEnabled = NO;
            //            hotspotListTableView.bounces = NO;
            subTableView.dataSource = self;
            subTableView.position = 0;
            subTableView.backgroundColor = [UIColor whiteColor];
            subTableView.tag = 100;
            subTableView.showsVerticalScrollIndicator = NO;
            
            subTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeaderAction)];
            __weak typeof(self) weakSelf = self;
            subTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakSelf refreshHeaderAction];
            }];
            
            subTableView2 = [[SubTableView alloc] initWithFrame:CGRectMake(subScrollView.frame.size.width, 0, subScrollView.frame.size.width, subScrollView.frame.size.height) style:UITableViewStylePlain];
            [subScrollView addSubview:subTableView2];
            subTableView2.delegate = self;
            subTableView2.position = 0;
            subTableView2.tag = 101;
            //            hotspotListTableView.scrollEnabled = NO;
            //            hotspotListTableView.bounces = NO;
            subTableView2.dataSource = self;
            subTableView2.backgroundColor = [UIColor whiteColor];
            subTableView2.showsVerticalScrollIndicator = NO;
            
            subTableView2.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeaderAction)];
            subTableView2.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakSelf refreshHeaderAction];
            }];
        }
        
        return cell;
    } else {
        NSString * cellStr = @"hotspotListTableViewCell";
        
        UITableViewCell * cell;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
//            cell.backgroundColor = [UIColor grayColor];
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"--- %ld %ld", (long)tableView.tag, (long)indexPath.row];
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == superTableView) {
        if (indexPath.section == 0) {
            return HEADER_VIEW_HEIGHT;
        } else {
            return superTableView.frame.size.height;
        }
    } else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == superTableView) {
        if (section == 0) {
            return 0;
        } else {
            return 40;
        }
    } else {
        return 0;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == superTableView) {
        if (section == 0) {
            return nil;
        } else {
            UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, superTableView.frame.size.width, 40)];
            headerView.backgroundColor = [UIColor grayColor];
            
            UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
            button1.frame = CGRectMake(0, 0, headerView.frame.size.width/2, 40);
            [button1 setTitle:@"title1" forState:UIControlStateNormal];
            [headerView addSubview:button1];
            [button1 addTarget:self action:@selector(button1Action:) forControlEvents:UIControlEventTouchUpInside];
            [headerView addSubview:button1];
            
            UIButton * button2 = [UIButton buttonWithType:UIButtonTypeCustom];
            button2.frame = CGRectMake(headerView.frame.size.width/2, 0, headerView.frame.size.width/2, 40);
            [button2 setTitle:@"title2" forState:UIControlStateNormal];
            [headerView addSubview:button2];
            [button2 addTarget:self action:@selector(button2Action:) forControlEvents:UIControlEventTouchUpInside];
            [headerView addSubview:button2];
            
            
            return headerView;
        }
    } else {
        return nil;
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == subScrollView) {
        CGPoint offsetPoint = scrollView.contentOffset;
        
        CGFloat offsetFloat = offsetPoint.x/subScrollView.frame.size.width;
        NSNumber * offsetNum = [NSNumber numberWithFloat:offsetFloat];
        positionNum = [offsetNum integerValue];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == superTableView) {
        
        SubTableView * tableview;
        
        for (UIView * view in [subScrollView subviews]) {
            if ([view isMemberOfClass:[SubTableView class]] && view.tag == 100+positionNum) {
                tableview = (SubTableView *)view;
            }
        }
        
        
        NSLog(@"============= positionNum %ld", positionNum);
        
        //记录手指在屏幕拖动的位置，如果是滑动手指离开屏幕之后值不会改变
        CGPoint point = [scrollView.panGestureRecognizer translationInView:scrollView];
        
        if (point.y > beginPoint.y) {
            
            //下滑
            if (tableview.position == 0 && superTableView.position == 0) {
            }
            
            
            if (tableview.position == 0 && superTableView.position == 1) {
                
                [tableview setContentOffset:CGPointZero];
                
                if (superTableView.contentOffset.y <= 0) {
                    superTableView.position = 0;
                }
            }
            
            if (tableview.position == 0 && superTableView.position == 2) {
                
                [tableview setContentOffset:CGPointZero];
                superTableView.position = 1;
            }
            
            if (tableview.position == 1 && superTableView.position == 2) {
                
                [superTableView setContentOffset:CGPointMake(0, HEADER_VIEW_HEIGHT)];
                
                if (tableview.contentOffset.y <= 0) {
                    tableview.position = 0;
                }
                
            }
            
            if (tableview.position == 2 && superTableView.position == 2) {
            }
            
        } else if (point.y < beginPoint.y){
            //上滑
            if (tableview.position == 0 && superTableView.position == 0) {
                [tableview setContentOffset:CGPointZero];
                superTableView.position = 1;
            }
            
            
            if (tableview.position == 0 && superTableView.position == 1) {
                [tableview setContentOffset:CGPointZero];
                
                if (superTableView.contentOffset.y >= HEADER_VIEW_HEIGHT) {
                    superTableView.position = 2;
                    [superTableView setContentOffset:CGPointMake(0, HEADER_VIEW_HEIGHT)];
                }
            }
            
            if (tableview.position == 0 && superTableView.position == 2) {
                [superTableView setContentOffset:CGPointMake(0, HEADER_VIEW_HEIGHT)];
                tableview.position = 1;
            }
            
            if (tableview.position == 1 && superTableView.position == 2) {
                [superTableView setContentOffset:CGPointMake(0, HEADER_VIEW_HEIGHT)];
            }
            
            if (tableview.position == 2 && superTableView.position == 2) {
            }
            
        }
        
        beginPoint = point;
    }
//    else if (scrollView == subTableView) {
//        CGPoint point = [scrollView.panGestureRecognizer translationInView:scrollView];
//        
//        subBeginPoint = point;
//    }
    
}

@end
