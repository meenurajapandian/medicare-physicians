import pandas as pd
import copy
import math

from bokeh.models.widgets import Slider, RadioGroup
from bokeh.layouts import row, widgetbox, column
from bokeh.plotting import show, figure, curdoc
from bokeh.io import output_file
from bokeh.models import ColumnDataSource, HoverTool, LogColorMapper, CustomJS, TapTool
from bokeh.sampledata import us_states
from bokeh.palettes import Oranges9 as palette

palette.reverse()
df = pd.read_csv("dfsegment.csv")

prov_types = df.columns[4:93].tolist()
#print(prov_types)
df['n'] = df['F'] + df['M']

df['Types'] = df[df.columns[4:93]].values.tolist()
df['Gender'] = df[df.columns[93:95]].values.tolist()
dfnew = df[['n','mmedpay','mmedbenif','Types','Gender']]

data=ColumnDataSource(dfnew.to_dict('list'))



def create_plot():

    s1 = ColumnDataSource(data=dict(y=prov_types, x=[0]*89))  # Type of Providers
    s2 = ColumnDataSource(data=dict(y=['Female', 'Male'], x=[0, 0]))  # Gender of Providers

    callback = CustomJS(args=dict(source=data, s1=s1, s2=s2), code="""
        var i = source.selected.indices
        var d1 = s1.data;
        d1['x'] = cb_data.source.data['Types'][i]
        
        var d2 = s2.data;
        console.log(cb_data.source.data['Gender'][i])
        d2['x'] = cb_data.source.data['Gender'][i]

        s1.change.emit();
        s2.change.emit();
        """)

    color_mapper = LogColorMapper(palette=palette)

    p = figure(title="Medicare Data", toolbar_location="left", plot_width=380, plot_height=380,
               x_range=(0.5, 5.5), y_range=(0.5, 5.5),
               match_aspect=True, aspect_scale=1)
    p.rect('mmedpay', 'mmedbenif', width=1, height=1, source=data, fill_alpha=1, line_color="#FFFFFF", line_width=1.25,
              fill_color={'field': 'n', 'transform': color_mapper})
    p.add_tools(TapTool(callback=callback))
    p.outline_line_alpha = 0
    p.xgrid.grid_line_color = None
    p.ygrid.grid_line_color = None
    p.yaxis.axis_line_color = None
    p.yaxis.major_tick_line_color = None
    p.yaxis.minor_tick_line_color = None
    p.yaxis.major_tick_out = 0
    p.ygrid.grid_line_color = None
    p.xaxis.axis_line_color = None
    p.xaxis.minor_tick_line_color = None
    p.xaxis.major_tick_line_color = None

    p.xaxis.major_label_overrides = {1: 'Lowest', 2: 'Low', 3: 'Medium', 4: 'High', 5:'Highest'}
    p.yaxis.major_label_overrides = {1: 'Lowest', 2: 'Low', 3: 'Medium', 4: 'High', 5:'Highest'}

    q1 = figure(title="Type of Providers", x_range=prov_types, #y_range=(0,200),
                plot_width=1000, plot_height=650,
                y_axis_label='Type of Providers', x_axis_label='Number of Providers')
    q1.vbar(x='y', top='x', width=0.5, source=s1)

    q1.outline_line_alpha = 0
    q1.yaxis.axis_line_color = "#a7a7a7"
    q1.yaxis.major_tick_line_color = "#a7a7a7"
    q1.yaxis.minor_tick_line_color = None
    q1.y_range.start = 0
    q1.yaxis.major_tick_out = 0

    q1.xaxis.major_label_orientation = math.pi/2
    q1.xaxis.axis_line_color = None
    q1.xaxis.minor_tick_line_color = None
    q1.xaxis.major_tick_line_color = None
    q1.xgrid.grid_line_color = None

    q2 = figure(title="Providers Gender", x_range=['Female', 'Male'], plot_width=250, plot_height=250,
                y_axis_label='% of Ratings Given', x_axis_label="Ratings")
    q2.vbar(x='y', top='x', width=0.5, source=s2)

    q2.outline_line_alpha = 0
    q2.yaxis.axis_line_color = "#a7a7a7"
    q2.yaxis.major_tick_line_color = "#a7a7a7"
    q2.yaxis.minor_tick_line_color = None
    q2.y_range.start = 0
    q2.yaxis.major_tick_out = 0

    #q1.xaxis.major_label_orientation = math.pi / 2
    q2.xaxis.axis_line_color = None
    q2.xaxis.minor_tick_line_color = None
    q2.xaxis.major_tick_line_color = None
    q2.xgrid.grid_line_color = None

    return row(column(p,q2),q1)


def update1(attr, old, new):
    layout.children[1] = create_plot()


# mapType = RadioGroup(labels=["State", "City", "ZipCode"], active=0)
# mapType.on_change('active', update1)

colorBy = RadioGroup(labels=["Provider", "Benificiaries"])
colorBy.on_change('active', update1)

layout = create_plot()

curdoc().add_root(layout)
curdoc().title = "Medicare Data"
