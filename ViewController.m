//
//  ViewController.m
//  RyCreateMoveByImages
//
//  Created by roy on 2018/7/28.
//  Copyright © 2018年 Iceroy. All rights reserved.
//

#import "ViewController.h"
#import "RyCreateMovieByImage.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    RyCreateMovieByImage *cv = [[RyCreateMovieByImage alloc]init];
    cv.height =600;
    cv.width =800;
    [cv setMovieImagesNumInOneSecond:10];
    [cv saveMoiveByPath:@"1.mp4"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
