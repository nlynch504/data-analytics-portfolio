import sqlite3
import pandas as pd
import matplotlib.pyplot as plt
from bokeh.plotting import figure, show
from bokeh.io import output_file, curdoc
from bokeh.models import ColumnDataSource, HoverTool, CategoricalColorMapper, Slider, Select
from bokeh.palettes import Spectral5
from bokeh.layouts import widgetbox, row

#connects to db file
conn = sqlite3.connect('gap_data.db')

#converts to a dataframe
#helpful link http://www.datacarpentry.org/python-ecology-lesson/08-working-with-sql/
gap_data = pd.read_sql_query("SELECT * from final_merge", conn)

conn.close()

#get rid of na values and set index
gap_data = gap_data.dropna()
gap_data = gap_data.set_index('Year')

# make column source var
source = ColumnDataSource(data = {
                          'x' : (gap_data.loc[1970].GDPpercapita/1000),
                          'y' : gap_data.loc[1970].Fertility,
                          'country' : gap_data.loc[1970].Country,
                          'pop' : (gap_data.loc[1970].Population/ 1000000),
                          'region' : gap_data.loc[1970].Region,
                          })

# make regions list and color map
regions_list = gap_data.Region.unique().tolist()
color_map = CategoricalColorMapper(palette = Spectral5, factors=regions_list)

p = figure(x_axis_label= 'GDP/capita (Thousands)', y_axis_label = 'Fertility (kids per woman)')

p.add_tools(HoverTool(tooltips='@country'))
p.circle(x='x', y='y', source=source, color = dict(field='region', transform = color_map), legend = 'region')

# update via year
def update_year_plot (attribute, original, updated):
    # update values based on widgets
    year = slider.value
    x = x_select.value
    y = y_select.value

    #label axis
    p.xaxis.axis_label = x
    p.yaxis.axis_label = y

    #update data
    updated_data = {
                          'x' : gap_data.loc[year][x],
                          'y' : gap_data.loc[year][y],
                          'GDPpercapita' : (gap_data.loc[year].GDPpercapita/1000),
                          'country' : gap_data.loc[year].Country,
                          'Population' : (gap_data.loc[year].Population/ 1000000),
                          'region' : gap_data.loc[year].Region,
    }
    source.data = updated_data

# auto scale for x,y axes
    p.x_range.start = min(data[x])
    p.x_range.end = max(data[x])
    p.y_range.start = min(data[y])
    p.y_range.end = max(data[y])

#updated title based on slider
    p.title = 'Gap Statistics for %d' %year


# make a slider for the year
slider = Slider(title='Year', start = 1955, end = 2015, step = 1, value = 2000)

# include callback
slider.on_change('value', update_year_plot)

#create select buttons for x,y axes
x_select = Select(options=['Fertility','Population', 'GDPpercapita'], value = 'Fertility', title = 'x-axis data')

y_select = Select(options=['Fertility','Population', 'GDPpercapita'], value = 'GDPpercapita', title = 'y-axis data')
#callback
x_select.on_change('value', update_year_plot)
y_select.on_change('value', update_year_plot)

# updated graph layout
layout = row( widgetbox(slider, x_select, y_select) ,p)
curdoc().add_root(layout)

#command line commands "bokeh server --show final_visual.py" , remember the anaconda 3 package needs to be installed




