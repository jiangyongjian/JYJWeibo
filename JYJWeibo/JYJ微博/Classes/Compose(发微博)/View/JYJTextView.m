//
//  JYJTextView.m
//  JYJ微博
//
//  Created by JYJ on 15/3/19.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJTextView.h"


@interface JYJTextView ()
@property (nonatomic, weak) UILabel *placehoderLable;

@end
@implementation JYJTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        // 添加一个显示提醒文字的lable
        UILabel *placehoderLable = [[UILabel alloc] init];
        placehoderLable.backgroundColor = [UIColor clearColor];
        
        [self addSubview:placehoderLable];
        self.placehoderLable = placehoderLable;
        // 设置默认的占位文字颜色
        self.placehoderColor = [UIColor lightGrayColor];
        
        // 设置默认的字体
        self.font = [UIFont systemFontOfSize:14];
#warning 不要设置自己的代理为自己本身 
        // 监听内部文字的改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
        
    }
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 监听文字改变
- (void)textDidChange
{
    // text属性：只包括普通的文本字符串
    // attributedText：包括了显示在textView里面的所有内容（表情、text）
    self.placehoderLable.hidden = self.hasText;
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    [self textDidChange];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self textDidChange];
}

- (void)setPlacehoder:(NSString *)placehoder
{
#warning 如果是copy策略，setter最好这么写
    _placehoder = [placehoder copy];
    // 设置文字
    self.placehoderLable.text = placehoder;
    // 重新计算子控件
    [self setNeedsLayout];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    self.placehoderLable.font = font;
    // 重新计算子控件的frame
    [self setNeedsLayout];
}
- (void)setPlacehoderColor:(UIColor *)placehoderColor
{
    _placehoderColor = placehoderColor;
    // 设置颜色
    self.placehoderLable.textColor = placehoderColor;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.placehoderLable.x = 5;
    self.placehoderLable.y = 8;
    self.placehoderLable.width = self.width - 2 * self.placehoderLable.x;
    // 根据文字计算label的高度
    CGSize maxSize = CGSizeMake(self.placehoderLable.width, MAXFLOAT);
    CGSize placehoderSize = [self.placehoder sizeWithFont:self.placehoderLable.font constrainedToSize:maxSize];
    self.placehoderLable.height = placehoderSize.height;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
