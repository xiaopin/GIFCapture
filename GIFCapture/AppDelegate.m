//
//  AppDelegate.m
//  GIFCapture
//
//  Created by nhope on 2017/3/28.
//  Copyright © 2017年 xiaopin. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

/// 应用主窗口控制器
@property (nonatomic, strong) NSWindowController *mainWindowController;
/// 将视频转GIF的窗口控制器
@property (nonatomic, strong) NSWindowController *convertWindowController;

@end

@implementation AppDelegate

#pragma mark - NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    self.mainWindowController = [NSApplication sharedApplication].keyWindow.windowController;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag {
    if (nil != self.mainWindowController) {
        [self.mainWindowController showWindow:self];
    }
    return YES;
}

#pragma mark - Actions

- (IBAction)convertMenuAction:(NSMenuItem *)sender {
    if (nil == self.convertWindowController) {
        NSStoryboard *storyboard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
        self.convertWindowController = [storyboard instantiateControllerWithIdentifier:@"ConvertWindowController"];
    }
    [self.convertWindowController showWindow:self];
}


@end
