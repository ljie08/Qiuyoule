//
//  MXPersonalInformationViewController.m
//  MXFootBall
//
//  Created by Mac on 2018/3/7.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXPersonalInformationViewController.h"
#import "MXAlertNameAndSignViewController.h"
#import "MXssPersonalAccountViewController.h"//账户绑定页面
#import <TZImagePickerController.h>
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import <TZImageManager.h>
#import "TZVideoPlayerController.h"

#define TabBarHeight 49
/////<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate
@interface MXPersonalInformationViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    UIScrollView *applicationSV;
    UIImagePickerController *imagePicker;
}
//相册
//@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@end


@implementation MXPersonalInformationViewController
@synthesize imgHeader;
@synthesize image;
@synthesize dic;
@synthesize hysXingbie;//性别显示
@synthesize hysNickName;//昵称
@synthesize hysQianmingName;//签名

- (void)viewDidLoad {
    [super viewDidLoad];
    //     _selectedPhotosModifyHead = [NSMutableArray array];
    //    self.title = @"个人信息";
    //    // Do any additional setup after loading the view.
    //    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden=YES;//不显示下面的tabbar
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupUI];
}

- (void)setupUI {
    CGFloat border = 1.0f;
    // 背景ScrollView
    [applicationSV removeFromSuperview];
    applicationSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    applicationSV.showsVerticalScrollIndicator = YES;
    applicationSV.showsVerticalScrollIndicator = NO;
    applicationSV.backgroundColor = mx_Wode_backgroundColor;
    applicationSV.scrollEnabled = YES;
    [self.view addSubview:applicationSV];
    MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
    CGFloat viewHeight = scaleWithSize(44.0f);
    
    UIView *viewComPro = [[UIView alloc] initWithFrame:CGRectMake(0, scaleWithSize(4), screen_width, viewHeight)];
    viewComPro.backgroundColor = [UIColor whiteColor];
    [applicationSV addSubview:viewComPro];
    [self addSubDetailViews:viewComPro iconName:@"" iconLeft:scaleWithSize(15) title:@"头像" titleLeft:scaleWithSize(15) hint:@""];
    UITapGestureRecognizer *tapViewComPro = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewHeaderClick:)];
    [viewComPro addGestureRecognizer:tapViewComPro];
    
    UIView *viewNickName = [[UIView alloc] initWithFrame:CGRectMake(0, viewComPro.frame.origin.y + viewComPro.frame.size.height + border, screen_width, viewHeight)];
    viewNickName.backgroundColor = [UIColor whiteColor];
    [applicationSV addSubview:viewNickName];
    [self addSubDetailViews:viewNickName iconName:@"" iconLeft:scaleWithSize(15) title:@"昵称" titleLeft:scaleWithSize(15) hint:[NSString stringWithFormat:@"%@",userModel.username ]];
    UITapGestureRecognizer *tapviewNickName = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewNickNameClick:)];
    [viewNickName addGestureRecognizer:tapviewNickName];
    
    UIView *viewGender = [[UIView alloc] initWithFrame:CGRectMake(0, viewNickName.frame.origin.y + viewNickName.frame.size.height + border, screen_width, viewHeight)];
    viewGender.backgroundColor = [UIColor whiteColor];
    [applicationSV addSubview:viewGender];
    [self addSubDetailViews:viewGender iconName:@"" iconLeft:scaleWithSize(15) title:@"性别" titleLeft:scaleWithSize(15) hint:[NSString stringWithFormat:@""]];
    UITapGestureRecognizer *tapViewContactus = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewGenderClick:)];
    [viewGender addGestureRecognizer:tapViewContactus];
    
    UIView *viewSignature = [[UIView alloc] initWithFrame:CGRectMake(0, viewGender.frame.origin.y + viewGender.frame.size.height + border, screen_width, viewHeight)];
    viewSignature.backgroundColor = [UIColor whiteColor];
    [applicationSV addSubview:viewSignature];
    [self addSubDetailViews:viewSignature iconName:@"" iconLeft:scaleWithSize(15) title:@"签名" titleLeft:scaleWithSize(15) hint:[NSString stringWithFormat:@"%@",userModel.userSign]];
    UITapGestureRecognizer *tapviewSignature = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewSignatureClick:)];
    [viewSignature addGestureRecognizer:tapviewSignature];
    
    UIView *viewInfluence = [[UIView alloc] initWithFrame:CGRectMake(0, viewSignature.frame.origin.y + viewSignature.frame.size.height + border, screen_width, viewHeight)];
    viewInfluence.backgroundColor = [UIColor whiteColor];
    [applicationSV addSubview:viewInfluence];
    [self addSubDetailViews:viewInfluence iconName:@"" iconLeft:scaleWithSize(15) title:@"账户绑定" titleLeft:scaleWithSize(15) hint:@""];
    UITapGestureRecognizer *tapviewInfluence = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewInfluenceClick:)];
    [viewInfluence addGestureRecognizer:tapviewInfluence];
    
    applicationSV.contentSize = CGSizeMake(screen_width, viewInfluence.frame.origin.y + viewInfluence.frame.size.height + TabBarHeight);
}
#pragma mark -- Event Methods头像修改的点击
-(void)tapViewHeaderClick:(UIButton *)sender {////NSLog(@"头像修改的点击");
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertControl addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //相机权限
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus ==AVAuthorizationStatusRestricted ||//此应用程序没有被授权访问的照片数据。
            
            authStatus ==AVAuthorizationStatusDenied)  //用户已经明确否认了这一照片数据的应用程序访问
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            alert.delegate = self;
            [alert show];
            
        }else{
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                //                [self loadImage:UIImagePickerControllerSourceTypeCamera];
                imagePicker = [[UIImagePickerController alloc]init];
                imagePicker.delegate = self;
                //        imagePicker.allowsEditing = YES;//相册图片截图
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
            else
            {
//                [SVProgressHUD showErrorWithStatus:@"不支持相机"];
                NSLog(@"手机不支持相机");
            }
        }
    }]];
    [alertControl addAction:[UIAlertAction actionWithTitle:@"从手机相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //        NSLog(@"从手机相册中选择的点击=%ld",UIImagePickerControllerSourceTypePhotoLibrary);
        //获取相册访问权限
        PHAuthorizationStatus photoStatus = [PHPhotoLibrary authorizationStatus];
        
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                switch (status) {
                    case PHAuthorizationStatusAuthorized: //已获取权限
                    { UIImagePickerController *pickerControll = [[UIImagePickerController alloc] init];
                        pickerControll.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                        pickerControll.delegate = self;
                        pickerControll.allowsEditing = YES;
                        
                        [self presentViewController:pickerControll animated:YES completion:nil];
                    }
                        break;
                        
                    case PHAuthorizationStatusDenied: //用户已经明确否认了这一照片数据的应用程序访问
                    {
                        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
                        alert.tag = 1;
                        alert.delegate = self;
                        [alert show];
                    }
                        break;
                        
                    case PHAuthorizationStatusRestricted://此应用程序没有被授权访问的照片数据。可能是家长控制权限
                    {
                        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
                        alert.tag = 1;
                        alert.delegate = self;
                        [alert show];
                    }
                        break;
                    default://其他。。。
                        break;
                }
            });
        }];
        
    }]];
    [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"取消点击");
        
    }]];
    [self presentViewController:alertControl animated:YES completion:nil];
}

