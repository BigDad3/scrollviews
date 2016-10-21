//
//  SecondViewController.m
//  scrollviews

//整个方法的实现主要参考了如下demo
//http://www.code4app.com/thread-10931-1-1.html
//https://github.com/seedotlee/AlipayIndexDemo
//
//  Created by gaowei on 2016/10/20.
//  Copyright © 2016年 xes. All rights reserved.
//

#import "SecondViewController.h"
#import "IndexTabelView.h"
#import "MJRefresh.h"

#define HEADER_VIEW_HEIGHT 180
#define ITEM_CELL_HEIGHT 50

@interface SecondViewController ()<UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate>
{
    UIScrollView * superScrollView;
    IndexTabelView * subTableView;
    IndexTabelView * subTableView2;
    UIScrollView * subScrollView;
    
    CGRect contentRect;
    
    NSInteger itemNum;
    
    NSInteger positionNum;
    
    UIView * headerView;
    
    UIView * buttonView;
}

@end

@implementation SecondViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"Second";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    positionNum = 0;
    itemNum = 20;
    
    contentRect = self.view.frame;
    
    superScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, contentRect.size.width, contentRect.size.height-64)];
    [superScrollView setContentSize:CGSizeMake(contentRect.size.width, HEADER_VIEW_HEIGHT + ITEM_CELL_HEIGHT * itemNum)];
    [self.view addSubview:superScrollView];
    superScrollView.backgroundColor = [UIColor clearColor];
    superScrollView.delegate = self;

    subScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, HEADER_VIEW_HEIGHT, superScrollView.frame.size.width, ITEM_CELL_HEIGHT * itemNum)];
    [superScrollView addSubview:subScrollView];
    subScrollView.bounces = NO;
    [subScrollView setContentSize:CGSizeMake(superScrollView.frame.size.width*2, ITEM_CELL_HEIGHT * itemNum)];
    subScrollView.backgroundColor = [UIColor greenColor];
    subScrollView.pagingEnabled = YES;
    subScrollView.delegate = self;
    
    subTableView = [[IndexTabelView alloc] initWithFrame:CGRectMake(0, 0, subScrollView.frame.size.width, ITEM_CELL_HEIGHT * itemNum) style:UITableViewStylePlain];
    [subScrollView addSubview:subTableView];
    subTableView.scrollEnabled = NO;
    subTableView.delegate = self;
    subTableView.dataSource = self;
    subTableView.backgroundColor = [UIColor whiteColor];
    subTableView.tag = 100;
    
    subTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeaderAction)];
    __weak typeof(self) weakSelf = self;
    subTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf refreshHeaderAction];
    }];
    
    subTableView2 = [[IndexTabelView alloc] initWithFrame:CGRectMake(subScrollView.frame.size.width, 0, subScrollView.frame.size.width, ITEM_CELL_HEIGHT * itemNum) style:UITableViewStylePlain];
    [subScrollView addSubview:subTableView2];
    subTableView2.delegate = self;
    subTableView2.scrollEnabled = NO;
    subTableView2.tag = 101;
    subTableView2.dataSource = self;
    subTableView2.backgroundColor = [UIColor whiteColor];
    
    subTableView2.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeaderAction)];
    subTableView2.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf refreshHeaderAction];
    }];
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, superScrollView.frame.size.width, HEADER_VIEW_HEIGHT)];
    headerView.backgroundColor = [UIColor blueColor];
    [superScrollView addSubview:headerView];
    
    buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, HEADER_VIEW_HEIGHT-40, headerView.frame.size.width, 40)];
    [headerView addSubview:buttonView];
    
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, 0, headerView.frame.size.width/2, 40);
    button1.backgroundColor = [UIColor grayColor];
    [button1 setTitle:@"title1" forState:UIControlStateNormal];
    [buttonView addSubview:button1];
    [button1 addTarget:self action:@selector(button1Action:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(headerView.frame.size.width/2, 0, headerView.frame.size.width/2, 40);
    [button2 setTitle:@"title2" forState:UIControlStateNormal];
    [buttonView addSubview:button2];
    [button2 addTarget:self action:@selector(button2Action:) forControlEvents:UIControlEventTouchUpInside];
    button2.backgroundColor = [UIColor grayColor];
    
}

- (IBAction)popAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    [subTableView setContentOffset:CGPointMake(0, -65)];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * cellStr = @"hotspotListTableViewCell";
    
    UITableViewCell * cell;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        //            cell.backgroundColor = [UIColor grayColor];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"--- %ld %ld", (long)tableView.tag, (long)indexPath.row];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ITEM_CELL_HEIGHT;
}


//-(void)functionViewAnimation:(CGFloat)y
//{
//    
//    if y > HEADER_VIEW_HEIGHT/2.0 {
//        self.mainScrollView.setContentOffset(CGPoint(x:0,y:95), animated: true)
//        
//    } else {
//        self.mainScrollView.setContentOffset(CGPoint(x:0,y:0), animated: true)
//        
//    }
//}

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

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView == superScrollView) {
        CGFloat y = scrollView.contentOffset.y;
        
        IndexTabelView * tableview;
        
        for (UIView * view in [subScrollView subviews]) {
            if ([view isMemberOfClass:[IndexTabelView class]] && view.tag == 100+positionNum) {
                tableview = (IndexTabelView *)view;
            }
        }
        
        if (y < -65) {
            [tableview.mj_header beginRefreshing];
        }
        
        if ( y> superScrollView.contentSize.height-603+65) {
            [tableview.mj_footer beginRefreshing];
            
//             tableview.contentInset = UIEdgeInsetsMake(0, 0, 65, 0);
//            superScrollView.contentInset = UIEdgeInsetsMake(0, 0, 5, 0);
//            [superScrollView setContentOffset:CGPointMake(0, superScrollView.contentSize.height-603+550)];
        }
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView == superScrollView) {
        CGFloat y = scrollView.contentOffset.y;
        
        IndexTabelView * tableview;
        
        for (UIView * view in [subScrollView subviews]) {
            if ([view isMemberOfClass:[IndexTabelView class]] && view.tag == 100+positionNum) {
                tableview = (IndexTabelView *)view;
            }
        }
        
        if (y <= 0) {
            
            CGRect frame  = headerView.frame;
            frame.origin.y = y;
            headerView.frame = frame;
            
            [tableview setScrollViewContentOffSet:CGPointMake(0, y)];

        }
        
        if (y > (HEADER_VIEW_HEIGHT-40)) {
            CGRect frame  = buttonView.frame;
            frame.origin.y = y;
            buttonView.frame = frame;
        }
        
        if ( y> superScrollView.contentSize.height-603) {
            [tableview setScrollViewContentOffSet:CGPointMake(0, y - (superScrollView.contentSize.height-603))];
        }
        
    }

}

@end
