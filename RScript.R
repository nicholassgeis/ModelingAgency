install.packages("readxl")
install.packages("plyr")
library(readxl)
library(plyr)

#rm(list=ls()) 

path = "/Users/rdcarini/Documents/Projects/modeling/"
seseds = read_excel(paste(path,"ModelingAgency/PythonCodes/AdjustedCData.xlsx",sep=""), sheet = "seseds")
msncodes = read_excel(paste(path,"ModelingAgency/PythonCodes/AdjustedCData.xlsx",sep=""), sheet = "msncodes")

###########################################################################################

both = join(seseds,msncodes)
summary(both)

data2009 <- subset(both,both$Year=="2009")
data2009$Year<-NULL
summary(data2009)

coal_data2009 <- data2009[grep("coal", data2009$Description, ignore.case=TRUE),]
nattygas_data2009 <- data2009[grep("natural gas", data2009$Description, ignore.case=TRUE),]
motor_data2009 <- data2009[grep("motor", data2009$Description, ignore.case=TRUE),]
distillate_data2009 <- data2009[grep("distillate", data2009$Description, ignore.case=TRUE),]
lpg_data2009 <- data2009[grep("lpg", data2009$Description, ignore.case=TRUE),]
residual_data2009 <- data2009[grep("residual", data2009$Description, ignore.case=TRUE),]
petroleum_data2009 <- data2009[grep("other petroleum", data2009$Description, ignore.case=TRUE),]
nuclear_data2009 <- data2009[grep("nuclear", data2009$Description, ignore.case=TRUE),]
hydroelectric_data2009 <- data2009[grep("hydroelectric", data2009$Description, ignore.case=TRUE),]
biomass_data2009 <- data2009[grep("biomass", data2009$Description, ignore.case=TRUE),]
geothermal_data2009 <- data2009[grep("geothermal", data2009$Description, ignore.case=TRUE),]
interstate_data2009 <- data2009[grep("net interstate", data2009$Description, ignore.case=TRUE),]
jet_data2009 <- data2009[grep("jet", data2009$Description, ignore.case=TRUE),]
totals20091 <- subset(data2009,grepl(glob2rx("T****"),data2009$MSN,ignore.case=TRUE))
totals20092 <- data2009[grep("renewable", data2009$Description, ignore.case=TRUE),]
totals2009 <- rbind(totals20091, totals20092)

write.csv(coal_data2009, "coal2009.csv",row.names=FALSE)
write.csv(nattygas_data2009, "natgas2009.csv",row.names=FALSE)
write.csv(motor_data2009, "motorGas2009.csv",row.names=FALSE)
write.csv(distillate_data2009, "distillate2009.csv",row.names=FALSE)
write.csv(lpg_data2009, "lpg2009.csv",row.names=FALSE)
write.csv(residual_data2009, "residualFuel2009.csv",row.names=FALSE)
write.csv(petroleum_data2009, "petroleum2009.csv",row.names=FALSE)
write.csv(nuclear_data2009, "nuclear2009.csv",row.names=FALSE)
write.csv(hydroelectric_data2009, "hydroelectric2009.csv",row.names=FALSE)
write.csv(biomass_data2009, "biomass2009.csv",row.names=FALSE)
write.csv(geothermal_data2009, "geothermal2009.csv",row.names=FALSE)
write.csv(interstate_data2009, "netInterstate2009.csv",row.names=FALSE)
write.csv(jet_data2009, "jetFuel2009.csv",row.names=FALSE)
write.csv(totals2009, "totals2009.csv",row.names=FALSE)

#hydroelectric, geothermal, 

money_data <- both[grep("dollars", both$Unit, ignore.case=TRUE),]
summary(money_data)
write.csv(money_data, "Money.csv",row.names=FALSE)

btu_energy_data = subset(both,both$Unit=="Billion Btu")
btu_energy_msncodes = subset(msncodes,msncodes$Unit=="Billion Btu")
btu_energy_data$Unit<-NULL
btu_energy_msncodes$Unit<-NULL
total_btu_energy_data = subset(btu_energy_data,grepl("total",btu_energy_data$Description,ignore.case=TRUE))
total_btu_energy_msncodes = subset(btu_energy_msncodes,grepl("total",btu_energy_msncodes$Description,ignore.case=TRUE))

tfc_data = subset(total_btu_energy_data,grepl("^.*.*TXB$",total_btu_energy_data$MSN,ignore.case=TRUE))
tfc_msncodes = subset(total_btu_energy_msncodes,grepl( "^.*.*TXB$",total_btu_energy_msncodes$MSN,ignore.case=TRUE))
tpes_data = subset(total_btu_energy_data,grepl( "^.*.*TCB$",total_btu_energy_data$MSN,ignore.case=TRUE))
tpes_msncodes = subset(total_btu_energy_msncodes,grepl("^.*.*TCB$",total_btu_energy_msncodes$MSN,ignore.case=TRUE))

summary(tpes_data2)
summary(tpes_msncodes2)

write.csv(tfc_data, "TotalFinalConsumption.csv",row.names=FALSE)
write.csv(tfc_msncodes, "TotalFinalConsumption_msn.csv",row.names=FALSE)
write.csv(tpes_data, "TotalPrimaryEnergySupply.csv",row.names=FALSE)
write.csv(tpes_msncodes, "TotalPrimaryEnergySupply_msn.csv",row.names=FALSE)
##########################################################################################################################
#BROKEN
totals <- data.frame(tfc_msncodes$MSN,tpes_data,tfc_data)
summary(totals)
for (code in tfc_msncodes$MSN){
  tpes_data2[grepl(gsub("X", "C", code),tpes_data$MSN)]
  tpes_msncodes2[grepl(gsub("X", "C", code),tpes_msncodes$MSN,value=TRUE)]
}

write.csv(tfc_data, "TotalFinalConsumption.csv",row.names=FALSE)
write.csv(tfc_msncodes, "TotalFinalConsumption_msn.csv",row.names=FALSE)
write.csv(tpes_data2, "TotalPrimaryEnergySupply.csv",row.names=FALSE)
write.csv(tpes_msncodes2, "TotalPrimaryEnergySupply_msn.csv",row.names=FALSE)
##################################################################################################################################


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

write.csv(btu_energy_data, paste(path,"RenewableEnergyData_FIXME.csv",sep=""),row.names=FALSE)
write.csv(btu_energy_msncodes, paste(path,"RenewableEnergyDataMSN_FIXME.csv",sep=""),row.names=FALSE)
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
