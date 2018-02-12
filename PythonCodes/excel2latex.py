from openpyxl import load_workbook

def nonone(s):
    if(s="None"):
        return("")
    return(s)

def tex(file,x,y):
    wb = load_workbook(file)
    ws = wb.active
    s="\\begin{tabular}\n"
    for j in range(1,x+1):
        for i in range(1,y):
            s+=str(ws.cell(j,i).value)+" & "
        s+=str(ws.cell(j,y).value)+" \\\\ \n"
    s+="\\end{tabular}"
    return(s)

print(tex("ProblemCData.xlsx",10,4))
