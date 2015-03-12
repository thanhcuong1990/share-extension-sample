//
//  ShareViewController.m
//  ShareAction
//
//  Created by Cuong Lam on 3/12/15.
//  Copyright (c) 2015 NUS Technology. All rights reserved.
//

#import "ShareViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <Social/Social.h>

@interface ShareViewController ()

@property NSString *requestURL;
@property NSData *imageURL;

@end

@implementation ShareViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getData:self.extensionContext];
}


- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    
    NSInteger messageLength = [[self.contentText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length];
    NSInteger charactersRemaining = 100 - messageLength;
    self.charactersRemaining = @(charactersRemaining);
    
    if (charactersRemaining >= 0) {
        return YES;
    }
    
    return NO;
}

- (void)didSelectPost {
    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.NUS.ShareExtension"];
    [defaults setObject:self.contentText forKey:@"title"];
    if (self.imageURL) {
        [defaults setObject:self.imageURL forKey:@"image"];
    }
    if (self.requestURL) {
        [defaults setObject:self.requestURL forKey:@"link"];
    }
    [defaults synchronize];

    // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}


- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}


// MARK: Get data
- (void)getData:(NSExtensionContext *)context {
    
    for (NSExtensionItem *item in context.inputItems) {
        for (NSItemProvider *itemProvider in item.attachments) {
            if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeURL]) {
                [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeURL options:nil completionHandler:^(NSURL *piggyBackData, NSError *error) {
                    if(piggyBackData) {
                        self.requestURL = [NSString stringWithFormat:@"%@",piggyBackData ];
                    }
                }];
            }
            if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeImage]) {
                [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeImage options:nil completionHandler:^(NSData *piggyBackData, NSError *error) {
                    if(piggyBackData) {
                        self.imageURL = piggyBackData;
                    }
                }];
            }
        }
    }
}

@end
