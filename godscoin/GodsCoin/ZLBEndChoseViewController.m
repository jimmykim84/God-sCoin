//
//  ZLBEndChoseViewController.m
//  
//
//  Created by jimmykim on 15/6/12.
//
//

#import "ZLBEndChoseViewController.h"
#import "ZLBContact.h"
#import "MBProgressHUD+MJ.h"



#define ZLBContactsFilepath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"contacts.data"]

@interface ZLBEndChoseViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIPickerView *showView;
- (IBAction)showBtnClick;
@property (nonatomic, strong) NSArray *choses;
@end

@implementation ZLBEndChoseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)choses
{
    if (_choses == nil) {
        // 1.从文件中读取联系人数据
        _choses = [NSKeyedUnarchiver unarchiveObjectWithFile:ZLBContactsFilepath];
    }
    return _choses;
}

#pragma mark - 数据源方法
/**
 *  一共有多少列
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

/**
 *  第component列显示多少行
 */
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.choses.count;
}

#pragma mark - 代理方法
/**
 *  第component列的第row行显示什么文字
 */
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
   
    ZLBContact *flag = self.choses[row];
    return flag.chose;
}


/**
 *  返回pickView高度
 */
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
        return 50;
}


#define ALERT_ENDCHOSE_ONE NSLocalizedStringFromTable(@"ALERT_ENDCHOSE_ONE",@"Localizable",@"给我一个选项")
#define ALERT_ENDCHOSE_TWO NSLocalizedStringFromTable(@"ALERT_ENDCHOSE_TWO",@"Localizable",@"没得选，别纠结了！")
#define ALERT_ENDCHOSE_THINK NSLocalizedStringFromTable(@"ALERT_ENDCHOSE_THINK",@"Localizable",@"哥正在帮你纠结中....")
#define ALERT_ENDCHOSE_OK NSLocalizedStringFromTable(@"ALERT_ENDCHOSE_OK",@"Localizable",@"选择完成")
- (IBAction)showBtnClick {
    if (self.choses.count == 0)
    {
        [MBProgressHUD showError:ALERT_ENDCHOSE_ONE];//@"给我个可选项啊！"
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 移除遮盖
            [MBProgressHUD hideHUD];});
        return;
    }
    if (self.choses.count == 1)
    {
        
        [MBProgressHUD showSuccess:ALERT_ENDCHOSE_TWO];//@"没得选，别纠结了！"
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 移除遮盖
            [MBProgressHUD hideHUD];});
        return;
    }    // 显示一个蒙版(遮盖)
    [MBProgressHUD showMessage:ALERT_ENDCHOSE_THINK];//@"哥正在帮你纠结中...."
    
    // 发送网络请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD showSuccess:ALERT_ENDCHOSE_OK];//@"选择完成"];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 移除遮盖
        [MBProgressHUD hideHUD];
               
        int count = [self.choses count];
        int  row = arc4random()%count;
        // 让pickerView主动选中第compoent列的第row行
        [self.showView selectRow:row inComponent:0 animated:YES];
       // NSLog(@"%@",self.choses);
        });
    //
    });
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    // 重新读取数据
     self.choses = [NSKeyedUnarchiver unarchiveObjectWithFile:ZLBContactsFilepath];
    // 参数为需更新的component的序号,调用此方法使得PickerView向其delegate: Query for new data
    [self.showView  reloadComponent:0];
    
}

@end
