import pandas as pd
import copy
import math

from bokeh.models.widgets import Slider, RadioGroup, Tabs, Panel
from bokeh.layouts import row, widgetbox, column
from bokeh.plotting import show, figure, curdoc
from bokeh.io import output_file
from bokeh.models import ColumnDataSource, HoverTool, LogColorMapper, CustomJS, TapTool, LinearColorMapper, BasicTicker, CategoricalTicker, ColorBar
from bokeh.sampledata import us_states
from bokeh.palettes import Oranges9 as palette


palette.reverse()
df = pd.read_csv("dfsegment.csv")
prov_types = df.columns[4:93].tolist()
df['n'] = df['F'] + df['M']

df['Types'] = df[df.columns[4:93]].values.tolist()
df['Gender'] = df[df.columns[93:95]].values.tolist()
dfnew = df[['n','mmedpay','mmedbenif','Types','Gender']]
data1 = ColumnDataSource(dfnew.to_dict('list'))

us_states = us_states.data.copy()
state_xs = [us_states[code]["lons"] for code in us_states]
state_ys = [us_states[code]["lats"] for code in us_states]
df_states = pd.DataFrame.from_dict(us_states, orient='index')
df = pd.read_csv("dfpandas.csv")
df = pd.merge(df_states, df, left_index=True , right_on='State.Code.of.the.Provider', how='left')
data2 = ColumnDataSource(df.to_dict('list'))



def create_plot():

    s1 = ColumnDataSource(data=dict(y=prov_types, x=[0]*89))  # Type of Providers
    s2 = ColumnDataSource(data=dict(y=['Female', 'Male'], x=[0, 0]))  # Gender of Providers

    callback = CustomJS(args=dict(source=data1, s1=s1, s2=s2), code="""
        var i = source.selected.indices
        var d1 = s1.data;
        d1['x'] = cb_data.source.data['Types'][i]
        
        var d2 = s2.data;
        console.log(cb_data.source.data['Gender'][i])
        d2['x'] = cb_data.source.data['Gender'][i]

        s1.change.emit();
        s2.change.emit();
        """)

    color_mapper = LinearColorMapper(palette=palette, low=min(dfnew['n']), high=max(dfnew['n']))

    p = figure(title="Number of Physicians in Each Category", toolbar_location="left", plot_width=320, plot_height=320,
               x_range=(0.5, 5.5), y_range=(0.5, 5.5),
               x_axis_label='Standardized Payments', y_axis_label='Beneficiaries',
               match_aspect=True, aspect_scale=1)
    p.rect('mmedpay', 'mmedbenif', width=1, height=1, source=data1, fill_alpha=1, line_color="#FFFFFF", line_width=1.25,
              fill_color={'field': 'n', 'transform': color_mapper})

    color_bar = ColorBar(color_mapper=color_mapper, ticker=BasicTicker(),
                         label_standoff=12, border_line_color=None, location=(0, 0))
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
    # # Legend
    # p.legend.location = "center_right"
    # p.legend.orientation = "vertical"

    p.xaxis.major_label_overrides = {1: 'Lowest', 2: 'Low', 3: 'Medium', 4: 'High', 5:'Highest'}
    p.yaxis.major_label_overrides = {1: 'Lowest', 2: 'Low', 3: 'Medium', 4: 'High', 5:'Highest'}

    q1 = figure(title="Type of Providers", x_range=prov_types, #y_range=(0,200),
                plot_width=1000, plot_height=650,
                x_axis_label='Type of Providers', y_axis_label='Number of Providers')
    q1.vbar(x='y', top='x', width=0.5, source=s1, color='#EC8400')

    q1.add_layout(color_bar,'left')

    q1.outline_line_alpha = 0
    q1.yaxis.axis_line_color = "#a7a7a7"
    q1.yaxis.major_tick_line_color = "#a7a7a7"
    q1.yaxis.minor_tick_line_color = None
    q1.y_range.start = 0
    q1.yaxis.major_tick_out = 0

    q1.xaxis.major_label_orientation = math.pi/2
    q1.xaxis.axis_line_color = "#a7a7a7"
    q1.xaxis.minor_tick_line_color = None
    q1.xaxis.major_tick_line_color = None
    q1.xgrid.grid_line_color = None

    q2 = figure(title="Providers Gender", x_range=['Female', 'Male'], plot_width=350, plot_height=350,
                x_axis_label='% of Ratings Given', y_axis_label="Ratings",
                match_aspect=True, aspect_scale=1)
    q2.vbar(x='y', top='x', width=0.5, source=s2, color='#EC8400')

    q2.outline_line_alpha = 0
    q2.yaxis.axis_line_color = "#a7a7a7"
    q2.yaxis.major_tick_line_color = "#a7a7a7"
    q2.yaxis.minor_tick_line_color = None
    q2.y_range.start = 0
    q2.yaxis.major_tick_out = 0

    q2.xaxis.axis_line_color = "#a7a7a7"
    q2.xaxis.minor_tick_line_color = None
    q2.xaxis.major_tick_line_color = None
    q2.xgrid.grid_line_color = None

    return row(column(p,q2),q1)


def update1(attr, old, new):
    layout.children[1] = create_plot()


colorBy = RadioGroup(labels=["Provider", "Beneficiaries"])
colorBy.on_change('active', update1)

layout = create_plot()

curdoc().add_root(layout)
curdoc().title = "Medicare Data"
