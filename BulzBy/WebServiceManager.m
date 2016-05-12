//
//  WebServiceManager.m
//  BulzBy
//
//  Created by Seby Feier on 14/04/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "WebServiceManager.h"
#import <AFHTTPClient.h>
#import "AFNetworking.h"

#define kTWebServiceForEndpoint(endpoint) [WebServiceUrl stringByAppendingPathComponent:endpoint]

NSString *const WebServiceUrl = @"http://restaurantfinder.boxnets.com/";

@implementation WebServiceManager

+ (WebServiceManager *)sharedInstance {
    static dispatch_once_t onceToken;
    static WebServiceManager *_sharedClient = nil;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[WebServiceManager alloc] init];
    });
    
    return _sharedClient;
}

- (void)getListOfRestaurantsWithPageNumber:(NSNumber *)pageNumber categoryId:(NSString *)categoryId cityId:(NSString *)cityId name:(NSString *)name andCompletionBlock:(ArrayAndErrorCompletionBlock)completionBlock {
    NSString * language = [[[[NSLocale preferredLanguages] objectAtIndex:0] componentsSeparatedByString:@"-"] firstObject];

//    NSString *urlString = [NSString stringWithFormat:@"companies.json?api_language=%@&category_id=&city_id=&name=&page=%@",language,pageNumber];
    NSString *urlString = [NSString stringWithFormat:@"companies.json?api_language=%@",language];
    if (categoryId) {
        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&category_id=%@",categoryId]];
    } else {
        urlString = [urlString stringByAppendingString:@"&category_id="];
    }
//    NSString *urlString = [NSString stringWithFormat:@"companies.json?api_language=%@",language];
    if (cityId) {
        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&city_id=%@",cityId]];
    } else {
        urlString = [urlString stringByAppendingString:@"&city_id="];
    }
    if (name) {
        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&name=%@",name]];
    } else {
        urlString = [urlString stringByAppendingString:@"&name="];
    }
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&page=%@",pageNumber]];
    
    
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:urlString parameters:nil];
    NSLog(@"%@",request);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (!self.listOfRestaurants ) {
            self.listOfRestaurants = [[NSMutableArray alloc] init];
        }
        completionBlock(JSON, nil);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];
}

- (void)getCitiesFromCountry:(NSNumber *)countryId withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock {
    NSString * language = [[[[NSLocale preferredLanguages] objectAtIndex:0] componentsSeparatedByString:@"-"] firstObject];
    
    //    NSString *urlString = [NSString stringWithFormat:@"companies.json?api_language=%@&category_id=&city_id=&name=&page=%@",language,pageNumber];
    NSString *urlString = [NSString stringWithFormat:@"selectable_cities.json?api_language=%@",language];
    if (countryId) {
        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&country_id=%@",countryId]];
    } else {
        urlString = [urlString stringByAppendingString:@"&country_id="];
    }
    //    NSString *urlString = [NSString stringWithFormat:@"companies.json?api_language=%@",language];
//    if (cityId) {
//        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&city_id=%@",cityId]];
//    } else {
//        urlString = [urlString stringByAppendingString:@"&city_id="];
//    }
//    if (name) {
//        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&name=%@",categoryId]];
//    } else {
//        urlString = [urlString stringByAppendingString:@"&name="];
//    }
//    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&page=%@",pageNumber]];
    
    
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:urlString parameters:nil];
    NSLog(@"%@",request);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (!self.listOfRestaurants ) {
            self.listOfRestaurants = [[NSMutableArray alloc] init];
        }
        completionBlock(JSON, nil);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];
}

- (void)getListOfCategoriesWithCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock {
    NSString * language = [[[[NSLocale preferredLanguages] objectAtIndex:0] componentsSeparatedByString:@"-"] firstObject];
    NSString *urlString = [NSString stringWithFormat:@"selectable_data.json?api_language=%@",language];
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:urlString parameters:nil];
    NSLog(@"%@",request);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        completionBlock(JSON, nil);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];
}

