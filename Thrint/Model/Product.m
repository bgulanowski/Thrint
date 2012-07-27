#import "Product.h"

#import <ThrintKit/NSManagedObject+ViewAdditions.h>
#import <ThrintKit/NSManagedObject+BAAdditions.h>

#import "Component.h"
#import "Team.h"


@implementation Product

+ (NSManagedObject *)insertObject {
    
    Product *product = (Product *)[super insertObject];
    
    product.name = @"New Product";
    product.code = @"PRODUCT-CODE";
    product.startDate = [NSDate date];
    product.dueDate = [NSDate dateWithTimeIntervalSinceNow:24 * 7 * 24 * 3600];
    [product addComponentsObject:[Component insertComponent]];
    product.team = [Team insertTeam];
    
    return product;
}

+ (Product *)insertProduct {
    return (Product *)[self insertObject];
}

- (NSDictionary *)genericDetailSections {
    return [NSDictionary dictionaryWithObject:[NSArray arrayWithObjects:@"name", nil] forKey:@"General"];
}

- (NSArray *)orderedSectionTitles {
    return [NSArray arrayWithObject:@"General"];
}

- (NSArray *)displayPropertyNames {
    
    static __strong NSArray * names;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        names = [[NSArray alloc] initWithObjects:
                 @"name",
                 @"code",
                 @"startDate",
                 @"dueDate",
                 @"otherTitle",
                 @"other",
                 nil];
    });
    return names;
}

@end
