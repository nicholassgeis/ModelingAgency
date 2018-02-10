from openpyxl import (load_workbook, Workbook)
from openpyxl.chart import( ScatterChart, Reference, Series)

wb = load_workbook('ProblemCData.xlsx')

## Names for different worksheets

seseds = wb[wb.sheetnames[0]]
msncodes = wb[wb.sheetnames[1]]

graphs = wb.create_sheet("Graphs")

chart = ScatterChart()
chart.style = 13

for i in range(2, 52):

    c = seseds.cell(row=i, column=1)
    d = seseds.cell(row=i, column=2)

    code = c.value
    state = d.value

    x = Reference(seseds, min_col=3, min_row = 2, max_row=51)
    y = Reference(seseds, min_col=4, min_row = 2, max_row=51)
    s = Series(y, xvalues=x)
    chart.append(s)

    for j in range(2, 607):

        cd = msncodes.cell(row=j, column=1)
        title = msncodes.cell(row=j, column=2)
        y_axis = msncodes.cell(row=j, column = 3)

        if code == cd.value:

            newtitle = (title.value + " " + state)

            chart.title = newtitle
            chart.x_axis.title = 'Years'
            chart.y_axis.title = y_axis.value

            ## This will just check every cell. Not sure how to be smart

    

testgraph.add_chart(chart, "A1")
wb.save("Test.xlsx")
