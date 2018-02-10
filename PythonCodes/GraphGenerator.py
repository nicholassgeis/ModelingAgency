from openpyxl import (load_workbook, Workbook)
from openpyxl.chart import( ScatterChart, Reference, Series)

wb = load_workbook('ProblemCData.xlsx')

## Names for different worksheets

seseds = wb[wb.sheetnames[0]]
msncodes = wb[wb.sheetnames[1]]

testgraph = wb.create_sheet("Graph")

chart = ScatterChart()
chart.style = 13

for i in range(2, 50):

    code = seseds.cell(row=i, column=1)

    for j in range(2, 606):

        if code == msncodes.cell(row=j, column=1):

            chart.title = "msncodes.cell(row=i, column=2)"
            chart.x_axis.title = 'Years'
            chart.y_axis.title = 'msncodes.cell(row=i, column=3)'

            ## This will just check every cell. Not sure how to be smart

    chart.add_data(seseds.cell(row=i, column=2), seseds.cell(row=i, column=3))

testgraph.add_chart(chart, "A1")
wb.save("Test.xlsx")
