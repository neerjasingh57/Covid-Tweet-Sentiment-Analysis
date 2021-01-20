# Covid - 19 Tweet Sentiment Analysis

**Objective**

NLP on Tweets to determine public sentiment during the early stages of the pandemic.

**Introduction**

This summer, I received a great opportunity to attend a workshop hosted by Deloitte and the Smith Analytics Consortium focused on NLP and sentiment analysis led by several consultants who specialize in this space. Each week we worked on incremental tasks towards NLP analysis by cleaning the text, conducting sentiment analysis, and clustering with the culminating project to process 20+ million tweets in order to deliver a report on state sentiment toward the government response to the pandemic. All tweets were related to politics in some way, mentioned some version of the word "covid", and from the U.S. These tweets were also all collected during mid-March when the pandemic first began in the US.

Our group also received a Top 5 ranking out of all the reports submitted during this workshop! The process my group used to data analysis is detailed below.

**Pre-processing**

Although we learned many cleaning techniques in our workshop - luckily, for our final report we received the data for our dataset relatively clean (only essential words were kept - no filler words such as the or and) with a few exceptions.

Before conducting our analysis we did a little housekeeping: each entry included the tweet, a user id, and the state location. The state location was not in the same format for each tweet so we altered all of the states to the regular lower-case abbreviation. Additionally the user id was a long string of numbers and we needed to re-format this to be recognizable as well. 

**ANALYSIS**

*Exploratory Analysis - Word Frequency*

First, to get an overview of our dataset, I conducted a word frequency analysis. 

These were the most frequent words:

corona, covid19, coronavirus, virus, people, amp, covid, test, like, time, new, case, go, death, say, trump, get, pandemic, need, day, know, work, home, think, help.

*Sentiment Analysis*

First, we conducted sentiment analysis using the package vaderSentiment. This was a very helpful package that made it easy to deduce the sentiment of each tweet. I found, after reading some tweets, and observing its sentiment rating, that the sentiment analysis seemed to be accurate.

Scores ranged from -1 to + 1. With close to 0 classified as neutral, -1 as the most negative possible sentiment, and +1 as the most positive possible sentiment. As you can see below, people have strong opinions about politics.

We then labeled each score as neutral, negative, or positive. And the same dataset again as neutral, very negative, negative, very positive, and positive to see try and detect more nuanced sentiments.

We then aggregated all the scores and sentiments by state, to get the overall score for each state and sorted it by mean score.

Texas seems to have the most negative state sentiment but, overall, is still relatively neutral. This same occurs for Arizona, New Jersey, and Mississippi.

The graphs below display the distribution of tweet sentiment scores across the 50 states. We can see that overall, surprisingly, tweet sentiment is mostly positive.

*Clustering*

A bit more difficult in our analysis process, was our attempt to cluster these tweets into groups of overall sentiment to determine the the top topics being tweeted about. First, we vectorized the text, determined the number of clusters, then assigned clusters.

There are many metrics you can adjust during this process such as the number of clusters you want to create or change the number of ngrams (such as 1 word, 2 word phrases, or 3 word phrases). We stuck with 1 gram because of the long processing time for our large dataset. Overall this part of the analysis was unfortunately a bit vague possibly due to the size of the dataset, as well as possibly the innumerable topics tweeters were talking about, and we did not receive clear-cut recommendations based on the clustering.

**Conclusion**

It seemed that, overall, state sentiment across many states was neutral. Was this actually truly the overall U.S. states response to the pandemic in March? Maybe so, it is hard to tell. Especially considering that the effects of the pandemic were isolated to a couple spots in the U.S. at that time point in March, with a relatively limited amount of cases, this is possible. Recalling my own thoughts during that time period, I was just happy to receive extra days off during spring break, so perhaps my own tweet about covid would have been positive then. Of course, looking back now, this was definitely some misplaced enthusiasm.

**Limitations**

There were, we found, some limitations of the project. As mentioned above, it is difficult to determine the accuracy of our analysis without reading and labeling each tweet as positive or neutral beforehand and then running vaderSentiment to compare. This would have been especially time-consuming considering the original dataset had 20+ million tweets and stop words had already been removed as well as the short time period during which we conducted our project.

Overall, wrangling this large amount of data and improving my python and Google Colab skills proved to be a great use of my summer as well as an eye-opening look into the world of data science that I thoroughly enjoyed. 