//监听点击事件 代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        NSString *btnTitle = [alertView buttonTitleAtIndex:buttonIndex];
        if ([btnTitle isEqualToString:@"取消"]) {
            NSLog(@"你点击了取消");
        }else if ([btnTitle isEqualToString:@"设置"] ) {
            NSLog(@"你点击了设置");
            //无权限 引导去开启
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }else {
        NSString *btnTitle = [alertView buttonTitleAtIndex:buttonIndex];
        if ([btnTitle isEqualToString:@"取消"]) {
            NSLog(@"你点击了取消");
        }else if ([btnTitle isEqualToString:@"设置"] ) {
            NSLog(@"你点击了设置");
            // 无权限 引导去开启
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                [[UIApplication sharedApplication]openURL:url];
            }
        }
        
    }
}

#pragma mark -- UIImagePickerControllerDelegate & UINavigationControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [imgHeader setImage:image];
    [self pushModelHeder];//修改头像
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"pic_100.png"]];   // 保存文件的名称
    [UIImagePNGRepresentation(image)writeToFile:filePath atomically:YES];
    [self dicPaths];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)dicPaths
{
    NSMutableArray *specialArr = [[NSMutableArray alloc] initWithCapacity:0];
    dic = [[NSMutableDictionary alloc]init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"pic_100.png"]];   // 保存文件的名称
    [dic setObject:filePath forKey:@"img"];
    [specialArr addObject:dic];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- Event Methods昵称修改的点击
