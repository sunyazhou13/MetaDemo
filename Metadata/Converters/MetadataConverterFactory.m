//
//  MetadataConverterFactory.m
//  MetaDemo
//
//  Created by sunyazhou on 2017/7/31.
//  Copyright © 2017年 Baidu, Inc. All rights reserved.
//

#import "MetadataConverterFactory.h"

#import "ArtworkMetadataConverter.h"
#import "CommentMetadataConverter.h"
#import "DiscMetadataConverter.h"
#import "GenreMetadataConverter.h"
#import "TrackMetadataConverter.h"

#import "MetadataDefines.h"

@implementation MetadataConverterFactory
- (id <MetadataConverter>)converterForKey:(NSString *)key{
    id <MetadataConverter> converter = nil;
    
    if ([key isEqualToString:MetadataKeyArtwork]) {
        converter = [[ArtworkMetadataConverter alloc] init];
    }
    else if ([key isEqualToString:MetadataKeyTrackNumber]) {
        converter = [[TrackMetadataConverter alloc] init];
    }
    else if ([key isEqualToString:MetadataKeyDiscNumber]) {
        converter = [[DiscMetadataConverter alloc] init];
    }
    else if ([key isEqualToString:MetadataKeyComments]) {
        converter = [[CommentMetadataConverter alloc] init];
    }
    else if ([key isEqualToString:MetadataKeyGenre]) {
        converter = [[GenreMetadataConverter alloc] init];
    }
    else {
        converter = [[DefaultMetadataConverter alloc] init];
    }
    
    return converter;
}
@end
