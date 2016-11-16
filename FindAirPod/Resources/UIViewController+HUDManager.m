//
//  UIViewController+HUDManager.m
//  Instask_objC
//
//  Created by Baoyu on 16/8/10.
//  Copyright © 2016年 Instask.Me. All rights reserved.
//

#import "UIViewController+HUDManager.h"


@implementation UIViewController (HUDManager)

- (void)showHUDWithTitle:(NSString *)title{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    
    hud.color = color_UneditWhite;
    
    hud.labelColor = [UIColor blackColor];
    
    hud.labelText = title;
    
    [hud hide:YES afterDelay:2.f];
    
    
}

- (void)showErrorHUDWithTitle:(NSString *)title{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Set the custom view mode to show any view.
    hud.mode = MBProgressHUDModeCustomView;
    // Set an image view with a checkmark.
    UIImage *image = [UIImage imageNamed:@"hudError"];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    
    hud.color = color_UneditWhite;
    
    hud.labelColor = [UIColor blackColor];

    
    hud.labelText = title;
    
    [hud hide:YES afterDelay:1.5f];
    
    
}

- (void)showSuccessHUDWithTitle:(NSString *)title{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Set the custom view mode to show any view.
    hud.mode = MBProgressHUDModeCustomView;
    // Set an image view with a checkmark.
    UIImage *image = [UIImage imageNamed:@"Checkmark"];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    
    hud.color = color_UneditWhite;
    
    hud.labelColor = [UIColor blackColor];
    
    
    hud.labelText = title;
    
    [hud hide:YES afterDelay:1.5f];
    
}

- (void)showHUDWithTitle:(NSString *)title withContent:(NSString *)content{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    
    hud.color = color_UneditWhite;
    
    hud.labelColor = [UIColor blackColor];
    
    hud.labelText = title;
    
    hud.detailsLabelColor = [UIColor blackColor];
    
    hud.detailsLabelText = content;
    
    [hud hide:YES afterDelay:2.f];
}


- (MBProgressHUD *)creatLoadingHUD{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    hud.color = color_UneditWhite;
    
    hud.activityIndicatorColor = [UIColor blackColor];
    
    return hud;
}

- (MBProgressHUD *)creatLoadingHUDWithTitle:(NSString *)title{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    hud.color = color_UneditWhite;

    hud.activityIndicatorColor = [UIColor blackColor];

    
    hud.labelColor = [UIColor blackColor];
    
    
    hud.labelText = title;
    
    return hud;
}

@end
