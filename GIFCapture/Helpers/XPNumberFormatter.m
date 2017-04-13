//
//  XPNumberFormatter.m
//  GIFCapture
//
//  Created by nhope on 2017/4/13.
//  Copyright © 2017年 xiaopin. All rights reserved.
//

#import "XPNumberFormatter.h"

@implementation XPNumberFormatter

/// 限制只允许输入数字且最大不超过4位数
- (BOOL)isPartialStringValid:(NSString *)partialString newEditingString:(NSString *__autoreleasing  _Nullable *)newString errorDescription:(NSString *__autoreleasing  _Nullable *)error {
    if (0 == partialString.length) {
        return YES;
    }
    if (4 < partialString.length) {
        return NO;
    }
    NSString *regexp = @"^\\d*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexp];
    return [predicate evaluateWithObject:partialString];
}

@end
