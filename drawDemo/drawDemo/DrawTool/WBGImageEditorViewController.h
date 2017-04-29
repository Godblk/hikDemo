//
//  WBGImageEditorViewController.h
//  CLImageEditorDemo
//
//  Created by Jason on 2017/2/27.
//  Copyright © 2017年 CALACULU. All rights reserved.
//

#import "WBGImageEditor.h"

typedef NS_ENUM(NSUInteger, EditorMode) {
    EditorNonMode,
    EditorDrawMode,
    EditorTextMode,
    EditorClipMode,
};

extern NSString * const kColorPanNotificaiton;

@interface WBGImageEditorViewController : WBGImageEditor
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *undoButton;
@property (strong,   nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImageView *drawingView;
@property (strong, nonatomic) UIScrollView *scrollView;

@property (nonatomic, assign) EditorMode currentMode;

- (void)resetCurrentTool;

- (void)hiddenTopAndBottomBar:(BOOL)isHide animation:(BOOL)animation;
@end
