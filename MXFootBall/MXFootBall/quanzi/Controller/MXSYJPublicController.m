//
//  MXSYJPublicController.m
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/3/26.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSYJPublicController.h"
#import "MXSYJTagView.h"
#import "MXSYJTextView.h"
#import <TZImagePickerController.h>
#import <UIView+Layout.h>
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import <TZImageManager.h>
#import "TZVideoPlayerController.h"
#import "MXSYJChannelModel.h"
#import "UIView+CornerRadius.h"
#import "NSString+MXMD5.h"
#import <AssetsLibrary/AssetsLibrary.h>


static NSString * const addPhotoCel = @"addPhotoCel";


@interface MXSYJPublicController ()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    CGFloat _itemWH;
    CGFloat _margin;
    
    //channleID
    NSString *strID;
    //标题
    NSString *title;
    //内容
    NSString *content;
    
    //用户信息
    MXSSToolConfig *config;
}

//相册
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) MXSYJTagView *tagView;
@property (nonatomic, strong) MXSYJTextView *textViews;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *arrName;
@property (nonatomic, strong) NSMutableArray *arrID;

@property (nonatomic, strong) UIButton *squareBtn;

@property (nonatomic, strong) NSMutableArray *imgArr;

@property (nonatomic, copy) NSString *htmlString;

@end

@implementation MXSYJPublicController


- (void)viewWillDisappear:(BOOL)animated {//界面即将消失
    [super viewWillDisappear:animated];
    //    [UBT logTrace:@"residenceTimeOut"; content:@"{\"VC\":\"\u9996\u9875\"}";
    [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"发布文章界面\"}"];
}

- (NSMutableArray *)imgArr {
    if (!_imgArr) {
        _imgArr = [NSMutableArray array];
    }
    return _imgArr;
}

//懒加载
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height - STATUS_AND_NAVIGATION_HEIGHT - TABBAR_FRAME)];
        _scrollView.backgroundColor = mx_Wode_bordColor;
        _scrollView.pagingEnabled = NO;
        _scrollView.scrollEnabled = YES;//关闭滑动
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
//        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(screen_width, screen_height + 160);
    }
    return _scrollView;
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"发布文章界面\"}"];
    
    [self initTitleViewWithTitle:@"发布文章"];

    //设置返回按钮是否显示
    [self setBackButton:YES];
    //设置标题
//    [self initTitleViewWithTitle:@""];
    
    [IQKeyboardManager sharedManager].enable = YES;
    
    UIButton *squareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [squareBtn setTitle:@"发送" forState:UIControlStateNormal];
    [squareBtn setTitleColor:mx_redColor forState:UIControlStateNormal];
    squareBtn.titleLabel.font = fontBoldSize(13);
    [squareBtn setBackgroundColor:[UIColor whiteColor]];
    squareBtn.frame = CGRectMake(10, 10, 40, 24);
    squareBtn.layer.masksToBounds = YES;
    squareBtn.layer.cornerRadius = 3.0;
    squareBtn.tag = 2;
    [squareBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:squareBtn];
    self.squareBtn = squareBtn;
}

