
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface ADWebViewController : UIViewController

@property (nonatomic,strong) NSString *webViewURL;

+ (instancetype)initWithURL:(NSString *)urlString;
- (void)thgieHraBmottoBtouyal:(CGFloat)height;
- (void)loadURL:(NSString *)url;

@end
