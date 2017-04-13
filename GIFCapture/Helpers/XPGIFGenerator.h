//
//  XPGIFGenerator.h
//  GIFCapture
//
//  Created by nhope on 2017/4/13.
//  Copyright © 2017年 xiaopin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XPGIFGenerator : NSObject

/**
 将本地视频转成GIF图片

 @param videoURL 本地视频文件URL
 @param completionHandler 完成时的回调(转换成功时`gifURL`即为生成的GIF图片路径URL)
 */
+ (void)gifGeneratorWithVideoURL:(NSURL *)videoURL completionHandler:(void(^)(NSURL *gifURL))completionHandler;

@end
