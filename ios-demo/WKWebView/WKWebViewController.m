//
//  WKWebViewController.m
//  ios-demo
//
//  Created by 张歆琳 on 2020/9/22.
//  Copyright © 2020 张歆琳. All rights reserved.
//

#import "WKWebViewController.h"
#import <WebKit/WebKit.h>
#import "Screen.h"

@interface WKWebViewController ()<WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>
@property (nonatomic, strong, readwrite) WKWebView *webView;
@property (nonatomic, strong, readwrite) UIProgressView *progressView;
@end

@implementation WKWebViewController

-(instancetype) init {
    self = [super init];
    if(self) {
        self.tabBarItem.title = @"首页";
        self.tabBarItem.image = [UIImage imageNamed:@"icon.bundle/home@2x.png"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"icon.bundle/home_selected@2x.png"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationItem];     // 设置导航条

    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];

    // KVO 模式，用 addObserver 注册被观察者，用于监测网页加载进度
    [self.webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
}

// KVO 模式，用 observeValueForKeyPath 接收被观察者发生变化时发出的广播，用于监测网页加载进度
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == _webView) {
        NSLog(@"网页加载进度 = %f", _webView.estimatedProgress);
        self.progressView.progress = _webView.estimatedProgress;
        if (_webView.estimatedProgress >= 1.0f) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.progress = 0;
            });
        }
    } else if([keyPath isEqualToString:@"title"] && object == _webView) {
        self.navigationItem.title = _webView.title;
    } else {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}
    
- (void)setupNavigationItem {
    // 后退按钮
    UIButton *goBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [goBackBtn setImage:[UIImage imageNamed:@"backbutton"] forState:UIControlStateNormal];
    [goBackBtn addTarget:self action:@selector(goBackAction:) forControlEvents:UIControlEventTouchUpInside];
//    goBackBtn.frame = CGRectMake(0, 0, 30, StatusBarAndNavigationBarHeight);
    goBackBtn.frame = CGRectMake(0, 0, 30, 200);//STATUSBAR_NAVIGATIONBAR_HEIGHT);
    
    UIBarButtonItem *goBackBtnItem = [[UIBarButtonItem alloc] initWithCustomView:goBackBtn];
    UIBarButtonItem *jstoOc = [[UIBarButtonItem alloc] initWithTitle:@"首页" style:UIBarButtonItemStyleDone target:self action:@selector(localHtmlClicked)];
    self.navigationItem.leftBarButtonItems = @[goBackBtnItem, jstoOc];  // 左侧：后退+首页 两个按钮
    
    // 刷新按钮
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshBtn setImage:[UIImage imageNamed:@"webRefreshButton"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventTouchUpInside];
//    refreshBtn.frame = CGRectMake(0, 0, 30, StatusBarAndNavigationBarHeight);
    refreshBtn.frame = CGRectMake(0, 0, 30, 0);//STATUSBAR_NAVIGATIONBAR_HEIGHT);
    
    UIBarButtonItem *refreshBtnItem = [[UIBarButtonItem alloc] initWithCustomView:refreshBtn];
    UIBarButtonItem * ocToJs = [[UIBarButtonItem alloc] initWithTitle:@"OC调用JS" style:UIBarButtonItemStyleDone target:self action:@selector(ocToJs)];
    self.navigationItem.rightBarButtonItems = @[refreshBtnItem, ocToJs];    // 右侧：刷新+OC条用JS 两个按钮
}
        
- (void)goBackAction:(id)sender {
    if ([_webView canGoBack]) {
       [_webView goBack];
    }
}

- (void)localHtmlClicked {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"JStoOC.html" ofType:nil];
    NSString *htmlString = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [_webView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}

- (void)refreshAction:(id)sender{
    [_webView reload];
}

- (void)ocToJs {     // OC调用JS
    // 调用 js 里自定义方法
    NSString *jsStr1 = @"oc2jsChangeColor()";
    [_webView evaluateJavaScript:jsStr1 completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        NSLog(@"改变HTML的背景色");
    }];

    // 可以自己撸一串 js 代码执行
    NSString *jsStr2 = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", arc4random()%99 + 100];
    [_webView evaluateJavaScript:jsStr2 completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        NSLog(@"改变HTML的字体大小");
    }];
}

#pragma mark -- Getter

- (UIProgressView *)progressView
{
    if (!_progressView){
//        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight + 1, self.view.frame.size.width, 2)];
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0/*STATUSBAR_NAVIGATIONBAR_HEIGHT*/ + 1, self.view.frame.size.width, 2)];
        _progressView.tintColor = [UIColor blueColor];
        _progressView.trackTintColor = [UIColor clearColor];
    }
    return _progressView;
}