- (void)btnClick:(UIButton *)btn{
    
    self.squareBtn.enabled = NO;
    [self.textViews.textView endEditing:YES];
    [self.textViews.titleTextFiled endEditing:YES];
    [self printHTML];
    if ([MXssWodeUtils loadPersonInfo].userId) {
        self.htmlString = [self.htmlString filterSensitiveString];
        if (self.htmlString.length > 30 && title.length > 0 && title.length < 30) {
            
            if (![NSString stringContainsEmoji:title] && ![NSString stringContainsEmoji:content]) {
                
                [self PostImage];
            }else{
                [SVProgressHUD showInfoWithStatus:@"不能包含字符!"];
                self.squareBtn.enabled = YES;
                return;
            }
        }else{
            self.squareBtn.enabled = YES;

            if (self.htmlString.length < 30 || self.htmlString == nil) {
                [SVProgressHUD showInfoWithStatus:@"内容要大于30个字符!"];
                return;
            }else if (title.length == 0 || title == nil || title.length > 30){
                [SVProgressHUD showInfoWithStatus:@"标题要在0~30字符之间!"];
                return;
            }else{
                [SVProgressHUD showInfoWithStatus:@"参数传入失败!"];
                return;
            }
            
        }
    }else{
        MXLoginViewController *login = [[MXLoginViewController alloc] init];
        MXNavigationController *nav = [[MXNavigationController alloc] initWithRootViewController:login];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)printHTML
{
    NSString *title = [self.textViews.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('title-input').value"];
    NSString *html = [self.textViews.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('content').innerHTML"];
    NSString *script = [self.textViews.webView stringByEvaluatingJavaScriptFromString:@"window.alertHtml()"];
    [self.textViews.webView stringByEvaluatingJavaScriptFromString:script];
    NSLog(@"Title: %@", title);
    NSLog(@"Inner HTML: %@", html);
    
    if (html.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入内容" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好", nil];
        [alert show];
    }
    else
    {
        NSLog(@"1");
        _htmlString = html;
        //对输出的富文本进行处理后上传
        NSLog(@"%@",[self changeString:_htmlString]);
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = mx_Wode_bordColor;
    
    //取出数据
    self.arrName = [[NSUserDefaults standardUserDefaults] objectForKey:@"arrName"];
    self.arrID = [[NSUserDefaults standardUserDefaults] objectForKey:@"arrID"];

    [self.view addSubview:self.scrollView];
    [self setUpView];
    
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    [self configCollectionView];
    
    // Do any additional setup after loading the view.
}

#pragma mark - 设置标签文章标题
- (void)setUpView{
    
    self.tagView = [[MXSYJTagView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 140)];
    self.tagView.arr = self.arrName;
    mx_weakify(self);
    self.tagView.tagList.clickTagBlock = ^(UIButton *btn) {
        
        strID = weakSelf.arrID[btn.tag];
        
    };

    [self.scrollView addSubview:self.tagView];
    
    self.textViews = [[MXSYJTextView alloc]initWithFrame:CGRectMake(0, 160, screen_width, screen_height - scaleWithSize(200))];
    self.textViews.fiedStrBlock = ^(NSString *filedText) {
        title = filedText;
    };
    self.textViews.textViewBlcok = ^(NSString *textViewText) {
        content = textViewText;
    };
    [self.scrollView addSubview:self.textViews];
    
    UIButton *addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addImageBtn setTitle:@"添加图片" forState:UIControlStateNormal];
    [addImageBtn setBackgroundColor:mx_Wode_colorBlue2374e4];
    [addImageBtn addTarget:self action:@selector(addImageClick) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:addImageBtn];
    
    [addImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(scaleWithSize(10));
        make.width.mas_equalTo(scaleWithSize(screen_width - scaleWithSize(20)));
        make.height.mas_equalTo(scaleWithSize(40));
        make.top.mas_equalTo(self.textViews.mas_bottom).offset(scaleWithSize(10));
    }];
 
}

#pragma mark - collection

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
#pragma clang diagnostic pop
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}
#pragma mark 添加图片
- (void)addImageClick{
//    [self pushImagePickerController];
    [self addImage];
}
#pragma mark - ImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSDate *now = [NSDate date];
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    __block NSString *imageName;
    __block NSString *imagePath;
    UIImage *image;
    if ([mediaType isEqualToString:@"public.image"])
    {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        NSURL *imageRefURL = [info objectForKey:UIImagePickerControllerReferenceURL];
        
        if ([[NSString stringWithFormat:@"%@", imageRefURL] containsString:@"GIF"]) {
            
            ALAssetsLibrary* assetLibrary = [[ALAssetsLibrary alloc] init];
            void (^ALAssetsLibraryAssetForURLResultBlock)(ALAsset *) = ^(ALAsset *asset) {
                
                ALAssetRepresentation *rep = [asset defaultRepresentation];
                Byte *imageBuffer = (Byte*)malloc(rep.size);
                NSUInteger bufferSize = [rep getBytes:imageBuffer fromOffset:0.0 length:rep.size error:nil];
                NSData *imageData = [NSData dataWithBytesNoCopy:imageBuffer length:bufferSize freeWhenDone:YES];
                imageName = [NSString stringWithFormat:@"iOS%@.gif", [self stringFromDate:now]];
                imagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
                [imageData writeToFile:imagePath atomically:YES];
                [_selectedPhotos addObject:imageData];
                NSInteger userid = 12345;
                //对应自己服务器的处理方法,
                //此处是将图片上传ftp中特定位置并使用时间戳命名 该图片地址替换到html文件中去
                NSString *url = [NSString stringWithFormat:@"http://test.xxx.com/apps/kanghubang/%@/%@/%@",[NSString stringWithFormat:@"%ld",userid%1000],[NSString stringWithFormat:@"%ld",(long)userid ],imageName];
            
                NSString *script = [NSString stringWithFormat:@"window.insertImage('%@', '%@')", url, imagePath];
                
                [self.textViews.webView stringByEvaluatingJavaScriptFromString:script];
                [self dismissViewControllerAnimated:YES completion:nil];
                
            };
            
            [assetLibrary assetForURL:imageRefURL
                          resultBlock:ALAssetsLibraryAssetForURLResultBlock
                         failureBlock:^(NSError *error){
                             NSLog(@"1");
                         }];

        }else{
            [_selectedPhotos addObject:image];
            imageName = [NSString stringWithFormat:@"iOS%@.jpg", [self stringFromDate:now]];
            imagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
            NSData *imageData = UIImageJPEGRepresentation(image, 1);
            [imageData writeToFile:imagePath atomically:YES];
            NSInteger userid = 12345;
            //对应自己服务器的处理方法,
            //此处是将图片上传ftp中特定位置并使用时间戳命名 该图片地址替换到html文件中去
            NSString *url = [NSString stringWithFormat:@"http://test.xxx.com/apps/kanghubang/%@/%@/%@",[NSString stringWithFormat:@"%ld",userid%1000],[NSString stringWithFormat:@"%ld",(long)userid ],imageName];
            
            NSString *script = [NSString stringWithFormat:@"window.insertImage('%@', '%@')", url, imagePath];
            //    NSDictionary *dic = @{@"url":url,@"image":image,@"name":imageName};
            //    [self.imgArr addObject:dic];
            
            [self.textViews.webView stringByEvaluatingJavaScriptFromString:script];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }
    
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)configCollectionView {
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _margin = 4;
    _itemWH = (self.view.tz_width - 2 * _margin - 4) / 3 - _margin;
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 380, self.view.tz_width, screen_height - 200) collectionViewLayout:layout];
    //    _collectionView = [[UICollectionView alloc]init];
    //    _collectionView.collectionViewLayout = layout;
    CGFloat rgb = 244 / 255.0;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
