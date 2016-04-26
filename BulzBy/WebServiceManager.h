//
//  WebServiceManager.h
//  BulzBy
//
//  Created by Seby Feier on 14/04/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DictionaryAndErrorCompletionBlock)(NSDictionary *dictionary, NSError *error);
typedef void(^ArrayAndErrorCompletionBlock)(NSArray *array, NSError *error);

@interface WebServiceManager : NSObject

@property (nonatomic, strong) NSMutableArray *listOfRestaurants;
@property (nonatomic, strong) NSString *language;
@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, strong) NSDictionary *userDetails;

+ (WebServiceManager *)sharedInstance;
- (void)getListOfRestaurantsWithPageNumber:(NSNumber *)pageNumber categoryId:(NSString *)categoryId cityId:(NSString *)cityId name:(NSString *)name andCompletionBlock:(ArrayAndErrorCompletionBlock)completionBlock;

- (void)getListOfCategoriesWithCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock;

- (void)registerWithEmail:(NSString *)email andPassword:(NSString *)password andUsername:(NSString *)username phoneNumber:(NSString *)phoneNumber withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock;

- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock;

- (void)showUserDetailsWithApiToken:(NSString *)apiToken withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock;

- (void)bookLocationForApiToken:(NSString *)apiToken locationIdid:(NSString *)locationId description:(NSString *)description dateTime:(NSString *)dateTime withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock;

- (void)reviewCompanyWithApiToken:(NSString *)apiToken withCompanyId:(NSString *)companyId description:(NSString *)description starFood:(NSNumber *)starFood starService:(NSNumber *)starService starEnvironment:(NSNumber *)starEnvironment withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock;

- (void)getCompanyInformationWithId:(NSString *)restaurantId withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock;
@end
