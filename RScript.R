install.packages("readxl")
install.packages("plyr")
library(readxl)
library(plyr)
#rm(list=ls()) 

seseds = read_excel("/Users/rdcarini/Documents/Projects/modeling/ModelingAgency/PythonCodes/AdjustedCData.xlsx", sheet = "seseds")
msncodes = read_excel("/Users/rdcarini/Documents/Projects/modeling/ModelingAgency/PythonCodes/AdjustedCData.xlsx", sheet = "msncodes")

###########################################################################################
both = join(seseds,msncodes)

btu_energy_data = subset(both,both$Unit=="Billion Btu")
btu_energy_msncodes = subset(msncodes,msncodes$Unit=="Billion Btu")
btu_energy_data$Unit<-NULL
btu_energy_msncodes$Unit<-NULL
total_btu_energy_data = subset(btu_energy_data,grepl("total",btu_energy_data$Description,ignore.case=TRUE))
total_btu_energy_msncodes = subset(btu_energy_msncodes,grepl("total",btu_energy_msncodes$Description,ignore.case=TRUE))

write.csv(total_btu_energy_data, "TotalBtuEnergyData.csv",row.names=FALSE)
write.csv(total_btu_energy_msncodes, "TotalBtuEnergyData_msn.csv",row.names=FALSE)

tfc_data = subset(total_btu_energy_data,grepl("^.*.*TCB$",total_btu_energy_data$MSN,ignore.case=TRUE))
tfc_msncodes = subset(total_btu_energy_msncodes,grepl( "^.*.*TCB$",total_btu_energy_msncodes$MSN,ignore.case=TRUE))
tpes_data = subset(total_btu_energy_data,grepl( "^.*.*TCB$",total_btu_energy_data$MSN,ignore.case=TRUE))
tpes_msncodes = subset(total_btu_energy_msncodes,grepl("^.*.*TCB$",total_btu_energy_msncodes$MSN,ignore.case=TRUE))

write.csv(tfc_data, "TotalFinalConsumption.csv",row.names=FALSE)
write.csv(tfc_msncodes, "TotalFinalConsumption_msn.csv",row.names=FALSE)
write.csv(tpes_data, "TotalPrimaryEnergySupply.csv",row.names=FALSE)
write.csv(tpes_msncodes, "TotalPrimaryEnergySupply_msn.csv",row.names=FALSE)

btu_energy_data$Renewable<-NA
btu_energy_msncodes$Renewable<-NA
dictRenewable <- c("solar","wind","geothermal","photovoltaic","natural gas","produced","production","biomass","Biomass")
dictNonrenewable <- c("coke","coal","Coal","fossil fuel","consumed","consumption")

for (word in dictNonrenewable){
  btu_energy_data$Renewable[grepl(word,btu_energy_data$Description)]<-"FALSE"
}
for (word in dictRenewable){
  btu_energy_data$Renewable[grepl(word,btu_energy_data$Description)]<-"TRUE"
}

for (word in dictNonrenewable){
  btu_energy_msncodes$Renewable[grepl(word,btu_energy_msncodes$Description)]<-"FALSE"
}
for (word in dictRenewable){
  btu_energy_msncodes$Renewable[grepl(word,btu_energy_msncodes$Description)]<-"TRUE"
}

write.csv(btu_energy_data, "RenewableEnergyData_FIXME.csv",row.names=FALSE)
write.csv(btu_energy_msncodes, "RenewableEnergyDataMSN_FIXME.csv",row.names=FALSE)
#############################################################################

california = subset(btu_energy_data,btu_energy_data$StateCode=="CA")
arizona = subset(btu_energy_data,btu_energy_data$StateCode=="AZ")
newmexico = subset(btu_energy_data,btu_energy_data$StateCode=="NM")
texas = subset(btu_energy_data,btu_energy_data$StateCode=="TX")

ca_total = sum(california$Data)
ca_renewabletotal = sum(subset(california,california$Renewable=="TRUE")$Data)
ca_nonrenewabletotal = sum(subset(california,california$Renewable=="FALSE")$Data)
ca_renewablepercent = ca_renewabletotal/ca_total*100.0
ca_nonrenewablepercent = ca_nonrenewabletotal/ca_total*100.0

az_total = sum(arizona$Data)
az_renewabletotal = sum(subset(arizona,arizona$Renewable=="TRUE")$Data)
az_nonrenewabletotal = sum(subset(arizona,arizona$Renewable=="FALSE")$Data)
az_renewablepercent = az_renewabletotal/az_total*100.0
az_nonrenewablepercent = az_nonrenewabletotal/az_total*100.0

nm_total = sum(newmexico$Data)
nm_renewabletotal = sum(subset(newmexico,newmexico$Renewable=="TRUE")$Data)
nm_nonrenewabletotal = sum(subset(newmexico,newmexico$Renewable=="FALSE")$Data)
nm_renewablepercent = nm_renewabletotal/nm_total*100.0
nm_nonrenewablepercent = nm_nonrenewabletotal/nm_total*100.0

tx_total = sum(texas$Data)
tx_renewabletotal = sum(subset(texas,texas$Renewable=="TRUE")$Data)
tx_nonrenewabletotal = sum(subset(texas,texas$Renewable=="FALSE")$Data)
tx_renewablepercent = tx_renewabletotal/tx_total*100.0
tx_nonrenewablepercent = tx_nonrenewabletotal/tx_total*100.0

renewable_percents <- c(ca_renewablepercent,az_renewablepercent,nm_renewablepercent,tx_renewablepercent)
nonrenewable_percents <- c(ca_nonrenewablepercent,az_nonrenewablepercent,nm_nonrenewablepercent,tx_nonrenewablepercent)
all_percents <- data.frame(renewable_percents, nonrenewable_percents)

barplot(t(as.matrix(all_percents)), main="Percentages",
        xlab="States", col=c("darkblue","red"),
        legend = rownames(t(as.matrix(all_percents))))
dev.copy(png,'Percentages.png')
dev.off()
