//
//  BaoyAnnotation.h
//  MapDemo
//
//  Created by Baoyu on 16/9/8.
//  Copyright © 2016年 Baoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "MainModel.h"


@interface BaoyAnnotation : NSObject<MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;


#pragma mark 自定义一个图片属性在创建大头针视图时使用
@property (nonatomic,strong) UIImage *image;

// 信息model
@property (nonatomic ,strong) MainModel *mainModel;

@end
