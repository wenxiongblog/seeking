//
//  LSDetactFace.m
//  Project
//
//  Created by XuWen on 2020/2/29.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSDetactFace.h"
#import <CoreImage/CoreImage.h>

@implementation LSDetactFace

+ (void)detactImage:(UIImage *)image haveFace:(void(^)(NSInteger faceCount))complete
{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
        CIImage *cImage = [CIImage imageWithCGImage:image.CGImage];
        //设置识别模式
        NSDictionary  *opts = [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh
        forKey:CIDetectorAccuracy];
        
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:opts];
        NSArray *features = [detector featuresInImage:cImage];
        for (CIFaceFeature *feature in features)
        {
            // 是否微笑
            BOOL smile = feature.hasSmile;
            
            NSLog(smile ? @"微笑" : @"没微笑");
            
            // 眼睛是否睁开
            BOOL leftEyeClosed = feature.leftEyeClosed;
            BOOL rightEyeClosed = feature.rightEyeClosed;
            
            NSLog(leftEyeClosed ? @"左眼没睁开" : @"左眼睁开");
            NSLog(rightEyeClosed ? @"右眼没睁开" : @"右眼睁开");
            
            // 获取脸部frame
            CGRect rect = feature.bounds;
    //        rect.origin.y = imageView.bounds.size.height - rect.size.height - rect.origin.y;// Y轴旋转180度
    //        faceRect = rect;
            NSLog(@"脸 %@",NSStringFromCGRect(rect));
            
            // 左眼
            if (feature.hasLeftEyePosition)
            {
                CGPoint eye = feature.leftEyePosition;
    //            eye.y = imageView.bounds.size.height - eye.y;// Y轴旋转180度
                NSLog(@"左眼 %@",NSStringFromCGPoint(eye));
            }
            
            // 右眼
            if (feature.hasRightEyePosition)
            {
                CGPoint eye = feature.rightEyePosition;
    //            eye.y = imageView.bounds.size.height - eye.y;// Y轴旋转180度
                NSLog(@"右眼 %@",NSStringFromCGPoint(eye));
            }
            
            // 嘴
            if (feature.hasMouthPosition)
            {
                CGPoint mouth = feature.mouthPosition;
    //            mouth.y = imageView.bounds.size.height - mouth.y;// Y轴旋转180度
                NSLog(@"嘴 %@",NSStringFromCGPoint(mouth));
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"检测完成");
                complete(features.count);
            });
        });
        
    });
    
}
@end
