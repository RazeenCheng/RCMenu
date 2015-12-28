//
//  RCMenu.m
//  RCMenu
//
//  Created by Razeen on 12/28/15.
//  Copyright © 2015 razeen. All rights reserved.
//

#import "RCMenu.h"

#define RCMenuHeight 40.0
#define MenuBtnWidth 80.0
#define Define_Tag_add 1000
#define UIColorFromRGBValue(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#pragma mark- use delegate

@interface RCMenuByDelegate ()

@property (strong, nonatomic)UIScrollView *scrollView;
@property (strong, nonatomic)NSMutableArray *array4Btn;
@property (strong, nonatomic)UIView *bottomLineView;

@end
@implementation RCMenuByDelegate

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}




- (id)initWithOriginY:(CGFloat)y Titles:(NSArray *)titles delegate:(id)delegate
{
    CGRect rect4View = CGRectMake(0.0f, y, RCWidth, RCMenuHeight);
    if (self = [super initWithFrame:rect4View]) {
        
        self.backgroundColor = UIColorFromRGBValue(0xf3f3f3);
        [self setUserInteractionEnabled:YES];
        
        self.delegate = delegate;
    
        _array4Btn = [[NSMutableArray alloc] initWithCapacity:[titles count]];
        
        CGFloat width4btn = rect4View.size.width/[titles count];
        if (width4btn < MenuBtnWidth) {
            width4btn = MenuBtnWidth;
        }
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = self.backgroundColor;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.contentSize = CGSizeMake([titles count]*width4btn, RCMenuHeight);
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        _scrollView.alwaysBounceHorizontal = YES;
        
        for (int i = 0; i<[titles count]; i++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i*width4btn, .0f, width4btn, RCMenuHeight);
            [btn setTitleColor:UIColorFromRGBValue(0x999999) forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:16];
            [btn setTitleColor:UIColorFromRGBValue(0x454545) forState:UIControlStateSelected];
            [btn setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(menuSelectedChange:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = Define_Tag_add+i;
            [_scrollView addSubview:btn];
            [_array4Btn addObject:btn];
            
            if (i == 0) {
                btn.selected = YES;
            }
        }
        
        //  lineView
        CGFloat height4Line = RCMenuHeight/3.0f;
        CGFloat originY = (RCMenuHeight - height4Line)/2;
        for (int i = 1; i<[titles count]; i++) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(i*width4btn-1.0f, originY, 1.0f, height4Line)];
            //            lineView.backgroundColor = UIColorFromRGBValue(0xcccccc);
            lineView.backgroundColor = [UIColor redColor];
            [_scrollView addSubview:lineView];
        }
        
        //
        //  bottom lineView
        //
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(5.0f, RCMenuHeight-1, width4btn-10.0f, 1.0f)];
        //        _bottomLineView.backgroundColor = UIColorFromRGBValue(0x454545);
        _bottomLineView.backgroundColor = [UIColor redColor];
        [_scrollView addSubview:_bottomLineView];
        
        [self addSubview:_scrollView];
    }
    return self;
}

//
//  btn clicked
//
- (void)menuSelectedChange:(UIButton *)btn
{
    btn.selected = YES;
    for (UIButton *subBtn in self.array4Btn) {
        if (subBtn != btn) {
            subBtn.selected = NO;
        }
    }
    
    CGRect rect4boottomLine = self.bottomLineView.frame;
    rect4boottomLine.origin.x = btn.frame.origin.x +5;
    
    CGPoint pt = CGPointZero;
    BOOL canScrolle = NO;
    if ((btn.tag - Define_Tag_add) >= 2 && [_array4Btn count] > 4 && [_array4Btn count] > (btn.tag - Define_Tag_add + 2)) {
        pt.x = btn.frame.origin.x - MenuBtnWidth*1.5f;
        canScrolle = YES;
    }else if ([_array4Btn count] > 4 && (btn.tag - Define_Tag_add + 2) >= [_array4Btn count]){
        pt.x = (_array4Btn.count - 4) * MenuBtnWidth;
        canScrolle = YES;
    }else if (_array4Btn.count > 4 && (btn.tag - Define_Tag_add) < 2){
        pt.x = 0;
        canScrolle = YES;
    }
    
    if (canScrolle) {
        [UIView animateWithDuration:0.3 animations:^{
            _scrollView.contentOffset = pt;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.bottomLineView.frame = rect4boottomLine;
            }];
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.bottomLineView.frame = rect4boottomLine;
        }];
    }
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(RCMenuSelectAtIndex:)]) {
        [self.delegate RCMenuSelectAtIndex:btn.tag - 1000];
    }
    
    
}