//    [self.scrollView addSubview:_collectionView];
    //    self.collectionView.sd_layout.leftSpaceToView(self.view,10).rightSpaceToView(self.view,10).topSpaceToView(self.textView,10).bottomSpaceToView(self.view,10);
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
}

#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"luntan_jiatupian"];
        cell.deleteBtn.hidden = YES;
        cell.gifLable.hidden = YES;
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.asset = _selectedAssets[indexPath.row];
        cell.deleteBtn.hidden = NO;
        cell.gifLable.hidden = YES;
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    //cell.backgroundColor = [UIColor blackColor];
    return cell;
}
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == _selectedPhotos.count) {
//
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//        //            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
//        //#pragma clang diagnostic pop
//        //            [sheet showInView:self.view];
//
////        [self pushImagePickerController];
//
//    } else { // preview photos or video / 预览照片或者视频
//        id asset = _selectedAssets[indexPath.row];
//        BOOL isVideo = NO;
//        if ([asset isKindOfClass:[PHAsset class]]) {
//            PHAsset *phAsset = asset;
//            isVideo = phAsset.mediaType == PHAssetMediaTypeVideo;
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//        } else if ([asset isKindOfClass:[ALAsset class]]) {
//            ALAsset *alAsset = asset;
//            isVideo = [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
//#pragma clang diagnostic pop
//        }
//        if (isVideo) { // perview video / 预览视频
//            TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
//            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypeVideo timeLength:@""];
//            vc.model = model;
//            [self presentViewController:vc animated:YES completion:nil];
//        } else { // preview photos / 预览照片
//            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
//            imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
//            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//                _selectedPhotos = [NSMutableArray arrayWithArray:photos];
//                _selectedAssets = [NSMutableArray arrayWithArray:assets];
//                _isSelectOriginalPhoto = isSelectOriginalPhoto;
//                [_collectionView reloadData];
//                _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
//            }];
//            [self presentViewController:imagePickerVc animated:YES completion:nil];
//        }
//    }
//}
- (void)addImage
{
    UIImagePickerController *imagePickerController = [self imagePickerVc];
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

//#pragma mark - TZImagePickerController
//
//- (void)pushImagePickerController {
//
//    int maxCount = 9;
//
//    //加载相册初始化
//    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxCount columnNumber:4 delegate:self pushPhotoPickerVc:YES];
//
//    if (maxCount > 1) {
//        // 1.设置目前已经选中的图片数组
//        imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
//    }
//
//    // 3. Set allow picking video & photo & originalPhoto or not
//    // 3. 设置是否可以选择视频/图片/原图
//    imagePickerVc.allowPickingVideo = YES;
//    //    imagePickerVc.allowPickingImage = NO;
//    imagePickerVc.allowPickingOriginalPhoto = NO;
//    imagePickerVc.allowPickingGif = YES;
//#pragma mark - 到这里为止
//
//    // You can get the photos by block, the same as by delegate.
//    // 你可以通过block或者代理，来得到用户选择的照片.
//    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0];
//        [_imgArr addObjectsFromArray:photos];
//        for (int i = 0; i < photos.count; i++) {
//            NSDate *now = [NSDate date];
//            NSString *imageName = [NSString stringWithFormat:@"iOS%d%@.jpg", i, [self stringFromDate:now]];
//            NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
//            NSData *imageData = UIImageJPEGRepresentation(photos[i], 1);
//            [imageData writeToFile:imagePath atomically:YES];
//            NSInteger userid = 12345;
//            //对应自己服务器的处理方法,
//            //此处是将图片上传ftp中特定位置并使用时间戳命名 该图片地址替换到html文件中去
//            NSString *url = [NSString stringWithFormat:@"http://test.xxx.com/apps/kanghubang/%@/%@/%@",[NSString stringWithFormat:@"%ld",userid%1000],[NSString stringWithFormat:@"%ld",(long)userid ],imageName];
//
//            NSString *script = [NSString stringWithFormat:@"window.insertImage('%@', '%@')", url, imagePath];
////            NSDictionary *dic = @{@"url":url,@"image":photos[i],@"name":imageName};
////            [_imgArr addObject:dic];
//
//            [self.textViews.webView stringByEvaluatingJavaScriptFromString:script];
//        }
//    }];
//
//    [imagePickerVc setDidFinishPickingGifImageHandle:^(UIImage *animatedImage, id sourceAssets) {
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0];
//        NSDate *now = [NSDate date];
//        NSString *imageName = [NSString stringWithFormat:@"iOS%@.gif", [self stringFromDate:now]];
//        NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
//        NSData *imageData = UIImageJPEGRepresentation(animatedImage, 1);
//
//        [imageData writeToFile:imagePath atomically:YES];
//        NSInteger userid = 12345;
//        //对应自己服务器的处理方法,
//        //此处是将图片上传ftp中特定位置并使用时间戳命名 该图片地址替换到html文件中去
//        NSString *url = [NSString stringWithFormat:@"http://test.xxx.com/apps/kanghubang/%@/%@/%@",[NSString stringWithFormat:@"%ld",userid%1000],[NSString stringWithFormat:@"%ld",(long)userid ],imageName];
//
//        NSString *script = [NSString stringWithFormat:@"window.insertImage('%@', '%@')", url, imagePath];
//        //            NSDictionary *dic = @{@"url":url,@"image":photos[i],@"name":imageName};
//        //            [_imgArr addObject:dic];
//
//        [self.textViews.webView stringByEvaluatingJavaScriptFromString:script];
//
//    }];
//
//    [self presentViewController:imagePickerVc animated:YES completion:nil];
//}

#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
//- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
//
//}


//- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
//    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
//    _selectedAssets = [NSMutableArray arrayWithArray:assets];
//    _isSelectOriginalPhoto = isSelectOriginalPhoto;
//    [_collectionView reloadData];
//    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
//
//
//    // 1.打印图片名字
//    [self printAssetsName:assets];
//}

//上传图片
- (void)PostImage{
    
//    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_HOST,@"api/news/saveForum"];
    
    [SVProgressHUD showWithStatus:@"正在上传..."];
    
    NSMutableDictionary *parmet = [NSMutableDictionary dictionary];
    
    NSMutableArray *imgArr = [NSMutableArray array];
    for (UIImage *img in _imgArr) {
        NSData *imageData = UIImageJPEGRepresentation(img, 0.28);
        NSString *encodedImageStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSDictionary *baseDic = @{@"imgBase":encodedImageStr};
        NSString *json = [baseDic mj_JSONString];
        [imgArr addObject:json];
    }

    [parmet setObject:[MXLJUtil getNowDateTimeString] forKey:@"time"];
    [parmet setObject:[MXssWodeUtils loadPersonInfo].userId forKey:@"userId"];
    [parmet setObject:[MXssWodeUtils loadPersonInfo].token forKey:@"token"];
    if (strID) {
        [parmet setObject:strID forKey:@"channelId"];
    }else{
        [SVProgressHUD showInfoWithStatus:@"选择发布的模块!"];
        self.squareBtn.enabled = YES;
        return;
    }
    [parmet setObject:title forKey:@"title"];
    [parmet setObject:self.htmlString forKey:@"content"];
   
    NSMutableDictionary *dict = [MXLJUtil sortedDictionary:parmet];
    
    mx_weakify(self);
    [[MXNetWorkRequest sharedClient] uploadImages:_selectedPhotos urlString:MXWodemModifyfileUploadPATH params:dict success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        weakSelf.squareBtn.enabled = YES;
        [SVProgressHUD dismiss];
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        if ([dict[@"code"] isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:dict[@"msg"]];
            
            [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"isResfure"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showSuccessWithStatus:dict[@"msg"]];
        }
        
        
    } failure:^(NSError *error) {
        weakSelf.squareBtn.enabled = YES;
        NSLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"发布失败!"];
    }];
}

