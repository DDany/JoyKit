//
//  UIImage+JoyKit.h
//  ShopSNS
//
//  Created by Danny on 12/17/13.
//  Copyright (c) 2013 True Internet Technology (Shanghai) Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JoyKit)

/**
 *  Fix orientation
 *
 *  @return fixed image.
 *  @seealso http://stackoverflow.com/questions/5427656/ios-uiimagepickercontroller-result-image-orientation-after-upload/5427890#5427890
 */
- (UIImage *)fixOrientation;

/**
 *  Rotate methods.
 *
 *  @param radians radians
 *  @param degrees degrees
 *
 *  @return rotated image.
 *  @seealso https://github.com/uzysjung/UzysImageCropper
 */
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

/**
 *  Resize methods.
 *
 *  @param boundingSize boundingSize
 *  @param scale        should scale if smaller
 *
 *  @return resized image
 *  @seealso https://github.com/uzysjung/UzysImageCropper
 */
- (UIImage *)imageResizedToSize:(CGSize)dstSize;

/**
 *  Fill with color.
 *
 *  @param  color
 *
 *  @return Color filled image
 */
- (UIImage *)imageFilledWithColor:(UIColor *)color;

/**
 *  Rounded method.
 *
 *  @param radius corner radius
 *
 *  @return rounded image
 *  @seealso http://stackoverflow.com/questions/14071278/uiimage-with-smooth-rounded-corners-in-quartz/14071921#14071921
 */
- (UIImage *)imageRoundedWithCornersRadius:(CGFloat)radius;

/**
 *  Crop image.
 *
 *  @param rect rect to crop
 *
 *  @return cropped image
 *  @seealso https://github.com/uzysjung/UzysImageCropper
 */
- (UIImage *)imageCroppedWithRect:(CGRect)rect;

@end
