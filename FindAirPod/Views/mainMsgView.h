//
//  mainMsgView.h
//  FindAirPod
//
//  Created by Baoyu on 16/9/9.
//  Copyright © 2016年 Baoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol mainMsgViewDelegate <NSObject>


@end

@class MainModel;

@interface mainMsgView : UIView

@property (nonatomic, strong) MainModel *mainModel;

@property (nonatomic, weak) id<mainMsgViewDelegate> delegate;

- (void)showWithViewController:(UIViewController *)superViewController;

- (void)dismisWithViewController:(UIViewController *)superViewController;

@end
