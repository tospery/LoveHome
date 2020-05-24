//
//  JXBannerView.m
//  iOSLibrary
//
//  Created by 杨建祥 on 15/5/9.
//  Copyright (c) 2015年 Thundersoft. All rights reserved.
//

#if defined(JXEnableMasonry) && defined(JXEnableSDWebImage)
#import "JXBannerView.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "JXApple.h"


//#define JXBannerViewForImageViewTagStart             (1000)

@interface JXBannerView()
@property (nonatomic, assign) BOOL enableRolling;
@property (nonatomic, assign) CGFloat delayRolling;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) JXBannerViewDirection direction;
@property (nonatomic, strong) NSMutableArray *imageViews;
//@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) UIImageView *placeholderImageView;
@property (nonatomic, copy) void(^tappedBlock)(NSInteger index);
@end

@implementation JXBannerView
#pragma mark - Override methods
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self initView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self configView];
}

//- (CGSize)intrinsicContentSize {
////    JXDimension *dimension = [JXDimension currentDimension];
////    return CGSizeMake(dimension.appFrame.width, dimension.appFrame.height);
//    
//    CGFloat height = 150;
//    
//    JXDeviceResolution resolution = [JXDevice sharedInstance].resolution;
//    if (JXDeviceResolution750x1334 == resolution) {
//        height = 200;
//    }
//    return CGSizeMake(self.bounds.size.width, height);
//}

#pragma mark - Private methods
#pragma mark init
- (void)initView {
    _delayRolling = 3.0f;
    _placeholderImage = [UIImage imageNamed:@"jx_placeholder_loading_image"];
    //_images = [NSMutableArray arrayWithCapacity:5];
    _imageViews = [NSMutableArray arrayWithCapacity:5];
    
    self.backgroundColor = [UIColor clearColor];
    
    _placeholderImageView = [[UIImageView alloc] initWithImage:_placeholderImage];
    [self addSubview:_placeholderImageView];
    [_placeholderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading);
        make.top.equalTo(self.mas_top);
        make.trailing.equalTo(self.mas_trailing);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading);
        make.top.equalTo(self.mas_top);
        make.trailing.equalTo(self.mas_trailing);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.enabled = NO;
    [self addSubview:_pageControl];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading);
        make.trailing.equalTo(self.mas_trailing);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@(kJXStandardPageHeight));
    }];
}

- (void)setPlaceholderImage:(UIImage *)placeholderImage {
    _placeholderImage = placeholderImage;
    _placeholderImageView.image = _placeholderImage;
}

#pragma mark config
- (void)configView {
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width * _imageViews.count, _scrollView.bounds.size.height);
    for (NSInteger i = 0; i < _imageViews.count; ++i) {
        //UIImageView *imageView = [[UIImageView alloc] initWithFrame:_scrollView.bounds];
        UIImageView *imageView = [_imageViews objectAtIndex:i];
        imageView.frame = _scrollView.bounds;
        //imageView.tag = JXBannerViewForImageViewTagStart + i;
        imageView.userInteractionEnabled = YES;
        //imageView.image = _images[i];
        UITapGestureRecognizer *imageViewTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)];
        [imageView addGestureRecognizer:imageViewTapped];
        imageView.frame = CGRectOffset(imageView.frame, _scrollView.bounds.size.width * i, 0);
        [_scrollView addSubview:imageView];
    }
    _pageControl.numberOfPages = _imageViews.count;
    [self startRolling];
}

#pragma mark - Action methods
- (void)imageViewTapped:(UITapGestureRecognizer *)tap {
    if (_tappedBlock) {
        _tappedBlock(_index);
    }
}

