# Purpose: to create an interactive visualization of global statistics for population, fertility, and gdp per capita for years 1950 to 2015.

1. [Sql visualization data.py](https://github.com/nlynch504/data-analytics-portfolio/blob/master/Python/SQL_visualization/sql%20visualization%20data.py) population and fertility was taken from gap minder website and cleaned prior to sql merge

2. [gdp cap.py](https://github.com/nlynch504/data-analytics-portfolio/blob/master/Python/SQL_visualization/gdp%20cap.py) gdp per caputa was taken from gap minder website and cleaned prior to sql merge

3. “Sql_in” csv files generated by 1 and 2 were joined with sqlite based on [final_merge.text](https://github.com/nlynch504/data-analytics-portfolio/blob/master/Python/SQL_visualization/sql_in/final_merge.txt) query

4. [final visual.py](Python/SQL_visualization/final%20visual.py) imports final_merge table using the sqlite3 and pandas library. Used bokeh library to create interactive visualization.

5. To view dynamic visualization, user must use command line and move to the directory containing “final_visual.py” and run the following command: “bokeh serve final_visual.py”
![terminal bokeh command](https://github.com/nlynch504/data-analytics-portfolio/blob/master/Python/SQL_visualization/terminal%20bokeh%20command.png)


This will generate a local html webpage “http://localhost:5006/final_visual”“

6. Look at “bokeh.visualization.png”. You can change the year of x and y axis data. Move cursor over data point to get country name. Regions are categorized by color, where other represents island nations and the rest represent continents.
![visualization](https://github.com/nlynch504/data-analytics-portfolio/blob/master/Python/SQL_visualization/bokeh%20visualization.png)
