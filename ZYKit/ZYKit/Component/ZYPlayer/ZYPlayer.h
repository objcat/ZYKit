//
//  ZYPlayer.h
//  MongolianReadProject
//
//  Created by 张祎 on 2017/5/26.
//  Copyright © 2017年 张祎. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


typedef NS_ENUM(NSUInteger, ZYPlayerState) {
    /** 正在加载 */
    ZYPlayerStateLoading,
    /** 正在播放 */
    ZYPlayerStatePlay,
    /** 暂停 */
    ZYPlayerStatePause,
    /** 结束 */
    ZYPlayerStateEnd,
    /** 将要跳转 */
    ZYPlayerStateWillJump,
    /** 跳转完成 */
    ZYPlayerStateDidJump,
    /** 播放错误 */
    ZYPlayerStateError,
    /** 未知状态 */
    ZYPlayerStateUnKnow,
};

@protocol ZYPlayerDelegate <NSObject>

@optional

/* 播放状态监控 */
- (void)playerStateDidChanged:(ZYPlayerState)state;

/**
 进度条监控
 @param progress 播放进度
 */
- (void)playerDidUpdateProgress:(float)progress currentTime:(NSString *)currentTime;

/**
 缓冲进度监控
 @param timeRanges 缓冲进度
 */
- (void)playerDidUpdateTimeRanges:(float)timeRanges;

@end

@interface ZYPlayer : AVPlayer

/**
 播放网络视频资源
 @param URL 本地路径
 @return ZYPlayer
 */
+ (instancetype)playerWithURL:(NSString *)URL;

/**
 播放本地视频资源
 @param fileURL 本地路径
 @return ZYPlayer
 */
+ (instancetype)playerWithFileURL:(NSString *)fileURL;

/**
 跳转进度
 使用系统方法封装 直接传入0-1的数值即可
 @param value 进度
 */
- (void)seekToTime:(Float32)value;

/**
 代理人
 */
@property (nonatomic, weak) id <ZYPlayerDelegate> delegate;

/**
 是否循环播放
 */
@property (nonatomic, assign) BOOL loop;

/**
 当前播放状态
 */
@property (nonatomic, assign) ZYPlayerState playerState;

/**
 总进度
 */
@property (nonatomic, strong, readonly) NSString *duration;

/**
 添加所有监听和通知
 */
- (void)addAllObservesAndNotifications;

/**
 移除所有监听和通知
 */
- (void)removeAllObservesAndNotifications;

/**
 增加item监听, 进度条监听, 通知监听
 */
- (void)addItemObservers;
- (void)addProgressObservers;
- (void)addNotifactions;

/**
 移除item监听, 进度条监听, 通知监听
 */
- (void)removeItemObservers;
- (void)removeProgressObservers;
- (void)removeNotifications;

@end
