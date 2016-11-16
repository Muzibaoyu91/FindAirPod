//
//  FilterView.h
//  FindAirPod
//
//  Created by Baoyu on 16/9/12.
//  Copyright © 2016年 Baoy. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FilterViewDelegate <NSObject>

- (void)filtrateWithWhich:(NSString *)which withGender:(NSString *)gender;


@end

@interface FilterView : UIView

@property (nonatomic, weak) id<FilterViewDelegate> delegate;

@end