//index 从 0 开始
- (void)menuSelectedAtIndex:(NSInteger)index
{
    if (index > [_array4Btn count]-1) {
        NSLog(@"index 超出范围");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"index 超出范围" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        [alertView show];
        return;
    }
    
    UIButton *btn = [_array4Btn objectAtIndex:index];
    [self menuSelectedChange:btn];
    
}

@end


#pragma mark - use block
@interface RCMenuByBlock ()

@property (strong, nonatomic)UIScrollView *scrollView;
@property (strong, nonatomic)NSMutableArray *array4Btn;
@property (strong, nonatomic)UIView *bottomLineView;

@end


@implementation RCMenuByBlock

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithOriginY:(CGFloat)y Titles:(NSArray *)titles{
    
    CGRect rect4View = CGRectMake(0.0f, y, RCWidth, RCMenuHeight);
    if (self = [super initWithFrame:rect4View]) {
        
        self.backgroundColor = UIColorFromRGBValue(0xf3f3f3);
        [self setUserInteractionEnabled:YES];
        
        
        _array4Btn = [[NSMutableArray alloc] initWithCapacity:[titles count]];
        
        CGFloat width4btn = rect4View.size.width/[titles count];
        if (width4btn < MenuBtnWidth) {
            width4btn = MenuBtnWidth;
        }
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = self.backgroundColor;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.contentSize = CGSizeMake([titles count]*width4btn, RCMenuHeight);
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        _scrollView.alwaysBounceHorizontal = YES;
        
        for (int i = 0; i<[titles count]; i++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i*width4btn, .0f, width4btn, RCMenuHeight);
            [btn setTitleColor:UIColorFromRGBValue(0x999999) forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:16];
            [btn setTitleColor:UIColorFromRGBValue(0x454545) forState:UIControlStateSelected];
            [btn setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(menuSelectedChange:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = Define_Tag_add+i;
            [_scrollView addSubview:btn];
            [_array4Btn addObject:btn];
            
            if (i == 0) {
                btn.selected = YES;
            }
        }
        
        //  lineView
        CGFloat height4Line = RCMenuHeight/3.0f;
        CGFloat originY = (RCMenuHeight - height4Line)/2;
        for (int i = 1; i<[titles count]; i++) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(i*width4btn-1.0f, originY, 1.0f, height4Line)];
            //            lineView.backgroundColor = UIColorFromRGBValue(0xcccccc);
            lineView.backgroundColor = [UIColor redColor];
            [_scrollView addSubview:lineView];
        }
        
        //
        //  bottom lineView
        //
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(5.0f, RCMenuHeight-1, width4btn-10.0f, 1.0f)];
        //        _bottomLineView.backgroundColor = UIColorFromRGBValue(0x454545);
        _bottomLineView.backgroundColor = [UIColor redColor];
        [_scrollView addSubview:_bottomLineView];
        
        [self addSubview:_scrollView];
    }
    return self;
}



//
//  btn clicked
//
- (void)menuSelectedChange:(UIButton *)btn
{
    btn.selected = YES;
    for (UIButton *subBtn in self.array4Btn) {
        if (subBtn != btn) {
            subBtn.selected = NO;
        }
    }
    
    CGRect rect4boottomLine = self.bottomLineView.frame;
    rect4boottomLine.origin.x = btn.frame.origin.x +5;
    
    CGPoint pt = CGPointZero;
    BOOL canScrolle = NO;
    if ((btn.tag - Define_Tag_add) >= 2 && [_array4Btn count] > 4 && [_array4Btn count] > (btn.tag - Define_Tag_add + 2)) {
        pt.x = btn.frame.origin.x - MenuBtnWidth*1.5f;
        canScrolle = YES;
    }else if ([_array4Btn count] > 4 && (btn.tag - Define_Tag_add + 2) >= [_array4Btn count]){
        pt.x = (_array4Btn.count - 4) * MenuBtnWidth;
        canScrolle = YES;
    }else if (_array4Btn.count > 4 && (btn.tag - Define_Tag_add) < 2){
        pt.x = 0;
        canScrolle = YES;
    }
    
    if (canScrolle) {
        [UIView animateWithDuration:0.3 animations:^{
            _scrollView.contentOffset = pt;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.bottomLineView.frame = rect4boottomLine;
            }];
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.bottomLineView.frame = rect4boottomLine;
        }];
    }
    
    self.selectedItemBlock(btn.tag - 1000);
}


//index 从 0 开始
- (void)menuSelectedAtIndex:(NSInteger)index
{
    if (index > [_array4Btn count]-1) {
        NSLog(@"index 超出范围");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"index 超出范围" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        [alertView show];
        return;
    }
    
    UIButton *btn = [_array4Btn objectAtIndex:index];
    [self menuSelectedChange:btn];
    
}


@end
