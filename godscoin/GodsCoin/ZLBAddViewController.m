//
//  ZLBAddViewController.m
//  GodsCoin
//
//  Created by jimmykim on 15/6/13.
//  Copyright (c) 2015年 cn.edu.hhtc. All rights reserved.
//

#import "ZLBAddViewController.h"
#import "ZLBContact.h"


@interface ZLBAddViewController ()
@property (strong, nonatomic) IBOutlet UIButton *addBtn;
@property (strong, nonatomic) IBOutlet UITextField *choseField;
- (IBAction)add;

@end

@implementation ZLBAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    
    // 监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.choseField];


}

/**
 *  控制器的view完全显示的时候调用
 */
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 让姓名文本框成为第一响应者(叫出键盘)
    [self.choseField becomeFirstResponder];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  文本框的文字发生改变的时候调用
 */
- (void)textChange
{
    self.addBtn.enabled = self.choseField.text.length;
}


- (IBAction)add {
    // 1.关闭当前控制器
    [self.navigationController popViewControllerAnimated:YES];
    
    // 2.传递数据给上一个控制器(ZLBChoseViewController)
    // 2.通知代理
    if ([self.delegate respondsToSelector:@selector(addViewController:didAddContact:)]) {
        ZLBContact *contact = [[ZLBContact alloc] init];
        contact.chose = self.choseField.text;
      
        [self.delegate addViewController:self didAddContact:contact];
       
        
        
    }
    
}


@end
