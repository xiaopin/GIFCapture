//
//  XPConvertViewController.m
//  GIFCapture
//
//  Created by nhope on 2017/4/14.
//  Copyright © 2017年 xiaopin. All rights reserved.
//

#import "XPConvertViewController.h"
#import "XPGIFGenerator.h"

@interface XPConvertViewController ()

@property (weak) IBOutlet NSTextField *videoTextField;
@property (weak) IBOutlet NSTextField *savepathTextField;
/// 需要转换的视频URL
@property (nonatomic, strong) NSURL *videoURL;
/// 生成的GIF保存URL
@property (nonatomic, strong) NSURL *gifURL;

@end

@implementation XPConvertViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

#pragma mark - Actions

/// 选择视频
- (IBAction)videoSourceButtonAction:(NSButton *)sender {
    NSOpenPanel *panel = [[NSOpenPanel alloc] init];
    panel.canChooseFiles = YES;
    panel.canChooseDirectories = NO;
    panel.allowsMultipleSelection = NO;
    panel.showsHiddenFiles = YES;
    panel.allowedFileTypes = @[@"mov",@"mp4",@"avi",@"rmvb"];
    __weak __typeof(self) weakSelf = self;
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
        if (result != NSFileHandlingPanelOKButton) return;
        weakSelf.videoTextField.stringValue = [panel.URL path];
        weakSelf.videoURL = panel.URL;
    }];
}

/// 选择保存目录
- (IBAction)saveTargetButtonAction:(NSButton *)sender {
    NSSavePanel *panel = [[NSSavePanel alloc] init];
    panel.allowedFileTypes = @[@"gif"];
    panel.nameFieldStringValue = @"Video2GIF";
    panel.extensionHidden = NO;
    __weak __typeof(self) weakSelf = self;
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
        if (result != NSFileHandlingPanelOKButton) return;
        weakSelf.savepathTextField.stringValue = [panel.URL path];
        weakSelf.gifURL = panel.URL;
    }];
}

/// 视频转GIF
- (IBAction)convertButtonAction:(NSButton *)sender {
    if (nil == self.videoURL || nil == self.gifURL) {
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = NSLocalizedString(@"No video source is selected or no save path is selected", nil);
        [alert beginSheetModalForWindow:self.view.window completionHandler:nil];
        return;
    }
    
    // 显示菊花HUD
    [self.view.window endEditingFor:nil];
    NSPanel *hudPanel = [[NSPanel alloc] init];
    hudPanel.styleMask = NSWindowStyleMaskNonactivatingPanel;
    [hudPanel setFrame:NSMakeRect(0.0, 0.0, 200.0, 200.0) display:YES];
    NSProgressIndicator *indicator = [[NSProgressIndicator alloc] init];
    indicator.frame = NSMakeRect(85.0, 85.0, 30.0, 30.0);
    indicator.style = NSProgressIndicatorSpinningStyle;
    indicator.controlSize = NSControlSizeRegular;
    [indicator startAnimation:nil];
    [hudPanel.contentView addSubview:indicator];
    [self.view.window beginSheet:hudPanel completionHandler:nil];
    
    // 将视频转成GIF
    __weak __typeof(self) weakSelf = self;
    [XPGIFGenerator gifGeneratorWithVideoURL:self.videoURL completionHandler:^(NSURL *gifURL) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (nil == strongSelf) return;
        NSData *data = [NSData dataWithContentsOfURL:gifURL];
        [data writeToURL:strongSelf.gifURL atomically:YES];
        [[NSFileManager defaultManager] removeItemAtURL:gifURL error:nil];
        [strongSelf.view.window endSheet:hudPanel];
    }];
}

@end
