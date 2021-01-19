//*****NATIONAL CONSOLIDATED BREWERY RATING DATABASE****// 

/////  ---- The DSCI 511 Brewery Team ---- /////
Wynton Britton
Russell Destremps
Hao Deng
Evan Falkowski
DSCI 511, Data Acquisition and Pre-Processing


///// ---- Comments -----  //////
In order to obtain the full end result of a consolidated brewery rating and review database for the United States, the following Python notebooks and/or supporting files are provided. The following is the required sequential manner in which these files shoudl be processed in order to recreate results. 

Detailed notes/comments are found within each respective Python notebook. 
///// ---- How to use these files ---- ///////

1. Brewers Association Database. 
- Input: none. 
- Membership fees required for full access, however the version used for this study is a static, “manually” scraped dataset. Website structure does not lend itself to automated scraping.
- Output: "brewery_master.csv"

Step 2 can be run in either order. 

2a. Google Places. "Creating a Dataset of Brewery Data via Google Places API.ipynb"
- Input: "brewery_master.csv" & "google_querries2.json"
- note that properly executing all included code requires a paid API key.  A full repsonse json file is provided so that script can be rerun from point forward of API query. 
- Output: "full_table.csv"

2b. Yelp Fusion. "Creating a Dataset of Brewery Data via Yelp Fusion API.ipynb"
Input: "brewery_master.csv"
- note that this notebook must be run four times based on daily API query restrictions. 
Output: "copy1YelpData.csv", "copy2YelpData.csv", "copy3YelpData.csv", "copy4YelpData.csv"

3.  "Join Brewery Review Data.ipynb"
Input: "brewery_master.csv", "full_table.csv", "copy1YelpData.csv", "copy2YelpData.csv", "copy3YelpData.csv", "copy4YelpData.csv"
Output: complete_database.csv