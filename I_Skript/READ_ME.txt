Die Schritte

1. Master_skript im 03_Sim_Umgebung öffnen 
2. Das System mit der BUTTON-Funktion konfigurieren 
	- BUTTON.PVvar gleich 1 einsetzen --> PV-Leistung von 2 bis 30 kWp variieren
	- BUTTON.EBATvar gleich 1 einsetzen --> Batterie Leistung von 2 bis 20kWh variieren 
	- BUTTON.TCSvar gleich 1 einsetzen --> TCS Leistung von 400 bis 2800kWh variieren 
	- BUTTON.nvar gleich 1 einsetzen --> Anzahl der Person im Haushalt variieren 

	- falls gleich Null wird ein Standard-Wert verwendet


Ordner-Struktur: 
01_Verbrauch_Data: Die Rohdaten
02_Simdata: Die bearbeitete Eingangsdaten und wird im Simulation verwendet
03_Sim_Umgebung: Die Master_skript konfiguriert, greift in allen Ordner die m-Function ein und berechnet
04_Funktion: Alle benötigte m-Function für die Simulation 
05_Literatur: Gesammelte Paper ( um die Dateigröße zu reduzieren, wird der Ordner entleert)
06_Analysis: Nach der Simulation können die Ergebnisse mithilfe der m-Function in diesem Ordner ausgewertet werden. 
