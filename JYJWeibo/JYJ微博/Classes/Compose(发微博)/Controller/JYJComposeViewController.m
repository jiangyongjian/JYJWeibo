//
//  JYJComposeViewController.m
//  JYJ微博
//
//  Created by JYJ on 15/3/15.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJComposeViewController.h"
#import "JYJEmotionTextView.h"
#import "JYJComposeToolbar.h"
#import "JYJComposePhotosView.h"
#import "MBProgressHUD+MJ.h"
#import "JYJAccountTool.h"
#import "JYJAccount.h"
#import "JYJStatusTool.h"
#import "JYJEmotionKeyboard.h"
#import "JYJEmotion.h"
#import "JYJEmotionTextView.h"

@interface JYJComposeViewController () <UITextViewDelegate, JYJComposeToolbarDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, weak) JYJEmotionTextView *textView;
@property (nonatomic, weak) JYJComposeToolbar *toolbar;
@property (nonatomic, weak) JYJComposePhotosView *photosView;
#warning 一定要用strong
/** 表情键盘 */
@property (nonatomic, strong) JYJEmotionKeyboard *keyboard;
/**
 *  是否正在切换键盘
 */
@property (nonatomic, assign, getter = isChangingKeyboard) BOOL changingKeyboard;
@end

@implementation JYJComposeViewController

-(JYJEmotionKeyboard *)keyboard
{
    if (!_keyboard) {
        
        self.keyboard = [JYJEmotionKeyboard keyboard];
        
        self.keyboard.width = JYJScreenW;
        self.keyboard.height = 216;
    }
    return _keyboard;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 设置导航条内容
    [self setupNavBar];
    
    // 添加输入控件
    [self setupTextView];
    
    // 添加工具条
    [self setupToolbar];
    
    // 添加显示图片的相册控件
    [self setupPhotosView];
  
    // 监听表情选中的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected:) name:JYJEmotionDidSelectedNotification object:nil];
    // 监听表情删除的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidDeleted:) name:JYJEmotionDidDeletedNotification object:nil];
}

// 添加显示图片的相册控件
- (void)setupPhotosView
{
    JYJComposePhotosView *photosView = [[JYJComposePhotosView alloc] init];
    photosView.width = self.textView.width;
    photosView.height = self.textView.height;
    photosView.x = 0;
    photosView.y = 70;
    
    self.photosView = photosView;
    [self.textView addSubview:photosView];
    
}

// 添加工具条
- (void)setupToolbar
{
    // 1.创建
    JYJComposeToolbar *toolbar = [[JYJComposeToolbar alloc] init];
    toolbar.width = self.view.width;
    toolbar.delegate = self;
    toolbar.height = 44;
    self.toolbar = toolbar;
    // 2.显示
    toolbar.y = self.view.height - toolbar.height;
    [self.view addSubview:toolbar];
}


// 添加输入控件
- (void)setupTextView
{
    // 1.创建输入控件
    JYJEmotionTextView *textView = [[JYJEmotionTextView alloc] init];
    textView.alwaysBounceVertical = YES;
    textView.delegate = self;
    textView.frame = self.view.bounds;
    [self.view addSubview:textView];
    self.textView = textView;
    
    // 设置文字
    textView.placehoder = @"分享新鲜事....";
    
    // 设置字体
    textView.font = [UIFont systemFontOfSize:15];
    
    // 监听键盘
    // 键盘的frame(位置)即将改变，就会发出UIKeyboardWillChangeFrameNotification
    // 键盘即将弹出，就会发出UIKeyboardWillShowNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 键盘即将隐藏，就会发出UIKeyBoardWillHideNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/**
 *  键盘即将隐藏
 */
- (void)keyboardWillHide:(NSNotification *)note
{
    if (self.isChangingKeyboard) return;
    // 1.键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 动画
    [UIView animateWithDuration:duration animations:^{
        self.toolbar.transform = CGAffineTransformIdentity;
    }];
}

/**
 *  键盘即将弹出
 */
- (void)keyboardWillShow:(NSNotification *)note
{
    // 1.键盘弹出需要的时间
    CGFloat durtion = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 动画
    [UIView animateWithDuration:durtion animations:^{
        // 取出键盘高度
        CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyboardH = keyboardF.size.height;
        self.toolbar.transform = CGAffineTransformMakeTranslation(0, -keyboardH);
    }];
}

/**
 *  view显示完毕的时候弹出键盘，避免显示控制器view显示的时候会卡主
 */
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    // 成为第一响应者（叫出键盘）
    [self.textView becomeFirstResponder];

}