- (NSMutableDictionary *)sorted:(NSMutableDictionary *)dict {
    NSMutableString *contentString =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    //拼接
    for (NSString *keyStr in sortedArray) {
        NSString *valueStr = [NSString stringWithFormat:@"%@", [dict objectForKey:keyStr]];//value有可能是integer类型，转化成string再做判断
        if (![valueStr isEqualToString:@""] && ![valueStr isEqualToString:@"key"] ) {
            [contentString appendFormat:@"%@=%@&", keyStr, [dict objectForKey:keyStr]];
        }
    }
    contentString = (NSMutableString *)[contentString substringToIndex:contentString.length-1];
    NSLog(@"%@", contentString);
    
    
    return dict;
}


// If user picking a video, this callback will be called.
// If system version > iOS8,asset is kind of PHAsset class, else is ALAsset class.
// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    // open this code to send video / 打开这段代码发送视频
    // [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
    // Export completed, send video here, send by outputPath or NSData
    // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
    
    // }];
    [_collectionView reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

#pragma mark - Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
}

- (NSString *)stringFromDate:(NSDate *)date
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    return timeString;
}


#pragma mark - Private

/// 打印图片名字
- (void)printAssetsName:(NSArray *)assets {
    NSString *fileName;
    for (id asset in assets) {
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = (PHAsset *)asset;
            fileName = [phAsset valueForKey:@"filename"];
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = (ALAsset *)asset;
            fileName = alAsset.defaultRepresentation.filename;;
        }
    }
}

