# scrollviews

里面的代码一共有两种实现方式，其中第二种还存在tableview上拉加载的问题没有解决。

首先来说一个整个的视图结构吧，Controller的View上有个一个Scrollview作为最下面的BottomScrollview，BottomScrollview 上面是一个View来展示一些内容，下面是一个subScrollView里面会横向排列N个tableview用来展示内容。每个tableview都会有下拉刷新跟上拉加载。大概的结构构如下所示，希望你们能明白…




需要一个连贯的动作，也就是手指不抬起来，切换响应者。整个的效果如下所示：（重点需要注意的是手指不抬起来，整个过程手指都没有抬起来，再一个难点就是下拉刷新在中间）。


思路1： 通过判断contentOffset位置，来切换BottomScrollview的scrollEnabled和tableview的scrollEnable来达到不同的scrollview响应滑动手势的目的。
最后结果：行不通
原因：手指不抬起来的时候没办法切换响应者。当开始响应手势的时候响应者就确定了，手指不离开屏幕整个过程不会中断，也就是响应者不会切换。
当滑动到一定的位置，这个时候
需要BottomScrollview（BottomScrollview. scrollEnabled = no）不在滑动，改为tableview(BottomScrollview. scrollEnabled = yes)来响应滑动手势去滑动的时候，BottomScrollview虽然不动了，但是tableview也不会动
，因为这时候BottomScrollview还是响应者。

思路2：Scrollview上的手势都是UIGestureRecognizer的子类，内部实现了UIGestureRecognizerDelegate的相关函数，通过重载UIGestureRecognizerDelegate的相关函数是不是可以控制手势的响应者呢？
结果：失败
原因：原因同上，响应者没办法切换。

思路3：既然切换手势的响应者的思路行不通，只能通过控制BottomScrollview和tableview的位置来达到效果了，也就是contentOffset的设置，来达到效果。开始响应手势之处呢就必须让两个scrollview（BottomScrollview和tableview）都要响应手势，只不过有一个动了有一个没动（[tableview setContentOffset:CGPointZero];），到了另一个情况呢就会切换这个操作也就是[BottomScrollview setContentOffset:CGPointZero];。
结果：可行。
具体实现：
创建UIScrollView和UITableView的子类，重载函数
`- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer`
这个函数返回YES的话，手势不只自己会响应，还会传递下去。达到我们同时响应手势的目的。



.h文件
`@interface SuperTableView : UITableView
@end`
.m文件
`@implementation SuperTableView
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
@end`


然后整个响应过程的控制呢是在

(void)scrollViewDidScroll:(UIScrollView *)scrollView里完成的。具体代码如下：
`- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
 if (scrollView == superTableView) {

  SubTableView * tableview;

  for (UIView * view in [subScrollView subviews]) {
      if ([view isMemberOfClass:[SubTableView class]] && view.tag == 100+positionNum) {
          tableview = (SubTableView *)view;
      }
  }
       //记录手指在屏幕拖动的位置，如果是滑动手指离开屏幕之后值不会改变
        CGPoint point = [scrollView.panGestureRecognizer     translationInView:scrollView];

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
}`


我定义了一个position的值来记录scrollview的位置，0 正常状态，就是刚进入界面时候的状态，此时只能下滑 1是出于中间状态此时可以上滑也可以下滑 2 滑到了最顶端的状态，此时只能往下滑。
比如当下滑的时候此时BottomScrollview的position值为1，tableview的position位置为0，这个时候BottomScrollview响应滑动手势，tableview不响应，代码如下

` if (tableview.position == 0 && BottomScrollview.position == 1) {

            [tableview setContentOffset:CGPointZero];

            if (BottomScrollview.contentOffset.y <= 0) {
                BottomScrollview.position = 0;
            }
        }
}`
