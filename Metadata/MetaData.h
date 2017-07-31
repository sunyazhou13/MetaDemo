//
//  MetaData.h
//  MetaDemo
//
//  Created by sunyazhou on 2017/7/31.
//  Copyright © 2017年 Baidu, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class Genre; //风格  eg: 蓝调、 古典 ....

@interface MetaData : NSObject
@property (copy) NSString *name;
@property (copy) NSString *artist;
@property (copy) NSString *albumArtist;
@property (copy) NSString *album;
@property (copy) NSString *grouping;
@property (copy) NSString *composer;
@property (copy) NSString *comments;
@property (strong) UIImage *artwork;
@property (strong) Genre *genre;

@property NSString *year;
@property NSNumber *bpm;
@property NSNumber *trackNumber;
@property NSNumber *trackCount;
@property NSNumber *discNumber;
@property NSNumber *discCount;

- (void)addMetadataItem:(AVMetadataItem *)item withKey:(id)key;

- (NSArray *)metadataItems;
@end
