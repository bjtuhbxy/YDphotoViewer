//
//  ViewController.m
//  YDphotoViewer
//
//  Created by apple on 16/8/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ViewController.h"
#import "YDImageScrollView.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"

@interface ViewController ()<UIScrollViewDelegate>
{
    NSMutableArray *_imgUrlMutArray;
    int _currentPageNo;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadImgArray];
    self.view.backgroundColor = [UIColor whiteColor];
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:22],NSFontAttributeName, nil];
    
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height, self.view.frame.size.width , self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - [[UIApplication sharedApplication] statusBarFrame].size.height)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.tag = INT_MAX;
    _scrollView.showsHorizontalScrollIndicator = NO;
    // 设置内容大小
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width*3, 0);
    _scrollView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width, 0);
    [self.view addSubview:_scrollView];
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:70/255.0 green:150/255.0 blue:255/255.0 alpha:1];;

    long a = _imgUrlMutArray.count;
    NSNumber *b = [NSNumber numberWithLong:a];
    NSString *str = [b stringValue];
    self.title = [@"1/" stringByAppendingString:str];
    
    [self loadInitBaseView];
}

-(void)viewDidAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)loadView
{
    [super loadView];
}

int pre = 0;
#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int current = scrollView.contentOffset.x / self.view.frame.size.width;
    
    YDImageScrollView *imgScrollView1 = (YDImageScrollView *)[scrollView viewWithTag:0];
    YDImageScrollView *imgScrollView2 = (YDImageScrollView *)[scrollView viewWithTag:1];
    YDImageScrollView *imgScrollView3 = (YDImageScrollView *)[scrollView viewWithTag:2];
//    if (current != pre && imgScrollView2.zoomScale > 1) {
        imgScrollView2.zoomScale = 1;
//    }
    pre = current;
    
    int pageNo = scrollView.contentOffset.x/self.view.frame.size.width;
    if (pageNo == 0) {
        _currentPageNo--;
    }else if (pageNo == 2){
        _currentPageNo++;
    }
    if (_currentPageNo < 0) {
        _currentPageNo = (int)[_imgUrlMutArray count] - 1;
    }else if (_currentPageNo > [_imgUrlMutArray count] - 1){
        _currentPageNo = 0;
    }
    int prePageNo = _currentPageNo - 1;
    if (prePageNo < 0) {
        NSLog(@"已经是第一页");
        prePageNo = (int)[_imgUrlMutArray count] - 1;
    }
    int nextPageNo = _currentPageNo+1;
    if (nextPageNo > [_imgUrlMutArray count] - 1) {
        NSLog(@"已经是最后一页");
        nextPageNo = 0;
    }
    
    [self loadTitleText:_currentPageNo];
    
    [imgScrollView1.imageView sd_setImageWithURL:[_imgUrlMutArray objectAtIndex:prePageNo] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    if (![[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[_imgUrlMutArray objectAtIndex:_currentPageNo]]) {
        [MBProgressHUD showHUDAddedTo:imgScrollView2.imageView animated:YES];
    }
    [imgScrollView2.imageView sd_setImageWithURL:[_imgUrlMutArray objectAtIndex:_currentPageNo] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [MBProgressHUD hideHUDForView:imgScrollView2.imageView animated:YES];
        if (!image) {
            NSLog(@"加载失败");
            [imgScrollView2.imageView setImage:[UIImage imageNamed:@"121"]];
        }
    }];
    [imgScrollView3.imageView sd_setImageWithURL:[_imgUrlMutArray objectAtIndex:nextPageNo] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    
    _scrollView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width, 0);
}

-(void)loadTitleText:(int)currentPage{
    
    NSNumber *num = [NSNumber numberWithInt:currentPage+1];
    NSString *str = [num stringValue];
    NSNumber *num2 = [NSNumber numberWithLong:[_imgUrlMutArray count]];
    NSString *str2 = [num2 stringValue];
    self.title = [[str stringByAppendingString:@"/"]stringByAppendingString:str2];
}

