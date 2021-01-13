//
//  LSProtocolViewController.m
//  Project
//
//  Created by XuWen on 2020/3/23.
//  Copyright © 2020 xuwen. All rights reserved.
//

#import "LSProtocolViewController.h"
#import <WebKit/WebKit.h>
@interface LSProtocolViewController ()
@property (nonatomic,strong) WKWebView *webView;
@end

@implementation LSProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBarView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}


#pragma mark - setter & getter1
- (WKWebView *)webView
{
    if(!_webView){
         WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH) configuration:config];
        _webView.backgroundColor = [UIColor whiteColor];
    }
    return _webView;
}


- (void)setFileType:(int)fileType
{
    _fileType = fileType;
    if(fileType == 0){
        [self speciceNavWithTitle:kLanguage(@"Terms of Use")];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Terms.html" ofType:nil];
        NSString *htmlString = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        [self.webView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    }else if(fileType == 1){
        [self speciceNavWithTitle:kLanguage(@"Privacy Policy")];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Privacy.html" ofType:nil];
        NSString *htmlString = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        [self.webView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    }
}


@end
