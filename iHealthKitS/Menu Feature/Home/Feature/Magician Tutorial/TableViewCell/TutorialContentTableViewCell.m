//
//  TutorialContentTableViewCell.m
//  iHealthS
//
//  Created by Wu on 2019/3/28.
//  Copyright © 2019 whitelok.com. All rights reserved.
//

#import "TutorialContentTableViewCell.h"
#import "FLAnimatedImage.h"
#import "UIView+Constraint.h"
#import "UIColor+Magic.h"
#import "URLSessionManager.h"

@interface TutorialContentTableViewCell ()

@property (nonatomic, strong) UILabel *contentLabel;
@property (strong, nonatomic) FLAnimatedImageView *imageURLView;
@property (strong, nonatomic) UIView *separatorView;
@property (strong, nonatomic) NSLayoutConstraint *imageViewRatioConstraint;

@end

@implementation TutorialContentTableViewCell

#pragma mark - API

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor purpleDark2];
        
        [self.contentView addSubview:self.contentLabel];
        [self.contentLabel constraintsTop:self.contentView toLayoutAttribute:NSLayoutAttributeTop leading:self.contentView toLayoutAttribute:NSLayoutAttributeLeading bottom:nil toLayoutAttribute:NSLayoutAttributeNotAnAttribute trailing:self.contentView toLayoutAttribute:NSLayoutAttributeTrailing constant:UIEdgeInsetsMake(20, 10, 0, -10)];
        
        [self.contentView addSubview:self.imageURLView];
        [self.imageURLView constraintsTop:self.contentLabel toLayoutAttribute:NSLayoutAttributeBottom leading:self.contentView toLayoutAttribute:NSLayoutAttributeLeading bottom:self.contentView toLayoutAttribute:NSLayoutAttributeBottom trailing:self.contentView toLayoutAttribute:NSLayoutAttributeTrailing constant:UIEdgeInsetsMake(20, 20, -20, -20)];
        
        self.separatorView = [UIView new];
        self.separatorView.backgroundColor = [UIColor whiteColor];
        self.separatorView.alpha = 0.5;
        [self.contentView addSubview:self.separatorView];
        [self.separatorView constraintsTop:self.contentView toLayoutAttribute:NSLayoutAttributeBottom leading:self.contentView toLayoutAttribute:NSLayoutAttributeLeading bottom:self.contentView toLayoutAttribute:NSLayoutAttributeBottom trailing:self.contentView toLayoutAttribute:NSLayoutAttributeTrailing constant:UIEdgeInsetsMake(-3, 0, 0, 0)];
    }
    return self;
}

- (void)setContentText:(NSString *)text {
    self.contentLabel.text = text;
}

- (void)setImageFromURL:(NSString *)urlStr {
    NSURL *url = [NSURL URLWithString:urlStr];
    [self loadAnimatedImageWithURL:url completion:^(FLAnimatedImage *animatedImage) {
        self.imageURLView.animatedImage = animatedImage;
        self.imageURLView.userInteractionEnabled = YES;
        CGFloat ratio = animatedImage.size.width/animatedImage.size.height;
        self.imageViewRatioConstraint = [NSLayoutConstraint constraintWithItem:self.imageURLView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.imageURLView attribute:NSLayoutAttributeHeight multiplier:ratio constant:0.0];
    }];
}

- (void)loadAnimatedImageWithURL:(NSURL *const)url completion:(void (^)(FLAnimatedImage *animatedImage))completion {
    NSString *const filename = url.lastPathComponent;
    NSString *const diskPath = [NSHomeDirectory() stringByAppendingPathComponent:filename];
    
    NSData * __block animatedImageData = [[NSFileManager defaultManager] contentsAtPath:diskPath];
    FLAnimatedImage * __block animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:animatedImageData];
    
    if (animatedImage) {
        if (completion) {
            completion(animatedImage);
        }
    } else {
        [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            animatedImageData = data;
            animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:animatedImageData];
            if (animatedImage) {
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(animatedImage);
                    });
                }
                [data writeToFile:diskPath atomically:YES];
            }
        }] resume];
    }
}

#pragma mark - Getter, Setter

- (void)setImageViewRatioConstraint:(NSLayoutConstraint *)imageViewRatioConstraint {
    _imageViewRatioConstraint = imageViewRatioConstraint;
    if (_imageViewRatioConstraint != nil) {
        [self.imageURLView removeConstraint:_imageViewRatioConstraint];
    }
    if (imageViewRatioConstraint != nil) {
        [self.imageURLView addConstraint:imageViewRatioConstraint];
    }
}

- (FLAnimatedImageView *)imageURLView {
    if (_imageURLView == nil) {
        FLAnimatedImageView *imageView = [FLAnimatedImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageURLView = imageView;
    }
    return _imageURLView;
}

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        UILabel *label = [UILabel new];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:20 weight:1];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        _contentLabel = label;
    }
    return _contentLabel;
}


@end
