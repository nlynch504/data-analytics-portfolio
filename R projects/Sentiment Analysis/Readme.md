# Purpose: To use commoncrawl web data, aws, python, and R to perform sentiment analysis on iPhone and Galaxy Phones. 

## Data visualizations and insights ## 
RandomForest with mtry = 24 was the most accurate classifier method for both datasets. See dotplots below for support. 

**Galaxy predictive model accuracy results**
![galaxydotplot](https://github.com/nlynch504/data-analytics-portfolio/blob/master/R%20projects/Sentiment%20Analysis/4.%20R%20Machine%20Learning%20Data%20Analytics/model%20outputs/Galaxy_model_summary.png)

**iPhone predictive model accuracy results** 
![iphonedotplot](https://github.com/nlynch504/data-analytics-portfolio/blob/master/R%20projects/Sentiment%20Analysis/4.%20R%20Machine%20Learning%20Data%20Analytics/model%20outputs/Iphone_model_summary.png)

**Initial sentiment counts**

![sentimenthistogram](https://github.com/nlynch504/data-analytics-portfolio/blob/master/R%20projects/Sentiment%20Analysis/4.%20R%20Machine%20Learning%20Data%20Analytics/model%20outputs/Sentiment%20findings.png)

**Insights:**  Both phones had more positive results than negative. The iPhone dataset had stronger sentiments over the entire range and had more positive sentiments. Therefore, it is recommended that Helio develop their medical application for iPhone platform. In addition, Apple’s operating system is similar across their phone models, which makes development for iPhone easier than Galaxy phones. The different Galaxy phones use a wide range of android operating systems versions and this makes application development more complicated.

The majority of the webpages had a neutral sentiment because only a small fraction of webpages review phones on Internet. The datasets had a normal distribution. There were no abnormalities noted. 

For future projects, Alert Analytics will determine if it is possible to get webpage data just for technology from common crawl organization. As a result, future findings will have more meaningful results because unnecessary data will be removed. 

See **[Summary Findings](https://github.com/nlynch504/data-analytics-portfolio/blob/master/R%20projects/Sentiment%20Analysis/Summary%20Findings.docx)** for additional information. 


## Project structure and description ##
**Note**: See [Ref - python scripts folder](https://github.com/nlynch504/data-analytics-portfolio/blob/master/R%20projects/Sentiment%20Analysis/5.%20Ref%20-%20python%20scripts) for the web scrapping and calculating sentiment scripts. See word documents, for summary findings and lessons learned reports. 

### **Webscrapping**
1. Obtain common crawl webpage data from [http://commoncrawl.org/connect/blog/](http://commoncrawl.org/connect/blog/). Unzip file using 7zip. 
2. Create aws account at [http://aws.amazon.com/](http://aws.amazon.com/). Create S3 buckets for mapper & reduce python files, output files, and logging data within aws website. I used Cyberduck to create desktop locations for these files that syncs with aws. Copy Mapper.py and Reducer.py into the mapper/reduce bucket you created.  
3. Open [wet.paths](https://github.com/nlynch504/data-analytics-portfolio/blob/master/R%20projects/Sentiment%20Analysis/1.%20web%20scrapping/wet.paths) from common crawl zip file and open within a text editor like Sublime 3 text or Notepad++. Within text editor, replace “crawl-data” with your S3 address “s3://commoncrawl/crawl-data”. Save file as “[websites.bdf](https://github.com/nlynch504/data-analytics-portfolio/blob/master/R%20projects/Sentiment%20Analysis/1.%20web%20scrapping/websites.bdf)”. You need around 250 wet address files with your bdf file for this task. Wet addresses are how commoncrawl.org stores website information. 
4. Create an EMR cluster within [https://aws.amazon.com/emr/](https://aws.amazon.com/emr/) with the mapper/reduce bucket & output bucket to determine your subnet address. Your input address will be one of the wet web addresses in your websites.bdf file. Make sure to terminate your cluster. 
5. Configure aws to run from the command line. reference: [https://docs.aws.amazon.com/cli/latest/userguide/installing.html#install-msi-on-windows](https://docs.aws.amazon.com/cli/latest/userguide/installing.html#install-msi-on-windows)
6. Open terminal or cmd and navigate the folder containing bdf & **createJsonFilesPv3.py** files. Update the createjson python file with the proper S3  addresses for mapper & reduce folder and output folder (Make sure to include a subfolder within your output folder).Then, run the  createJson file within terminal with [**python createJsonFilesPv3.py**](https://github.com/nlynch504/data-analytics-portfolio/blob/master/R%20projects/Sentiment%20Analysis/1.%20web%20scrapping/createJsonFilesPv3.py). The terminal will ask for the bdf file name, enter **websites.bdf**. It will then ask for an output file name with json, I chose [AWS_websites](https://github.com/nlynch504/data-analytics-portfolio/blob/master/R%20projects/Sentiment%20Analysis/1.%20web%20scrapping/AWS_websites.json)
7.  Open [AWS_websites.json](https://github.com/nlynch504/data-analytics-portfolio/blob/master/R%20projects/Sentiment%20Analysis/1.%20web%20scrapping/AWS_websites.json) within text editor. Copy code into [http://jsonlint.com/](http://jsonlint.com/) to check for any coding errors. In this case, The original file needed a closing bracket “]”. Once the Json file has been validated, copy code back into text editor and save it.
8.  Use aws_cli_command text below and enter it into your terminal. The process took about 15 hours to run for 250 addresses. You will need to update the code below for the following fields: name, subnetID(based on aws cluster created above.), log-uri (based on the S3 bucket you created), and --steps. 

**AWS command**
`aws emr create-cluster --name "c4_t2_date_3_7_18" --ec2-attributes SubnetId=subnet-85421ae1 --ami-version 3.11.0 --auto-terminate --log-uri s3://3-debug-c4t2/ --use-default-roles --enable-debugging --instance-groups InstanceGroupType=MASTER,InstanceCount=1,InstanceType=m4.large InstanceGroupType=CORE,InstanceCount=3,InstanceType=m4.large --steps file://AWS_websites.json`

### **Output**
9. Copy your output folders from your s3 output bucket into your own output folder. Open terminal or cmd and navigate to the output folder directory. Run the [concatenatepv3.py](https://github.com/nlynch504/data-analytics-portfolio/blob/master/R%20projects/Sentiment%20Analysis/2.%20output/concatenatepv3.py) with the folding code “python concatenatepv3.py”. The terminal will ask for an output location, leave it blank and press enter. This will create 2 csv files ([concatenated_websites](https://github.com/nlynch504/data-analytics-portfolio/blob/master/R%20projects/Sentiment%20Analysis/2.%20output/concatenated_websites.csv) and [concatenated_factors](https://github.com/nlynch504/data-analytics-portfolio/blob/master/R%20projects/Sentiment%20Analysis/2.%20output/concatenated_factors.csv)). You want to have around 20k observations for your sentiment analysis.     

10. Copy the csv files to the **3. final output** folder

### **Final Output**
11. Navigate to the final output folder within the terminal and run [python robolabelpv3.py](https://github.com/nlynch504/data-analytics-portfolio/blob/master/R%20projects/Sentiment%20Analysis/3.%20final%20output/robolabelpv3.py). This will generate a sentiment csv file with the following columns “id, iphoneSentiment, and galaxySentiment” The sentiment columns will act as dependent variables for your machine learning in R. 

12. Using excel, cut and paste the iphoneSentiment column into your [concatenated_factors.csv](https://github.com/nlynch504/data-analytics-portfolio/blob/master/R%20projects/Sentiment%20Analysis/3.%20final%20output/concatenated_factors.csv) file. Save this file as [iPhoneLargeMatrix.csv](https://github.com/nlynch504/data-analytics-portfolio/blob/master/R%20projects/Sentiment%20Analysis/3.%20final%20output/iPhoneLargeMatrix.csv). Create the [GalaxyLargeMatrix.csv](https://github.com/nlynch504/data-analytics-portfolio/blob/master/R%20projects/Sentiment%20Analysis/3.%20final%20output/GalaxyLargeMatrix.csv) file. The files will be used for machine learning within R. 


### **R Data Analytics**
13. Confirm that GalaxyLargeMatrix and iPhoneLargeMatrix csv files are in the **4. R Machine Learning Data Analytics** folder
14. Run scripts in chronological order
* [1. data import and cleansing.R](https://github.com/nlynch504/data-analytics-portfolio/blob/master/R%20projects/Sentiment%20Analysis/4.%20R%20Machine%20Learning%20Data%20Analytics/1.%20data%20import%20and%20cleaning.R)
* [2.Parallel processing.R](https://github.com/nlynch504/data-analytics-portfolio/blob/master/R%20projects/Sentiment%20Analysis/4.%20R%20Machine%20Learning%20Data%20Analytics/2.%20Parallel%20processing.R). Change the number of cores based on your CPU architecture. You do not want to use all the CPU cores on your PC, please leave 1 core to perform backgrounds processes. Otherwise, your PC will crash.
* [3. modeling.R](https://github.com/nlynch504/data-analytics-portfolio/blob/master/R%20projects/Sentiment%20Analysis/4.%20R%20Machine%20Learning%20Data%20Analytics/3.%20Modeling.R)

15. Write the **[Lessons Learned Report](https://github.com/nlynch504/data-analytics-portfolio/blob/master/R%20projects/Sentiment%20Analysis/Lessons%20Learned%20Report.docx)** and **[Summary Findings](https://github.com/nlynch504/data-analytics-portfolio/blob/master/R%20projects/Sentiment%20Analysis/Summary%20Findings.docx)**.
