//
//  ViewController.m
//  yytextdemo
//
//  Created by 张行舟 on 2017/7/29.
//  Copyright © 2017年 zxz. All rights reserved.
//

#import "YYText.h"
#import "ViewController.h"

@interface ViewController ()
<YYTextViewDelegate>
@property (nonatomic ,assign) BOOL isEditing;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    YYTextView *textView = [YYTextView new];
    textView.frame = CGRectMake(0, 100, 250, 250);
    textView.selectable = false;
    textView.editable = false;
    textView.delegate = self;
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    NSArray *tags = @[@"red", @"orange", @"yellow", @"grveen", @"blue", @"purple", @"gray"];
    UIFont *font = [UIFont boldSystemFontOfSize:16];
    for (int i = 0; i < tags.count; i++) {
        NSString *tag = tags[i];
        
        NSMutableAttributedString *tagText = [[NSMutableAttributedString alloc] initWithString:tag];
        [tagText yy_insertString:@"   " atIndex:0];
        [tagText yy_appendString:@"   "];
        tagText.yy_font = font;
        tagText.yy_color = [UIColor whiteColor];
        [tagText yy_setTextBinding:[YYTextBinding bindingWithDeleteConfirm:false] range:tagText.yy_rangeOfAll];
        
        YYTextBorder *border = [YYTextBorder new];
        border.strokeWidth = 0;
        border.strokeColor = [UIColor redColor];
        border.fillColor = [UIColor redColor];
        border.cornerRadius = 100; // a huge value
        border.insets = UIEdgeInsetsMake(-2, -5.5, -2, -8);
        [tagText yy_setTextBackgroundBorder:border range:[tagText.string rangeOfString:tag]];
        
        
        YYTextHighlight *hight = [YYTextHighlight new];
        YYTextBorder *hightBorder = [border copy];
        hightBorder.fillColor = [UIColor blueColor];
        hightBorder.strokeColor = [UIColor blueColor];
        [hight setBackgroundBorder:hightBorder];
        [tagText yy_setTextHighlight:hight range:tagText.yy_rangeOfAll];
        [text appendAttributedString:tagText];
    }
    
    text.yy_lineSpacing = 10;
    text.yy_lineBreakMode = NSLineBreakByWordWrapping;
    [text appendAttributedString:text]; // repeat for test
    
    textView.attributedText = text;
    textView.backgroundColor = [UIColor grayColor];
    [UIView animateWithDuration:0.3 animations:^{
        textView.frame = CGRectMake(0, 100, 250, textView.textLayout.textBoundingSize.height);
    }];
    [self.view addSubview:textView];
}
- (BOOL)textView:(YYTextView *)textView shouldTapHighlight:(YYTextHighlight *)highlight inRange:(NSRange)characterRange{
    return YES;
}
- (void)textViewDidChangeSelection:(YYTextView *)textView {
    textView.selectedRange = NSMakeRange(textView.text.length-1, 0);
}

- (void)textViewDidBeginEditing:(YYTextView *)textView {
    self.isEditing = YES;
}
- (void)textViewDidEndEditing:(YYTextView *)textView {
    self.isEditing = false;
}

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text containsString:@","]) {
        return YES;
    }
    return !self.isEditing;
}

- (void)textView:(YYTextView *)textView didTapHighlight:(YYTextHighlight *)highlight inRange:(NSRange)characterRange rect:(CGRect)rect{
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:textView.attributedText];
    [string replaceCharactersInRange:characterRange withString:@""];
    textView.attributedText = string;
    [UIView animateWithDuration:0.3 animations:^{
        textView.frame = CGRectMake(0, 100, 250, textView.textLayout.textBoundingSize.height);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
