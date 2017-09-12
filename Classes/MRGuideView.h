//
//  MRGuideView.h
//  MRGuideView
//
//  Created by MrXir on 2017/9/8.
//  Copyright © 2017年 MRXIR Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MRGuideCoverView;

@interface MRGuideView : UIView

@property (nonatomic, weak) IBOutlet MRGuideCoverView *coverView;

- (instancetype)initWithPortraitImageNames:(NSArray<NSString *> *)portrait landscapeImageNames:(NSArray<NSString *> *)landscape;

- (void)showWithAnimated:(BOOL)animated;

- (void)dismissWithAnimated:(BOOL)animated;

@end

@interface MRGuideCoverView : UIView

@end
