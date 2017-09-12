//
//  MRGuideView.m
//  MRGuideView
//
//  Created by MrXir on 2017/9/8.
//  Copyright © 2017年 MRXIR Inc. All rights reserved.
//

#import "MRGuideView.h"

#import "MRGuideCollectionCell.h"

@interface MRGuideView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) IBOutlet UIButton *skipButton;

@property (nonatomic, weak) IBOutlet UIButton *enterButton;

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@property (nonatomic, assign, getter=isAnimating) BOOL animating;

@property (nonatomic, strong) NSArray<NSString *> *portraitImageNames;
@property (nonatomic, strong) NSArray<NSString *> *landscapeImageNames;

@property (nonatomic, strong) NSArray<NSString *> *imageNames;

@end

@implementation MRGuideView

#pragma mark - life cycle

- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

+ (instancetype)static_instance
{
    static MRGuideView *static_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        static_instance = [[NSBundle mainBundle] loadNibNamed:@"MRGuideView" owner:nil options:nil].firstObject;
    });
    return static_instance;
}

- (instancetype)initWithPortraitImageNames:(NSArray<NSString *> *)portrait landscapeImageNames:(NSArray<NSString *> *)landscape
{
    MRGuideView *guide = [MRGuideView static_instance];
    
    [guide initialSetup];
    
    guide.portraitImageNames = portrait;
    
    guide.landscapeImageNames = landscape;
    
    return guide;
}

- (void)showWithAnimated:(BOOL)animated
{
    if (self.isAnimating) return;
    self.animating = YES;
    
    [self setupSubviews];
    
    UIWindow *topWindow = [self topWindow];
    
    if (animated) {
        
        self.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(self.bounds), 0);
        [topWindow addSubview:self];
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.animating = NO;
        }];
        
    } else {
        
        [topWindow addSubview:self];
        self.animating = NO;
    }
    
}

- (void)dismissWithAnimated:(BOOL)animated
{
    if (self.isAnimating) return;
    self.animating = YES;
    
    if (animated) {
        
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.transform = CGAffineTransformMakeTranslation(- CGRectGetWidth(self.bounds), 0);
        } completion:^(BOOL finished) {
            self.animating = NO;
            self.transform = CGAffineTransformIdentity;
            [self removeFromSuperview];
        }];
        
    } else {
        
        [self removeFromSuperview];
        self.animating = NO;
        
    }
    
}

#pragma mark - setter

- (void)setImageNames:(NSArray<NSString *> *)imageNames
{
    _imageNames = imageNames;
    
    [self.collectionView reloadData];
}

#pragma mark - layout


- (void)layoutSubviews
{
    [self setupSubviews];
}

#pragma mark - setup subviews

- (void)setupSubviews
{
    self.frame = [[UIScreen mainScreen] bounds];
    
    UICollectionViewFlowLayout *layout = (id)self.collectionView.collectionViewLayout;
    layout.itemSize = self.bounds.size;
    self.collectionView.collectionViewLayout = layout;
    
    // landscape
    if (self.bounds.size.width > self.bounds.size.height) {
        if (self.landscapeImageNames) self.imageNames = self.landscapeImageNames;
    } else {
        if (self.portraitImageNames) self.imageNames = self.portraitImageNames;
    }
    
}

#pragma mark - private method

- (void)initialSetup
{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.collectionView registerClass:[MRGuideCollectionImageCell class] forCellWithReuseIdentifier:@"IMAGE"];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.skipButton addTarget:self action:@selector(didClickSkipButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.enterButton addTarget:self action:@selector(didClickEnterButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self observeStatusBarOrientationToUpdateScrollViewOffset];
    
}

/** 监听状态栏方向变化从而改变滚动式图偏移量 */
- (void)observeStatusBarOrientationToUpdateScrollViewOffset
{
    __block CGSize sizeBeforeOrientationChange;
    __block CGPoint offsetBeforeOrientationChange;
    
    __block CGSize sizeAfterOrientationChanged;
    __block CGPoint offsetAfterOrientationChanged;
    
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillChangeStatusBarOrientationNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        sizeBeforeOrientationChange = self.bounds.size;
        offsetBeforeOrientationChange = self.collectionView.contentOffset;
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidChangeStatusBarOrientationNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        sizeAfterOrientationChanged = self.bounds.size;
        offsetAfterOrientationChanged = self.collectionView.contentOffset;
        
        CGFloat x = offsetBeforeOrientationChange.x / sizeBeforeOrientationChange.width * sizeAfterOrientationChanged.width;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.collectionView.contentOffset = CGPointMake(x, offsetBeforeOrientationChange.y);
        });
        
    }];
}

- (UIWindow *)topWindow
{
    NSArray<UIWindow *> *windows = [[UIApplication sharedApplication] windows];
    
    __block UIWindow *window = nil;
        
    [windows enumerateObjectsUsingBlock:^(UIWindow * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.windowLevel >= window.windowLevel) window = obj;
    }];
    
    return window;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    [self endEditing:YES];
}

- (void)didClickSkipButton:(UIButton *)button
{
    [self dismissWithAnimated:YES];
}

- (void)didClickEnterButton:(UIButton *)button
{
    [self dismissWithAnimated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageNames.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MRGuideCollectionImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IMAGE" forIndexPath:indexPath];
    
    cell.title = [@(indexPath.row) stringValue];
    
    NSString *imageName = self.imageNames[indexPath.row];
    
    cell.imageName = imageName;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MRGuideCollectionImageCell *cell = (id)[collectionView cellForItemAtIndexPath:indexPath];
    
    NSLog(@"%@", cell);
}

// 多层视图触摸事件穿透处理
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *targetView = [super hitTest:point withEvent:event];
    
    if ([targetView isEqual:self.coverView]) {
        
        CGPoint location = [targetView convertPoint:point toView:self.collectionView];
        
        NSLog(@"hit in cover root view <%@: %p> and convert point %@", targetView.class, targetView, NSStringFromCGPoint(location));
        
        return [self.collectionView hitTest:location withEvent:event];
        
    } else {
        
        NSLog(@"hit in cover sub view <%@: %p>", targetView.class, targetView);
        
        return targetView;
        
    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


@implementation MRGuideCoverView

@end
