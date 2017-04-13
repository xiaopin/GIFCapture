//
//  NSWindow+XP.h
//  GIFCapture
//
//  Created by nhope on 2017/3/28.
//  Copyright © 2017年 xiaopin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSWindow (XP)

/**
 是否开启拖拽功能

 @param enable YES/NO
 */
- (void)setEnableDrag:(BOOL)enable;

@end