- (void)showUserDetailsWithApiToken:(NSString *)apiToken withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock {
    NSString * language = [[[[NSLocale preferredLanguages] objectAtIndex:0] componentsSeparatedByString:@"-"] firstObject];
    NSString *urlString = [NSString stringWithFormat:@"users/api_current_user_details.json?api_language=%@",language];
    if (apiToken) {
        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&api_token=%@",apiToken]];
    }
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:urlString parameters:nil];
    NSLog(@"%@",request);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        self.userDetails = JSON;
        completionBlock(JSON, nil);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];

}

- (void)registerWithEmail:(NSString *)email andPassword:(NSString *)password andUsername:(NSString *)username phoneNumber:(NSString *)phoneNumber withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock {
    NSString * language = [[[[NSLocale preferredLanguages] objectAtIndex:0] componentsSeparatedByString:@"-"] firstObject];
    NSString *urlString = [NSString stringWithFormat:@"users.json"];
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:language forKey:@"api_language"];
    NSMutableDictionary *user = [[NSMutableDictionary alloc] init];
    if (email) {
        [user setObject:email forKey:@"email"];
//        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&email=%@",email]];

    }
    if (password) {
        [user setObject:password forKey:@"password"];
        [user setObject:password forKey:@"password_confirmation"];
//        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&password=%@",password]];

    }
    if (username) {
        [user setObject:username forKey:@"name"];
//        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&name=%@",username]];

    }
    if (phoneNumber) {
        [user setObject:phoneNumber forKey:@"phone"];
//        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&phone=%@",phoneNumber]];

    }
    [parameters setObject:user forKey:@"user"];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:urlString
                                                      parameters:parameters];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        self.userInfo = JSON;
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];
    
}

- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock {
    NSString * language = [[[[NSLocale preferredLanguages] objectAtIndex:0] componentsSeparatedByString:@"-"] firstObject];
    NSString *urlString = [NSString stringWithFormat:@"users/api_login.json"];
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:language forKey:@"api_language"];
//    NSMutableDictionary *user = [[NSMutableDictionary alloc] init];
    if (email) {
        [parameters setObject:email forKey:@"email"];
        //        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&email=%@",email]];
        
    }
    if (password) {
        [parameters setObject:password forKey:@"password"];
        //        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&password=%@",password]];
        
    }
//    [parameters setObject:user forKey:@"user"];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:urlString
                                                      parameters:parameters];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        self.userInfo = JSON;
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];

}

- (void)bookLocationForApiToken:(NSString *)apiToken locationIdid:(NSString *)locationId description:(NSString *)description dateTime:(NSString *)dateTime withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock {
    NSString * language = [[[[NSLocale preferredLanguages] objectAtIndex:0] componentsSeparatedByString:@"-"] firstObject];
    NSString *urlString = [NSString stringWithFormat:@"locations/%@/book.json",locationId];
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:language forKey:@"api_language"];
    //    NSMutableDictionary *user = [[NSMutableDictionary alloc] init];
    if (apiToken) {
        [parameters setObject:apiToken forKey:@"api_token"];
        //        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&email=%@",email]];
        
    }
    if (description) {
        [parameters setObject:description forKey:@"description"];
        //        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&password=%@",password]];
        
    }
    if (dateTime) {
        [parameters setObject:dateTime forKey:@"datetime"];
        //        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&password=%@",password]];
        
    }
    //    [parameters setObject:user forKey:@"user"];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:urlString
                                                      parameters:parameters];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];

}

- (void)reviewCompanyWithApiToken:(NSString *)apiToken withCompanyId:(NSString *)companyId description:(NSString *)description starFood:(NSNumber *)starFood starService:(NSNumber *)starService starEnvironment:(NSNumber *)starEnvironment withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock {
    NSString * language = [[[[NSLocale preferredLanguages] objectAtIndex:0] componentsSeparatedByString:@"-"] firstObject];
    NSString *urlString = [NSString stringWithFormat:@"reviews.json"];
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:language forKey:@"api_language"];
    if (apiToken) {
        [parameters setObject:apiToken forKey:@"api_token"];
        //        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&email=%@",email]];
        
    }
    NSMutableDictionary *review = [[NSMutableDictionary alloc] init];
    if (companyId) {
        [review setObject:companyId forKey:@"company_id"];
        //        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&email=%@",email]];
        
    }
    if (description) {
        [review setObject:description forKey:@"description"];
        //        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&password=%@",password]];
        
    }
    if (starFood) {
        [review setObject:starFood forKey:@"star_food"];
        //        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&name=%@",username]];
        
    }
    if (starService) {
        [review setObject:starService forKey:@"star_service"];
        //        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&phone=%@",phoneNumber]];
        
    }
    if (starEnvironment) {
        [review setObject:starEnvironment forKey:@"star_environment"];
        //        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&phone=%@",phoneNumber]];
        
    }
    [parameters setObject:review forKey:@"review"];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:urlString
                                                      parameters:parameters];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//        self.userInfo = JSON;
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];
    

}

