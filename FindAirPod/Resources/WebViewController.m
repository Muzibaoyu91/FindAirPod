//
//  WebViewController.m
//  Instask_objC
//
//  Created by Baoyu on 16/7/27.
//  Copyright © 2016年 Instask.Me. All rights reserved.
//

#import "WebViewController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"


@interface WebViewController ()<UIWebViewDelegate, NJKWebViewProgressDelegate>


@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) NJKWebViewProgressView *progressView;

@property (nonatomic, strong) NJKWebViewProgress *progressProxy;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadContentView];
}

- (void)loadContentView{
    
    //0.
    [self addLeftBackButton];
    self.view.backgroundColor = color_RockBgGray;
    
    
   //1.
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64)];
    [self.view addSubview:self.webView];

    
    //2.
    self.progressProxy = [[NJKWebViewProgress alloc] init];
    self.webView.delegate = self.progressProxy;
    self.progressProxy.webViewProxyDelegate = self;
    self.progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    self.progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    self.progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    self.progressView.progressBarView.backgroundColor = color_mainColor;

    //3.
    if (self.url) {
        NSURLRequest *request =[NSURLRequest requestWithURL:self.url];
        [self.webView loadRequest:request];
    }
    
    
    //4.刷新按钮
    [self addRightRefreshbtn];
    
}

- (void)addRightRefreshbtn{
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
    [backBtn setImage:[UIImage imageNamed:@"刷新"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(refreshBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.rightBarButtonItem = item;

}

- (void)refreshBtnAction:(UIButton *)btn{
    [self.webView reload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:self.progressView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [self.progressView removeFromSuperview];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];

    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}



@end
