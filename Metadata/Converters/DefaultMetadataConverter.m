//
//  DefaultMetadataConverter.m
//  MetaDemo
//
//  Created by sunyazhou on 2017/7/31.
//  Copyright © 2017年 Baidu, Inc. All rights reserved.
//

#import "DefaultMetadataConverter.h"

@implementation DefaultMetadataConverter

- (id)displayValueFromMetadataItem:(AVMetadataItem *)item {
    return item.value;
}

- (AVMetadataItem *)metadataItemFromDisplayValue:(id)value
                                withMetadataItem:(AVMetadataItem *)item {
    
    AVMutableMetadataItem *metadataItem = [item mutableCopy];
    metadataItem.value = value;
    return metadataItem;
}
@end
