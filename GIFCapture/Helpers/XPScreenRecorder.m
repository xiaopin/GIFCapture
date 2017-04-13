//
//  XPScreenRecorder.m
//  GIFCapture
//
//  Created by nhope on 2017/3/29.
//  Copyright © 2017年 xiaopin. All rights reserved.
//

#import "XPScreenRecorder.h"
#import <AVFoundation/AVFoundation.h>


@interface XPScreenRecorder ()<AVCaptureFileOutputRecordingDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureScreenInput *input;
@property (nonatomic, strong) AVCaptureMovieFileOutput *output;
@property (nonatomic, assign) BOOL recording;

@end


@implementation XPScreenRecorder

#pragma mark - Lifecycle

+ (instancetype)screenRecorderWithRect:(NSRect)rect {
    XPScreenRecorder *recorder = [[self alloc] init];
    recorder.input.cropRect = rect;
    return recorder;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _session = [[AVCaptureSession alloc] init];
        _session.sessionPreset = AVCaptureSessionPresetHigh;
        
        _input = [[AVCaptureScreenInput alloc] initWithDisplayID:CGMainDisplayID()];
        _input.capturesMouseClicks = YES;
        [_session addInput:_input];
        
        _output = [[AVCaptureMovieFileOutput alloc] init];
        [_session addOutput:_output];
    }
    return self;
}

#pragma mark - <AVCaptureFileOutputRecordingDelegate>

/// 开始录制的回调
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections {
    
}

/// 暂停录制的回调
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didPauseRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections {
    
}

/// 从暂停录制恢复到录制状态的回调
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didResumeRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections {
    
}

/// 即将结束录制的回调
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput willFinishRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    
}

/// 结束录制的回调
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    if (nil != self.didFinishRecordingHandle) {
        self.didFinishRecordingHandle(outputFileURL);
    }
}

#pragma mark - Public

- (void)startRecording {
    NSString *path = [[NSTemporaryDirectory() stringByAppendingPathComponent:[NSUUID UUID].UUIDString] stringByAppendingPathExtension:@"mov"];
    NSURL *url = [NSURL fileURLWithPath:path];
    [_session startRunning];
    [_output startRecordingToOutputFileURL:url recordingDelegate:self];
    _recording = YES;
}

- (void)stopRecording {
    [_output stopRecording];
    [_session stopRunning];
    _recording = NO;
}

- (BOOL)isRecording {
    return _recording;
}

- (void)setRecordRect:(NSRect)rect {
    _input.cropRect = rect;
}

@end
