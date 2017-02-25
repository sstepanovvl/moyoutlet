//
//  CameraViewController.h
//  Demo
//
//  Created by Maxim Makhun on 6/16/16.
//  Copyright © 2016 Maxim Makhun. All rights reserved.
//

@import UIKit;

@protocol ImagePickerViewControllerDelegate <NSObject>

- (void)imageSelected:(UIImage *)image;
- (void)imageSelectionCancelled;

@end

@interface CameraViewControllerOld : UIViewController

@property(nonatomic, weak) id<ImagePickerViewControllerDelegate> delegate;
@property(strong,nonatomic) NSNumber* arrayPosition;
@end
