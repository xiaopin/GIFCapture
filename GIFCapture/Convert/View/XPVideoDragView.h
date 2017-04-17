//
//  XPVideoDragView.h
//  GIFCapture
//
//  Created by nhope on 2017/4/17.
//  Copyright © 2017年 xiaopin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface XPVideoDragView : NSView<NSDraggingDestination>

/// 视频文件拖拽完成的回调
@property (nonatomic, copy) void(^didDraggingVideoFile)(NSURL *videoURL);

@end
