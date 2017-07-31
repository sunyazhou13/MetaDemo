//
//  MetadataConverterFactory.h
//  MetaDemo
//
//  Created by sunyazhou on 2017/7/31.
//  Copyright © 2017年 Baidu, Inc. All rights reserved.
//

#import "DefaultMetadataConverter.h"
#import "MetadataConverter.h"

@interface MetadataConverterFactory : DefaultMetadataConverter

- (id <MetadataConverter>)converterForKey:(NSString *)key;

@end
