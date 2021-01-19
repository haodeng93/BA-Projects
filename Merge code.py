#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Oct 12 13:08:53 2020

@author: haodeng
"""

#Slice Monthly Pattern Dataset
import pandas as pd
for i,chunk in enumerate(pd.read_csv('patterns-part3.csv', chunksize=100000)):
    chunk.to_csv('pattern 03_19 - {}.csv'.format(i), index=False)
    
    
# import poi & pattern data
poi_data = pd.read_csv('/Users/haodeng/Desktop/MSBA/BSAN 710/SafeGraph Project files/Core POI/core_poi-part1.csv')
poi_data1 = pd.read_csv('/Users/haodeng/Desktop/MSBA/BSAN 710/SafeGraph Project files/Core POI/core_poi-part2.csv')
poi_data2 = pd.read_csv('/Users/haodeng/Desktop/MSBA/BSAN 710/SafeGraph Project files/Core POI/core_poi-part3.csv')
poi_data3 = pd.read_csv('/Users/haodeng/Desktop/MSBA/BSAN 710/SafeGraph Project files/Core POI/core_poi-part4.csv')
poi_data4 = pd.read_csv('/Users/haodeng/Desktop/MSBA/BSAN 710/SafeGraph Project files/Core POI/core_poi-part5.csv')

#Filter Walmart only
poi_data_filtered = poi_data.loc[poi_data.location_name=="Walmart"]
poi_data1_filtered = poi_data1.loc[poi_data1.location_name=="Walmart"]
poi_data2_filtered = poi_data2.loc[poi_data2.location_name=="Walmart"]
poi_data3_filtered = poi_data3.loc[poi_data3.location_name=="Walmart"]
poi_data4_filtered = poi_data4.loc[poi_data4.location_name=="Walmart"]


merge_Wal_poi = pd.concat([poi_data_filtered, poi_data1_filtered, poi_data2_filtered, poi_data3_filtered, poi_data4_filtered], ignore_index = True)

merge_Wal_poi.to_excel('Walmart_POI.xlsx')


# pull data by naics code
poi_data_filtered = poi_data.loc[poi_data.naics_code==452210]
poi_data1_filtered = poi_data1.loc[poi_data1.naics_code==452210]
poi_data2_filtered = poi_data2.loc[poi_data2.naics_code==452210]
poi_data3_filtered = poi_data3.loc[poi_data3.naics_code==452210]
poi_data4_filtered = poi_data4.loc[poi_data4.naics_code==452210]
# merge 5 datasets into 1
merge_poi = pd.concat([poi_data_filtered, poi_data1_filtered, poi_data2_filtered, poi_data3_filtered, poi_data4_filtered], ignore_index = True)
#Philadelphia Only
poi_452210_philly = merge_poi.loc[(merge_poi.city=="Philadelphia")& (merge_poi.region=="PA")]
#Save data into excel
poi_452210_philly.to_excel('poi_452210_philly.xlsx')
# check if there are duplicates row
merge_poi = merge_poi.drop_duplicates()


# March,19 part 3 data with only philadelphia data

# read sliced datasets and merge with merge_poi data
merged_list1903_philly = []
for i in range(11): 
    pattern_data_temp1903_philly = pd.read_csv('/Users/haodeng/Desktop/MSBA/BSAN 710/SafeGraph Project files/Monthly_Data/2019/03/pattern 03_19_{}.csv'.format(i))
    pattern_data_temp_filtered1903_philly = pattern_data_temp1903_philly[['safegraph_place_id','date_range_start','date_range_end','raw_visit_counts','raw_visitor_counts',
                                      'median_dwell','bucketed_dwell_times','related_same_day_brand','related_same_month_brand']]
  
    merged1903_philly = pd.merge(poi_452210_philly,pattern_data_temp_filtered1903_philly,on='safegraph_place_id', how='inner')
    merged_list1903_philly.append(merged1903_philly)
result1903_philly = pd.concat(merged_list1903_philly)
result1903_philly.to_excel('Philly_Mar_19_result.xlsx')



# read sliced datasets and merge with merge_poi data, Feb 19 part 3 only
merged_list = []
for i in range(11): 
    pattern_data_temp = pd.read_csv('/Users/haodeng/Desktop/MSBA/BSAN 710/SafeGraph Project files/Monthly_Data/2019/02/pattern 02_19 - {}.csv'.format(i))
    pattern_data_temp_filtered = pattern_data_temp[['safegraph_place_id','date_range_start','date_range_end','raw_visit_counts','raw_visitor_counts',
                                      'median_dwell','bucketed_dwell_times','related_same_day_brand','related_same_month_brand']]
  
    merged = pd.merge(merge_poi,pattern_data_temp_filtered,on='safegraph_place_id', how='inner')
    merged_list.append(merged)
result = pd.concat(merged_list)
#generate result
result.to_excel('Feb_19_result.xlsx')
merge_poi.to_excel('Merge_poi.xlsx')


# March,19 part 3 data

# read sliced datasets and merge with merge_poi data
merged_list1903 = []
for i in range(11): 
    pattern_data_temp1903 = pd.read_csv('/Users/haodeng/Desktop/MSBA/BSAN 710/SafeGraph Project files/Monthly_Data/2019/03/pattern 03_19 - {}.csv'.format(i))
    pattern_data_temp_filtered1903 = pattern_data_temp1903[['safegraph_place_id','date_range_start','date_range_end','raw_visit_counts','raw_visitor_counts',
                                      'median_dwell','bucketed_dwell_times','related_same_day_brand','related_same_month_brand']]
  
    merged1903 = pd.merge(merge_poi,pattern_data_temp_filtered1903,on='safegraph_place_id', how='inner')
    merged_list1903.append(merged1903)
result1903 = pd.concat(merged_list1903)
result1903.to_excel('Mar_19_result.xlsx')













































quarter_need = (num_change//quarter) % 100


dollar_need = num_change//dollar
dollar_left = num_change -(num_change//dollar) * dollar
quarter_need = dollar_left//quarter
quarter_left = dollar_left - (dollar_left//quarter) * quarter
dime_need = quarter_left//dimes
dime_left = quarter_left - (quarter_left//dimes) * dimes
nickels_need = dime_left//nickels
nickels_left = dime_left - (dime_left//nickels) * nickels
pennies_need = nickels_left/pennies

if (num_change <= 0):
    print('No change')
elif (dollar_left == 0):
    print('{} Dollar'.format(dollar_need))
elif ((dollar_left != 0) and (quarter_left == 0)):
    print('{} Dollar'.format(dollar_need))
    print('{} Quarter'.format(quarter_need))
elif ((quarter_left != 0) and (dime_left == 0)):
    print('{} Dollar'.format(dollar_need))
    print('{} Quarter'.format(quarter_need))
    print('{} Dimes'.format(dime_need))
elif ((quarter_left != 0) and (dime_left != 0) and (nickels_left == 0)):
    print('{} Dollar'.format(dollar_need))
    print('{} Quarter'.format(quarter_need))
    print('{} Dimes'.format(dime_need))
    print('{} Nickels'.farmat(nickels_need))
elif ((quarter_left != 0) and (dime_left != 0) and (nickels_left != 0)):
    print('{} Dollar'.format(dollar_need))
    print('{} Quarter'.format(quarter_need))
    print('{} Dimes'.format(dime_need))
    print('{} Nickels'.format(nickels_need))
    print('{} Pennies'.format(pennies_need))
else:
    print('No change')

