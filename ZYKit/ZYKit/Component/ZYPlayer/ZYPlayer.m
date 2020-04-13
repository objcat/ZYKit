//
//  ZYPlayer.m
//  MongolianReadProject
//
//  Created by 张祎 on 2017/5/26.
//  Copyright © 2017年 张祎. All rights reserved.
//

#import "ZYPlayer.h"

@interface ZYPlayer ()
@property (nonatomic, weak) id playTimeObserver;
@property (nonatomic, strong) NSString *duration;
@end

@implementation ZYPlayer

- (void)setPlayerState:(ZYPlayerState)playerState {
    _playerState = playerState;
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerStateDidChanged:)]) {
        [self.delegate playerStateDidChanged:playerState];
    }
}


+ (instancetype)playerWithURL:(NSString *)URL {
    NSURL *url = [NSURL URLWithString:URL];
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
    ZYPlayer *player = [[ZYPlayer alloc] initWithPlayerItem:item];
    return player;
}


+ (instancetype)playerWithFileURL:(NSString *)fileURL {
    NSURL *url = [NSURL fileURLWithPath:fileURL];
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
    ZYPlayer *player = [[ZYPlayer alloc] initWithPlayerItem:item];
    return player;
}


- (instancetype)initWithPlayerItem:(AVPlayerItem *)item {
    self = [super initWithPlayerItem:item];
    if (self) {
        // 设置监听和通知
        [self addAllObservesAndNotifications];
    }
    return self;
}


- (void)addAllObservesAndNotifications {
    [self addItemObservers];
    [self addProgressObservers];
    [self addNotifactions];
}

- (void)addItemObservers {
    /** 设置item监听 */
    [self.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)addProgressObservers {
    __weak typeof(self) weakSelf = self;
    self.playTimeObserver = nil;
    self.playTimeObserver = [self addPeriodicTimeObserverForInterval:CMTimeMake(1, 2) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        Float64 currentPlayTime = self.currentItem.currentTime.value / self.currentItem.currentTime.timescale;
        Float64 progress = CMTimeGetSeconds(self.currentItem.currentTime) / CMTimeGetSeconds(self.currentItem.duration);
        NSString *currentTimeString = [weakSelf timeToString:currentPlayTime];
        //回调当前播放进度
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(playerDidUpdateProgress:currentTime:)]) {
            [weakSelf.delegate playerDidUpdateProgress:progress currentTime:currentTimeString];
        }
    }];
}

#pragma mark - Notification
- (void)addNotifactions {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(AVPlayerItemDidPlayToEndTimeNotification:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [center addObserver:self selector:@selector(AVPlayerItemFailedToPlayToEndTimeErrorKey:) name:AVPlayerItemFailedToPlayToEndTimeErrorKey object:nil];
}

//播放结束
- (void)AVPlayerItemDidPlayToEndTimeNotification:(NSNotification *)noti {
    self.playerState = ZYPlayerStateEnd;
    if (self.loop) {
        [self seekToTime:0];
        [self play];
    }
//    else{
//        [self removeAllObservesAndNotifications];
//    }
}


//播放失败
- (void)AVPlayerItemFailedToPlayToEndTimeErrorKey:(NSNotification *)noti {
    self.playerState = ZYPlayerStateError;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if (![object isKindOfClass:[AVPlayerItem class]]) {
        return;
    }

    if ([keyPath isEqualToString:@"status"]) {
        //监听状态
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue]; // 获取
        if (status == AVPlayerStatusReadyToPlay) {
            [self play];
        } else if (status == AVPlayerStatusFailed) {
            self.playerState = ZYPlayerStateError;
        } else {
            self.playerState = ZYPlayerStateUnKnow;
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        //缓冲进度
        NSTimeInterval timeInterval = [self availableDuration];
        CMTime duration             = self.currentItem.duration;
        CGFloat totalDuration       = CMTimeGetSeconds(duration);
        float timeRange = timeInterval / totalDuration;
        if (self.status == AVPlayerStatusReadyToPlay) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(playerDidUpdateTimeRanges:)]) {
                [self.delegate playerDidUpdateTimeRanges:timeRange];
            }
        }
    }
}


- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [self.currentItem loadedTimeRanges];
    CMTimeRange timeRange     = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds        = CMTimeGetSeconds(timeRange.start);
    float durationSeconds     = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result     = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}


- (NSString *)timeToString:(Float64)time {
    NSInteger integerTime = time;
    NSString *timeStr;
    
    if (integerTime < 0) {
        return @"00:00";
    }
    
    if (integerTime < 60) {
        timeStr = [NSString stringWithFormat:@"00:%02ld", integerTime];
    }
    else if (integerTime < 3600) {
        timeStr = [NSString stringWithFormat:@"%02ld:%02ld", integerTime / 60, integerTime % 60];
    }
    else{
        timeStr = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", integerTime / 3600, integerTime % 3600 / 60, integerTime % 60];
    }
    
    return timeStr;
}


- (NSString *)duration {
    return [self timeToString:CMTimeGetSeconds(self.currentItem.duration)];
}


- (void)play {
    [super play];
    self.playerState = ZYPlayerStatePlay;
}


- (void)pause {
    [super pause];
    self.playerState = ZYPlayerStatePause;
}


- (void)dealloc {
    NSLog(@"-----------ZYPlayer释放------------");
    //移除所有监听
    [self removeAllObservesAndNotifications];
}

- (void)removeItemObservers {
    [self.currentItem removeObserver:self forKeyPath:@"status"];
    [self.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}


- (void)removeProgressObservers {
    [self removeTimeObserver:_playTimeObserver];
}

- (void)removeNotifications {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [center removeObserver:self name:AVPlayerItemFailedToPlayToEndTimeErrorKey object:nil];
}

- (void)removeAllObservesAndNotifications {
    // 移除item监听
    [self removeItemObservers];
    // 移除进度条监听
    [self removeProgressObservers];
    // 移除通知
    [self removeNotifications];
}

- (void)seekToTime:(Float32)value {
    [self pause];
    CMTimeScale scale = self.currentItem.asset.duration.timescale;
    Float64 time = CMTimeGetSeconds(self.currentItem.duration) * value;
    self.playerState = ZYPlayerStateWillJump;
    [self seekToTime:CMTimeMakeWithSeconds(time, scale) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
        self.playerState = ZYPlayerStateDidJump;
    }];
}

- (void)replaceCurrentItemWithPlayerItem:(AVPlayerItem *)item {
    [self removeItemObservers];
    [super replaceCurrentItemWithPlayerItem:item];
    [self addItemObservers];
}

@end
