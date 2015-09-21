//
//  MJRefreshBaseView.m
//  MJRefresh
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJRefreshBaseView.h"
#import "MJRefreshConst.h"
#import "UIFont+CustomFont.h"
#define CUSTOM_FONT_BYSIZE(FONT_SIZE) [UIFont customFontWithPath:[[NSBundle mainBundle] pathForResource:@"Yuanti" ofType:@"ttf"] size:FONT_SIZE]

@interface  MJRefreshBaseView()
{
    BOOL _hasInitInset;
}
/**
 交给子类去实现
 */
// 合理的Y值
- (CGFloat)validY;
// view的类型
- (MJRefreshViewType)viewType;
@end

@implementation MJRefreshBaseView

#pragma mark 创建一个UILabel
- (UILabel *)labelWithFontSize:(CGFloat)size
{
    UILabel *label = [[UILabel alloc] init];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.font = [UIFont boldSystemFontOfSize:size];
    label.textColor = MJRefreshLabelTextColor;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
- (CustomLabelWithChinese *)CustomLabelWithChineseWithFontSize{
    CustomLabelWithChinese *label = [[CustomLabelWithChinese alloc] init];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    //    label.font = [UIFont boldSystemFontOfSize:size];
    label.textColor = MJRefreshLabelTextColor;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

#pragma mark - 初始化方法
- (instancetype)initWithScrollView:(UIScrollView *)scrollView
{
    if (self = [super init]) {
        self.scrollView = scrollView;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!_hasInitInset) {
        _scrollViewInitInset = _scrollView.contentInset;
        
        [self observeValueForKeyPath:MJRefreshContentSize ofObject:nil change:nil context:nil];
        
        _hasInitInset = YES;
        
        if (_state == MJRefreshStateWillRefreshing) {
            [self setState:MJRefreshStateRefreshing];
        }
    }
}

#pragma mark 构造方法
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 1.自己的属性
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        
        // 2.时间标签
        [self addSubview:_lastUpdateTimeLabel = [self CustomLabelWithChineseWithFontSize]];
        [_lastUpdateTimeLabel setFont:CUSTOM_FONT_BYSIZE(13.0f)];
        
        // 3.状态标签
        [self addSubview:_statusLabel = [self CustomLabelWithChineseWithFontSize]];
        [_statusLabel setFont:CUSTOM_FONT_BYSIZE(14.0f)];
        
        // 5.指示器
//        DTIActivityIndicatorView *activityView = [[DTIActivityIndicatorView alloc] initWithFrame:CGRectMake(19.0, 5.0, 40.0, 40.0)];
        //        [smallActivityIndicatorView setCenter:spinner.center];
//        activityView.indicatorColor = [UIColor lightGrayColor];
//        activityView.indicatorStyle = @"wp8";
//        [activityView setBackgroundColor:[UIColor clearColor]];
//        [self addSubview:_activityView = activityView];
        
        
        // 4.箭头图片
        UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kSrcName(@"arrow.png")]];
        arrowImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_arrowImage = arrowImage];
        
        
        // 6.设置默认状态
        [self setState:MJRefreshStateNormal];
        
    }
    return self;
}

#pragma mark 设置frame
- (void)setFrame:(CGRect)frame
{
    frame.size.height = MJRefreshViewHeight;
    [super setFrame:frame];
    
    CGFloat w = frame.size.width;
    CGFloat h = frame.size.height;
    if (w == 0 || _arrowImage.center.y == h * 0.5) return;
    
    CGFloat statusX = 0;
    CGFloat statusY = 5;
    CGFloat statusHeight = 20;
    CGFloat statusWidth = w;
    // 1.状态标签
    _statusLabel.frame = CGRectMake(statusX, statusY, statusWidth, statusHeight);
    
    // 2.时间标签
    CGFloat lastUpdateY = statusY + statusHeight + 5;
    _lastUpdateTimeLabel.frame = CGRectMake(statusX, lastUpdateY, statusWidth, statusHeight);
    
    // 3.箭头
//    CGFloat arrowX = w * 0.5 - 100;
//    _arrowImage.center = CGPointMake(arrowX, h * 0.5);
    [_arrowImage setTranslatesAutoresizingMaskIntoConstraints:NO];
//    CENTER_V(_arrowImage);
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem: _arrowImage attribute: NSLayoutAttributeLeft relatedBy: NSLayoutRelationEqual toItem: [_arrowImage superview] attribute: NSLayoutAttributeLeft multiplier: 1.0f constant: 50],[NSLayoutConstraint constraintWithItem: _arrowImage attribute: NSLayoutAttributeCenterY relatedBy: NSLayoutRelationEqual toItem: [_arrowImage superview] attribute: NSLayoutAttributeCenterY multiplier: 1.0f constant: 0.0f]]];
    [self subToAddElement];
    
