import pandas as pd
import copy

from bokeh.models.widgets import Slider, RadioGroup
from bokeh.layouts import row, widgetbox, column
from bokeh.plotting import show, figure, curdoc
from bokeh.io import output_file
from bokeh.models import ColumnDataSource, HoverTool, LogColorMapper, CustomJS, TapTool
from bokeh.sampledata import us_states
from bokeh.palettes import Viridis6 as palette


us_states = us_states.data.copy()
state_xs = [us_states[code]["lons"] for code in us_states]
state_ys = [us_states[code]["lats"] for code in us_states]
df_states = pd.DataFrame.from_dict(us_states, orient='index')
df = pd.read_csv("dfpandas.csv")
df = pd.merge(df_states, df, left_index=True , right_on='State.Code.of.the.Provider', how='left')

data = ColumnDataSource(df.to_dict('list'))


def create_plot():

    s1 = ColumnDataSource(data=dict(x=['Male', 'Female'], y=[0, 0]))  # Gender of Providers
    s2 = ColumnDataSource(data=dict(x=['Male', 'Female'], y=[0, 0]))  # Gender of Beneficiaries
    # s3 = ColumnDataSource()  # Type of Physicians

    callback = CustomJS(args=dict(source=data, s1=s1, s2=s2), code="""
        var i = source.selected.indices
        console.log(cb_data.source.data['male_prov'][i])
        console.log(cb_data.source.data['male_benif'][i])
        
        var d1 = s1.data;
        d1['x'] = []
        d1['y'] = []
        d1['x'].push('Male')
        d1['x'].push('Female')
        d1['y'].push(cb_data.source.data['male_prov'][i])
        d1['y'].push(cb_data.source.data['female_pro'][i])
        
        s1.change.emit();
        
        var d2 = s2.data;
        d2['x'] = []
        d2['y'] = []
        d2['x'].push('Male')
        d2['x'].push('Female')
        d2['y'].push(cb_data.source.data['male_benif'][i])
        d2['y'].push(cb_data.source.data['female_benif'][i])
        
        s2.change.emit();
        """)

    color_mapper = LogColorMapper(palette=palette)

    p = figure(title="Medicare Data", toolbar_location="left", plot_width=810, plot_height=484,
              match_aspect=True, aspect_scale=0.7, x_range=[-128, -64], y_range=[23, 50])
    p.patches('lons', 'lats', source=data, fill_alpha=1, line_color="#FF9200", line_width=1.25,
              fill_color={'field': 'male_prov', 'transform': color_mapper})
    p.add_tools(TapTool(callback=callback))

    q1 = figure(title="Providers Gender", x_range=['Male','Female'], plot_width=250, plot_height=250,
                y_axis_label='Number of Providers', x_axis_label="Gender")
    q1.vbar(x='x', top='y', width=0.5, source=s1)

    q2 = figure(title="Beneficiaries Gender", x_range=['Male', 'Female'], plot_width=250, plot_height=250,
                y_axis_label='Number of Beneficiaries', x_axis_label="Gender")
    q2.vbar(x='x', top='y', width=0.5, source=s2)

    return row(p,column(q1,q2))


def update1(attr, old ,new):
    layout.children[1] = create_plot()


#mapType = RadioGroup(labels=["State", "City", "ZipCode"], active=0)
#mapType.on_change('active', update1)

colorBy = RadioGroup(labels=["Provider", "Benificiaries"])
colorBy.on_change('active', update1)

layout = create_plot()

curdoc().add_root(layout)
curdoc().title = "Vegas Yelp - Businesses & Users"