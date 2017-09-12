//
//  ViewController.m
//  MRGuideView
//
//  Created by MrXir on 2017/9/8.
//  Copyright © 2017年 MRXIR Inc. All rights reserved.
//

#import "ViewController.h"

#import "MRGuideView.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIButton *button;

@end

@implementation ViewController

- (void)showGuideView:(UIButton *)button
{
    NSArray *portraitImages = @[@"551798fb352fa3426c820c19f68659fb.jpg",
                                @"bfbf5f339dcd44395fe38eefbe93237e.jpeg",
                                @"cebf18ea36f953bbd424cbce8a7dee92.jpg",
                                @"f92509fd026fdd7aebc4e9b3e81f0666.jpg"];
    
    NSArray *landscapeImages = @[@"06e0367b994ace8f9b40efc9176cd617.jpg",
                                 @"19332fe243cd83064f1ac9a9ee718038.jpg",
                                 @"8562e0bba354cae4a0e9a1ce99352133.jpg",
                                 @"90b8617bc1133180923ffb92ca19ac67.jpg"];
    
    MRGuideView *guideView = [[MRGuideView alloc] initWithPortraitImageNames:portraitImages landscapeImageNames:landscapeImages];
    
    [guideView showWithAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self showGuideView:_button];
    
    [self.button addTarget:self action:@selector(showGuideView:) forControlEvents:UIControlEventTouchUpInside];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
