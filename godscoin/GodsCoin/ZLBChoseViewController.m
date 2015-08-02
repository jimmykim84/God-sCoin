//
//  ZLBChoseViewController.m
//  GodsCoin
//
//  Created by jimmykim on 15/6/12.
//  Copyright (c) 2015年 cn.edu.hhtc. All rights reserved.
//

#import "ZLBChoseViewController.h"
#import "ZLBAddViewController.h"
#import "ZLBContact.h"
#import "ZLBEditViewController.h"

#define ZLBContactsFilepath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"contacts.data"]

@interface ZLBChoseViewController () <ZLBAddViewControllerDelegate,ZLBEditViewControllerDelegate>
- (IBAction)deleteClick:(UIBarButtonItem *)sender;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *deleteBtnState;

@property (nonatomic, strong) NSMutableArray *contacts;
@end

@implementation ZLBChoseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.deleteBtnState setEnabled: (!self.contacts.count ? NO:YES)];
    
 
}




- (IBAction)deleteClick:(UIBarButtonItem *)sender {
   
      [self.tableView setEditing:!self.tableView.isEditing animated:YES];
        // 让tableView进入编辑状态
    //    self.tableView.editing = !self.tableView.isEditing;

}

- (NSMutableArray *)contacts
{
    if (_contacts == nil) {
        // 1.从文件中读取联系人数据
        _contacts = [NSKeyedUnarchiver unarchiveObjectWithFile:ZLBContactsFilepath];
        
        // 2.如果数组为nil
        if (_contacts == nil) { // 文件不存在
            _contacts = [NSMutableArray array];
        }
    }
    return _contacts;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
   return self.contacts.count;
}
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chose" forIndexPath:indexPath];
    
    // Configure the cell...
    
    ZLBContact * contact = self.contacts[indexPath.row];
    cell.textLabel.text = contact.chose;
    
    return cell;
}

#pragma mark - tableView的代理方法
/**
 *  如果实现了这个方法,就自动实现了滑动删除的功能
 *  点击了删除按钮就会调用
 *  提交了一个编辑操作就会调用(操作:删除\添加)
 *  @param editingStyle 编辑的行为
 *  @param indexPath    操作的行号
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) { // 提交的是删除操作
        // 1.删除模型数据
        [self.contacts removeObjectAtIndex:indexPath.row];
        
        // 2.刷新表格
        // 局部刷新某些行(使用前提:模型数据的行数不变)
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        
        // 3.归档
        [NSKeyedArchiver archiveRootObject:self.contacts toFile:ZLBContactsFilepath];
    }
    if (self.contacts.count==0) {
        [self.deleteBtnState setEnabled:NO];
        self.tableView.editing = !self.tableView.isEditing;
        
    }else{[self.deleteBtnState setEnabled:YES];}
    
    
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // 1.修改模型数据
//        ZLBContact *contact = [[ZLBContact alloc] init];
//        contact.chose = @"再试一次吧";
//       
//        [self.contacts insertObject:contact atIndex:indexPath.row + 1];
//        
//        // 2.刷新表格
//        NSIndexPath *nextPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0];
//        [self.tableView insertRowsAtIndexPaths:@[nextPath] withRowAnimation:UITableViewRowAnimationBottom];
//        //        [self.tableView reloadData];
//    }
}

/**
 *  当tableView进入编辑状态的时候会调用,询问每一行进行怎样的操作(添加\删除)
 */
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return indexPath.row  ? UITableViewCellEditingStyleDelete : UITableViewCellEditingStyleInsert;
//}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

/**
 *  执行跳转之前会调用
 *  在这个方法中,目标控制器的view还没有被创建
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    id vc = segue.destinationViewController;
    
    if ([vc isKindOfClass:[ZLBAddViewController class]]) { // 如果是跳转到添加联系人的控制器
        // 设置下一个控制器(添加联系人的控制器)的代理
        ZLBAddViewController *addVc = vc;
        addVc.delegate = self;
    } else if ([vc isKindOfClass:[ZLBEditViewController class]]) { // 如果是跳转到查看(编辑)联系人的控制器
        ZLBEditViewController *editVc = vc;
        // 取得选中的那行
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        editVc.contact = self.contacts[path.row];
        editVc.delegate = self;
    }
}



#pragma mark - ZLBAddViewController的代理方法
- (void)addViewController:(ZLBAddViewController *)addVc didAddContact:(ZLBContact *)contact
{
    
    // 1.添加模型数据
    [self.contacts addObject:contact];
    
    // 2.刷新表格
    [self.tableView reloadData];
    
    // 3.归档数组
    [NSKeyedArchiver archiveRootObject:self.contacts toFile:ZLBContactsFilepath];
    
    [self.deleteBtnState setEnabled:YES];
     self.tableView.editing = NO;
}

#pragma mark - ZLBEditViewController的代理方法
- (void)editViewController:(ZLBEditViewController *)editVc didSaveContact:(ZLBContact *)contact
{
    // 刷新表格
    [self.tableView reloadData];
    
    // 归档数组
    [NSKeyedArchiver archiveRootObject:self.contacts toFile:ZLBContactsFilepath];
}
@end