//
//  XPHomeViewController.m
//  GIFCapture
//
//  Created by nhope on 2017/3/28.
//  Copyright © 2017年 xiaopin. All rights reserved.
//

#import "XPHomeViewController.h"
#import "NSWindow+XP.h"
#import "XPScreenRecorder.h"
#import "XPGIFGenerator.h"

#define USER_NOTIFICATION_SAVE_URL_KEY  @"kSaveURLKey"

@interface XPHomeViewController ()<NSUserNotificationCenterDelegate>

@property (weak) IBOutlet NSBox *bottomBox;
@property (weak) IBOutlet NSTextField *widthTextField;
@property (weak) IBOutlet NSTextField *heightTextField;
@property (weak) IBOutlet NSBox *indicatorBox;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;
@property (nonatomic, strong) XPScreenRecorder *screenRecorder;
/// 是否正在生成GIF
@property (nonatomic, assign, getter=isGifGenerating) BOOL gifGenerating;

@end

@implementation XPHomeViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)viewDidLayout {
    [super viewDidLayout];
    NSRect recordRect = [self recordRect];
    self.widthTextField.stringValue = [NSString stringWithFormat:@"%.f", recordRect.size.width];
    self.heightTextField.stringValue = [NSString stringWithFormat:@"%.f", recordRect.size.height];
}

#pragma mark - <NSUserNotificationCenterDelegate>

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification {
    return YES;
}

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification {
    NSString *savePath = notification.userInfo[USER_NOTIFICATION_SAVE_URL_KEY];
    if (savePath.length) {
        NSURL *saveURL = [NSURL URLWithString:savePath];
        [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:@[saveURL]];
    }
}

#pragma mark - Actions

- (IBAction)controlButtonAction:(NSButton *)sender {
    if ([self isGifGenerating]) return;
    if (nil == _screenRecorder || ![_screenRecorder isRecording]) { // 开始录制
        sender.image = [NSImage imageNamed:@"stop"];
        sender.toolTip = NSLocalizedString(@"Stop Capture", nil);
        [self.view.window setEnableDrag:NO];
        
        if (nil == _screenRecorder) {
            _screenRecorder = [XPScreenRecorder screenRecorderWithRect:NSZeroRect];
            __weak __typeof(self) weakSelf = self;
            [_screenRecorder setDidFinishRecordingHandle:^(NSURL *outputFileURL) {
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                if (nil == strongSelf) return;
                NSSavePanel *panel = [[NSSavePanel alloc] init];
                panel.allowedFileTypes = @[@"gif"];
                panel.nameFieldStringValue = @"GIFCapture";
                panel.extensionHidden = NO;
                [panel beginSheetModalForWindow:strongSelf.view.window completionHandler:^(NSInteger result) {
                    if (result != NSFileHandlingPanelOKButton) return;
                    NSURL *saveURL = panel.URL;
                    [strongSelf setGifGenerating:YES];
                    [strongSelf.indicatorBox setHidden:NO];
                    [strongSelf.progressIndicator startAnimation:nil];
                    [strongSelf videoToGIFFromVideoURL:outputFileURL toURL:saveURL];
                }];
            }];
        }
        [_screenRecorder setRecordRect:[self recordRect]];
        [_screenRecorder startRecording];
    } else { // 结束录制
        sender.image = [NSImage imageNamed:@"start"];
        sender.toolTip = NSLocalizedString(@"Start Capture", nil);
        [self.view.window setEnableDrag:YES];
        [_screenRecorder stopRecording];
        _screenRecorder = nil;
    }
}

#pragma mark - Private

/// 屏幕录制区域
- (NSRect)recordRect {
    CGFloat borderWidth = self.view.layer.borderWidth;
    CGFloat bottomHeight = self.bottomBox.frame.size.height;
    NSRect windowFrame = self.view.window.frame;
    NSRect rect = NSMakeRect(windowFrame.origin.x+borderWidth,
                             windowFrame.origin.y+borderWidth+bottomHeight,
                             windowFrame.size.width-borderWidth*2,
                             windowFrame.size.height-borderWidth*2-bottomHeight-20.0
                             );
    return rect;
}

/// 将视频转成GIF
- (void)videoToGIFFromVideoURL:(NSURL *)videoURL toURL:(NSURL *)saveURL {
    __weak __typeof(self) weakSelf = self;
    [XPGIFGenerator gifGeneratorWithVideoURL:videoURL completionHandler:^(NSURL *gifURL) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (nil == strongSelf) return;
        // Save gif to target file
        NSData *data = [NSData dataWithContentsOfURL:gifURL];
        [data writeToURL:saveURL atomically:YES];
        // Remove temp file opes
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm removeItemAtURL:videoURL error:nil];
        [fm removeItemAtURL:gifURL error:nil];
        
        // Notification
        NSUserNotification *notification = [[NSUserNotification alloc] init];
        notification.title = @"GIF Capture";
        notification.informativeText = [saveURL.absoluteString lastPathComponent];
        notification.userInfo = @{USER_NOTIFICATION_SAVE_URL_KEY:saveURL.absoluteString};
        notification.hasActionButton = YES;
        notification.actionButtonTitle = NSLocalizedString(@"Open", nil);
        [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
        [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
        
        [strongSelf setGifGenerating:NO];
        [strongSelf.indicatorBox setHidden:YES];
        [strongSelf.progressIndicator stopAnimation:nil];
    }];
}

@end
