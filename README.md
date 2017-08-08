# [博客地址](http://www.sunyazhou.com/2017/08/07/Learning-AV-Foundation-AVAsset-Senior/)
---
title: Learning AV Foundation(四)AVAsset元数据(高级篇)
categories: iOS开发
tags:
  - iOS开发
  - macOS开发
  - Learning AV Foundation
date: 2017-08-07 20:36:46
---

![](https://raw.githubusercontent.com/sunyazhou13/sunyazhou13.github.io-images/684038b04b8ff1f2ed00e9b76f8bd02e8e243726/Learning-AV-Foundation-AVAsset-Senior3.2/audio-artwork.jpg)

# 前言

先上图 

![](https://raw.githubusercontent.com/sunyazhou13/sunyazhou13.github.io-images/master/Learning-AV-Foundation-AVAsset-Senior3.2/metadata.gif)

这一篇 **我们将学习解决如何一套代码解析大部分 多媒体格式的文件然后形成通用的 model - 元数据键值空间标准化**

## 内容介绍

结构图
![](https://raw.githubusercontent.com/sunyazhou13/sunyazhou13.github.io-images/master/Learning-AV-Foundation-AVAsset-Senior3.2/MetaDataModel.png)
 
--- 

class 代码 

* __MediaItem (一个直接对外的接口)__
* __MetaData (元数据model)__
* __Genre (风格)__
* __AVMetadataItem+Additions__
* __MetadataDefines__
* __MetadataKit__
* __Converters (文件夹包含如下:)__
	* __MetadataConverter  (Protocol 存取 `AVMetadataItem`)__
	* __MetadataConverterFactory__
	* __DefaultMetadataConverter__
	* __ArtworkMetadataConverter__
	* __CommentMetadataConverter__
	* __TrackMetadataConverter__
	* __DiscMetadataConverter__
	* __GenreMetadataConverter__

---

 



### MediaItem 使用

这个类主要对外直接暴露接口 如下代码即可调用使用

``` objc
        __weak typeof(self) weakSelf = self;
        MediaItem *item = [[MediaItem alloc] initWithURL:self.url];
        [item prepareWithCompletionHandler:^(BOOL complete) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf refreshDataByItem:item];
            NSLog(@"%@",[item modelDescription]);
        }];
        
``` 

代码实现部分

``` objc
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "MetaData.h"
typedef void(^CompletionHandler)(BOOL complete);
@interface MediaItem : NSObject
@property (strong, readonly) NSString *filename;
@property (strong, readonly) NSString *filetype;
@property (strong, readonly) MetaData *metadata;
@property (readonly, getter = isEditable) BOOL editable;
- (id)initWithURL:(NSURL *)url;
/**
 此方法完成之后如果成功即可取metadata

 @param handler 回调 block
 */
- (void)prepareWithCompletionHandler:(CompletionHandler)handler;
- (void)saveWithCompletionHandler:(CompletionHandler)handler;
@end
@end
```

`.m`可参考源码 比较多就不赘述了

当 block 完成时使用 
目前支持获取元数据信息的媒体格式如下:  

* m4a
* mov
* mp4
* mp3

> 注意:_**mp3文件是不可编辑的文件故而不能进行编辑 比如改变歌手名称之类 如果要编辑可使用其它专业软件尝试**_  

我尝试了 mac 版本的 demo 编辑 文件 是 OK 的 但是在 iOS 上 我更改其它格式也没能保存成功 如果你看到有解决办法 可以留言给我或者发邮件给我 非常感谢.

### MetaData

``` objc
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
@property id bpm;
@property NSNumber *trackNumber;
@property NSNumber *trackCount;
@property NSNumber *discNumber;
@property NSNumber *discCount;
- (void)addMetadataItem:(AVMetadataItem *)item withKey:(id)key;
- (NSArray *)metadataItems;
@end


```
看到上边的代码估计你也猜到了 这就是我们需要的 比如 mp3文件解析出来的真正 model  

这里东西比较多 有些值有可能没有 请自行做好 check

### MetadataConverter
这个协议是为了支持所有多媒体文件统一解析使用,比如:mp3文件和mp4文件两个是不一样的文件格式,虽然里面有很多相同的key,但是肯定数据结构是不一样的,这样就要求,搞一个统一的协议,比如输入的是一个URL返回一个 model那么为了解决key value参差不齐问题 就搞了这个协议.

``` objc
@protocol zh <NSObject>
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
```



### MetadataConverterFactory

这个类用于统一输出遵守`MetadataConverter`协议的model并且找到适当的转换器去转换响应的格式

``` objc
@interface MetadataConverterFactory : DefaultMetadataConverter
- (id <MetadataConverter>)converterForKey:(NSString *)key;
@end

@implementation MetadataConverterFactory
- (id <MetadataConverter>)converterForKey:(NSString *)key{
    id <MetadataConverter> converter = nil;
    if ([key isEqualToString:MetadataKeyArtwork]) {
        converter = [[ArtworkMetadataConverter alloc] init];
    } else if ([key isEqualToString:MetadataKeyTrackNumber]) {
        converter = [[TrackMetadataConverter alloc] init];
    } else if ([key isEqualToString:MetadataKeyDiscNumber]) {
        converter = [[DiscMetadataConverter alloc] init];
    } else if ([key isEqualToString:MetadataKeyComments]) {
        converter = [[CommentMetadataConverter alloc] init];
    } else if ([key isEqualToString:MetadataKeyGenre]) {
        converter = [[GenreMetadataConverter alloc] init];
    } else {
        converter = [[DefaultMetadataConverter alloc] init];
    }
    return converter;
}
@end
```


### DefaultMetadataConverter

简单实现`MetadataConverter`协议


``` objc
@interface DefaultMetadataConverter : NSObject <MetadataConverter>

@end

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


```


### ArtworkMetadataConverter
实现`MetadataConverter`协议 取出专辑封面

此处省略 .h 文件只贴出.m ( .h里面啥也没有 大家可参考 demo)

``` objc
@implementation ArtworkMetadataConverter
- (id)displayValueFromMetadataItem:(AVMetadataItem *)item {
    UIImage *image = nil;  //下面是核心代码取出图片 
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

```

这里 mp3 (id3v2格式）取图片的方式可能有不一样的地方 1出判断 属于哪种格式 3处把 UIImage 转 NSData 再放回去

需要注意一个地方是 返回`AVMetadataItem`的类型
由于`AV Foundation`无法写入 ID3元数据 所以这里使用了 `AVMutableMetadataItem`来存储封面图

`AVMutableMetadataItem` 是 `AVMetadataItem`的子类

### CommentMetadataConverter 注释转换

``` objc
@implementation CommentMetadataConverter

- (id)displayValueFromMetadataItem:(AVMetadataItem *)item {
    
    NSString *value = nil;
    if ([item.value isKindOfClass:[NSString class]]) {                      // 1
        value = item.stringValue;
    }
    else if ([item.value isKindOfClass:[NSDictionary class]]) {             // 2
        NSDictionary *dict = (NSDictionary *) item.value;
        if ([dict[@"identifier"] isEqualToString:@""]) {
            value = dict[@"text"];
        }
    }
    return value;
}

- (AVMetadataItem *)metadataItemFromDisplayValue:(id)value
                                withMetadataItem:(AVMetadataItem *)item {
    
    AVMutableMetadataItem *metadataItem = [item mutableCopy];               // 3
    metadataItem.value = value;
    return metadataItem;
}
@end
```

1. `MPEG-4`和`QuickTime`媒体的 value 为 `NSString`  
2. `MP3`的注释保存在一个定义`ID3 COMM帧`的`NSDictionary`中(如果处理的是`ID3V2.2`,则为`COM`),所有类型的值都保存在这个帧中. eg： iTune 在这个帧中保存音频标准化和无缝播放设置等,意味着当请求 `ID3`元数据时需要多接收多个`COMM帧`.包含实际注释内容的特定`COMM帧`被存储在一个带有空字符串标识的帧中.找到需要的条目后 通过请求`text` key 来检索出注释内容

#### TrackMetadataConverter 音轨数据转换

音轨: 通常包含一首歌曲在整个唱片中的编号位置信息(eg: 12首歌中的第4首  4/12)等信息.

``` objc
@implementation TrackMetadataConverter
- (id)displayValueFromMetadataItem:(AVMetadataItem *)item {
    
    NSNumber *number = nil;
    NSNumber *count = nil;
    
    if ([item.value isKindOfClass:[NSString class]]) {                      // 1
        NSArray *components =
        [item.stringValue componentsSeparatedByString:@"/"];
        if (components.count > 0) {
            number = @([components[0] integerValue]);
        }
        if (components.count > 1) {
            count = @([components[1] integerValue]);
        }
    }
    else if ([item.value isKindOfClass:[NSData class]]) {                   // 2
        NSData *data = item.dataValue;
        if (data.length == 8) {
            uint16_t *values = (uint16_t *) [data bytes];
            if (values[1] > 0) {
                number = @(CFSwapInt16BigToHost(values[1]));                // 3
            }
            if (values[2] > 0) {
                count = @(CFSwapInt16BigToHost(values[2]));                 // 4
            }
        }
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];           // 5
    [dict setObject:number ?: [NSNull null] forKey:MetadataKeyTrackNumber];
    [dict setObject:count ?: [NSNull null] forKey:MetadataKeyTrackCount];
    
    return dict;
}
- (AVMetadataItem *)metadataItemFromDisplayValue:(id)value
                                withMetadataItem:(AVMetadataItem *)item {
    AVMutableMetadataItem *metadataItem = [item mutableCopy];
    
    NSDictionary *trackData = (NSDictionary *)value;
    NSNumber *trackNumber = trackData[MetadataKeyTrackNumber];
    NSNumber *trackCount = trackData[MetadataKeyTrackCount];
    
    uint16_t values[4] = {0};                                                // 6
    
    if (trackNumber && ![trackNumber isKindOfClass:[NSNull class]]) {
        values[1] = CFSwapInt16HostToBig([trackNumber unsignedIntValue]);   // 7
    }
    
    if (trackCount && ![trackCount isKindOfClass:[NSNull class]]) {
        values[2] = CFSwapInt16HostToBig([trackCount unsignedIntValue]);    // 8
    }
    size_t length = sizeof(values);
    metadataItem.value = [NSData dataWithBytes:values length:length];       // 9
    
    return metadataItem;
}
@end
```

1. 刚才所说 `mp3`格式已 `xx/xx` 格式的字符串标识一个歌曲 在整个唱片中的第几首 所以我们用`/`分割
2. iTunes `M4A`文件的唱片信息保存在一个 `NSData` 中,`NSData`包含3个16位的`big encoding`数字,如果直接在控制台打印 NSData 会输出**`<00000008 000a0000>`这是4个16位的`big endian`数字数组的十六进制表现形式**. 数组中第2个和第3个元素分别保存唱片编号和唱片计数值
3. 如果唱片编号 != 0, 则获取该值并使用[`CFSwapInt16BigToHost()`](https://developer.apple.com/documentation/corefoundation/1425282-cfswapint16bigtohost?language=objc)函数执行`endian`转换,转换成一个`little endian` 并打包成`NSNumber`
4. 同样如果音轨计数值不为0, 则获取该值并在字节上执行`endian`转换并打包成`NSNumber`
5. 
6. 步骤反过来换成3个`uint16_t` 保存音轨编号和计数值.
7. 如果音轨编号有效, 将字节转换为`big endian`格式并保存到数组第2个位置
8. 如果音轨计数值有效, 将字节转换为`big endian`格式并保存到数组第3个位置
9. 打成 NSData 保存将其设置为元数据项的 value

### DiscMetadataConverter 唱片数据转换

唱片计数信息用于表示一首歌曲所在的CD是所有唱片中的第几张 通常都是 1/1 (通常都是一个 cd 一首)

上下的和音轨 非常类似了 如果是4/10就是 10首里面的第4首 
由于唱片这玩意都过时了 你现在应该很少看到 屌丝 带着 walkman 在大街上压马路了都看不到了 

但是逻辑还是在的 这里逻辑看代码吧 和 音轨 基本一模一样

### GenreMetadataConverter 风格转换

数字音频使用的标准风格最初来自 MP3. ID3 规范定义了80个默认的风格类型及 另外46个 WinAmp 扩展,共计 126个风格. 不过这些都不属于正式格式. 由于 mp3风格的主导地位比较明显, iTunes 没有另造轮子,而是基本遵循 ID3 的风格分类,不过做了点小变化。**iTunes 音乐风格的标号比响应的 ID3标识符大 `1` .**

![](https://raw.githubusercontent.com/sunyazhou13/sunyazhou13.github.io-images/34c39090f2a8e0ec7a09652065acdd648d5f0133/Learning-AV-Foundation-AVAsset-Senior3.2/gener.png)


虽然 iTunes 使用了 ID3集合中的预定义音乐风格, 不过 iTunes 对电视、电影和有声读物等定义了自己的风格集. [Apple's Genre IDs Appendix](https://affiliate.itunes.apple.com/resources/documentation/genre-mapping/)

示例代码已经包含了这些类型 虽不在赘述 请参考 demo

### 保存元数据

`AVAsset`是一个不可变类型 我们不能直接修改 `AVAsset` 而是使用`AVAssetExportSession`类来导出新的资源副本以及元数据的改动.

#### 使用`AVAssetExportSession`

``` objc
- (void)saveWithCompletionHandler:(CompletionHandler)handler {
    
    NSString *presetName = AVAssetExportPresetPassthrough;                  // 1
    AVAssetExportSession *session =
    [[AVAssetExportSession alloc] initWithAsset:self.asset
                                     presetName:presetName];
    
    NSURL *outputURL = [self tempURL];                                      // 2
    session.outputURL = outputURL;
    session.outputFileType = self.filetype;
    session.metadata = [self.metadata metadataItems];                       // 3
    
    [session exportAsynchronouslyWithCompletionHandler:^{
        AVAssetExportSessionStatus status = session.status;
        BOOL success = (status == AVAssetExportSessionStatusCompleted);
        if (success) {                                                      // 4
            NSURL *sourceURL = self.url;
            NSFileManager *manager = [NSFileManager defaultManager];
            [manager removeItemAtURL:sourceURL error:nil];
            [manager moveItemAtURL:outputURL toURL:sourceURL error:nil];
            [self reset];                                                   // 5
        }
        
        if (handler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(success);
            });
        }
        NSLog(@"sessionError:%@",session.error);
    }];
}


- (NSURL *)tempURL {
    // 获取Caches目录路径
    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *tempDir = cachesDir;
    NSString *ext = [[self.url lastPathComponent] pathExtension];
    NSString *tempName = [NSString stringWithFormat:@"temp.%@", ext];
    NSString *tempPath = [tempDir stringByAppendingPathComponent:tempName];
    return [NSURL fileURLWithPath:tempPath];
}
```

> 注意: __**`AVAssetExportPresetPassthrough` 这个预设值 确实允许修改`MPEG-4`和`QuickTime`容器中的存在的元数据信息, 不过它不可以添加新的元数据,添加元数据的唯一方法是使用转码预设值, 此外不能修改 `ID3`(mp3)标签。 框架不支持写入 MP3数据.**__

## 总结

经过了代码实现和解析多媒体元数据 `AVAsset`,我们也熟悉了多媒体文件的构造, ID3(MP3)格式的文件解析 arkwork 功能. 从而在后续开发过程中 提升开发效率. 最后放出 代码的 demo 请大家多多指教

**[示例 demo](https://github.com/sunyazhou13/MetaDemo)**

