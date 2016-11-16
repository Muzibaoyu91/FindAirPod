//
//  NSString+Instask.m
//  Instask_objC
//
//  Created by Baoyu on 16/7/5.
//  Copyright © 2016年 Instask.Me. All rights reserved.
//

#import "NSString+Instask.h"



@implementation NSString (Instask)


/**
 *  计算文本占用的宽高
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dic =
    @{
      NSFontAttributeName:font
      };
    CGSize labelSize = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;

    return labelSize;
}


- (BOOL)hasIn2DecimalPlaces{
    if ([self rangeOfString:@"."].location == NSNotFound) {
        return YES;
    }
    
    
    NSArray *subArray = [self componentsSeparatedByString:@"."];
    if (subArray.count >2) {
        return NO;
    }
    
    
    NSString *lastStr = subArray.lastObject;
    if (lastStr.length >2) {
        return NO;
    }
    return YES;
    
}

- (NSString *)removeLastBlack{
    NSString *outString = [NSString stringWithString:self];
    
    
    while ([outString hasSuffix:@" "]) {
        outString = [outString substringToIndex:outString.length -1];
    }
    
    return outString;
}


- (NSString *)urlencode {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    int sourceLen = (int)strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

- (BOOL)isAllNum{
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    int i = 0;
    while (i < self.length) {
        NSString * string = [self substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;

}


@end