- (void)getCompanyInformationWithId:(NSString *)restaurantId withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock {
    NSString * language = [[[[NSLocale preferredLanguages] objectAtIndex:0] componentsSeparatedByString:@"-"] firstObject];
    NSString *urlString = [NSString stringWithFormat:@"companies/%@.json?api_language=%@",restaurantId,language];
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:urlString parameters:nil];
    NSLog(@"%@",request);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        completionBlock(JSON, nil);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];
}

- (void)loginWithFacebookId:(NSString *)facebookId email:(NSString *)email name:(NSString *)name image:(NSString *)image withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock {
//    NSString *urlString = @"facebook";
    NSString * language = [[[[NSLocale preferredLanguages] objectAtIndex:0] componentsSeparatedByString:@"-"] firstObject];
    NSString *urlString = [NSString stringWithFormat:@"users/auth/facebook/callback.json"];
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:language forKey:@"api_language"];
    if (facebookId) {
        [parameters setObject:facebookId forKey:@"uid"];
        //        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&email=%@",email]];
        
    }
    NSMutableDictionary *user = [[NSMutableDictionary alloc] init];
    if (email) {
        [user setObject:email forKey:@"email"];
        //        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&email=%@",email]];
        
    }
    if (name) {
        [user setObject:name forKey:@"name"];
    }
    [parameters setObject:user forKey:@"info"];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:urlString
                                                      parameters:parameters];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        self.userInfo = JSON;
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];
}

- (void)editUserWithId:(NSString *)userId username:(NSString *)name andPassword:(NSString *)password andApiToken:(NSString *)apiToken andEmail:(NSString *)email withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock {
    NSString * language = [[[[NSLocale preferredLanguages] objectAtIndex:0] componentsSeparatedByString:@"-"] firstObject];
    NSString *urlString = [NSString stringWithFormat:@"users.json"];
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:language forKey:@"api_language"];
    if (apiToken) {
        [parameters setObject:apiToken forKey:@"api_token"];
        //        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&email=%@",email]];
        
    }
    NSMutableDictionary *user = [[NSMutableDictionary alloc] init];
    if (email) {
        [user setObject:email forKey:@"email"];
        //        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&email=%@",email]];
        
    }
    if (name) {
        [user setObject:name forKey:@"name"];
    }
    if (password) {
        [user setObject:password forKey:@"password"];
        [user setObject:password forKey:@"password_confirmation"];
    }
    [parameters setObject:user forKey:@"user"];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"PUT"
                                                            path:urlString
                                                      parameters:parameters];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //        self.userInfo = JSON;
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];
}

- (void)contactOwnerWithUsername:(NSString *)username email:(NSString *)email phone:(NSString *)phone message:(NSString *)message withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock {
    NSString * language = [[[[NSLocale preferredLanguages] objectAtIndex:0] componentsSeparatedByString:@"-"] firstObject];
    NSString *urlString = [NSString stringWithFormat:@"pages/post_contact.json"];
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:language forKey:@"api_language"];
    NSMutableDictionary *applicant = [[NSMutableDictionary alloc] init];
    if (email) {
        [applicant setObject:email forKey:@"email"];
        //        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&email=%@",email]];
        
    }
    if (username) {
        [applicant setObject:username forKey:@"name"];
    }
    if (phone) {
        [applicant setObject:phone forKey:@"phone"];
    }
    if (message) {
        [applicant setObject:message forKey:@"message"];
    }
    [parameters setObject:applicant forKey:@"applicant"];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:urlString
                                                      parameters:parameters];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //        self.userInfo = JSON;
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];
}


@end
