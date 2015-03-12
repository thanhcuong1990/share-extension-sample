//
//  ViewController.m
//  ShareExtension
//
//  Created by Cuong Lam on 3/12/15.
//  Copyright (c) 2015 NUS Technology. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *linkLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.NUS.ShareExtension"];
    self.titleLabel.text = [defaults stringForKey:@"title"];
    
    NSString *link = [defaults stringForKey:@"link"];
    if (link) {
        self.linkLabel.text = link;
    }
    
    NSData *imageData = [defaults dataForKey:@"image"];
    if (imageData) {
        [self.imageView setImage:[UIImage imageWithData:imageData]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
