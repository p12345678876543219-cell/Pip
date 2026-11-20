
#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <WebKit/WebKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property(nonatomic,strong) UIWindow *window;
@end

@interface PiPController : NSObject
@property(nonatomic,strong) UIView *menu;
@property(nonatomic,strong) UIButton *floating;
@property(nonatomic,strong) WKWebView *web;
@property(nonatomic,strong) AVPlayerViewController *playerVC;
@property(nonatomic,strong) UIViewController *root;
@end

@implementation PiPController

- (void)start {
    self.root = UIApplication.sharedApplication.keyWindow.rootViewController;

    if (!self.root) return;

    self.floating = [UIButton buttonWithType:UIButtonTypeSystem];
    self.floating.frame = CGRectMake(30, 180, 58, 58);
    self.floating.backgroundColor = UIColor.systemPurpleColor;
    self.floating.layer.cornerRadius = 29;
    [self.floating setTitle:@"▶" forState:UIControlStateNormal];
    [self.floating setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.floating addTarget:self action:@selector(toggle)
            forControlEvents:UIControlEventTouchUpInside];

    UIPanGestureRecognizer *pan =
    [[UIPanGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(drag:)];
    [self.floating addGestureRecognizer:pan];

    [self.root.view addSubview:self.floating];
}

- (void)drag:(UIPanGestureRecognizer *)g {
    CGPoint p = [g translationInView:self.root.view];
    self.floating.center = CGPointMake(
        self.floating.center.x + p.x,
        self.floating.center.y + p.y
    );
    [g setTranslation:CGPointZero inView:self.root.view];
}

- (void)toggle {
    if (self.menu) {
        [self close];
        return;
    }

    self.menu = [[UIView alloc] initWithFrame:
        CGRectMake(25, 250, 300, 125)];

    self.menu.backgroundColor =
        [UIColor colorWithWhite:0.12 alpha:0.96];
    self.menu.layer.cornerRadius = 20;

    UILabel *title = [[UILabel alloc] initWithFrame:
        CGRectMake(15, 12, 260, 30)];
    title.text = @"YouTube PiP";
    title.textColor = UIColor.whiteColor;
    title.font = [UIFont boldSystemFontOfSize:18];

    UIButton *on = [UIButton buttonWithType:UIButtonTypeSystem];
    on.frame = CGRectMake(15, 60, 125, 42);
    on.backgroundColor = UIColor.systemGreenColor;
    on.layer.cornerRadius = 10;
    [on setTitle:@"ON - Play" forState:UIControlStateNormal];
    [on setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [on addTarget:self action:@selector(play)
        forControlEvents:UIControlEventTouchUpInside];

    UIButton *off = [UIButton buttonWithType:UIButtonTypeSystem];
    off.frame = CGRectMake(155, 60, 125, 42);
    off.backgroundColor = UIColor.systemRedColor;
    off.layer.cornerRadius = 10;
    [off setTitle:@"OFF" forState:UIControlStateNormal];
    [off setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [off addTarget:self action:@selector(close)
        forControlEvents:UIControlEventTouchUpInside];

    [self.menu addSubview:title];
    [self.menu addSubview:on];
    [self.menu addSubview:off];
    [self.root.view addSubview:self.menu];
}

- (void)play {
    if (self.playerVC) {
        [self.playerVC dismissViewControllerAnimated:NO completion:nil];
    }

    self.web = [[WKWebView alloc] initWithFrame:CGRectZero];

    NSString *html =
    @"<html><body style='margin:0;background:black'>"
    "<iframe id='v' width='100%' height='100%' "
    "src='https://www.youtube.com/embed/Mk8aXZDHUMU?autoplay=1&loop=1&playlist=Mk8aXZDHUMU' "
    "allow='autoplay; encrypted-media; picture-in-picture' "
    "allowfullscreen></iframe></body></html>";

    [self.web loadHTMLString:html
        baseURL:[NSURL URLWithString:@"https://www.youtube.com"]];

    [self.root.view addSubview:self.web];
    self.web.frame = CGRectMake(0, 0, 1, 1);
}

- (void)close {
    [self.web removeFromSuperview];
    self.web = nil;
    [self.menu removeFromSuperview];
    self.menu = nil;
}

@end

static PiPController *controller;

@interface AppDelegate (PiP)
@end

@implementation AppDelegate (PiP)

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)options {

    dispatch_async(dispatch_get_main_queue(), ^{
        controller = [PiPController new];
        [controller start];
    });

    return YES;
}

@end