- (WKWebView *)webView
{
    if(_webView == nil) {
        // 创建 WKWebView 的初始化的配置项
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];

        // 设置请求的 User-Agent 中应用程序名称（iOS9+可用）
        config.applicationNameForUserAgent = @"WKWebView-demo";
        
        // 偏好配置
        WKPreferences *preference = [[WKPreferences alloc] init];
        preference.minimumFontSize = 0;     // 最小字体大小，当将 javaScriptEnabled 属性设为 NO 时，可以看到明显的效果
        preference.javaScriptCanOpenWindowsAutomatically = YES; // iOS默认为NO，MacOS默认为YES，是否允许不经过用户交互由 JS 自动打开窗口
        preference.javaScriptEnabled = YES; // 是否允许页面执行 js
        config.preferences = preference;
        
        // 媒体设置
        config.allowsInlineMediaPlayback = YES; // 设为YES用H5的视频播放器在线播放，设为NO用内置的native播放器全屏播放
        config.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeVideo;
        config.allowsPictureInPictureMediaPlayback = YES;   // 是否允许H5视频中播放画中画（在特定设备上有效）
        
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addScriptMessageHandler:self name:@"js2coPostMessage"];
        config.userContentController = wkUController;
        
        // 可以在初始化解决注入一些 JavaScript
        NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [config.userContentController addUserScript:wkUScript];

        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) configuration:config];
        
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        
        _webView.allowsBackForwardNavigationGestures = YES; // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
//        WKBackForwardList *backForwardList = [_webView backForwardList];    // webview 的 back-forward 列表, 存储已打开过的网页

        NSString *path = [[NSBundle mainBundle] pathForResource:@"JStoOC.html" ofType:nil];
        NSString *htmlString = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        [_webView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    }
    return _webView;
}

#pragma mark -- WKUIDelegate

// 新创建个WebView，这里用于当h5标签上有 _blank 时IOS无法跳转，解决方案就是：放弃掉原来的点击事件，强制让 webView 加载打开的链接
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    // 该方法的本意是让程序员return个新的webview，但这里只是解决个跳转的问题，所以不需要新的webview，return nil
    return nil;
}

// 将JS的alert转成native的形式显示（支持转成弹出窗形式，或actionSheet形式）
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"捕捉到了js的alert" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
    
// 将JS的confirm转成native的形式显示（支持转成弹出窗形式，或actionSheet形式）
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"捕捉到了js的confirm" message:message?:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:([UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
    
// 将JS的prompt转成native的形式显示
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -- WKNavigationDelegate

// 拦截即将跳转的HTTP请求，根据protocol，或header头信息来决定是否放行跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *urlStr = navigationAction.request.URL.absoluteString;
    // 指定想捕获的的协议头
    if([urlStr hasPrefix:@"mymapi://"]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"oc捕获到了指定的协议头" message:@"是否用Safari访问？" preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction:([UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://zxljack.com/"]]];
        }])];
        [alertController addAction:([UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *newUrl = [NSURL URLWithString:[urlStr stringByReplacingOccurrencesOfString:@"mymapi://callName_?" withString:@""]];
            [[UIApplication sharedApplication] openURL:newUrl];    // 用 Safari 打开链接
        }])];
        [self presentViewController:alertController animated:YES completion:nil];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);     // 允许跳转
    }
}

// 拦截收到的服务器的响应response头来决定是否放行跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSString * urlStr = navigationResponse.response.URL.absoluteString;
    NSLog(@"当前跳转地址：%@", urlStr);
    decisionHandler(WKNavigationResponsePolicyAllow);   // 允许跳转
    // decisionHandler(WKNavigationResponsePolicyCancel);   // 不允许跳转
}

// 当 WKWebView 总体内存占用过大，页面即将白屏的时候，系统会调用该回调函数，在这里可以 reload 解决白屏问题
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    [_webView reload];
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if([message.name isEqualToString:@"js2coPostMessage"]){
        NSLog(@"name:%@\n body:%@\n frameInfo:%@\n", message.name, message.body, message.frameInfo);
        NSDictionary *params = message.body;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"oc捕获到了js post的消息" message:params[@"name"] preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }])];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)dealloc{
    // 移除注册的js方法
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"js2coPostMessage"];
    // 移除观察者
    [_webView removeObserver:self
                  forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    [_webView removeObserver:self
                  forKeyPath:NSStringFromSelector(@selector(title))];
}
@end
