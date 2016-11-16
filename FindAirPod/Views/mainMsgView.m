//
//  mainMsgView.m
//  FindAirPod
//
//  Created by Baoyu on 16/9/9.
//  Copyright © 2016年 Baoy. All rights reserved.
//

#import "mainMsgView.h"
#import "MainModel.h"
#import "pop.h"


@interface mainMsgView ()


@property (nonatomic, strong) UIImageView *iconImg;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UITextView *descView;

@property (nonatomic, strong) HTCopyableLabel *wechatLabel;


@end

@implementation mainMsgView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //0.
        CGFloat height = kScreenH/3.5f;
        self.frame = CGRectMake(0, kScreenH - 64, kScreenW, height);
        self.backgroundColor = [UIColor whiteColor];
        
        
        //1.
        self.iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(13, 13, 22, 22)];
        [self addSubview:self.iconImg];
        
        
        
        
        //2.
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImg.frame) + 15, CGRectGetMinY(self.iconImg.frame), 200 , 22)];
        self.nameLabel.font = [UIFont boldSystemFontOfSize:19];
        [self addSubview:self.nameLabel];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.nameLabel.frame) + 10, 50, 25)];
        label.text = @"微信:";
        label.font = [UIFont systemFontOfSize:19];
        label.textColor = color_TestBlack;
        [self addSubview:label];
        
        self.wechatLabel = [[HTCopyableLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), CGRectGetMaxY(self.nameLabel.frame) + 10, kScreenW - CGRectGetMinX(self.nameLabel.frame), 25)];
        self.wechatLabel.font = [UIFont systemFontOfSize:19];
        self.wechatLabel.textColor = color_TestBlack;
        self.wechatLabel.textAlignment = NSTextAlignmentLeft;
        self.wechatLabel.userInteractionEnabled = YES;
        [self addSubview:self.wechatLabel];
        
        //3.
        self.descView = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImg.frame) + 13, CGRectGetMaxY(self.wechatLabel.frame) + 5, kScreenW - 10 - CGRectGetMinX(self.nameLabel.frame), height - 5 -  CGRectGetMaxY(self.nameLabel.frame) - 45)];
        self.descView.font = [UIFont systemFontOfSize:18];
        self.descView.userInteractionEnabled = NO;
        self.descView.textColor = color_TestGray;
        [self addSubview:self.descView];
        
    
        UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, height, kScreenW, 100)];
        buttonView.backgroundColor = [UIColor whiteColor];
        [self addSubview:buttonView];
        
        
    }
    return self;
}


- (void)setMainModel:(MainModel *)mainModel{
    _mainModel = mainModel;
    
    UIImage *img;
    UIColor *titleColor;
    
    if ([mainModel.gender isEqualToString:@"male"]) {
        img = [UIImage imageNamed:@"icon_man"];
        titleColor = color_maleBlue;
    }else{
        img = [UIImage imageNamed:@"icon_woman"];
        titleColor = color_femalePink;
    }
    
    
    self.iconImg.image = img;
    self.nameLabel.text = mainModel.title;
    self.nameLabel.textColor = titleColor;
    self.descView.text = mainModel.desc;
    self.wechatLabel.text = mainModel.wechat;

}

#pragma mark - public
- (void)showWithViewController:(UIViewController *)superViewController{
    CGFloat Bounciness = 11;    //振动幅度
    CGFloat speed = 9;     //动画速度
    if (kIsScreen5_5) {
        speed = 16;
    }
    
    CGFloat height = self.frame.size.height;
    POPSpringAnimation *anSpring_logo = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    anSpring_logo.toValue = @(kScreenH - height/2.f - 64);
    anSpring_logo.beginTime = CACurrentMediaTime();
    anSpring_logo.springBounciness = Bounciness;
    anSpring_logo.springSpeed = speed;
    [self pop_addAnimation:anSpring_logo forKey:@"position"];

    
    
    
    
//    [UIView animateWithDuration:0.2 animations:^{
//        CGFloat height = self.frame.size.height;
//        self.frame = CGRectMake(0, kScreenH - height - 64, kScreenW, height);
//    }];
}

- (void)dismisWithViewController:(UIViewController *)superViewController{
    [UIView animateWithDuration:0.2 animations:^{
        CGFloat height = self.frame.size.height;
        self.frame = CGRectMake(0, kScreenH - 64, kScreenW, height);
    }];
}

@end
