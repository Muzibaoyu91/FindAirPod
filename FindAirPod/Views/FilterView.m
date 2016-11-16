//
//  FilterView.m
//  FindAirPod
//
//  Created by Baoyu on 16/9/12.
//  Copyright © 2016年 Baoy. All rights reserved.
//

#import "FilterView.h"

#define maginX  20
#define cellHeight  45

@interface FilterView ()

@property (nonatomic, strong) NSMutableArray *allOptionsArray;

@property (nonatomic, strong) NSMutableArray *btnesArray;

@property (nonatomic, copy) NSString *which;

@property (nonatomic, copy) NSString *gender;

@end

@implementation FilterView

- (NSMutableArray *)btnesArray{
    if (!_btnesArray) {
        _btnesArray = [NSMutableArray array];
    }
    return _btnesArray;
}

- (NSMutableArray *)allOptionsArray{
    if (!_allOptionsArray) {
        _allOptionsArray = [NSMutableArray array];
    }
    return _allOptionsArray;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
        self.backgroundColor = [UIColor whiteColor];
        
        NSArray *option_0 = @[
                              @"全部",
                              @"左耳",
                              @"右耳"
                              ];
    
        NSArray *option_1 = @[
                              @"全部",
                              @"男生",
                              @"女生"
                              ];
        
        

        
        [self addNewCellWithOptionsArray:option_0 withRow:0];
        CGFloat maxY = [self addNewCellWithOptionsArray:option_1 withRow:1];
        
        self.which = @"both";
        self.gender = @"unknow";
        
        UIButton *finishBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, maxY, kScreenW, cellHeight)];
        finishBtn.backgroundColor = color_mainColor;
        [finishBtn setTitle:@"确定" forState:UIControlStateNormal];
        [finishBtn addTarget:self action:@selector(finishBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:finishBtn];
        
        
//        UIButton *btn_0 = [[UIButton alloc] initWithFrame:CGRectMake(0, maxY, kScreenW/2.f, cellHeight)];
//        btn_0.backgroundColor = color_RockBgGray;
//        [btn_0 setTitle:@"取消" forState:UIControlStateNormal];
//        [btn_0 setTitleColor:color_TestBlack forState:UIControlStateNormal];
//        btn_0.titleLabel.font = [UIFont systemFontOfSize:15];
//        [self addSubview:btn_0];
//        
//        UIButton *btn_1 = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW/2.f, maxY, kScreenW/2.f, cellHeight)];
//        [btn_1 setTitle:@"确定" forState:UIControlStateNormal];
//        btn_1.titleLabel.font = [UIFont systemFontOfSize:15];
//        btn_1.backgroundColor = color_DangerRed;
//        [self addSubview:btn_1];
//        
        
        self.frame = CGRectMake(0, - CGRectGetMaxY(finishBtn.frame), kScreenW, CGRectGetMaxY(finishBtn.frame));
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, -100, kScreenW, 100)];
        topView.backgroundColor = [UIColor whiteColor];
        [self addSubview:topView];
        
    }
    return self;
}

- (CGFloat)addNewCellWithOptionsArray:(NSArray *)optionsArray withRow:(NSInteger)row{
    
    UIView *cell = [[UIView alloc] initWithFrame:CGRectMake(0, (row) *cellHeight, kScreenW, cellHeight)];
    cell.backgroundColor = [UIColor whiteColor];
    [self addSubview:cell];
    
    
    for (int i = 0; i<optionsArray.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*(kScreenW/3.f), 0, kScreenW/3.f, cellHeight)];
        [btn setTitle:optionsArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:color_TestGray forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        btn.tag = row*1000 + i;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnesArray addObject:btn];
        [cell addSubview:btn];
        
        if (i==0) {
            [btn setTitleColor:color_mainColor forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        }
        
    }
    return CGRectGetMaxY(cell.frame);
}

- (void)btnAction:(UIButton *)btn{
    NSInteger cellRow = btn.tag/1000;
    
    //  清空别的颜色
    for (UIButton *btn in self.btnesArray) {
        if (btn.tag/1000 == cellRow) {
            [btn setTitleColor:color_TestGray forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:16];
        }
    }
    [btn setTitleColor:color_mainColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:17];

    
    
    NSInteger btnRow = btn.tag%1000;
    if (!cellRow) {
        //  第一行
        if (btnRow == 0) {
            self.which = @"both";
        }else if (btnRow == 1){
            self.which = @"left";
        }else if (btnRow == 2){
            self.which = @"right";
        }
    }else{
        //  第二行
        if (btnRow == 0) {
            self.gender = @"unknow";
        }else if (btnRow == 1){
            self.gender = @"male";
        }else if (btnRow == 2){
            self.gender = @"female";
        }
    }
}

- (void)finishBtnAction:(UIButton *)btn{
    kDebugLog(@"筛选：%@ 性别:%@",self.which,self.gender);
    if ([self.delegate respondsToSelector:@selector(filtrateWithWhich:withGender:)]) {
        [self.delegate filtrateWithWhich:self.which withGender:self.gender];
    }
}


- (CGFloat )addCellWithTitle:(NSString *)title withOptionsArray:(NSArray *)optionsArray withRow:(NSInteger)row{
    CGFloat magin = 10;
    CGFloat maginy = 10;
    
    
    UIView *cell = [[UIView alloc] initWithFrame:CGRectMake(0, row*cellHeight, kScreenW, cellHeight)];
    cell.backgroundColor = [UIColor whiteColor];
    [self addSubview:cell];
    
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(magin, maginy, 70, cellHeight - maginy)];
    titleLable.text = title;
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.font = [UIFont systemFontOfSize:14];
    [cell addSubview:titleLable];
    
    
    CGFloat btnWidth = (kScreenW - titleLable.frame.size.width - (optionsArray.count+2)*magin)/optionsArray.count;
    CGFloat btnHeigtht = cellHeight - maginy;
    
    for (int i = 0; i<optionsArray.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLable.frame) +magin + i *(magin + btnWidth), maginy, btnWidth, btnHeigtht)];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        NSString *title = optionsArray[i];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:color_TestBlack forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(optionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = color_RockBgGray;
        [cell addSubview:btn];
        
        [self.allOptionsArray addObject:btn];
    }
    
    return CGRectGetMaxY(cell.frame) + maginy;
    
}


#pragma mark - function
- (void)optionBtnAction:(UIButton *)btn{
    for (UIButton *btn in self.allOptionsArray) {
        [btn setTitleColor:color_TestBlack forState:UIControlStateNormal];
        btn.backgroundColor = color_RockBgGray;
    }
    
}

- (void)viewCancleBtnAction:(UIButton *)btn{
    self.hidden = YES;
}


@end
