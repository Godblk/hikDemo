//
//  WBGImageEditorViewController.m
//  CLImageEditorDemo
//
//  Created by Jason on 2017/2/27.
//  Copyright © 2017年 CALACULU. All rights reserved.
//

#import "WBGImageEditorViewController.h"
#import "WBGImageToolBase.h"
#import "WBGDrawTool.h"
#import "WBGImageEditor.h"
#import "Masonry.h"
#import "CALayer+Extension.h"
#import "UIView+Extension.h"
#import "UIImage+Extension.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

static const CGFloat kTopBarHeight = 64.0f;
static const CGFloat kBottomBarHeight = 64.0f;
NSString * const kColorPanNotificaiton = @"kColorPanNotificaiton";
#pragma mark - WBGImageEditorViewController

@interface WBGImageEditorViewController () <UINavigationBarDelegate, UIScrollViewDelegate>
@property (nonatomic, strong, nullable) WBGImageToolBase *currentTool;
@property (strong, nonatomic) UIView *bottomBar;
@property (strong, nonatomic) UIView *topBar;


@property (strong, nonatomic) UIView *topBannerView;
@property (strong, nonatomic) UIView *bottomBannerView;
@property (strong, nonatomic) UIView *leftBannerView;
@property (strong, nonatomic) UIView *rightBannerView;

@property (strong, nonatomic) UIView       *contentView;

@property (strong, nonatomic) UIButton *sendButton;
@property (strong, nonatomic) UIButton *panButton;

@property (nonatomic, strong) WBGDrawTool *drawTool;

@property (nonatomic, copy  ) UIImage   *originImage;

@property (nonatomic, assign) CGFloat clipInitScale;
@property (nonatomic, assign) BOOL barsHiddenStatus;

@end

@implementation WBGImageEditorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)init
{
    if (self){
        
    }
    return self;
}

- (id)initWithImage:(UIImage *)image
{
    return [self initWithImage:image delegate:nil];
}

- (id)initWithImage:(UIImage*)image delegate:(id<WBGImageEditorDelegate>)delegate
{
    self = [self init];
    if (self){
        _originImage = image;
        self.delegate = delegate;
    }
    return self;
}

- (id)initWithDelegate:(id<WBGImageEditorDelegate>)delegate
{
    self = [self init];
    if (self){
        
        self.delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.currentTool = self.drawTool;
    self.undoButton.hidden = YES;
    [self initUI];
    [self initImageScrollView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.panButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    });
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //ShowBusyIndicatorForView(self.view);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      //  HideBusyIndicatorForView(self.view);
        [self refreshImageView];
    });
}

- (UIView *)topBannerView {
    if (!_topBannerView) {
        _topBannerView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = self.scrollView.backgroundColor;
            [self.imageView.superview addSubview:view];
            view;
        });
    }
    
    return _topBannerView;
}

- (UIView *)bottomBannerView {
    if (!_bottomBannerView) {
        _bottomBannerView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = self.scrollView.backgroundColor;
            [self.imageView.superview addSubview:view];
            view;
        });
    }
    return _bottomBannerView;
}

- (UIView *)leftBannerView {
    if (!_leftBannerView) {
        _leftBannerView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = self.scrollView.backgroundColor;
            [self.imageView.superview addSubview:view];
            view;
        });
    }
    
    return _leftBannerView;
}

- (UIView *)rightBannerView {
    if (!_rightBannerView) {
        _rightBannerView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = self.scrollView.backgroundColor;
            [self.imageView.superview addSubview:view];
            view;
        });
    }
    
    return _rightBannerView;
}

#pragma mark - 初始化 &getter
- (void)initUI {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.imageView];
    self.drawingView = [[UIImageView alloc] init];
    self.drawingView.contentMode = UIViewContentModeCenter;
    self.drawingView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    [self.contentView addSubview:self.drawingView];
    
    [self.view addSubview:self.topBar];
    [self.topBar addSubview:self.backButton];
    [self.topBar addSubview:self.undoButton];
    [self.topBar addSubview:self.panButton];
    [self.view addSubview:self.bottomBar];
    [self.bottomBar addSubview:self.sendButton];
    [self layoutChildViews];
}

