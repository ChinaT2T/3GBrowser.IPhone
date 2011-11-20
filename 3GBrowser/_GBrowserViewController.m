//
//  _GBrowserViewController.m
//  3GBrowser
//
//  Created by apple on 11-8-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "_GBrowserViewController.h"
 
@implementation _GBrowserViewController

- (void)dealloc
{
    //[m_status release];
    [m_errorImg release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    //m_status.hidden = TRUE;
    m_errorImg.hidden = TRUE;
    m_homeUrl = @"http://m.3gcoo.net/index.htm#aa";
    m_searchUrl = @"http://m.3gcoo.net/i.jsp?st=1&wd=%@";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        m_homeUrl = @"http://m.3gcoo.net/index.htm#aa";
        m_searchUrl = @"http://m.3gcoo.net/i.jsp?st=1&wd=%@";
    } else {
        m_homeUrl = @"http://m.3gcoo.net/ipad.htm#aa";
        m_searchUrl = @"http://m.3gcoo.net/ipad.jsp?st=1&wd=%@";
    }
    [self loadUrl:m_homeUrl];
    [m_loadingIndication setHidesWhenStopped:true];
}


- (void)viewDidUnload
{
    [m_webView release];
    m_webView = nil;
    [m_loadingIndication release];
    m_loadingIndication = nil;
    [m_addressBox release];
    m_addressBox = nil;
    //[m_status release];
    [m_errorImg release];
    m_errorImg = nil;
    //m_status = nil;
    [m_errorImg release];
    m_errorImg = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (IBAction)onTouchAddressBox:(id)sender {
    [m_addressBox selectAll:self];
    [UIMenuController sharedMenuController].menuVisible = NO;
}

- (IBAction)onGoUrl:(id)sender {
    [self loadOrSearch: [m_addressBox text]];
}

- (IBAction)onGoHomePage:(id)sender {
    [m_addressBox setText:@""];
    [self loadUrl:m_homeUrl];
}



- (void) loadUrl:(NSString*) urlStr
{
    
    NSLog(@"Loading URL: %@", urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    
    if ([url scheme] == nil) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", urlStr]];
    }
    //url = [NSURL URLWithString:@"http://www.baidu.com"];
    NSLog(@"URL schema is: '%@', url is : '%@'", [url scheme], url);
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [m_webView loadRequest:request];
    NSLog(@"After Load");
    
}

//dispatch load or search action
- (void) loadOrSearch:(NSString*) urlOrKeyword
{
    [m_addressBox resignFirstResponder];
    if ([urlOrKeyword length ] == 0)
        return;
    NSRange textRange;
    textRange =[urlOrKeyword rangeOfString:@"."];
    
    if(textRange.location != NSNotFound)    {
        [self loadUrl: urlOrKeyword];
    } else {
        [self searchKeyWord: urlOrKeyword];
    }    
}

// search keyword from qurey url
- (void) searchKeyWord:(NSString*) keyword
{
    NSString* queryUrl = [NSString stringWithFormat:m_searchUrl, keyword];
    queryUrl = [NSString stringWithFormat:@"%@#result", [queryUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [self loadUrl:queryUrl];    
}
// url text box return pressed.
- (BOOL) textFieldShouldReturn:(UITextField *)textField			
{
    [self loadOrSearch: [textField text]];
    return true;
}

// UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)req navigationType:(UIWebViewNavigationType)navigationType
{
    NSMutableURLRequest *request = (NSMutableURLRequest *)req;
    [request setValue:@"3gcoo 1.1" forHTTPHeaderField:@"User-Agent"];
    NSLog(@"should start load, user-agent: %@", [request valueForHTTPHeaderField:@"User-Agent"]);
    m_htmlString =@"";
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //m_status.hidden = TRUE;
    m_errorImg.hidden = TRUE;
    NSLog(@"webViewDidStartLoad");
    [m_loadingIndication startAnimating];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)view
{
    NSLog(@"webViewDidFinishLoad");
    //m_status.hidden = TRUE;
    m_errorImg.hidden = TRUE;
    [m_loadingIndication stopAnimating];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"webView didFailLoadWithError");
    [m_loadingIndication stopAnimating];
    //m_status.hidden = FALSE;
    m_errorImg.hidden = FALSE;
    NSString * msg=@"未知错误,请联系开发者。";
    switch (error.code)
    {
        case -1009:
            msg = @"无法连接到网络，请检查网络连接";
            break;
        default:break;
    }
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"错误 %d", error.code]
                                                 message:msg
                                                delegate:self 
                                       cancelButtonTitle:@"确定"
                                       otherButtonTitles:nil];
    [alert show];
    [alert release];
    //[m_status setText:msg];
}

@end
