//  Created by Boris Schneiderman.
//  Copyright (c) 2012-2013 The Readium Foundation.
//
//  The Readium SDK is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//


#import "LOXSpine.h"
#import "LOXSpineItem.h"


@implementation LOXSpine {

    NSMutableArray* _items;

}

@synthesize items = _items;

- (id)init
{
    if ((self = [super init])) {
        _items = [[NSMutableArray alloc] init];
    }

    return self;
}

- (void)dealloc {
    [_items release];
    [super dealloc];
}

- (void)addItem:(LOXSpineItem *)spineItem
{
    [_items addObject:spineItem];
}

- (void)clear
{
    [_items removeAllObjects];
}

-(NSInteger)itemCount
{
    return [_items count];
}

-(NSString*) toJSON
{
    NSDictionary * dict = [self toDictionary];

    NSData* encodedData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];

    NSString* jsonString = [[[NSString alloc] initWithData:encodedData encoding:NSUTF8StringEncoding] autorelease];

    return jsonString;
}

-(NSDictionary *) toDictionary
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];

    NSMutableArray * itemDicts = [NSMutableArray array];

    for(LOXSpineItem * item in _items) {
        [itemDicts addObject:[item toDictionary]];
    }

    [dict setObject:itemDicts forKey:@"items"];
}



@end