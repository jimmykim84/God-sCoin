//
//  ZLBEditViewController.m
//  GodsCoin
//
//  Created by jimmykim on 15/6/13.
//  Copyright (c) 2015年 cn.edu.hhtc. All rights reserved.
//

#import "ZLBEditViewController.h"
#import "ZLBContact.h"
@interface ZLBEditViewController ()
@property (strong, nonatomic) IBOutlet UITextField *choseField;
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;
- (IBAction)edit:(UIBarButtonItem *)sender;
- (IBAction)save;



@end

@implementation ZLBEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.choseField.text = self.contact.chose;
    // 监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.choseField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    self.saveBtn.enabled = self.choseField.text.length;
}

#define EDIT_YES NSLocalizedStringFromTable(@"EDIT_YES",@"Localizable",@"编辑")
#define EDIT_NO NSLocalizedStringFromTable(@"EDIT_NO",@"Localizable",@"取消")

- (IBAction)edit:(UIBarButtonItem *)sender {
    if (self.choseField.enabled) { // 点击的是"取消"
        self.choseField.enabled = NO;
        [self.view endEditing:YES];
        self.saveBtn.hidden = YES;
        
        sender.title = EDIT_YES;//@"编辑"
        
        // 还原回原来的数据
        self.choseField.text = self.contact.chose;

    } else { // 点击的是"编辑"
        self.choseField.enabled = YES;
        
        [self.choseField becomeFirstResponder];
        self.saveBtn.hidden = NO;
        
        sender.title = EDIT_NO;//@"取消"
    }

}

- (IBAction)save {
    // 1.关闭页面
    [self.navigationController popViewControllerAnimated:YES];
    
    // 2.通知代理
    if ([self.delegate respondsToSelector:@selector(editViewController:didSaveContact:)]) {
        // 更新模型数据
        self.contact.chose= self.choseField.text;
        [self.delegate editViewController:self didSaveContact:self.contact];
    }

}
@end