- (void)layoutChildViews {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.drawingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.topBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(@(kTopBarHeight));
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topBar);
        make.left.equalTo(self.topBar).offset(10);
    }];
    
    [self.panButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topBar);
        make.right.equalTo(self.topBar).offset(-10);
    }];
    
    [self.undoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topBar);
        make.right.equalTo(self.panButton.mas_left).offset(-10);
    }];
    
    [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(@(kBottomBarHeight));
    }];
    
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bottomBar);
    }];
}

- (WBGDrawTool *)drawTool {
    if (_drawTool == nil) {
        _drawTool = [[WBGDrawTool alloc] initWithImageEditor:self];
        
        __weak typeof(self)weakSelf = self;
        _drawTool.drawToolStatus = ^(BOOL canPrev) {
            if (canPrev) {
                weakSelf.undoButton.hidden = NO;
            } else {
                weakSelf.undoButton.hidden = YES;
            }
        };
        _drawTool.drawingCallback = ^(BOOL isDrawing) {
            [weakSelf hiddenTopAndBottomBar:isDrawing animation:YES];
        };
        _drawTool.drawingDidTap = ^(void) {
            [weakSelf hiddenTopAndBottomBar:!weakSelf.barsHiddenStatus animation:YES];
        };
    }
    
    return _drawTool;
}

- (void)initImageScrollView {
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.clipsToBounds = NO;
    self.scrollView.backgroundColor = [UIColor blackColor];

}

- (void)refreshImageView {
    if (self.imageView.image == nil) {
        self.imageView.image = self.originImage;
    }
    
    [self resetImageViewFrame];
    [self resetZoomScaleWithAnimated:NO];
}

- (void)resetImageViewFrame {
    CGSize size = (_imageView.image) ? _imageView.image.size : _imageView.frame.size;
    if(size.width > 0 && size.height > 0 ) {
        CGFloat ratio = MIN(_scrollView.frame.size.width / size.width, _scrollView.frame.size.height / size.height);
        CGFloat W = ratio * size.width * _scrollView.zoomScale;
        CGFloat H = ratio * size.height * _scrollView.zoomScale;
        
        _imageView.frame = CGRectMake(MAX(0, (_scrollView.width-W)/2), MAX(0, (_scrollView.height-H)/2), W, H);
    }
    self.topBannerView.frame = CGRectMake(0, 0, self.imageView.width, CGRectGetMinY(self.imageView.frame));
    self.bottomBannerView.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame), self.imageView.width, self.drawingView.height - CGRectGetMaxY(self.imageView.frame));
    self.leftBannerView.frame = CGRectMake(0, 0, CGRectGetMinX(self.imageView.frame), self.drawingView.height);
    self.rightBannerView.frame= CGRectMake(CGRectGetMaxX(self.imageView.frame), 0, self.drawingView.width - CGRectGetMaxX(self.imageView.frame), self.drawingView.height);
}

- (void)resetZoomScaleWithAnimated:(BOOL)animated
{
    CGFloat Rw = _scrollView.frame.size.width / _imageView.frame.size.width;
    CGFloat Rh = _scrollView.frame.size.height / _imageView.frame.size.height;
    
    //CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat scale = 1;
    Rw = MAX(Rw, _imageView.image.size.width / (scale * _scrollView.frame.size.width));
    Rh = MAX(Rh, _imageView.image.size.height / (scale * _scrollView.frame.size.height));
    
    _scrollView.contentSize = _imageView.frame.size;
    _scrollView.minimumZoomScale = 1;
    _scrollView.maximumZoomScale = MAX(MAX(Rw, Rh), 3);
    
    [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:animated];
    [self scrollViewDidZoom:_scrollView];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark- ScrollView delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView.superview;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{ }

#pragma mark - Actions
///发送
- (IBAction)sendAction:(UIButton *)sender {

    [self buildClipImageShowHud:YES clipedCallback:^(UIImage *clipedImage) {
        if ([self.delegate respondsToSelector:@selector(imageEditor:didFinishEdittingWithImage:)]) {
            [self.delegate imageEditor:self didFinishEdittingWithImage:clipedImage];
        }
    }];
    
}

///涂鸦模式
- (IBAction)panAction:(UIButton *)sender {
    if (_currentMode == EditorDrawMode) {
        
        [self resetCurrentTool];
    }else {
        //先设置状态，然后在干别的
        self.currentMode = EditorDrawMode;
        [self.currentTool setup];
    }
    self.panButton.selected = !self.panButton.isSelected;
    
    
}

- (IBAction)backAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)undoAction:(UIButton *)sender {
    if (self.currentMode == EditorDrawMode) {
        WBGDrawTool *tool = (WBGDrawTool *)self.currentTool;
        [tool backToLastDraw];
    }
}