-(void)tapViewNickNameClick:(UIButton *)sender {
    NSLog(@"昵称修改的点击");
    MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
    MXAlertNameAndSignViewController *alertVC = [[MXAlertNameAndSignViewController alloc]init];
    alertVC.isNameVC = YES;
    alertVC.title = @"更改名字";
    alertVC.infoString = userModel.username;
    [self.navigationController pushViewController:alertVC animated:YES];
}
#pragma mark -- Event Methods性别修改的点击
-(void)tapViewGenderClick:(UIButton *)sender {///NSLog(@"性别修改的点击");
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertControl addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"男点击");
        hysXingbie.text = @"男";
        [self dataModifyMessageSexORHeadPic:hysXingbie.text];//修改性别调用数据接口相关
    }]];
    [alertControl addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {// NSLog(@"女点击");
        hysXingbie.text = @"女";
        [self dataModifyMessageSexORHeadPic:hysXingbie.text];//修改性别调用数据接口相关
    }]];
    [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消点击");
    }]];
    [self presentViewController:alertControl animated:YES completion:nil];
}

#pragma mark -- 修改头上传修改头像
-(void)pushModelHeder {
    MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
    NSMutableDictionary *parmet = [NSMutableDictionary dictionary];
    [parmet setObject:[MXLJUtil getNowDateTimeString] forKey:@"time"];
    [parmet setObject:userModel.userId forKey:@"userId"];
    [parmet setObject:userModel.token forKey:@"token"];
    NSMutableDictionary *dict = [MXLJUtil sortedDictionary:parmet];
    //    NSLog(@"传值？？？==%@",dict);
    //    mx_weakify(self);//修改成功返回上一层
    [[MXNetWorkRequest sharedClient] uploadModifyUHeaderImages:@[image] urlString:MXWodeModifyUHeadern_PATH params:dict success:^(id responseObject) {
        NSLog(@"修改头像🍎🍊==%@",responseObject);
        MXSSToolConfig *infoModel = [MXssWodeUtils loadPersonInfo];//注意不可以 alloc
        NSDictionary *dict = (NSDictionary *)responseObject;
        if ([dict[@"code"] isEqualToString:@"0"]) {
            infoModel.headerPic = responseObject[@"data"][@"headerPic"];
            [imgHeader sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", responseObject[@"data"][@"headerPic"]]] placeholderImage:[UIImage imageNamed:@"saishi_morentouxiang"]];
            [SVProgressHUD showSuccessWithStatus:dict[@"msg"]];
            //      [weakSelf.navigationController popViewControllerAnimated:YES];修改成功返回
        }else{
            [SVProgressHUD showErrorWithStatus:dict[@"msg"]];
        }
        [MXssWodeUtils savePersonInfo:infoModel];//缓存修改的性别保存
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
}

#pragma mark --dataModifyMessageSex 数据请求 修改性别信息
- (void)dataModifyMessageSexORHeadPic:(NSString*)stringName {//数据请求 修改性别信息
    MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
    NSString *userid = [NSString stringWithFormat:@"%@",userModel.userId];//用户ID
    NSString *token = userModel.token;//用户token
    NSString *timeStr = [MXLJUtil getNowDateTimeString];//当前Unix时间戳
    
    NSString *url = MXWodemModifyUserSex_PATH;//请求接口
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:userid forKey:@"userId"];//用户ID
    [paraDic setObject:token forKey:@"token"];//用户token
    [paraDic setObject:timeStr forKey:@"time"];//当前Unix时间戳
    NSString *sex = [NSString stringWithFormat:@"%@",stringName];//修改性别
    [paraDic setObject:sex forKey:@"sex"];
    //    }
    [paraDic setObject:userid forKey:@"userId"];//用户ID
    [paraDic setObject:token forKey:@"token"];//用户token
    [paraDic setObject:timeStr forKey:@"time"];//当前Unix时间戳
    MXNetWorkConfig *config = [[MXNetWorkConfig alloc] init];
    [config ModifyPersonMessagesWithDIC:paraDic withUrl:url success:^(NSDictionary *personDic) {
        MXSSToolConfig *infoModel = [MXssWodeUtils loadPersonInfo];//注意不可以 alloc
        if ([[personDic objectForKey:@"code"] isEqualToString:@"0"]) {
            infoModel.sex = personDic[@"data"][@"sex"];//NSLog(@"sex性别修改为
            [MXssWodeUtils savePersonInfo:infoModel];//缓存修改的性别保存
            [SVProgressHUD showSuccessWithStatus:[personDic objectForKey:@"msg"]];
        }else {
            [SVProgressHUD showErrorWithStatus:[personDic objectForKey:@"msg"]];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showSuccessWithStatus:error];
    }];
}

#pragma mark -- Event Methods签名修改的点击
-(void)tapViewSignatureClick:(UIButton *)sender {
    MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
    MXAlertNameAndSignViewController *alertVC = [[MXAlertNameAndSignViewController alloc]init];
    alertVC.isNameVC = NO;
    alertVC.title = @"签名";
    alertVC.infoString = userModel.userSign;
    
    [self.navigationController pushViewController:alertVC animated:YES];
}
#pragma mark -- Event Methods  账户绑定、  影响力修改的点击
-(void)tapViewInfluenceClick:(UIButton *)sender {//账户绑定
    MXssPersonalAccountViewController *zhanghuView = [[MXssPersonalAccountViewController alloc] init];
    zhanghuView.title = @"账户绑定";
    [self.navigationController pushViewController:zhanghuView animated:YES];
}
//各条件view块添加详细内容
-(UILabel *)addSubDetailViews:(UIView *)parentView iconName:(NSString *)imageName iconLeft:(CGFloat)iconX title:(NSString*)titleName titleLeft:(CGFloat)titleX hint:(NSString*)hintText{
    //开头图标
    UIImageView *viewIcon = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, 0, 20, 20)];
    [parentView addSubview:viewIcon];
    viewIcon.center = CGPointMake(viewIcon.center.x, parentView.frame.size.height/2);
    [viewIcon setImage:[UIImage imageNamed:imageName]];
    
    //标题
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(titleX, 0, 64, 32)];
    if ([titleName isEqualToString:@"账户绑定"]) {
        lblTitle.frame = CGRectMake(titleX, 0, 200, 32);
    }
    [parentView addSubview:lblTitle];
    lblTitle.center = CGPointMake(lblTitle.center.x, parentView.frame.size.height/2);
    lblTitle.numberOfLines = 1;
    lblTitle.text = titleName;
    lblTitle.lineBreakMode = NSLineBreakByWordWrapping;
    //lblTitle.textColor = [UIColor colorWithRed:167.0/255 green:167.0/255 blue:167.0/255 alpha:1];
    [lblTitle setTextColor:mx_Wode_color333333];
    lblTitle.backgroundColor =[UIColor clearColor];
    //    lblTitle.font = [UIFont fontWithName:@"Arial" size:15];//fontSize(14)
    lblTitle.font = fontSize(scaleWithSize(15));
    //右箭头  15*15，距离右边也是15
    UIImageView *viewArrow = [[UIImageView alloc] initWithFrame:CGRectMake(parentView.frame.size.width- scaleWithSize(13)- scaleWithSize(15), 0, scaleWithSize(8), scaleWithSize(13))];
    
    viewArrow.center = CGPointMake(viewArrow.center.x, parentView.frame.size.height/2);
    if ([titleName isEqualToString:@"我的帖子"]||[titleName isEqualToString:@""]) {
        [viewArrow setImage:[UIImage imageNamed:@""]];//不显示右边的箭头
    }else {
        [viewArrow setImage:[UIImage imageNamed:@"mxWodeRightArrow"]];
    }
    //内容，初始化时为提示文字
    CGFloat left = scaleWithSize(62);
    MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
    if ([titleName isEqualToString:@"头像"]) {
        imgHeader = [[UIImageView alloc] initWithFrame:CGRectMake(left, 5, scaleWithSize(30), scaleWithSize(30))];
        if (userModel.headerPic) {//头像
            //        [imgHeader setImage:img];
            [imgHeader sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", userModel.headerPic]] placeholderImage:[UIImage imageNamed:@"saishi_morentouxiang"]];//[UIImage imageNamed:@"pro_up_img"]
        } else {
            imgHeader.image = [UIImage imageNamed:@"saishi_morentouxiang"];
        }
        imgHeader.layer.cornerRadius = scaleWithSize(30/2.0f);
        imgHeader.layer.masksToBounds = YES;
        [parentView addSubview:imgHeader];
    }
    [parentView addSubview:viewArrow];
    
    if ([titleName isEqualToString:@"性别"]) {
        hysXingbie = [[UILabel alloc] initWithFrame:CGRectMake(left, 0, viewArrow.frame.origin.x - left + 16 - 20, 22 + 8)];
        if ([userModel.sex isEqualToString:@"男"]) {
            hysXingbie.text = @"男";
        }else if([userModel.sex isEqualToString:@"女"]){
            hysXingbie.text = @"女";
        }else {
            hysXingbie.text = @"未知";
        }
        hysXingbie.textColor = mx_Wode_color666666;
        hysXingbie.backgroundColor =[UIColor clearColor];
        hysXingbie.textAlignment = 0;
        hysXingbie.center = CGPointMake(hysXingbie.center.x, parentView.frame.size.height/2);
        hysXingbie.font = fontSize(scaleWithSize(14));
        [parentView addSubview:hysXingbie];
    }
    /*签名*/
    if ([titleName isEqualToString:@"签名"]) {
        hysQianmingName = [[UILabel alloc] initWithFrame:CGRectMake(left, 0, viewArrow.frame.origin.x - left - 4, scaleWithSize(30))];
        [parentView addSubview:hysQianmingName];
        hysQianmingName.center = CGPointMake(hysQianmingName.center.x, parentView.frame.size.height/2);
        //    hysQianmingName.text = hintText;
        hysQianmingName.textColor = mx_Wode_color666666;
        hysQianmingName.backgroundColor =[UIColor clearColor];
        hysQianmingName.textAlignment = 0;
        hysQianmingName.font = fontSize(scaleWithSize(14));
    }
    /*昵称*/
    if ([titleName isEqualToString:@"昵称"]) {
        hysNickName = [[UILabel alloc] initWithFrame:CGRectMake(left, 0, viewArrow.frame.origin.x - left - 4, scaleWithSize(30))];
        [parentView addSubview:hysNickName];
        hysNickName.center = CGPointMake(hysNickName.center.x, parentView.frame.size.height/2);
        //    hysNickName.text = hintText;
        hysNickName.textColor = mx_Wode_color666666;
        hysNickName.backgroundColor =[UIColor clearColor];
        hysNickName.textAlignment = 0;
        hysNickName.font = fontSize(scaleWithSize(14));
    }
    UILabel *lblContent = [[UILabel alloc] initWithFrame:CGRectMake(left, 0, viewArrow.frame.origin.x - left + 16 - 20, 22 + 8)];
    [parentView addSubview:lblContent];
    lblContent.center = CGPointMake(lblContent.center.x, parentView.frame.size.height/2);
    lblContent.text = hintText;
    lblContent.textColor = mx_Wode_color666666;
    lblContent.backgroundColor =[UIColor clearColor];
    lblContent.textAlignment = 0;
    //    lblContent.font = [UIFont fontWithName:@"Arial" size:15];//fontSize(scaleWithSize(14))
    lblContent.font = fontSize(scaleWithSize(14));
    return lblContent;
}

- (void)viewWillAppear:(BOOL)animated {//界面即将显示
    [super viewWillAppear:animated];
    [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"个人信息界面\"}"];
    [self initTitleViewWithTitle:@"个人信息"];
    //设置返回按钮是否显示
    [self setBackButton:YES];
}

- (void)viewWillDisappear:(BOOL)animated {//界面即将消失
    [super viewWillDisappear:animated];
    [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"个人信息界面\"}"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
