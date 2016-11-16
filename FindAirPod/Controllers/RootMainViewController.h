//
//  RootMainViewController.h
//  FindAirPod
//
//  Created by Baoyu on 16/9/9.
//  Copyright © 2016年 Baoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootMainViewController : UIViewController

@property (nonatomic, strong) UIButton *continueBtn;

@property (nonatomic, strong) NSMutableDictionary *demandDic;



- (void)addLeftBackButton;

- (void)addContinueButton;

- (void)changeContinueBtnCanUse:(BOOL)canUse;

- (void)rightContinueBtnAction:(UIButton *)btn;

- (void)addNSNotificationToKeyboard;

- (void)keyBoardHide;

-(void)keyBoard:(NSNotification*)noti;


@end
