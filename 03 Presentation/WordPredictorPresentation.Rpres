<style>

  .reveal h1, .reveal h2, .reveal h3 {
    margin-top: 20px;
    margin-bottom: 20px;
    padding-top: 10px;
    padding-bottom: 20px;
    padding-left: 10px;
    background-color: #E8E8E8;
  }

  .midcenter {
      position: fixed;
      top: 50%;
      left: 50%;
  }

  .footer {
      color: black;
      background: #E8E8E8;
      position: fixed;
      top: 83%;
      text-align:center;
      width:100%;
  }

</style>
Building a Word Predictor with RStudio
========================================================
author: Bjoern W. Steffens
date: October 9, 2016
width: 1440
height: 900


1. Word Predictor Objectives
========================================================
<div class="footer">Word prediction by Bjoern W. Steffens</div>
**Predictive text** is an input technology used where one key or button represents many letters, such as on the numeric keypads of **mobile phones and in accessibility technologies**. 

Each key press results in a prediction rather than repeatedly sequencing through the same group of "letters" it represents, in the same, invariable order. 

Predictive text could allow for an entire word to be input by single keypress. **Predictive text makes efficient use of fewer device keys to input writing into a text message**, an e-mail, an address book, a calendar, and the like.

Source: <a href="https://en.wikipedia.org/wiki/Predictive_text" target="_top"/>Wikipedia</a>


2. Implementation Overview
========================================================
<div class="footer">Word prediction by Bjoern W. Steffens</div>
The solution is based on Natural Language Processing <a href="https://cran.r-project.org/web/views/NaturalLanguageProcessing.html" target="_top"> (NLP)</a> research implementing various R-libraries working on large quantities of text or Corpuses. These activities are also referred to as <a href="https://eight2late.wordpress.com/2015/05/27/a-gentle-introduction-to-text-mining-using-r/" target="_top">text mining.</a>

Text from three different sources (blogs, news and twitter) with ~100 million words have been randomly sampled where the frequency of word and combinations <a href="https://en.wikipedia.org/wiki/N-gram"> (ngrams)</a> of 180,000 words have been looked at in detail. 

The frequency of 2, 3 and 4 word compbinations (models) have been pre-processed and persisted in files. These files provide the models for predicting possible next words. 

When text is keyd in, one of these models is scanned picking the statistically most significant word (higest frequency in the model scanned) as guess for predicting next word.


3. Technical Implementation
========================================================
<div class="footer">Word prediction by Bjoern W. Steffens</div>
1. Large quantities of text from Internet (blogs, news and twitter) feeds have been randomly sampled.

2. The corpus (text) has been <a href="https://github.com/bjoernsteffens/capstone_science/blob/master/01%20Build%20nGram%20Models/create_nGrams.R" target="_top"> processed </a> looking for frequencies of word and combination of words <a href="http://rpubs.com/bjoerntheviking/projectstatus" target="_top"> (models).</a> 

3. The frequency of 1, 2, 3 and 4 word combinations (ngrams) are persited to disk to be used by the word predictor implementation.

4. The ngrams are used by the application to scan and predict the next possible word with the highest frequency (statistically most likely next word).

<p style="font-size: 18px">Note: Step 1 through 3 above were implemented on a 12 Core system randmply sampling 180,000 words from a text corpus of ~100 million words. Creating all the ngrams took approximately 35 minutes on this system using R. Leveraging Spark instead will get the processing time down significantly</p>

4. Performance Considerations
========================================================
<div class="footer">Word prediction by Bjoern W. Steffens</div>
From a text corpus of 180,000 processed words stored in separate files, the following observations were made. Lookup performance of <0.5 seconds can be considered as acceptable.

| ngram      | File Size (MB)  | Lookup Time-1  | Lookup Time-2 |
| :------:   | -----------:    | -------------: | ------------: |
| 2          | 34              | 0.23           | 0.21          |
| 3          | 36              | 0.24           | 0.22          |
| 4          | 40              | 0.26           | 0.24          |

Considering the file size and lookup time of loading all matched entries (1) or simply only the top 5 (2) we can tune memory and performance of the implementation. Devices with more memory we can prepare larger ngram files and get more accurate predictions. 


5. Prototype Resources
========================================================
<div class="footer">Word prediction by Bjoern W. Steffens</div>
<div class="midcenter" style="margin-left:250px; margin-top:-200px">
<img src="./images/wordcloud.png"></img>
</div>

- Link to <a href="https://github.com/bjoernsteffens/capstone_science" target="_top">GitHub</a> source code
- Link to Shinyio application to try it out


Appendix - References
========================================================
<div class="footer">Word prediction by Bjoern W. Steffens</div>
Here are the technical references used to format these slides.

- https://support.rstudio.com/hc/en-us/articles/200486468-Authoring-R-Presentations
- https://rpubs.com/ajlyons/rpres_css
- https://support.rstudio.com/hc/en-us/articles/200714023-Displaying-and-Distributing-Presentations

