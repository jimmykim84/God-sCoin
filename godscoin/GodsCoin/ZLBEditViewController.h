//
//  ZLBEditViewController.h
//  GodsCoin
//
//  Created by jimmykim on 15/6/13.
//  Copyright (c) 2015年 cn.edu.hhtc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZLBContact, ZLBEditViewController;

@protocol ZLBEditViewControllerDelegate <NSObject>

@optional
- (void)editViewController:(ZLBEditViewController *)editVc didSaveContact:(ZLBContact *)contact;

@end

@interface ZLBEditViewController : UIViewController
@property (nonatomic, strong) ZLBContact *contact;
@property (nonatomic, weak) id<ZLBEditViewControllerDelegate> delegate;
@end
