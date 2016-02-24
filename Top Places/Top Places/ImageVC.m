//
//  ImageVC.m
//  Top Places
//
//  Created by iYww on 15/11/4.
//  Copyright © 2015年 zank. All rights reserved.
//

#import "ImageVC.h"
#import "URLFetch.h"

@interface ImageVC () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) UIImageView *imageView;
@property (nonatomic) BOOL autoResize;

@end

@implementation ImageVC

#pragma mark - Property

- (UIImageView *)imageView {
    if(!_imageView) {
        _imageView = [[UIImageView alloc] init];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewPan:)];
        [_imageView addGestureRecognizer:panGesture];
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.minimumZoomScale = 0.2;
    self.scrollView.maximumZoomScale = 2;
    self.scrollView.delegate = self;
    [self.scrollView addSubview:self.imageView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.autoResize = YES;
    [self fetchImage];
}

#pragma mark - Fetch Image

static const int STATUS_BAR_HEIGHT = 20;
static const int NAVIGATION_BAR_HEIGHT = 44;
static const int TAB_BAR_HEIGHT = 49;

- (void)fetchImage {
    [self.spinner startAnimating];
    
    [URLFetch requestWithURL:self.imageURL completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        UIImage *image = [URLFetch parseURLToImage:location];
        CGSize viewSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT);
        
        self.imageView.image = image;
        
        self.scrollView.contentSize = viewSize;
        self.imageView.frame = CGRectMake(0, 0, viewSize.width, viewSize.height);
        
        [self.spinner stopAnimating];
    }];
    
}


#pragma mark - UIScrollView Delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if(self.autoResize) {
        [self.imageView sizeToFit];
        self.scrollView.contentSize = self.imageView.image.size;
        self.autoResize = NO;
    }
    return self.imageView;
}

#pragma mark - ImageView Gesture Delegate

- (void)imageViewPan:(UIPanGestureRecognizer *)sender {
    CGPoint offsetPoint = [sender translationInView:self.scrollView];
    CGPoint originCenter = self.imageView.center;
    self.imageView.center = CGPointMake(originCenter.x+offsetPoint.x, originCenter.y+offsetPoint.y);
    
    [sender setTranslation:CGPointMake(0, 0) inView:self.scrollView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
