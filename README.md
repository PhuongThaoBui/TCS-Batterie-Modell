# TCS-Batterie-Modell
In dem Projekt handelt sich um die Technologiekombination von thermochemischem Speicher und Batterie für die Energieversorgung im Haushalt. 
Die Idee dahinter ist, dass man eine möglichst große PV-Anlage installiert, die deutlich mehr Energie produziert als der elektrische Bedarf ist. Dann entstehen besonders im SOmmer hohe Überschussenergiemengen, welche durch den thermochemischen Speicher aufgenommen werden können. Die Energie kann im Form von physikalischer Bindungsenergie bis in den Winter gespeichert werden. 
Dabei soll die erzeugte elektrische Energie bei PV Analge nach folgenden Prioritäten verbraucht werden 
||Prioritätenliste zur Verwendung des erzeugten PV-Stroms|
|:------|-----:|
|1|Direktversorgung des elektrischen Energiebedarfs|
|2|Aufladung des Batteriespeichers|
|3|Beladung des thermochemischen Speichers|
|4|Aufwärmung des Warmwasserspeicher über Heizelement|

# GUI des Rechners 
Der Benutzer kann über 3 Slider und einen Spinner die gewünschte Variation seines Technologiekonzept eingeben. Die vier variablen Eingangsgrößen sind die PV-Generatorleistung, die Batteriekapazität, die Anzahl der EInwohner und die Größe des saisonalen thermochemischen Speichers. Für die Benutzerfreundlichkeit wird die Größe in Kubikmetern angegeben, so kann der Nutzer seinen verfügbaren Platz ausmessen und eingeben. Intern wird die Angabe dann mit 400 kWh/m3 multipliziert, welches der Energiespeicherdichte des Speichermaterials Cu-BTC entspricht. 
Direkt unterhalb der Eingaberegler werden in drei Felder der elektrische Autarkiegrad, der thermische Autarkiegrad und der gesamte Autarkiegrad angezeigt. Darüber hinaus kann der nutzer die Zusammensetzung seiner elektrischen und thermischen Versorgung anhand der zwei Tortendiagrammen betrachten 
