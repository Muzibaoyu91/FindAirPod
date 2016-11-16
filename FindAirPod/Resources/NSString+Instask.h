//
//  NSString+Instask.h
//  Instask_objC
//
//  Created by Baoyu on 16/7/5.
//  Copyright © 2016年 Instask.Me. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define NULLString(string) ([string isEqualToString:@""] || (string == nil) || [string isEqualToString:@""] || [string isKindOfClass:[NSNull class]]) //    判断字符串是不是为空，如果为空返回YES

@interface NSString (Instask)

/**
 *  计算文本占用的宽高
 *
 *  @param font    显示的字体
 *  @param maxSize 最大的显示范围
 *
 *  @return 占用的宽高
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;


/**
 *  两位小数范围内的数字
 *
 *  @return 
 */
- (BOOL)hasIn2DecimalPlaces;


/**
 *  判断字符串是否为数字
 *
 *  @return 数字返回YES
 */
- (BOOL)isAllNum;


- (NSString *)removeLastBlack;

- (NSString *)urlencode;

@end
