//
//  MetaDataViewController.h
//  MetaDemo
//
//  Created by sunyazhou on 2017/6/18.
//  Copyright © 2017年 Baidu, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MetaDataViewControllerDelegate <NSObject>
@optional
- (void)needReload;
@end

@interface MetaDataViewController : UIViewController
@property (nonatomic, copy) NSURL *url;
@property (nonatomic, weak) id <MetaDataViewControllerDelegate> delegate;
@end