//    [self addConstraints:@[[NSLayoutConstraint]]]
    
    // 4.指示器
//    _activityView.center = _arrowImage.center;
//    [_activityView setTranslatesAutoresizingMaskIntoConstraints:NO];

//       [self addConstraints:@[[NSLayoutConstraint constraintWithItem: _activityView attribute: NSLayoutAttributeLeft relatedBy: NSLayoutRelationEqual toItem: [_activityView superview] attribute: NSLayoutAttributeLeft multiplier: 1.0f constant: 50],[NSLayoutConstraint constraintWithItem: _activityView attribute: NSLayoutAttributeCenterY relatedBy: NSLayoutRelationEqual toItem: [_activityView superview] attribute: NSLayoutAttributeCenterY multiplier: 1.0f constant: 0.0f],[NSLayoutConstraint constraintWithItem: _activityView attribute: NSLayoutAttributeWidth relatedBy: NSLayoutRelationEqual toItem:nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0f constant: 40],[NSLayoutConstraint constraintWithItem: _activityView attribute: NSLayoutAttributeHeight relatedBy: NSLayoutRelationEqual toItem:nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0f constant: 40]]];
}
-(void)subToAddElement{

}

-(void)setcenterForArrowDeltaX:(CGFloat)dx DeltaY:(CGFloat)dy
{
    
    CGPoint center = _arrowImage.center;
    center.x += dx;
    center.y += dy;
    [_arrowImage setCenter:center];
}
-(void)setcenterForActivityDeltaX:(CGFloat)dx DeltaY:(CGFloat)dy
{
    
//    CGPoint center = _activityView.center;
//    center.x += dx;
//    center.y += dy;
//    [_activityView setCenter:center];
}
- (void)setBounds:(CGRect)bounds
{
    bounds.size.height = MJRefreshViewHeight;
    [super setBounds:bounds];
}

#pragma mark - UIScrollView相关
#pragma mark 设置UIScrollView
- (void)setScrollView:(UIScrollView *)scrollView
{
    // 移除之前的监听器
    [_scrollView removeObserver:self forKeyPath:MJRefreshContentOffset context:nil];
    // 监听contentOffset
    [scrollView addObserver:self forKeyPath:MJRefreshContentOffset options:NSKeyValueObservingOptionNew context:nil];
    
    // 设置scrollView
    _scrollView = scrollView;
    [_scrollView addSubview:self];
}

