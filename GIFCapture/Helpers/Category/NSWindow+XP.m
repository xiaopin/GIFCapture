//
//  NSWindow+XP.m
//  GIFCapture
//
//  Created by nhope on 2017/3/28.
//  Copyright © 2017年 xiaopin. All rights reserved.
//

#import "NSWindow+XP.h"
#import <objc/runtime.h>

@implementation NSWindow (XP)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalMethod = class_getInstanceMethod([NSWindow class], @selector(maxFullScreenContentSize));
        Method swizzledMethod = class_getInstanceMethod([NSWindow class], @selector(xp_maxFullScreenContentSize));
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

/**
 返回全屏时的最大尺寸

 @return 最大尺寸为屏幕的可视区域(不包含Dock栏和菜单栏)
 */
- (NSSize)xp_maxFullScreenContentSize {
    CGSize maxSize = [NSScreen mainScreen].visibleFrame.size;
    return maxSize;
}

/**
 是否开启拖拽功能
 
 @param enable YES/NO
 */
- (void)setEnableDrag:(BOOL)enable {
    if (enable) {
        self.styleMask |= NSWindowStyleMaskResizable;
    } else {
        self.styleMask = self.styleMask & ~NSWindowStyleMaskResizable;
    }
    [self setRestorable:enable];
    [self setMovable:enable];
    [self setMovableByWindowBackground:enable];
    [self setLevel:CGWindowLevelForKey(enable?kCGNormalWindowLevelKey:kCGFloatingWindowLevelKey)];
}

@end
