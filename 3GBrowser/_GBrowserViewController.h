//
//  _GBrowserViewController.h
//  3GBrowser
//
//  Created by apple on 11-8-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface _GBrowserViewController : UIViewController {
    
    IBOutlet UIWebView *m_webView;
    IBOutlet UITextField *m_addressBox;
    IBOutlet UIActivityIndicatorView *m_loadingIndication;
    IBOutlet UILabel *m_status;

    NSString * m_htmlString;
    NSString * m_homeUrl;
    NSString * m_searchUrl;
}

- (IBAction)onTouchAddressBox:(id)sender;
- (IBAction)onGoUrl:(id)sender;
- (IBAction)onGoHomePage:(id)sender;

- (void) loadUrl:(NSString*) urlStr;
// search keyword from qurey url
- (void) searchKeyWord:(NSString*) keyword;
//dispatch load or search action
- (void) loadOrSearch:(NSString*) urlOrKeyword;

//URL text field delegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField;

// UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)webViewDidStartLoad:(UIWebView *)webView;
- (void)webViewDidFinishLoad:(UIWebView *)webView;
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;


@end