#pragma mark - Method
-(NSString *)changeString:(NSString *)str
{
    NSMutableArray * marr = [NSMutableArray arrayWithArray:[str componentsSeparatedByString:@"\""]];
    
    for (int i = 0; i < marr.count; i++)
    {
        NSString * subStr = marr[i];
        if ([subStr hasPrefix:@"/var"] || [subStr hasPrefix:@" id="])
        {
            [marr removeObject:subStr];
            i --;
        }
    }
    NSString * newStr = [marr componentsJoinedByString:@"\""];
    return newStr;
}

//+ (NSData *)zipGIFWithData:(NSData *)data {
//    if (!data) {
//        return nil;
//    }
//    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
//    size_t count = CGImageSourceGetCount(source);
//    UIImage *animatedImage = nil;
//    NSMutableArray *images = [NSMutableArray array];
//    NSTimeInterval duration = 0.0f;
//    for (size_t i = 0; i < count; i++) {
//        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
//        duration += [self frameDurationAtIndex:i source:source]; //[NSNumber numberWithFloat:[self frameDurationAtIndex:i source:source]];
//        UIImage *ima = [UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
////        ima = [ima zip];
//        [images addObject:ima];
//        CGImageRelease(image);
//        if (!duration) {
//            duration = (1.0f / 10.0f) * count;
//        }
//        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
//    }
//    CFRelease(source);
//    return UIImagePNGRepresentation(animatedImage);
//}
//- (CGFloat)frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
//    float frameDuration = 0.1f;
//    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
//    if (!cfFrameProperties) {
//        return frameDuration;
//    }
//    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
//    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
//
//    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
//    if (delayTimeUnclampedProp != nil) {
//        frameDuration = [delayTimeUnclampedProp floatValue];
//    } else {
//        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
//        if (delayTimeProp != nil) {
//            frameDuration = [delayTimeProp floatValue];
//        }
//    }
//
//    // Many annoying ads specify a 0 duration to make an image flash as quickly as possible.
//    // We follow Firefox's behavior and use a duration of 100 ms for any frames that specify
//    // a duration of <= 10 ms. See <rdar://problem/7689300> and <http://webkit.org/b/36082>
//    // for more information.
//
//    if (frameDuration < 0.011f) {
//        frameDuration = 0.100f;
//    }
//
//    CFRelease(cfFrameProperties);
//    return frameDuration;
//}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}




@end
