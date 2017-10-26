//
//  MediaItem.h
//  MetaDemo
//
//  Created by sunyazhou on 2017/7/10.
//  Copyright © 2017年 Baidu, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "MetaData.h"
typedef void(^CompletionHandler)(BOOL complete);
@interface MediaItem : NSObject
@property (strong, readonly) NSString *filename;
@property (strong, readonly) NSString *filetype;
@property (strong, readonly) MetaData *metadata;
@property (readonly, getter = isEditable) BOOL editable;


/**
 通过 URL 构建

 @param url url
 @return 实例
 */
- (instancetype)initWithURL:(NSURL *)url;


/**
 通过 AVAsset 构建

 @param asset AVAsset
 @return 实例
 */
- (instancetype)initWithAVAsset:(AVAsset *)asset;
/**
 此方法完成之后如果成功即可取metadata

 @param handler 回调 block
 */
- (void)prepareWithCompletionHandler:(CompletionHandler)handler;
- (void)saveWithCompletionHandler:(CompletionHandler)handler;
@end