- (void)performScrolling {
    _index++;
    if (_index == _imageViews.count) {
        _index = 0;
    }
    [UIView animateWithDuration:0.25f
                     animations:^{
                         _scrollView.contentOffset = CGPointMake(_index * _scrollView.bounds.size.width, 0);
                     } completion:^(BOOL finished) {
                         _pageControl.currentPage = _index;
                         if (_enableRolling) {
                             [self performSelector:@selector(performScrolling) withObject:nil afterDelay:_delayRolling];
                         }
                     }];
}

#pragma mark - Public methods
- (void)setupImageWithURLs:(NSArray *)URLs
                    cached:(void(^)())cached
                    tapped:(void(^)(NSInteger index))tapped{
    if ((0 == URLs.count) ||
        CGSizeEqualToSize(self.bounds.size, CGSizeZero)) {
        return;
    }
    
    _tappedBlock = tapped;
    __block NSInteger total = URLs.count;
    for (NSURL *obj in URLs) {
        [[SDWebImageManager sharedManager] downloadImageWithURL:obj
                                                        options:SDWebImageRetryFailed
                                                       progress:NULL
                                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                          --total;
                                                          [_imageViews addObject:image];
                                                          if (0 == total) {
                                                              [self setNeedsLayout];
                                                              if (cached) {
                                                                  cached();
                                                              }
                                                          }
                                                      }];
    }
}

- (void)setupWithLocalImages:(NSArray *)images
                      tapped:(void(^)(NSInteger index))tapped {
    if ((0 == images.count) || CGSizeEqualToSize(self.bounds.size, CGSizeZero)) {
        return;
    }
    
    _tappedBlock = tapped;
    //[_images addObjectsFromArray:images];
    for (int i = 0; i < images.count; ++i) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:images[i]];
        [_imageViews addObject:imageView];
    }
    [self setNeedsLayout];
}

- (void)setupWithWebImages:(NSArray *)urlStrings
                    cached:(void(^)())cached
                    tapped:(void(^)(NSInteger index))tapped {
    if ((0 == urlStrings.count) ||
        CGSizeEqualToSize(self.bounds.size, CGSizeZero)) {
        return;
    }
    
    //[self stopRolling];
    [self cancelRolling];
    for (UIImageView *imageView in _imageViews) {
        [imageView removeFromSuperview];
    }
    [_imageViews removeAllObjects];
    
    
    _tappedBlock = tapped;
//    for (int i = 0; i < urlStrings.count; ++i) {
//        [_imageViews addObject:[[UIImageView alloc] initWithImage:_placeholderImage]];
//    }
//    [self setNeedsLayout];
//    
//    __block NSInteger total = urlStrings.count;
//    __block NSInteger index = 0;
    for (NSString *urlString in urlStrings) {
//        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:urlString]
//                                                        options:SDWebImageRetryFailed
//                                                       progress:NULL
//                                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                                                          [(UIImageView *)[_imageViews objectAtIndex:index++] setImage:image];
//                                                          if (index == total) {
//                                                              if (cached) {
//                                                                  cached();
//                                                              }
//                                                          }
//                                                      }];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:_placeholderImage options:SDWebImageRetryFailed];
        [_imageViews addObject:imageView];
    }
    [self setNeedsLayout];
}

- (void)startRolling {
    if (0 == _imageViews.count) {
        return;
    }
    
    if (_enableRolling) {
        return;
    }
    [self stopRolling];
    [_placeholderImageView setHidden:YES];
    
    _enableRolling = YES;
    [self performSelector:@selector(performScrolling) withObject:nil afterDelay:_delayRolling];
}

- (void)stopRolling {
    if (!_enableRolling) {
        return;
    }
    [_placeholderImageView setHidden:NO];
    
    _enableRolling = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(performScrolling) object:nil];
}

- (void)cancelRolling {
    [self stopRolling];
    _index = 0;
    _scrollView.contentOffset = CGPointMake(0, 0);
    _pageControl.currentPage = 0;
    //[self performScrolling];
}

#pragma mark - Delegate
#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopRolling];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    _pageControl.currentPage = _index;
    [self startRolling];
}
@end
#endif