// 设置导航条内容
- (void)setupNavBar
{
    NSString *name = [JYJAccountTool account].name;
    if (name) {
        // 构建文字
        NSString *prefix = @"发微博";
        NSString *text = [NSString stringWithFormat:@"%@\n%@", prefix, name];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
        [string addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:[text rangeOfString:prefix]];
        [string addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:[text rangeOfString:name]];
        
        // 创建lable
        UILabel *titleLable = [[UILabel alloc] init];
        titleLable.attributedText = string;
        titleLable.numberOfLines = 0;
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.width = 100;
        titleLable.height = 44;
        self.navigationItem.titleView = titleLable;
    }else{
        self.title = @"发微博";
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(send)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.view.backgroundColor = [UIColor whiteColor];
}

/**
 *  取消
 */
- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 *  发送
 */
- (void)send
{
    // 1.发表微博
    if (self.photosView.images.count != 0) {
        [self sendStatusWithImage];
    }else{
        [self sendStatusWithoutImage];
    }
    // 关闭控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 *  发表有图片的微博
 */

- (void)sendStatusWithImage
{
//    // 1.获取请求管理者
//    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
//    
//    // 2.封装请求参数
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"access_token"] = [JYJAccountTool account].access_token;
//    params[@"status"] = self.textView.text;
//    
//    // 3.发送POST请求
//    [mgr POST:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//#warning 目前新浪开放的发微博接口 最多 只能上传一张图片
//        UIImage *image = [self.photosView.images firstObject];
//        NSData *data = UIImageJPEGRepresentation(image, 1.0);
//        
//        [formData appendPartWithFileData:data name:@"pic" fileName:@"status.jpg" mimeType:@"image/jpeg"];
//    } success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
//        [MBProgressHUD showSuccess:@"发表成功"];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [MBProgressHUD showError:@"发表失败"];
//    }];
}
/**
 *  发表没有图片的微博
 */
- (void)sendStatusWithoutImage
{
    // 1.封装请求参数
    
    JYJSendStatusParam *param = [JYJSendStatusParam param];
    param.status = self.textView.realText;
    
    // 2.发送POST请求
    [JYJStatusTool sendStatusesWithParam:param success:^(JYJSendStatusResult *result) {
        [MBProgressHUD showSuccess:@"发表成功"];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"发表失败"];
    }];

}


#pragma mark - UITextViewDelegate
/**
 *  当用户开始拖拽scrollView时调用
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.textView endEditing:YES];
}
/**
 *  当textView的文字改变就会调用
 */
- (void)textViewDidChange:(UITextView *)textView
{
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - JYJComposeToolbarDelegate
- (void)composeToolbar:(JYJComposeToolbar *)toolBar didClickButton:(JYJComposeToolbarButtonType)buttonType
{
    switch (buttonType) {
        case JYJComposeToolbarButtonTypeCamera:
            [self openCamera];
            break;
        case JYJComposeToolbarButtonTypePicture:
            [self openAlbum];
            break;
        case JYJComposeToolbarButtonTypeMention:
            JYJLog(@"提到@");
            break;
        case JYJComposeToolbarButtonTypeTrend:
            JYJLog(@"话题");
            break;
        case JYJComposeToolbarButtonTypeEmotion:
            [self openEmotion];
            break;
    }

}

/**
 *  打开照相机
 */
- (void)openCamera
{
    if (![UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera]) return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];

}

/**
 *  打开相册
 */
- (void)openAlbum
{
    if (![UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypePhotoLibrary]) return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}
/**
 *  打开表情
 */
- (void)openEmotion
{
    // 正在切换键盘
    self.changingKeyboard = YES;
    
    if (self.textView.inputView) { // 当前显示的是自定义键盘，切换系统自带的键盘
        self.textView.inputView = nil;
        
        // 显示表情图片
        self.toolbar.showEmotionButton = YES;
    }else { // 当前显示的是系统自带的键盘，切换为自定义的键盘
        // 如果临时要更换了文本框的键盘。一定要重新打开键盘
        self.textView.inputView = self.keyboard;
        
        // 不显示表情图片
        self.toolbar.showEmotionButton = NO;
    }
    
    // 关闭键盘
    [self.textView resignFirstResponder];
    
#warning 记录是否正在更换键盘
    // 更换完毕完毕
    self.changingKeyboard = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 打开键盘
        [self.textView becomeFirstResponder];
    });

}
/**
 *  当表情选中的时候调用
 *
 *  @param note 里面包含了选中的表情
 */
- (void)emotionDidSelected:(NSNotification *)note
{
    JYJEmotion *emotion = note.userInfo[JYJSelectedEmotion];
    
    // 1.拼接表情
    [self.textView appendEmotion:emotion];
    
    // 2.检测文字长度
    [self textViewDidChange:self.textView];
}

- (void)emotionDidDeleted:(NSNotification *)note
{
    [self.textView deleteBackward];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 取出选中的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // 2.添加图片到相册中
    [self.photosView addImage:image];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