#pragma mark 加载初始化启动时的三张图片
-(void)loadInitBaseView{
    int _x = 0;
    for (int index = 0; index < 3; index++) {
        YDImageScrollView *imgScrollView = [[YDImageScrollView alloc] initWithFrame:CGRectMake(0+_x, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        
        imgScrollView.tag = index;
        

        if (index == 0) {
            
            [imgScrollView.imageView sd_setImageWithURL:[_imgUrlMutArray objectAtIndex:_imgUrlMutArray.count - 1] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            }];
        }else{
            if (![[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[_imgUrlMutArray objectAtIndex:index - 1]]) {
                [MBProgressHUD showHUDAddedTo:imgScrollView.imageView animated:YES];
            }
            [imgScrollView.imageView sd_setImageWithURL:[_imgUrlMutArray objectAtIndex:index - 1] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [MBProgressHUD hideHUDForView:imgScrollView.imageView animated:YES];
                if (!image) {
                    [imgScrollView.imageView setImage:[UIImage imageNamed:@"121"]];
                }
            }];
        }
        
        [_scrollView addSubview:imgScrollView];
        _x += self.view.frame.size.width;
    }
}

-(void)loadImgArray{
    NSString *pathStr = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@",pathStr);
    NSString *str1 = @"http://img4q.duitang.com/uploads/item/201505/13/20150513154513_KMhij.jpeg";
    NSString *str2 = @"http://cdnq.duitang.com/uploads/item/201501/29/20150129223754_YxPAM.jpeg";
    NSString *str3 = @"http://img4q.duitang.com/uploads/item/201410/13/20141013122309_ijduL.jpeg";
    NSString *str4 = @"http://i9.download.fd.pchome.net/t_480x854/g1/M00/0C/1C/oYYBAFR8FXmIY6EFAA2uURWCqVkAACH_gJdM34ADa5p035.jpg";
    NSString *str5 = @"http://img5.duitang.com/uploads/item/201504/27/20150427171455_FijsH.thumb.700_0.jpeg";
    NSString *str6 = @"http://img4.duitang.com/uploads/item/201404/28/20140428171407_Xf8tE.thumb.600_0.jpeg";
    NSString *str7 = @"http://img3.duitang.com/uploads/item/201404/28/20140428171541_uXRtV.thumb.700_0.jpeg";
    NSString *str8 = @"http://img3.duitang.com/uploads/item/201404/28/20140428171532_vSMaH.thumb.700_0.jpeg";
    NSString *str9 = @"http://img3.duitang.com/uploads/item/201404/27/20140427114225_UTCV4.thumb.700_0.jpeg";
    NSString *str10 = @"http://img3.duitang.com/uploads/item/201404/27/20140427114338_GXcaX.thumb.700_0.jpeg";
    NSString *str11 = @"http://img3.duitang.com/uploads/item/201404/25/20140425102102_aCVAi.thumb.700_0.jpeg";
    NSString *str12 = @"http://img3.duitang.com/uploads/item/201404/25/20140425101904_PEeT4.thumb.700_0.jpeg";
    NSString *str13 = @"http://img3.duitang.com/uploads/item/201404/25/20140425102031_ECHyr.thumb.700_0.jpeg";
    NSString *str14 = @"http://img3.duitang.com/uploads/item/201404/25/20140425102010_uRrhn.thumb.700_0.jpeg";
    NSString *str15 = @"http://img3.duitang.com/uploads/item/201404/25/20140425101815_RWrAh.thumb.700_0.jpeg";
    _imgUrlMutArray = [NSMutableArray arrayWithObjects:str1,str2,str3,str4,str5,str6,str7,str8,str9,str10,str11,str12,str13,str14,str15, nil];
}

-(BOOL)prefersStatusBarHidden{
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
