//
//  PhotoViewController.m
//  Top Places
//
//  Created by Apple on 9/25/17.
//  Copyright © 2017 Mari. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController () <UIScrollViewDelegate, UISplitViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property(strong, nonatomic) UIImageView *imageView;
@property(strong, nonatomic) UIImage *image;

@end

@implementation PhotoViewController

- (void)setScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
    _scrollView.minimumZoomScale = 0.1;
    _scrollView.maximumZoomScale = 2.5;
    _scrollView.delegate = self;
    _scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UIImage *)image {
    return self.imageView.image;
}

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
    [self.imageView sizeToFit];
    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
    double wScale = self.scrollView.bounds.size.width / self.imageView.image.size.width;
    double hScale = (self.scrollView.bounds.size.height - self.navigationController.navigationBar.frame.size.height - self.tabBarController.tabBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height) / self.imageView.image.size.height;
    if (wScale > hScale) self.scrollView.zoomScale = wScale;
    else self.scrollView.zoomScale = hScale;
    
    [self.activityIndicator stopAnimating];
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    [self downloadImage];
}

- (void)downloadImage {
    self.image = nil;
    if (!self.imageURL) return;
    
    [self.activityIndicator startAnimating];
    
    NSURL *url = self.imageURL;
    NSURLSessionConfiguration *config= [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            if ([self.imageURL isEqual:response.URL]) {
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.image = image;
                });
            }
        }
    }];
    
    [task resume];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//# pragma mark - Split View Controller delegate
//
//- (void)awakeFromNib
//{
//    [super awakeFromNib];
//    self.splitViewController.delegate = self;
//}

//- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation {
//    return UIInterfaceOrientationIsPortrait(orientation);
//}

//- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController
// withBarButtonItem:(UIBarButtonItem *)barButtonItem {
//    UIViewController *master = aViewController;
//    if ([master isKindOfClass:[UITabBarController class]]) {
//        master = ((UITabBarController *)master).selectedViewController;
//    }
//    if ([master isKindOfClass:[UINavigationController class]]) {
//        master = ((UINavigationController *)master).topViewController;
//    }
//    barButtonItem.title = master.title;
//    self.navigationItem.leftBarButtonItem = barButtonItem;
//}
//
//- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
//    self.navigationItem.leftBarButtonItem = nil;
//}

@end
