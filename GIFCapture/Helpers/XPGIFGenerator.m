//
//  XPGIFGenerator.m
//  GIFCapture
//
//  Created by nhope on 2017/4/13.
//  Copyright © 2017年 xiaopin. All rights reserved.
//

#import "XPGIFGenerator.h"
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>

@implementation XPGIFGenerator

/**
 将本地视频转成GIF图片
 
 @param videoURL 本地视频文件URL
 @param completionHandler 完成时的回调(转换成功时`gifURL`即为生成的GIF图片路径URL)
 */
+ (void)gifGeneratorWithVideoURL:(NSURL *)videoURL completionHandler:(void (^)(NSURL *))completionHandler {
    if (![videoURL isFileURL]) {
        if (nil != completionHandler) {
            completionHandler(nil);
        }
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
        AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
        imageGenerator.appliesPreferredTrackTransform = YES;
        imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
        imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
        
        CMTimeValue videoLength = asset.duration.value/asset.duration.timescale; // 视频总时长
        int frameRate = 10; // 帧率
        CMTimeValue frames = videoLength*frameRate; // 总帧数
        
        NSString *filepath = [NSString stringWithFormat:@"%@%@.gif", NSTemporaryDirectory(),[NSUUID UUID].UUIDString];
        NSURL *gifURL = [NSURL fileURLWithPath:filepath];
        
        CGImageDestinationRef destinationRef = CGImageDestinationCreateWithURL((__bridge CFURLRef)gifURL, kUTTypeGIF, frames, NULL);
        NSDictionary *properties = @{(__bridge NSString*)kCGImagePropertyGIFDictionary:
                                         @{(__bridge NSString*)kCGImagePropertyGIFLoopCount: @(0)}
                                     };
        CGImageDestinationSetProperties(destinationRef, (__bridge CFDictionaryRef)properties);
        
        NSDictionary *frameProperties = @{(__bridge NSString*)kCGImagePropertyGIFDictionary:
                                              @{(__bridge NSString*)kCGImagePropertyGIFDelayTime: @(0.2)},
                                            (__bridge NSString*)kCGImagePropertyColorModel:(NSString *)kCGImagePropertyColorModelRGB
                                          };
        
        // 获取每一帧的图片
        for (CMTimeValue i=0; i<frames; i++) {
            @autoreleasepool {
                NSError *error = nil;
                CMTime time = CMTimeMake(i, frameRate);
                CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:&error];
                if (nil != error) continue;
                CGImageDestinationAddImage(destinationRef, imageRef, (__bridge CFDictionaryRef)frameProperties);
                CGImageRelease(imageRef);
            }
        }
        
        bool succuess = CGImageDestinationFinalize(destinationRef);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (nil != completionHandler) {
                NSURL *url = succuess ? gifURL : nil;
                completionHandler(url);
            }
        });
    });
}

@end
