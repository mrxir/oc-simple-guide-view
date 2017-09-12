//
//  MRGuideCollectionCell.m
//  MRGuideView
//
//  Created by MrXir on 2017/9/8.
//  Copyright © 2017年 MRXIR Inc. All rights reserved.
//

#import "MRGuideCollectionCell.h"

@implementation MRGuideCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end


@interface MRGuideCollectionImageCell ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end


@implementation MRGuideCollectionImageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self = [[NSBundle mainBundle] loadNibNamed:@"MRGuideCollectionCell" owner:self options:nil][0];
        
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    self.titleLabel.text = _title;
}

- (void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    
    self.imageView.image = [UIImage imageNamed:_imageName];
}

@end
