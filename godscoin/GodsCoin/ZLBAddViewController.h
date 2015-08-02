//
//  ZLBAddViewController.h
//  GodsCoin
//
//  Created by jimmykim on 15/6/13.
//  Copyright (c) 2015年 cn.edu.hhtc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLBContact.h"
@class ZLBAddViewController, ZLBContact;

@protocol ZLBAddViewControllerDelegate <NSObject>

@optional
//- (void)addViewController:(MJAddViewController *)addVc didAddContactWithName:(NSString *)name phone:(NSString *)phone;
- (void)addViewController:(ZLBAddViewController *)addVc didAddContact:(ZLBContact *)contact;
@end


@interface ZLBAddViewController : UIViewController
@property (nonatomic, weak) id<ZLBAddViewControllerDelegate> delegate;
@end
