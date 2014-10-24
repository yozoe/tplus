//
//  ImageDisplayViewController.m
//  MyShow
//
//  Created by max on 14-7-24.
//  Copyright (c) 2014年 maxingchuan. All rights reserved.
//

#import "ImageDisplayViewController.h"
#import "IntroControll.h"

@interface ImageDisplayViewController ()
{
    NSMutableArray * _imageArray;
}
@end

@implementation ImageDisplayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _imageArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


-(void)setImages:(NSArray *)images
{
    _images = images;
    for (UIImage * image in images) {
        IntroModel * model = [[IntroModel alloc] initWithTitle:@"" description:@"" newImage:image];
        [_imageArray addObject:model];
    }
    _introView = [[IntroControll alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) pages:_imageArray];
    [self.view addSubview:_introView];
    
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(5, 20, 45, 44);
    [backButton setImage:[UIImage imageNamed:@"top_navigation_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [_introView addSubview:backButton];
    
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


















@end
