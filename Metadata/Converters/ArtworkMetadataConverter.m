//
//  ArtworkMetadataConverter.m
//  MetaDemo
//
//  Created by sunyazhou on 2017/7/31.
//  Copyright © 2017年 Baidu, Inc. All rights reserved.
//

#import "ArtworkMetadataConverter.h"

@implementation ArtworkMetadataConverter
- (id)displayValueFromMetadataItem:(AVMetadataItem *)item {
    UIImage *image = nil;
    if ([item.value isKindOfClass:[NSData class]]) {                        // 1
        image = [[UIImage alloc] initWithData:item.dataValue];
    }
    else if ([item.value isKindOfClass:[NSDictionary class]]) {             // 2
        NSDictionary *dict = (NSDictionary *)item.value;
        image = [[UIImage alloc] initWithData:dict[@"data"]];
    }
    return image;
}

- (AVMetadataItem *)metadataItemFromDisplayValue:(id)value
                                withMetadataItem:(AVMetadataItem *)item {
    
    AVMutableMetadataItem *metadataItem = [item mutableCopy];
    
    UIImage *image = (UIImage *)value;
    metadataItem.value = UIImagePNGRepresentation(image);                          // 3
    
    return metadataItem;
}
@end
