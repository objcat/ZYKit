//
//  ZYCaptureSessionView.h
//  扫描二维码
//
//  Created by 张祎 on 16/2/3.
//  Copyright © 2016年 张祎. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface ZYCaptureSessionView : UIView<AVCaptureMetadataOutputObjectsDelegate>

@property(nonatomic, strong) AVCaptureSession *session;

/**
 *  初始化方法
 *
 *  @param rect 扫描面积
 *
 *  @return object
 */
+ (instancetype)sessionWithRect:(CGRect)rect;

/**
 *  扫描完成block回调  用法  self.sessionView setscanFinishBlock
 */
@property(nonatomic, copy) void (^scanFinishBlock) (NSString *string);

/**
 *  识别图片二维码(从相册中选择然后识别,仅支持iOS8以上)
 */
+ (NSString *)OrCodeFromPhoto:(UIImage *)infoImage;

/**
 *  生成二维码
 *
 *  @param string      二维码扫描的文字
 *  @param size        二维码图片的大小
 *  @param transparent 是否转化成透明二维码(转化成透明扫码正常, 图片识别会为null(暂无法解决))
 *
 *  @return UIImage
 */
+ (UIImage *)makeOrCodeByString:(NSString *)string size:(CGFloat)size isTransparent:(BOOL)transparent;











@end
