//
//  UIImage+JoyKit.m
//  ShopSNS
//
//  Created by Danny on 12/17/13.
//  Copyright (c) 2013 True Internet Technology (Shanghai) Company Limited. All rights reserved.
//

#import "UIImage+JoyKit.h"
#import "JKFoundationMethods.h"

@implementation UIImage (JoyKit)

#pragma mark
- (UIImage *)fixOrientation
{
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

#pragma mark
- (UIImage *)imageRotatedByRadians:(CGFloat)radians
{
    return [self imageRotatedByDegrees:JKRadiansToDegrees(radians)];
}

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(JKDegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContextWithOptions(rotatedSize, NO, self.scale);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, JKDegreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark
- (UIImage *)imageResizedToSize:(CGSize)dstSize
{
//    CGImageRef imgRef = self.CGImage;
//	// the below values are regardless of orientation : for UIImages from Camera, width>height (landscape)
//	CGSize  srcSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef)); // not equivalent to self.size (which is dependant on the imageOrientation)!
//    
//	CGFloat scaleRatio = dstSize.width / srcSize.width;
//	UIImageOrientation orient = self.imageOrientation;
//	CGAffineTransform transform = CGAffineTransformIdentity;
//	switch(orient) {
//            
//		case UIImageOrientationUp: //EXIF = 1
//			transform = CGAffineTransformIdentity;
//			break;
//            
//		case UIImageOrientationUpMirrored: //EXIF = 2
//			transform = CGAffineTransformMakeTranslation(srcSize.width, 0.0);
//			transform = CGAffineTransformScale(transform, -1.0, 1.0);
//			break;
//            
//		case UIImageOrientationDown: //EXIF = 3
//			transform = CGAffineTransformMakeTranslation(srcSize.width, srcSize.height);
//			transform = CGAffineTransformRotate(transform, M_PI);
//			break;
//            
//		case UIImageOrientationDownMirrored: //EXIF = 4
//			transform = CGAffineTransformMakeTranslation(0.0, srcSize.height);
//			transform = CGAffineTransformScale(transform, 1.0, -1.0);
//			break;
//            
//		case UIImageOrientationLeftMirrored: //EXIF = 5
//			dstSize = CGSizeMake(dstSize.height, dstSize.width);
//			transform = CGAffineTransformMakeTranslation(srcSize.height, srcSize.width);
//			transform = CGAffineTransformScale(transform, -1.0, 1.0);
//			transform = CGAffineTransformRotate(transform, 3.0 * M_PI_2);
//			break;
//            
//		case UIImageOrientationLeft: //EXIF = 6
//			dstSize = CGSizeMake(dstSize.height, dstSize.width);
//			transform = CGAffineTransformMakeTranslation(0.0, srcSize.width);
//			transform = CGAffineTransformRotate(transform, 3.0 * M_PI_2);
//			break;
//            
//		case UIImageOrientationRightMirrored: //EXIF = 7
//			dstSize = CGSizeMake(dstSize.height, dstSize.width);
//			transform = CGAffineTransformMakeScale(-1.0, 1.0);
//			transform = CGAffineTransformRotate(transform, M_PI_2);
//			break;
//            
//		case UIImageOrientationRight: //EXIF = 8
//			dstSize = CGSizeMake(dstSize.height, dstSize.width);
//			transform = CGAffineTransformMakeTranslation(srcSize.height, 0.0);
//			transform = CGAffineTransformRotate(transform, M_PI_2);
//			break;
//            
//		default:
//			[NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
//            
//	}
//    
//	/////////////////////////////////////////////////////////////////////////////
//	// The actual resize: draw the image on a new context, applying a transform matrix
//	UIGraphicsBeginImageContextWithOptions(dstSize, NO, 0.0);
//    
//	CGContextRef context = UIGraphicsGetCurrentContext();
//    
//	if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
//		CGContextScaleCTM(context, -scaleRatio, scaleRatio);
//		CGContextTranslateCTM(context, -srcSize.height, 0);
//	} else {
//		CGContextScaleCTM(context, scaleRatio, -scaleRatio);
//		CGContextTranslateCTM(context, 0, -srcSize.height);
//	}
//    
//	CGContextConcatCTM(context, transform);
//    
//	// we use srcSize (and not dstSize) as the size to specify is in user space (and we use the CTM to apply a scaleRatio)
//	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, srcSize.width, srcSize.height), imgRef);
//	UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
//	UIGraphicsEndImageContext();
//    
//	return resizedImage;
    
    UIGraphicsBeginImageContextWithOptions(dstSize, NO, .0);
    [self drawInRect:CGRectMake(.0, .0, dstSize.width, dstSize.height)];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

#pragma mark
- (UIImage *)imageFilledWithColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, .0);
    [color set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect bounds = CGRectZero;
    bounds.size = self.size;
    CGContextTranslateCTM(context, 0, bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextClipToMask(context, bounds, self.CGImage);
    CGContextFillRect(context, bounds);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

#pragma mark
- (UIImage *)imageRoundedWithCornersRadius:(CGFloat)radius
{
    UIImage * newImage = nil;
	
    @autoreleasepool {
        int w = self.size.width;
        int h = self.size.height;
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
        
        CGContextBeginPath(context);
        CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
        
        void (^addRoundedRectToPathBlock)(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight) = ^(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight) {
            float fw, fh;
            if (ovalWidth == 0 || ovalHeight == 0) {
                CGContextAddRect(context, rect);
                return;
            }
            CGContextSaveGState(context);
            CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
            CGContextScaleCTM (context, ovalWidth, ovalHeight);
            fw = CGRectGetWidth (rect) / ovalWidth;
            fh = CGRectGetHeight (rect) / ovalHeight;
            CGContextMoveToPoint(context, fw, fh/2);
            CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
            CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
            CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
            CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
            CGContextClosePath(context);
            CGContextRestoreGState(context);
        };
        addRoundedRectToPathBlock(context, rect, 10, 10);
        
        CGContextClosePath(context);
        CGContextClip(context);
        
        CGContextDrawImage(context, CGRectMake(0, 0, w, h), self.CGImage);
        
        CGImageRef imageMasked = CGBitmapContextCreateImage(context);
        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
        
        newImage = [UIImage imageWithCGImage:imageMasked];
        CGImageRelease(imageMasked);
    }
    
    return newImage;
}

#pragma mark
- (UIImage *)imageCroppedWithRect:(CGRect)rect
{
    if (self.scale > 1.0f) {
        rect = CGRectMake(rect.origin.x * self.scale,
                          rect.origin.y * self.scale,
                          rect.size.width * self.scale,
                          rect.size.height * self.scale);
    }
    
    CGAffineTransform rectTransform;
	switch (self.imageOrientation)
	{
		case UIImageOrientationLeft:
			rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(M_PI_2), 0, -self.size.height);
			break;
		case UIImageOrientationRight:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation((-M_PI_2)), -self.size.width, 0);
			break;
		case UIImageOrientationDown:
			rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(-M_PI), -self.size.width, -self.size.height);
			break;
		default:
			rectTransform = CGAffineTransformIdentity;
	};
	
	rectTransform = CGAffineTransformScale(rectTransform, self.scale, self.scale);
    rect = CGRectApplyAffineTransform(rect, rectTransform);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    
    return result;
}

@end
