//
//  XPScreenRecorder.h
//  GIFCapture
//
//  Created by nhope on 2017/3/29.
//  Copyright © 2017年 xiaopin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XPScreenRecorder : NSObject

/**
 完成录制的回调
 outputFileURL 录制的视频存放的URL
 */
@property (nonatomic, copy) void(^didFinishRecordingHandle)(NSURL *outputFileURL);

/**
 实例化屏幕录制机

 @param rect 录制的区域
 @return XPScreenRecorder
 */
+ (instancetype)screenRecorderWithRect:(NSRect)rect;

/**
 设置录制区域

 @param rect 目标区域坐标
 */
- (void)setRecordRect:(NSRect)rect;
/**
 开始录制
 */
- (void)startRecording;
/**
 结束录制
 */
- (void)stopRecording;
/**
 是否正在录制

 @return YES:正在录制 NO:已结束录制/暂停录制
 */
- (BOOL)isRecording;


- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end
