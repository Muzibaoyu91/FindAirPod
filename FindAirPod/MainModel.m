//
//  MainModel.m
//  FindAirPod
//
//  Created by Baoyu on 16/9/9.
//  Copyright © 2016年 Baoy. All rights reserved.
//

#import "MainModel.h"

@implementation MainModel

+(JSONKeyMapper*)keyMapper{
    
    return  [[JSONKeyMapper alloc] initWithDictionary:@{
                                                        @"id":@"ID"
                                                        }];
}


+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    if ([propertyName isEqualToString: @"title"]) return YES;
    if ([propertyName isEqualToString: @"desc"]) return YES;
    if ([propertyName isEqualToString: @"which"]) return YES;
    if ([propertyName isEqualToString: @"gender"]) return YES;
    if ([propertyName isEqualToString: @"lat"]) return YES;
    if ([propertyName isEqualToString: @"lng"]) return YES;
    if ([propertyName isEqualToString: @"ID"]) return YES;
    if ([propertyName isEqualToString: @"wechat"]) return YES;
    return NO;
}


@end
