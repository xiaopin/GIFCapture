//
//  XPWindowController.m
//  GIFCapture
//
//  Created by nhope on 2017/3/28.
//  Copyright © 2017年 xiaopin. All rights reserved.
//

#import "XPWindowController.h"
#import "NSWindow+XP.h"

@interface XPWindowController ()

@end

@implementation XPWindowController

#pragma mark - Lifecycle

- (void)windowDidLoad {
    [super windowDidLoad];
    
//    [self.window setTitleVisibility:NSWindowTitleHidden];
    [self.window setOpaque:NO];
    [self.window setBackgroundColor:[NSColor clearColor]];
    [self.window setEnableDrag:YES];
    [self.window.contentView setWantsLayer:YES];
    [self.window.contentView.layer setBorderWidth:4.0];
    NSColor *color = [NSColor colorWithRed:255/255.0
                                     green:66/255.0
                                      blue:0.0
                                     alpha:1.0];
    [self.window.contentView.layer setBorderColor:color.CGColor];
    
    // 修改标题栏的背景色
    [self.window setTitlebarAppearsTransparent:YES];
    NSView *titleView = [[self.window standardWindowButton:NSWindowCloseButton] superview];
    [titleView setWantsLayer:YES];
    [titleView.layer setBackgroundColor:color.CGColor];
}

@end
