//
//  YDImageScrollView.m
//  YDphotoViewer
//
//  Created by apple on 16/8/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "YDImageScrollView.h"

@implementation YDImageScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 设置scrollView的属性
        self.maximumZoomScale = 2.5;
        self.minimumZoomScale = 1;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        // 添加图片
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        
//        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [self addSubview:_imageView];
        
        // 设置代理
        self.delegate = self;
        
        // 添加双击事件
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomInOrOut:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
    }
    return self;
}

#pragma mark - UIScrollView Delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

#pragma mark - Target Action
- (void)zoomInOrOut:(UITapGestureRecognizer *)tapGesture
{
    if (self.zoomScale == 1.0){
        CGPoint point = [tapGesture locationInView:self];
        [self zoomToRect:CGRectMake(point.x - 40, point.y - 40, 80, 80) animated:YES];
    }else{
        [self setZoomScale:1 animated:YES];
    }
}


@end
