//
//  RCMenu.h
//  RCMenu
//
//  Created by Razeen on 12/28/15.
//  Copyright © 2015 razeen. All rights reserved.
//



#import <UIKit/UIKit.h>

#define RCWidth  [UIScreen mainScreen].bounds.size.width
#define RCHeight [UIScreen mainScreen].bounds.size.height


#pragma mark - use delegate
//利用代理放回
@protocol RCMenuDelegate <NSObject>
@required
//获取当前下标
- (void)RCMenuSelectAtIndex:(NSInteger)index;
@end

@interface RCMenuByDelegate : UIView
@property (assign, nonatomic) id<RCMenuDelegate>delegate;
//初始化函数
- (id)initWithOriginY:(CGFloat)y Titles:(NSArray *)titles delegate:(id)delegate;
//提供方法改变 index
- (void)menuSelectedAtIndex:(NSInteger)index;
@end

#pragma mark -use block

//利用block选择
typedef void(^RCMenuBlock)(NSInteger index);

@interface RCMenuByBlock : UIView

- (id)initWithOriginY:(CGFloat)y Titles:(NSArray *)titles;

- (void)menuSelectedAtIndex:(NSInteger)index;

@property (nonatomic, copy)RCMenuBlock selectedItemBlock;


@end
