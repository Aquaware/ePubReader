//
//  ViewController.m
//  ePubReader
//
//  Created by KUDO IKUO on 12/07/14.
//  Copyright (c) 2012年 n/a. All rights reserved.
//

#import "ViewController.h"
#import "ePubReader.h"
#import "ePubBook.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [ center addObserver:self selector:@selector( loadedBookInfo: ) name: kLoadedEpubInfo object:nil ];
    
    UIImage* image = [ UIImage imageNamed: @"glass_background.JPG" ];
    UIImageView* bg = [ [ UIImageView  alloc ] initWithImage:image ];
    
    [ self.view addSubview: bg ];
    
    webView = [ [ UIWebView alloc ] initWithFrame: self.view.frame ];
    webView.delegate = self;
    [ self.view addSubview: webView ];
    NSURLRequest* request = [ [ NSURLRequest alloc ] initWithURL: [ NSURL URLWithString: @"http://www.yahoo.co.jp" ] ];
    [ webView loadRequest: request ];
    
    ePubReader* reader = [[ ePubReader alloc ] init ];
    [ reader openEpubFile ];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- ( void ) viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated ];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackTranslucent;
    self.wantsFullScreenLayout = YES;    
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = YES;
    
    self.navigationController.toolbar.barStyle = UIBarStyleBlack;
    self.navigationController.toolbar.translucent = YES;
    self.navigationController.toolbarHidden = NO;
}

-( void ) loadedBookInfo: ( NSNotification* ) notification
{
    
    ePubBook* book =  ( ePubBook* ) [ [ notification userInfo ] objectForKey: @"ePubBook" ];
    
    if( [book.pages count ] > 0 ) {
        ePubPage* page = [ book.pages objectAtIndex: 0 ];
        NSString* path = [ NSString stringWithFormat: @"%@/%@/%@", book.absolutePath, book.contentsDir, page.href ];
        NSLog( @"page: %@", path );
        NSURLRequest* request = [[ NSURLRequest alloc ] initWithURL: [ NSURL fileURLWithPath:  path ] ];
        [ webView loadRequest: request ];
    }
    

    
    
}

@end
