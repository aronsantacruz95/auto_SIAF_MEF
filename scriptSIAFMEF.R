#este script descarga los excel con informaci�n de los gobiernos locales del
# siaf-mef (Consultar el Gasto Presupuestal [Actualizaci�n Mensual])

#autor: aron santa cruz
#contacto: aronsantacruz95@gmail.com
#versi�n 1.0
#16-9-2020

#cargamos las librer�as
library("stringr")
library("RSelenium")
library("xml2")
library("rvest")
library("httr")


#+---------------------+
#| se puede modificar: |
#+---------------------+

#queremos informaci�n del 2020 hasta agosto
anio<-toString(2020)
#dependiendo de qu� info queremos habilitaremos solo una de las siguientes 3 l�neas:
quiero<-"ActProy"   # Actividades/Proyectos
#quiero<-Actividad   # S�lo Actividades
#quiero<-Proyecto    # S�lo Proyectos


driver<-rsDriver(browser=c("chrome"), chromever="85.0.4183.83")
remote_driver<-driver[["client"]]

#abrimos el navegador (chrome)
remote_driver$open()

#armamos la url de consulta amigable
web1<-"https://apps5.mineco.gob.pe/transparencia/mensual/default.aspx?y="
web2<-"&ap="
web<-paste0(web1,anio,web2,quiero)
web

#en el chrome abierto ingresaremos a la url armada arriba
remote_driver$navigate(web)

#ubicamos el frame donde est�n los botones
frame0<-remote_driver$findElement(value='//*[@id="frame0"]')

#una vez ubicado el frame, lo "activaremos"
remote_driver$switchToFrame(frame0)

#clic al bot�n de nivel de gobierno
webElem<-remote_driver$findElement("name","ctl00$CPH1$BtnTipoGobierno")
webElem$clickElement()

#clic a la opci�n "Gobiernos locales"
webElem<-remote_driver$findElement("id","ctl00_CPH1_RptData_ctl02_TD0")
webElem$clickElement()

#clic al bot�n de Gob.Loc./Mancom.
webElem<-remote_driver$findElement("name","ctl00$CPH1$BtnSubTipoGobierno")
webElem$clickElement()

#clic a la opci�n "Municipalidades"
webElem<-remote_driver$findElement("id","ctl00_CPH1_RptData_ctl01_TD0")
webElem$clickElement()

#clic al bot�n Departamento
webElem<-remote_driver$findElement("name","ctl00$CPH1$BtnDepartamento")
webElem$clickElement()

#Bucle

for(i in 1:25) {
  #count
  j<-str_pad(i,2,pad="0")
  print(j)
  #clic a la opci�n "##: NOMDEP"
  webElem<-remote_driver$findElement("id",paste0("ctl00_CPH1_RptData_ctl",j,"_TD0"))
  webElem$clickElement()
  #clic al bot�n Municipalidad
  webElem<-remote_driver$findElement("name","ctl00$CPH1$BtnMunicipalidad")
  webElem$clickElement()
  #clic a la opci�n Descarga
  webElem<-remote_driver$findElement("id","ctl00_CPH1_lbtnExportar")
  webElem$clickElement()
  #clic al bot�n Regresar
  webElem<-remote_driver$findElement("id","ctl00_CPH1_RptHistory_ctl04_TD0")
  webElem$clickElement()
}

#cerramos la sesi�n
remote_driver$close()
rm(driver)
system("taskkill /im java.exe /f", intern=FALSE, ignore.stdout=FALSE)