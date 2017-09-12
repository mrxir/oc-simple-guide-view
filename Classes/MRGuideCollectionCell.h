//
//  MRGuideCollectionCell.h
//  MRGuideView
//
//  Created by MrXir on 2017/9/8.
//  Copyright © 2017年 MRXIR Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRGuideCollectionCell : UICollectionViewCell

@end

@interface MRGuideCollectionImageCell : MRGuideCollectionCell

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *imageName;

@end
