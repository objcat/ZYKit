//
//  ZYCaptureSessionView.m
//  扫描二维码
//
//  Created by 张祎 on 16/2/3.
//  Copyright © 2016年 张祎. All rights reserved.
//

#import "ZYCaptureSessionView.h"
#import "ZYKit.h"

@interface ZYCaptureSessionView ()
@property(nonatomic, strong) UIImageView *lineView;
@property(nonatomic, strong) UIImageView *imageBaseView;
@property(nonatomic, strong) NSTimer *timer;
@end

@implementation ZYCaptureSessionView

+ (instancetype)sessionWithRect:(CGRect)rect {
    ZYCaptureSessionView *session = [[ZYCaptureSessionView alloc]initWithFrame:[UIScreen mainScreen].bounds rectOfInterest:rect];
    return session;
}

- (instancetype)initWithFrame:(CGRect)frame rectOfInterest:(CGRect)rect {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        
        
        //获取摄像设备
        AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        //创建输入流
        AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        //创建输出流
        AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
        
        //设置代理 在主线程里刷新
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        //初始化链接对象
        self.session = [[AVCaptureSession alloc]init];
        //高质量采集率
        [self.session setSessionPreset:AVCaptureSessionPresetHigh];
        
        if (input) {
            [self.session addInput:input];
        }
        
        [self.session addOutput:output];
        
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        if (input) {
            output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
            output.rectOfInterest = CGRectMake(rect.origin.y / height, rect.origin.x / width, rect.size.height / height, rect.size.width / width);
        }
        
        AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        layer.frame = self.layer.bounds;
        [self.layer insertSublayer:layer atIndex:0];
        
        self.imageBaseView = [[UIImageView alloc]initWithFrame:rect];
        self.imageBaseView.image = [UIImage imageNamed:@"saoerwei_Group"];
        [self addSubview:self.imageBaseView];
        
        
        self.lineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.imageBaseView.frame.size.width, 10)];
        self.lineView.image = [UIImage imageNamed:@"Bitmap_line"];
        [self.imageBaseView addSubview:self.lineView];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(lineViewMoveAction:) userInfo:nil repeats:YES];
        
        
        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, rect.origin.y)];
        [self addSubview:view1];
        view1.backgroundColor = [UIColor blackColor];
        view1.alpha = 0.7;
        
        UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, rect.origin.y, (width - rect.size.width) / 2, height - rect.origin.y)];
        [self addSubview:view2];
        view2.backgroundColor = [UIColor blackColor];
        view2.alpha = 0.7;
        
        UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(rect.origin.x + rect.size.width, rect.origin.y, (width - rect.size.width) / 2, height - rect.origin.y)];
        [self addSubview:view3];
        view3.backgroundColor = [UIColor blackColor];
        view3.alpha = 0.7;
        
        UIView *view4 = [[UIView alloc]initWithFrame:CGRectMake(rect.origin.x, rect.origin.y + rect.size.height, rect.size.width, rect.origin.y)];
        [self addSubview:view4];
        view4.backgroundColor = [UIColor blackColor];
        view4.alpha = 0.7;

        [self.session startRunning];
    }
    return self;
}
- (void)lineViewMoveAction:(NSTimer *)timer {
    self.lineView.top = self.lineView.top + 1;
    if (self.lineView.top >= self.imageBaseView.height - 10) {
        self.lineView.top = 0;
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        //[session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        //输出扫描字符串
        NSLog(@"%@",metadataObject.stringValue);
        
        if (self.scanFinishBlock != nil) {
            self.scanFinishBlock(metadataObject.stringValue);
        }
        [self.session stopRunning];
    }
}

+ (NSString *)OrCodeFromPhoto:(UIImage *)infoImage {
    UIImage * srcImage = infoImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    CIImage *image = [CIImage imageWithCGImage:srcImage.CGImage];
    NSArray *features = [detector featuresInImage:image];
    CIQRCodeFeature *feature = [features firstObject];
    NSString *result = feature.messageString;
    return result;
}

- (void)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(lineViewMoveAction:) userInfo:nil repeats:YES];
}

- (void)invalideTimer {
    [self.timer invalidate];
}

//生成二维码
+ (UIImage *)makeOrCodeByString:(NSString *)string size:(CGFloat)size isTransparent:(BOOL)transparent {
    
    ZYCaptureSessionView *cap = [[ZYCaptureSessionView alloc]init];
    CIImage *ciImage = [cap createQRForString:string];
    UIImage *image = [cap createNonInterpolatedUIImageFormCIImage:ciImage withSize:size];
    
    if (transparent == YES) {
        image = [cap imageBlackToTransparent:image withRed:0 andGreen:0 andBlue:0];
        return image;
    }
    
    return image;
}


- (CIImage *)createQRForString:(NSString *)qrString {
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // 创建filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 设置内容和纠错级别
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // 返回CIImage
    return qrFilter.outputImage;
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

void ProviderReleaseData (void *info, const void *data, size_t size) {
    free((void*)data);
}

- (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900)    // 将白色变成透明
        {
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }
        else
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // 输出图片
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // 清理空间
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}

@end