#pragma mark 监听UIScrollView的contentOffset属性
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![MJRefreshContentOffset isEqualToString:keyPath]) return;
    
    if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden
        || _state == MJRefreshStateRefreshing) return;
    
    // scrollView所滚动的Y值 * 控件的类型（头部控件是-1，尾部控件是1）
    CGFloat offsetY = _scrollView.contentOffset.y * self.viewType;
    CGFloat validY = self.validY;
    if (offsetY <= validY) return;
    
    if (_scrollView.isDragging) {
        CGFloat validOffsetY = validY + MJRefreshViewHeight;
        if (_state == MJRefreshStatePulling && offsetY <= validOffsetY) {
            // 转为普通状态
            [self setState:MJRefreshStateNormal];
            // 通知代理
            if ([_delegate respondsToSelector:@selector(refreshView:stateChange:)]) {
                [_delegate refreshView:self stateChange:MJRefreshStateNormal];
            }
            
            // 回调
            if (_refreshStateChangeBlock) {
                _refreshStateChangeBlock(self, MJRefreshStateNormal);
            }
        } else if (_state == MJRefreshStateNormal && offsetY > validOffsetY) {
            // 转为即将刷新状态
            [self setState:MJRefreshStatePulling];
            // 通知代理
            if ([_delegate respondsToSelector:@selector(refreshView:stateChange:)]) {
                [_delegate refreshView:self stateChange:MJRefreshStatePulling];
            }
            
            // 回调
            if (_refreshStateChangeBlock) {
                _refreshStateChangeBlock(self, MJRefreshStatePulling);
            }
        }
    } else { // 即将刷新 && 手松开
        if (_state == MJRefreshStatePulling) {
            // 开始刷新
            [self setState:MJRefreshStateRefreshing];
            // 通知代理
            if ([_delegate respondsToSelector:@selector(refreshView:stateChange:)]) {
                [_delegate refreshView:self stateChange:MJRefreshStateRefreshing];
            }
            
            // 回调
            if (_refreshStateChangeBlock) {
                _refreshStateChangeBlock(self, MJRefreshStateRefreshing);
            }
        }
    }
}

#pragma mark 设置状态
- (void)setState:(MJRefreshState)state
{
    if (_state != MJRefreshStateRefreshing) {
        // 存储当前的contentInset
        _scrollViewInitInset = _scrollView.contentInset;
    }
    
    // 1.一样的就直接返回
    if (_state == state) return;
    
    // 2.根据状态执行不同的操作
    switch (state) {
        case MJRefreshStateNormal: // 普通状态
            // 显示箭头
            _arrowImage.hidden = NO;
            // 停止转圈圈
//            [_activityView stopActivity:YES];
            [self normalStateAction];
            
            // 说明是刚刷新完毕 回到 普通状态的
            if (MJRefreshStateRefreshing == _state) {
                // 通知代理
                if ([_delegate respondsToSelector:@selector(refreshViewEndRefreshing:)]) {
                    [_delegate refreshViewEndRefreshing:self];
                }
                
                // 回调
                if (_endStateChangeBlock) {
                    _endStateChangeBlock(self);
                }
            }
            
            break;
            
        case MJRefreshStatePulling:
            break;
            
        case MJRefreshStateRefreshing:
            // 开始转圈圈
//            [_activityView startActivity];
            [self refreshingStateAction];
            // 隐藏箭头
            _arrowImage.hidden = YES;
            _arrowImage.transform = CGAffineTransformIdentity;
            
            // 通知代理
            if ([_delegate respondsToSelector:@selector(refreshViewBeginRefreshing:)]) {
                [_delegate refreshViewBeginRefreshing:self];
            }
            
            // 回调
            if (_beginRefreshingBlock) {
                _beginRefreshingBlock(self);
            }
            break;
        default:
            break;
    }
    
    // 3.存储状态
    _state = state;
}
-(void)refreshingStateAction{

}
-(void)normalStateAction{

}
#pragma mark - 状态相关
#pragma mark 是否正在刷新
- (BOOL)isRefreshing
{
    return MJRefreshStateRefreshing == _state;
}
#pragma mark 开始刷新
- (void)beginRefreshing
{
    if (self.window) {
        [self setState:MJRefreshStateRefreshing];
    } else {
        _state = MJRefreshStateWillRefreshing;
    }
}
#pragma mark 结束刷新
- (void)endRefreshing
{
    double delayInSeconds = self.viewType == MJRefreshViewTypeFooter ? 0.3 : 0.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self setState:MJRefreshStateNormal];
    });
}

#pragma mark - 随便实现
- (CGFloat)validY { return 0;}
- (MJRefreshViewType)viewType {return MJRefreshViewTypeHeader;}
- (void)free
{
    [_scrollView removeObserver:self forKeyPath:MJRefreshContentOffset];
}
- (void)removeFromSuperview
{
    [self free];
    _scrollView = nil;
    [super removeFromSuperview];
}
- (void)endRefreshingWithoutIdle
{
    [self endRefreshing];
}
@end