- (void)resetCurrentTool {
    self.currentMode = EditorNonMode;
    [self.currentTool cleanup];;
}

- (void)hiddenTopAndBottomBar:(BOOL)isHide animation:(BOOL)animation {
    if (isHide) {
        [self.topBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(-kTopBarHeight);
        }];
        
        [self.bottomBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(kBottomBarHeight);
        }];
    } else {
        [self.topBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
        }];
        
        [self.bottomBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
        }];
    }
    _barsHiddenStatus = isHide;
    [UIView animateWithDuration:animation ? .25f : 0.f delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:isHide ? UIViewAnimationOptionCurveEaseOut : UIViewAnimationOptionCurveEaseIn animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)buildClipImageShowHud:(BOOL)showHud clipedCallback:(void(^)(UIImage *clipedImage))clipedCallback {
    if (showHud) {
        //ShowBusyTextIndicatorForView(self.view, @"生成图片中...", nil);
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGFloat WS = self.imageView.width/ self.drawingView.width;
        CGFloat HS = self.imageView.height/ self.drawingView.height;
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.imageView.image.size.width, self.imageView.image.size.height),
                                               NO,
                                               self.imageView.image.scale);
        [self.imageView.image drawAtPoint:CGPointZero];
        CGFloat viewToimgW = self.imageView.width/self.imageView.image.size.width;
        CGFloat viewToimgH = self.imageView.height/self.imageView.image.size.height;
        __unused CGFloat drawX = self.imageView.left/viewToimgW;
        CGFloat drawY = self.imageView.top/viewToimgH;
        [_drawingView.image drawInRect:CGRectMake(0, -drawY, self.imageView.image.size.width/WS, self.imageView.image.size.height/HS)];
        UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //HideBusyIndicatorForView(self.view);
            UIImage *image = [UIImage imageWithCGImage:tmp.CGImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
            clipedCallback([image imageByResizeToSize:_originImage.size]);
//            clipedCallback(image);
            
        });
    });
}

#pragma mark === setter and getter
-(UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.frame = CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    return _contentView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
    }
    return _imageView;
}

- (UIView *)topBar {
    if (!_topBar) {
        _topBar = [UIView new];
        _topBar.backgroundColor = [UIColor blackColor];
    }
    return _topBar;
}
- (UIView *)bottomBar {
    if (!_bottomBar) {
        _bottomBar = [UIView new];
        _bottomBar.backgroundColor = [UIColor blackColor];
    }
    return _bottomBar;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton new];
        [_sendButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

- (UIButton *)panButton {
    if (!_panButton) {
        _panButton = [UIButton new];
        [_panButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_panButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_panButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_panButton addTarget:self action:@selector(panAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _panButton;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton new];
        [_backButton setTitle:@"返回" forState:UIControlStateNormal];
        [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)undoButton {
    if (!_undoButton) {
        _undoButton = [UIButton new];
        [_undoButton setTitle:@"撤销" forState:UIControlStateNormal];
        [_undoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_undoButton addTarget:self action:@selector(undoAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _undoButton;
}

@end

