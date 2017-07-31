//
//  MetadataConverter.h
//  MetaDemo
//
//  Created by sunyazhou on 2017/7/31.
//  Copyright © 2017年 Baidu, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol MetadataConverter <NSObject>

@optional

/**
 AVMetadataItem to Model 转换 用于UI显示的model

 @param item AVMetadataItem
 @return model
 */
- (id)displayValueFromMetadataItem:(AVMetadataItem *)item;


/**
 AVMetadataItem映射通用字段
 
 @param value 通过媒体元数据取出的某个key的value
 @param item AVMetadataItem
 @return AVMetadataItem
 */
- (AVMetadataItem *)metadataItemFromDisplayValue:(id)value
                                withMetadataItem:(AVMetadataItem *)item;
@end
