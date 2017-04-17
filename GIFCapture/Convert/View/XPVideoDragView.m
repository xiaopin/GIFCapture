//
//  XPVideoDragView.m
//  GIFCapture
//
//  Created by nhope on 2017/4/17.
//  Copyright © 2017年 xiaopin. All rights reserved.
//

#import "XPVideoDragView.h"

@implementation XPVideoDragView

#pragma mark - Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    [self registerForDraggedTypes:@[NSFilenamesPboardType]];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

#pragma mark - <NSDraggingDestination>

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    NSPasteboard *pasteboard = [sender draggingPasteboard];
    if ([pasteboard.types containsObject:NSFilenamesPboardType]) {
        NSArray<NSString *> *files = [pasteboard propertyListForType:NSFilenamesPboardType];
        if (1 == files.count) { // 只支持单文件拖拽,不支持多文件拖拽
            NSString *videoFilename = [[files firstObject] lastPathComponent];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES[cd] %@", @"^.+\\.(mov|mp4|avi|rmvb)$"];
            BOOL isVideo = [predicate evaluateWithObject:videoFilename];
            if (isVideo) {
                return NSDragOperationCopy;
            }
        }
    }
    // None表示不支持拖拽
    return NSDragOperationNone;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender {
    return YES;
}

- (void)concludeDragOperation:(id<NSDraggingInfo>)sender {
    if (nil != _didDraggingVideoFile) {
        NSPasteboard *pasteboard = [sender draggingPasteboard];
        NSArray<NSString *> *files = [pasteboard propertyListForType:NSFilenamesPboardType];
        NSString *videoPath = [files firstObject];
        NSURL *videoURL = [NSURL fileURLWithPath:videoPath];
        _didDraggingVideoFile(videoURL);
    }
}

@end
