//
//  UIViewController+HUDManager.h
//  Instask_objC
//
//  Created by Baoyu on 16/8/10.
//  Copyright © 2016年 Instask.Me. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBProgressHUD;

@interface UIViewController (HUDManager)

- (void)showHUDWithTitle:(NSString *)title;

- (void)showErrorHUDWithTitle:(NSString *)title;

- (void)showSuccessHUDWithTitle:(NSString *)title;

- (void)showHUDWithTitle:(NSString *)title withContent:(NSString *)content;

- (MBProgressHUD *)creatLoadingHUD;

- (MBProgressHUD *)creatLoadingHUDWithTitle:(NSString *)title;



@end
