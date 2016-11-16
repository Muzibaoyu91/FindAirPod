//
//  AboutUsViewController.m
//  FindAirPod
//
//  Created by Baoyu on 16/10/6.
//  Copyright © 2016年 Baoy. All rights reserved.
//

#import "AboutUsViewController.h"
#import <MessageUI/MessageUI.h>
#import "WebViewController.h"

#define firstHeight 120
#define iconSide 60
#define secondHeight 46
#define ThirdHeight  170
#define fouthHeight 200

@interface AboutUsViewController ()<UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;


@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadContentView];
    
}

#pragma mark - UI
- (void)loadContentView{
    
    self.title = @"关于我们";
    [self addLeftBackButton];
    
    
    
    //0.tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return 4;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    switch (indexPath.section) {
        case 0:
        {
            UIImageView *iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake( (kScreenW - iconSide)/2.f,10, iconSide, iconSide)];
            iconImgView.image =[UIImage imageNamed:@"main-logo"];
            iconImgView.layer.cornerRadius = 5;
            iconImgView.layer.masksToBounds = YES;
            [cell.contentView addSubview:iconImgView];
            
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,  CGRectGetMaxY(iconImgView.frame) + 10, kScreenW, firstHeight - iconSide - 20)];
            label.text = @"世界这样大，能这样找到你，真好。";
            label.font = [UIFont boldSystemFontOfSize:17];
            label.textColor = color_mainColor;
            label.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:label];
            
            break;
        }
        
        case 1:
        {
            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, kScreenW -20, ThirdHeight - 20)];
            textView.layer.borderColor = color_TestGray.CGColor;
            //            textView.layer.borderWidth = 1;
            textView.layer.cornerRadius = 3;
            textView.layer.masksToBounds = YES;
            textView.editable = NO;
            textView.text = @"   这是一款专为寻找耳机的高端交友APP，个人可以发布需要寻找的左右耳需求以及个人信息，利用手机定位找到身边的同样发布需求的ta。我有左耳的耳机，茫茫人海中擦肩而过的你，是否就是我想要的那个右耳呢？";
            textView.font = [UIFont systemFontOfSize:17];
            textView.textColor = color_TestGray;
            [cell.contentView addSubview:textView];
            break;
        }
        case 2:
        {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"iOS:";
                cell.detailTextLabel.text = @"Baoy";
            }else if (indexPath.row == 1){
                cell.textLabel.text = @"Python:";
                cell.detailTextLabel.text = @"jerryleooo";
            }else if (indexPath.row == 2){
                cell.textLabel.text = @"设计&产品:";
                cell.detailTextLabel.text = @"lucy";
            }else if (indexPath.row == 3){
                cell.textLabel.text = @"运营&文案";
                cell.detailTextLabel.text = @"嵇小康";
            }
            break;
        }
            
        default:
            return 0;
            break;
    }
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {   return firstHeight;
        }
        case 1:
        {
            return ThirdHeight;
        }
        case 2:
        {
            return fouthHeight/4.f;
        }
            
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 4;
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self openUrl:@"https://github.com/Muzibaoyu91"];
        }else if (indexPath.row == 1){
            [self openUrl:@"https://github.com/jerryleooo"];
        }else if (indexPath.row == 2){
            if ([MFMailComposeViewController canSendMail]) { // 用户已设置邮件账户
                [self sendEmailActionWithEmail:@"895133318@qq.com"]; // 调用发送邮件的代码
            }else{
                [self openUrlToSendEmailWithEmail:@"895133318@qq.com"];
            }
        }else if (indexPath.row == 3){
            if ([MFMailComposeViewController canSendMail]) { // 用户已设置邮件账户
                [self sendEmailActionWithEmail:@"jixiaokang1992@126.com"]; // 调用发送邮件的代码
            }else{
                [self openUrlToSendEmailWithEmail:@"jixiaokang1992@126.com"];
            }
        }
    }
}


#pragma mark - function
- (void)sendEmailActionWithEmail:(NSString *)Email
{
    // 邮件服务器
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    // 设置邮件代理
    [mailCompose setMailComposeDelegate:self];
    
    // 设置邮件主题
//    [mailCompose setSubject:@"AskInstask"];
    
    // 设置收件人
    [mailCompose setToRecipients:@[Email]];
    // 设置抄送人
    //    [mailCompose setCcRecipients:@[@"邮箱号码"]];
    // 设置密抄送
    //    [mailCompose setBccRecipients:@[@"邮箱号码"]];
    
    /**
     *  设置邮件的正文内容
     */
//    NSString *emailContent = @"Hi,I'm instasker.";
    // 是否为HTML格式
//    [mailCompose setMessageBody:emailContent isHTML:NO];
    // 如使用HTML格式，则为以下代码
    //    [mailCompose setMessageBody:@"<html><body><p>Hello</p><p>World！</p></body></html>" isHTML:YES];
    
    /**
     *  添加附件
     */
    //    UIImage *image = [UIImage imageNamed:@"image"];
    //    NSData *imageData = UIImagePNGRepresentation(image);
    //    [mailCompose addAttachmentData:imageData mimeType:@"" fileName:@"custom.png"];
    //
    //    NSString *file = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"pdf"];
    //    NSData *pdf = [NSData dataWithContentsOfFile:file];
    //    [mailCompose addAttachmentData:pdf mimeType:@"" fileName:@"7天精通IOS233333"];
    
    // 弹出邮件发送视图
    [self presentViewController:mailCompose animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    
    NSString *showStr;
    
    switch (result)
    {
        case MFMailComposeResultCancelled: // 用户取消编辑
            showStr = @"用户取消发送...";
            break;
        case MFMailComposeResultSaved: // 用户保存邮件
            showStr = @"用户保存邮件...";
            break;
        case MFMailComposeResultSent: // 用户点击发送
            showStr = @"用户发送中...";
            break;
        case MFMailComposeResultFailed: // 用户尝试保存或发送邮件失败
            showStr = [NSString stringWithFormat:@"发送失败: %@...", [error localizedDescription]];
            break;
    }
    
    
    [self showHUDWithTitle:showStr];
    
    
    // 关闭邮件发送视图
    [self dismissViewControllerAnimated:YES completion:nil];
}

//  打开网页发邮件
- (void)openUrlToSendEmailWithEmail:(NSString *)Email{
    NSMutableString *mailUrl = [[NSMutableString alloc] init];
    
    [mailUrl appendFormat:@"mailto:%@", Email];
    
//    [mailUrl appendString:@"?subject=AskInstask"];
//    [mailUrl appendString:@"&body=Hi,I'm instasker."];
    
    NSString *emailPath = [mailUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:emailPath]];

}

//  打开我们的twitter主页
- (void)openUrl:(NSString *)url{
    NSString *ourTwitter = url;
    
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.url = [NSURL URLWithString:ourTwitter];
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}


@end
