//
//  YDImageScrollView.h
//  YDphotoViewer
//
//  Created by apple on 16/8/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDImageScrollView : UIScrollView<UIScrollViewDelegate>

{
@private
    UIImageView *_imageView;
}

@property (nonatomic, retain) UIImageView *imageView;

@end
