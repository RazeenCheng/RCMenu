//
//  ViewController.m
//  RCMenu
//
//  Created by Razeen on 12/28/15.
//  Copyright © 2015 razeen. All rights reserved.
//

#import "ViewController.h"
#import "RCMenu.h"

@interface ViewController ()<RCMenuDelegate,UIScrollViewDelegate>{
    NSArray *_menuArray;
}


@property (nonatomic, strong)RCMenu *menu;
@property (nonatomic, strong) UIScrollView *ScrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _menuArray = @[@"小区生活",@"饭后杂坛",@"食尽天下",@"运动健身",@"旅游出行",@"育儿心经",@"情感生活",@"物业攻略",@"装饰装修"];
    
    [self text1];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - 利用协议
- (void)text1{
    
    
    //菜单
    self.menu = [[RCMenu alloc]initWithOriginY:64 Titles:_menuArray delegate:self];
    [self.view addSubview:self.menu];
    
    
    self.ScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 105, RCWidth, RCHeight)];
    self.ScrollView.contentSize = CGSizeMake(RCWidth*9, RCHeight);
    self.ScrollView.scrollEnabled = YES;
    self.ScrollView.bounces = NO;
    self.ScrollView.pagingEnabled = YES;
    self.ScrollView.showsHorizontalScrollIndicator = NO;
    self.ScrollView.showsVerticalScrollIndicator = YES;
    self.ScrollView.directionalLockEnabled = YES;
    self.ScrollView.delegate = self;
    
    [self.view addSubview:_ScrollView];
    
    for (int i = 0; i < 9; i ++) {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        label.center = CGPointMake(RCWidth * i + RCWidth /2, RCHeight/3);
        label.text =  _menuArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        [self.ScrollView addSubview:label];
    }
}


//当页面滚动时，视图跟着滚动
- (void)chageMenuWithIndex:(NSInteger)pageIndex{

    [self.menu menuSelectedAtIndex:pageIndex];
}

//当菜单滚动结束，视图跟着发生变化
- (void)RCMenuSelectAtIndex:(NSInteger)index{
    
    NSLog(@"%d",(int)index);
    
    [self.ScrollView setContentOffset:CGPointMake(index*RCWidth, 0) animated:NO];

}


//视图滚动结束时的位置
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int pageIndex = scrollView.contentOffset.x / scrollView.frame.size.width ;
    
    [self chageMenuWithIndex:pageIndex];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
