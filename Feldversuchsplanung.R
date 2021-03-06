########################################
# Script zur Planung von Feldversuchen #
########################################

# (C) 2021 Ronja Wonneberger 
# Bei Fragen und Problemen: ronja.wonneberger@gmail.com

# Dieses Script erstellt einen Feldversuchsplan f�r ein completely randomized design mit einer oder mehreren Wiederholungen. Dies bedeutet, dass die niedrigste Gruppierungsebene die Wiederholung ist. Weitere Einteilungen der einzelnen Wiederholungen in Blocks nach dem lattice design, z.B. f�r verschiedene Behandlungen, sind mit diesem Script nicht m�glich. Bei Bedarf bitte an Ronja wenden.

# Der Output dieses Scripts sind verschiedene Dateien:
# Ein Feldplan, der f�r die Erstellung der Magazinpl�ne genutzt werden kann. Er spiegelt das Felddesign und die Anordnung aller Plots wider und gibt f�r jeden Plot die Plotnummer und den Akzessionsnamen an.
# Zwei Bilddateien, mithilfe derer die Verteilung der Checks im Feld �berpr�ft werden kann. Bei Nichtgefallen kann die Anordnung im Script ver�ndert werden. Eine der Dateien beinhaltet die Plotnummern, sodass gleichzeitig auch das allgemeine Felddesign �berpr�ft werden kann. Die andere Datei enth�lt die Akzessionsnamen, sodass �berpr�ft werden kann, wo sich welche Akzession befinden wird.
# Ein Feldbuch, in dem Plotnummer, Akzessionsname, Reihe und Spalte sowie Wiederholung f�r jeden Plot tabellarisch aufgef�hrt sind




#######################################################################
# Hinweise zu wichtigen Begriffen und zur Gestaltung des Feldversuchs #
#######################################################################

# Wichtige Begriffe:
# Plot: Die kleinste Einheit im Versuch. Ein Plot besteht bei uns in GGR meist aus einer Doppelreihe. F�r Ertragsversuche sind auch ganze Parzellen als Plot m�glich. Eine Parzelle besteht stets aus 3 Doppelreihen = 6 Saatreihen.
# Reihe: Wird in diesem Script f�r "Zeilen" im Versuchsplan verwendet, also die horizontale Abfolge von Plots. Nicht verwechseln mit den Saatreihen, die einen Plot ausmachen.
# Spalte: Wird in diesem Script f�r "Spalten" im Versuchsplan verwendet, also die vertikale Abfolge von Plots.

# Das Script bietet die M�glichkeit, verschiedene Parameter f�r den Feldversuch festzulegen:
# Die Anzahl der Plots pro Reihe und die Anzahl der Reihen
# Die Anzahl der Wiederholungen
# Die Anordnung der Wiederholungen (nebeneinander oder �bereinander)
# Wieviele Reihen einen Plot ausmachen sollen
# F�r den Feld-/Magazinplan kann eingestellt werden, ob die mittleren Reihen einer Parzelle mit Akzessionen bepflanzt werden oder ob Trennreihen eingeplant werden sollen (z.B. Weizen in Gerstenversuchen und umgekehrt.)
# Die Nummerierung der Plots beginnt IMMER unten links, geht von links nach rechts und von unten nach oben. 




######################################
# Hinweise zur ben�tigten Inputdatei #
######################################

# Das Script ben�tigt als Input eine Tabstop-getrennte .txt-Datei mit folgenden Informationen:
# Erste Spalte: Namen aller Genotypen einer Wiederholung, z.B. Barke, Morex, HOR1234 etc.
# Zweite Spalte: H�ufigkeit der Genotypen pro Wiederholung. Ausser bei Checks wird dies meist 1 sein.
# Beide Spalten m�ssen eine Uberschrift haben. Wie diese lautet, ist egal. Vorschlag: Lines, NumTimes oder Linien, Anzahl
# Werden Checks verwendet, muss das Wort "Check" (grossgeschrieben) im Namen der Akzession auftauchen, z.B. BarkeCheck, Morex_Check etc. Ansonsten werden diese nicht farblich in den Feldplan-Bilddateien hervorgehoben.
# Die Datei kann in Excel etc. erstellt werden, muss aber zwingend als .txt (Tabstop-getrennt) abgespeichert werden!

# Beispiel f�r einen Inputdatei:

# Line        | NumTimes 
# _______________________
# HOR001      | 1        
# HOR002      | 1        
# HOR003      | 1        
# HOR004      | 1        
# HOR005      | 1        
# HOR006      | 1        
# HOR007      | 1        
# HOR008      | 1        
# BarkeCheck  | 5        
# MorexCheck  | 2        




#######################
# Hinweise zum Script #
#######################

# Zum Script:
# Zeilen wie diese, denen ein # vorangestellt ist, sind Kommentare. Diese werden nicht ausgef�hrt, sondern dienen der Information und Anleitung des Nutzers. Bitte sorgf�ltig lesen.
# Alle Zeilen, denen KEIN # vorangestellt ist, sind Befehle, die ausgef�hrt werden m�ssen.
# Zur Ausf�hrung eines Befehls irgendwo in die entsprechende Zeile klicken und Strg + Enter dr�cken oder rechts oben auf "Run" klicken. Der blinkende Cursor springt dann automatisch zum n�chsten ausf�hrbaren Befehl.
# Hier ein Beispiel: Bitte den Cursor irgendwo in die n�chste Zeile ohne # setzen und Strg + Enter dr�cken oder Run klicken. Unter diesem Fenster befindet sich ein weiteres Fenster, die Konsole. In der Konsole sollte nun eine Begr�ssung erscheinen.

cat("Hallo Nutzer!")

# Wichtig: Jeder Befehl muss in der richtigen Reihenfolge (fortlaufend von oben nach unten) ausgef�hrt werden.
# Wenn eine �nderung in der Inputdatei gemacht wurde, muss diese neu in R geladen werden. Hierzu ab Zeile 134 erneut alle Befehle der Reihe nach ausf�hren.
# Einige Befehle erstrecken sich �ber viele Zeilen. In diesem Fall ist nur die erste Zeile linksb�ndig, alle weiteren sind einger�ckt. Zum Ausf�hren dieser Befehle bitte den Cursor in die erste, linksb�ndige Zeile setzen und Strg + Enter dr�cken oder Run klicken. Der komplette Befehl wird ausgef�hrt und der Cursor springt zur n�chsten auszuf�hrenden Zeile.
# Um einen grossen Block an Befehlen gleichzeitig auszuf�hren, kann man diesen mit der Maus markieren und dann Strg + Enter dr�cken oder Run klicken. Der schnellste Weg um das gesamte Script auf einmal auszuf�hren, ist Strg + a um alles zu markieren und Strg + Enter um alles auszuf�hren.
# Das Script kontrolliert, ob der Nutzer korrekte Eingaben gemacht hat. R�ckmeldungen �ber diese Kontrollen werden in der Konsole ausgegeben. Bitte die Konsole im Blick behalten und ggf. die ausgegebenen Hinweise befolgen. 
# Wenn in der Konsole ein Fehler angezeigt wird, bitte das komplette Script noch einmal Schritt f�r Schritt von oben nach unten ausf�hren. Ein h�ufiger Grund f�r Fehlermeldungen ist, dass eine Zeile vergessen wurde auszuf�hren.
# Viele Kommentare in diesem Script sind auf Englisch. Diese sind f�r den Nutzer nicht von Bedeutung, sondern dienen der Dokumentation des Scripts f�r den Entwickler. 

# Ein Hinweis zur Terminologie: 
# Im Script finden sich h�ufig Zeilen wie diese:
# year <- "2020"
# Diese Zeile erstellt eine VARIABLE mit dem Namen year und weist ihr durch den nach links zeigenden Pfeil einen WERT zu. year ist nun somit der Name eines Lagerplatzes, in dem wir den Wert 2020 abgelegt haben, �hnlich eines beschrifteten Kartons, in den man einen Gegenstand ablegt. Wenn der Nutzer dem Programm sagt, wie der Feldversuch aussehen soll, legt er diese Informationen in verschiedenen Variablen ab. Das Programm sucht dann diese Variablen und verwendet den hinterlegten Wert. Wenn eine Variable falsch oder nicht definiert ist, kann das Programm nicht korrekt laufen. Daher ist es zwingend notwendig, alle Zeilen auszuf�hren und der Anleitung zu folgen.




#################################
# Installation n�tiger Packages #
#################################

# Die folgenden Zeilen �berpr�fen, ob alle ben�tigten Packages installiert sind und installieren sie wenn n�tig. Packages sind kleine Software-Pakete, die nicht automatisch geladen sind, die aber n�tig sind, damit R die Befehle in diesem Script ausf�hren kann.

packages = c("agricolae", "ggplot2", "RColorBrewer") # Required packages

package.check <- lapply( # Hier ein Beispiel f�r einen mehrzeiligen Befehl. In diese Zeile klicken und ausf�hren.
  packages,
  FUN = function(x) {
    if (!require(x, character.only = TRUE)) {
      install.packages(x, dependencies = TRUE)
      library(x, character.only = TRUE)
    }
  }
  )

# Wenn in der Konsole nun eine Fehlermeldung auftritt (z.B. "Error: ..." oder "Package x had non-zero exit status"), bitte an R-kundige Kollegen oder den IT-Support wenden.




##################################################################################
# Laden der Packages, Einstellen des Arbeitsverzeichnis, Einlesen der Inputdatei #
##################################################################################

# Die ben�tigten Packages sollten nun eigentlich installiert und geladen sein, aber zur Sicherheit k�nnen nochmal die n�chsten beiden Zeilen ausgef�hrt werden. Wenn in der Konsole immer noch ein Fehler auftaucht, wird das Programm nicht laufen.
library(agricolae)
library(ggplot2)

# Das Arbeitsverzeichnis einstellen. In dieses Verzeichnis wird R alle Dateien schreiben, die dieses Script erstellt. 
# Dies ist nur ein Beispielverzeichnis. Den Teil zwischen den Anf�hrungszeichen durch eigenes Verzeichnis ersetzen! Auf IPK-Rechnern mit Windows wird der Pfad normalerweise mit U:/Eigene Dateien/ beginnen.

setwd("U:/Eigene Dateien/fieldscript_test") 


# Die Input-Datei einlesen. Zwischen die Anf�hrungszeichen den Pfad und Namen der Datei einf�gen. Schr�gstriche zwischen Verzeichnisebenen nicht vergessen. Idealerweise befindet sich die Datei im Arbeitsverzeichnis (s.o.), dann reicht der Dateiname. 

Lines <- read.delim("SHAPE_spring_2021.txt",sep="\t",header=T, stringsAsFactors = F)

# Wenn an dieser Stelle in der Konsole eine Fehlermeldung auftritt ("cannot open file 'xyz': No such file or directory'), dann wurde der Pfad und/oder Dateiname nicht korrekt eingegeben. Bitte genau �berpr�fen. Wurde die Datei als .txt abgespeichert und nicht als .xlsx oder �hnliches?

# Die Datei ist jetzt in R in Form eines sog. data.frame, also einer Art Tabelle �hnlich einer Excel-Tabelle, mit dem Namen "Lines" eingelesen.

# Die folgenden Zeilen dienen zur �berpr�fung, dass die Datei korrekt eingelesen wurde. Bitte in die Konsole schauen.
cat("Die eingelesene Datei enth�lt" ,dim(Lines)[1], "Reihen und", dim(Lines)[2], "Spalten.")

# head und tail geben die ersten bzw. letzten 6 Zeilen der Tabelle an.
head(Lines)
tail(Lines)

# Diese Zeile gibt die Anzahl der Akzessionen incl. der Checks an und dient zur Kontrolle.
cat("Es sind", nrow(Lines), "Akzessionen, darunter",nrow(Lines[grep("Check", Lines[,1]),]), "Checks, f�r den Versuch vorgesehen.")

# Diese Zeile summiert die Zahlen in der zweiten Spalte der Inputdatei. Das Ergebnis entspricht also der gew�nschten Anzahl an Plots.
cat("Es werden", sum(Lines[2]), "Plots ben�tigt.")

# Wenn die ausgegebenen Informationen nicht der Erwartung entsprechen, bitte noch einmal die Inputdatei �berpr�fen. Wurde die Datei korrekt als Tabstop-getrennte .txt-Datei abgespeichert? Sobald die Inputdatei ver�ndert wird, muss sie erneut eingelesen werden.





####################################################
# Festlegen diverser Parameter f�r den Feldversuch #
####################################################

# Wenn die Daten richtig eingelesen wurden, m�ssen nun einige Parameter festgelegt werden, damit das Programm weiss, wie der Feldversuch aussehen soll.

# Die folgenden Informationen werden Bestandteile der Output-Dateinamen. Darauf achten, dass die Anf�hrungsstriche nicht gel�scht werden!
# Theoretisch k�nnen hier auch weitere Informationen eingetragen werden, aber es ist ratsam, den Dateinamen nicht allzu lang werden zu lassen.
# Experimentname
experiment <- "SHAPE"
# Jahr
year <- "2020"


#### Gr�sse und Form des Versuchs - Reihen und Spalten
# In den folgenden Reihen bitte eintragen, wieviele Reihen und Spalten in einer Wiederholung gew�nscht sind:
Reihen <- 10 # Anzahl der Reihen pro Wiederholung
Spalten <-64 # Anzahl der Spalten pro Wiederholung (=Anzahl der Plots in einer Reihe)


#### Checks
# Die folgenden Zeilen geben alle Eintr�ge aus der Inputdatei aus, die das Wort "Check" in der ersten Spalte enthalten. Angegeben ist auch, wie oft jeder Check in jeder Wiederholung auftauchen soll. Wenn hier etwas nicht stimmt, bitte in der Inputdatei korrigieren und das Script erneut von Anfang an ausf�hren.

print("Die folgenden Checks wurden in der Inputdatei gefunden:")
Lines[grep("Check", Lines[,1]),]


#### Randomisierung
# Der Parameter seed_rep ist wichtig f�r die Randomisierung innerhalb einer Wiederholung. Hierbei ist seed_rep1 verantwortlich f�r die Randomisierung von Wiederholung 1 usw. Die Checks werden zuf�llig in einer Wiederholung verteilt, und seed_rep bestimmt, mit welcher Zahl das Programm seine Berechnung startet. Wenn man diesen Prozess mehrfach mit jeweils unterschiedlichen Werten f�r seed_rep ausf�hrt, bekommt man immer ein anderes Ergebnis. Beh�lt man den gleichen Wert bei, so ist das Ergebnis immer dasselbe.
# Warum ist das wichtig?
# Das Script erstellt im Arbeitsverzeichnis zwei Grafiken, auf denen die Verteilung der Checks in den Wiederholungen ersichtlich ist. Wenn die Verteilung nicht gleichm�ssig genug ist, einfach wahllos den Wert f�r seed_rep f�r die entsprechende Wiederholung ver�ndern und alle Zeilen ab Zeile 193 erneut ausf�hren. Solange wiederholen, bis die Checks in der Grafik zufriedenstellend verteilt sind. Es kann etwas dauern, bis man eine zufriedenstellende Verteilung f�r jede Wiederholung gefunden hat.
# In der folgenden Zeile f�r jede Wiederholung eine Zahl (ohne Anf�hrungsstriche) eingeben. Wenn weniger als drei Wiederholungen gew�nscht sind, einfach die entsprechende Variable mit zugeh�rigem Wert entfernen. Wenn z.B. nur zwei Wiederholungen gew�nscht sind, dann diesen Teil entfernen: ", seed_rep3 = 4563464". Das sollte dann noch �brig sein: seeds<-c(seed_rep1 = 44254, seed_rep2 = 34523452). Das Komma vor der jeweiligen Variable muss mit entfernt werden, die Klammern m�ssen allerdings bleiben.
# Wenn mehr als drei Wiederholungen gew�nscht sind, bitte entsprechend neue Variablen erstellen, z.B. seed_rep4 = 12345 f�r eine vierte Wiederholung (an das Komma zwischen den Variablen denken!): seeds<-c(seed_rep1 = 44254, seed_rep2 = 34523452, seed_rep3 = 4563464, seed_rep4 = 12345). Zwei seed_rep-Variablen d�rfen nicht den gleichen Namen haben. Am besten wie im Beispiel durchnummerieren.
# Ganz wichtig: Ist die Anzahl der Variablen in den Klammern niedriger als die Anzahl der Wiederholungen (s. Zeile 197), kann das Programm nicht ausgef�hrt werden! Die Anzahl der Variablen sollte deswegen gleich der Anzahl der Wiederholungen sein. 
seeds<-c(seed_rep1 = 44254, seed_rep2 = 34523452, seed_rep3 = 4563464)

#### Wiederholungen
# Hier die Anzahl der Wiederhoungen festlegen. Bitte beachten, dass die Anzahl der Wiederholungen nicht h�her als die Anzahl der Variablen im "seeds"-Vektor (s. oben) sein sollte.
Wiederholungen = 2

# Bitte festlegen, ob die Wiederholungen "nebeneinander" (entlang der "Spalten") oder "�bereinander" ("entlang der "Reihen") angeordnet werden sollen, also:

# Nebeneinander:
# Wdh1 Wdh2 Wdh3

# �bereinander:
# Wdh 3
# Wdh 2
# Wdh 1

# F�r eine Anordnung nebeneinander bitte unten "horizontal" zwischen die Anf�hrungszeichen eingeben. F�r eine Anordnung �bereinander bitte "vertical" (mit c!) eingeben. Gibt man etwas anderes ein, erfolgt sp�ter eine Fehlermeldung und das Programm wird nicht ausgef�hrt.
orientation = "horizontal"

#### Trennreihen
# Bitte angeben, ob die mittleren Reihen einer Parzelle Akzessionen beinhalten sollen (also Teil des Versuchs sein sollen). In diesem Fall bitte "yes" eintragen. Wenn die mittleren Reihen Trennreihen, z.B. aus Weizen, beinhalten sollen, bitte etwas anderes eintragen, z.B. "wheat" oder "Gerste". Das, was eingetragen wird erscheint am Ende im Feld-/Magazinplan und in den Feld�bersichten. Daher ist es aus praktischen Gr�nden ratsam, den Eintrag kurz zu halten.
middle_rows = "wheat"

#### Anzahl der Saatreihen pro Plot
# Hier bitte angeben, wieviele Reihen einen Plot ergeben sollen, also z.B. ob Doppelreihen oder komplette Parzellen (6 Reihen/3 Doppelreihen) gew�nscht sind. Bei Doppelreihen bitte Nr_Plotreihen = 2 setzen, bei ganzen Parzellen Nr_Plotreihen = 6, da sechs Reihen eine Parzelle ergeben. Es ist jede beliebige Nummer m�glich, so auch 1, 3, 4 etc., was aber in der Praxis eher nicht gebraucht wird.
Nr_Plotreihen = 3




###################################################################
# Kontrolle der Eingaben - bitte Hinweise in der Konsole beachten #
###################################################################

# Dieser Abschnitt dient der Kontrolle der get�tigten Eingaben. Bitte alle Befehle nacheinander ausf�hren und falls n�tig Anweisungen in der Konsole (dem Fenster unter diesem) befolgen (ggf. falsche Eingaben oben korrigieren und entsprechende Zeilen neu ausf�hren).

# Check if user made correct input
# Logical subvectortor that is going to hold the results of all the checks as boolean values
checklist=as.logical()

# Orientation must be horizontal or vertical
if (orientation != "horizontal" && orientation != "vertical"){
    cat("Falsche Eingabe der Versuchsanordnung. G�ltige Werte sind 'horizontal' oder 'vertical'.")
  checklist<-c(checklist, F)
  } else {
  cat("Kontrolle - Wurde f�r die Orientierung der Versuchsanordnung ein g�ltiger Wert eingegeben? Ok.")
  checklist<-c(checklist, T)
  }

# Check if number of rows is numeric
if (! is.numeric(Reihen)){
  cat("Ung�ltige Anzahl der Reihen. Bitte numerischen Wert eingeben.")
  checklist<-c(checklist, F)
  } else {
  cat("Kontrolle - Wurde f�r Anzahl der Reihen ein numerischer Wert eingegeben? Ok.")
  checklist<-c(checklist, T)
  }

# Check if number of columns is numeric
if (! is.numeric(Spalten)){
  cat("Ung�ltige Anzahl der Spalten. Bitte numerischen Wert eingeben.")
  checklist<-c(checklist, F)
  } else {
  cat("Kontrolle - Wurde f�r Anzahl der Spalten ein numerischer Wert eingegeben? Ok.")
  checklist<-c(checklist, T)
  }

# Check if number of reps is numeric
if (! is.numeric(Wiederholungen)){
  cat("Ung�ltige Anzahl der Wiederholungen. Bitte numerischen Wert eingeben.")
  checklist<-c(checklist, F)
  } else {
  cat("Kontrolle - Wurde f�r Anzahl der Wiederholungen ein numerischer Wert eingegeben? Ok.")
  checklist<-c(checklist, T)
  }

#check if number of rows per plot is numeric
if (! is.numeric(Nr_Plotreihen)){
  cat("Ung�ltige Anzahl der Reihen pro Plot. Bitte numerischen Wert eingeben.")
  checklist<-c(checklist, F)
  } else {
  cat("Kontrolle - Wurde f�r Anzahl der Reihen pro Plot ein numerischer Wert eingegeben? Ok.")
  checklist<-c(checklist, T)
  }

# Check if middle_rows is not NULL
if (!exists("middle_rows")){
  cat("Es wurde nicht festgelegt, wie die mittleren Reihen einer Parzelle bepflanzt werden sollen. Bitte die Anleitungen in Zeile 214 befolgen.")
  checklist<-c(checklist, F)
  } else {
  cat("Kontrolle - Wurde f�r die mittleren Parzellenreihen eine g�ltige Anweisung gegeben? Ok.")
  checklist<-c(checklist, T)
  }

# Check if the number of reps is not larger than the lenght of the seed vector
if (length(seeds) < Wiederholungen){
  cat("Es wurden nicht gen�gend seed_rep-Variablen angegeben. Die Anzahl der seed_rep-Variablen ist kleiner als die Anzahl der gew�nschten Wiederholungen. Bitte weitere seed_rep-Variablen in Zeile 193 definieren oder Anzahl der Wiederholungen verringern.")
  checklist<-c(checklist, F)
  } else {
  cat("Kontrolle - Ist die Anzahl der seed_rep-Variablen gleich der Anzahl der Wiederholungen? ok.")
  checklist<-c(checklist, T)
  }

# Give a final feedback on whether all checks were passed.
if (all(checklist)){
  cat("Alle Eingabechecks wurden bestanden. Versuchspl�ne k�nnen nun erstellt werden.\n\n")
  cat("Hier noch einmal eine Zusammenfassung aller eingegeben Parameter:\n\n")
  cat("Experimentname:", experiment,"\n")
  cat("Year:", year, "\n")
  cat("Es werden", sum(Lines[2]), "Plots ben�tigt.\n")
  cat("Es sind", nrow(Lines), "Akzessionen, darunter",nrow(Lines[grep("Check", Lines[,1]),]), "Checks, f�r den Versuch vorgesehen.\n")
  cat("Die folgenden Checks wurden in der Inputdatei gefunden:\n")
  print(Lines[grep("Check", Lines[,1]),])
  cat("Anzahl der Wiederholungen:", Wiederholungen, "\n")
  cat("Anordnung der Wiederholungen:", orientation, "\n")
  cat("Was soll mit den Mittelreihen einer Parzelle passieren: 'yes' wenn Teil des Versuchs, bei anderem Eintrag werden sie als Trennreihen behandelt:", middle_rows, "\n")
  cat("Anzahl der Saatreihen pro Plot:", Nr_Plotreihen, "\n\n")
  cat("Wenn alle Angaben stimmen bitte mit dem n�chsten Abschnitt fortfahren.\n")


  } else {
  cat("Eine oder mehrere Eingaben sind falsch. Bitte Eingaben in den Zeilen x bis y �berpr�fen.")
    }




#################################################
# Eigentliches Script - Erstellen der Feldpl�ne #
#################################################

# Ab hier wird kein Input von Seiten des Nutzers mehr ben�tigt. Es m�ssen nur noch die folgenden Zeilen ausgef�hrt werden. Die erstellten Dateien befinden sich dann im Arbeitsverzeichnis und k�nnen ganz normal �ber den Windows Explorer aufgerufen werden. 
# Der n�chste Codeblock ist sehr lang und beinhaltet die komplette Funktionalit�t des Programms. Dieses Fenster wird eine ganze Ecke nach unten scrollen, und dann muss noch die letzte Zeile ausgef�hrt werden. Diese sorgt letztlich f�r die Ausf�hrung der Funktionalit�ten.
  
field_design=function(x, seeds){
  if (all(checklist)){ # Do a final check of all inputs
    cat("Alle Eingabechecks bestanden. Versuchsplan wird erstellt.\n")
    colnames(x)<-c("Lines", "NumTimes")
  
    lines <- x$Lines
    rep <- x$NumTimes
  
    fieldbook=NULL
    matrix_all=NULL

    # Loop through all reps
    for (i in seq_along(1:Wiederholungen)){
      # design.crd function from agricolae: make complete randomized design 
      outdesign <- design.crd(lines,r=rep,seed=seeds[i],serie=3)
      # Get plot numbers and randomly assigned lines
      book <- outdesign$book
      book$r<-NULL # r column is not needed anymore
    
      # Change plot numeration according to rep. Each rep starts with a number divisible by 1000
      plot_offset <- (i * 1000) - 1000
      book$plots <- book$plots + plot_offset
    
      # Make a matrix of row numbers and fill the matrix with both the accession names and the plot numbers
      book$PlotLine<-paste(book$lines, book$plots, sep="_")
      layout_fieldplan <- matrix(book$PlotLine,c(Reihen,Spalten), byrow = T)
    
      layout_fieldbook<-t(layout_fieldplan) # Transpose the matrix. The new matrix is used to make the field book, the old one for the field plan
    
      # Get array indices
      ind <- which(!is.na(layout_fieldbook), arr.ind = TRUE) 
      ind<-as.data.frame(ind)
      plotinfo<-cbind(book, ind)
    
      plotinfo<-as.data.frame(plotinfo)
      plotinfo$Rep<-i
      colnames(plotinfo) <- c("Plot", "Line","PlotLine", "PlotCol","PlotRow", "Rep")
      
      # Check if an accession is a Check. If yes, enter its name in a new column Category. If not, enter the name of the experiment. This allows highlighting different checks in the field plans. First the Lines column needs ot be converted from factor to character.
      f <- sapply(plotinfo, is.factor)
      plotinfo[f] <- lapply(plotinfo[f], as.character)
      plotinfo$Category<-ifelse(grepl("Check", plotinfo$Line), plotinfo$Line, experiment)
    
      # Adjust row/column numbers according to the desired orientation of the reps
      if (orientation == "vertical"){
        # Change row number according to rep
        Row_offset <- (i * Reihen) - Reihen
        plotinfo$PlotRow <- plotinfo$PlotRow + Row_offset
        matrix_all = rbind(matrix_all, layout_fieldplan)
        } else if (orientation == "horizontal"){
      
        # Change col number according to rep
        Col_offset <- (i * Spalten) - Spalten
        plotinfo$PlotCol <- plotinfo$PlotCol + Col_offset
        matrix_all = cbind(matrix_all, layout_fieldplan)
        } 
      fieldbook = rbind(fieldbook, plotinfo)
      } # Rep loop ends
  
    #Get an idea of how checks are spaced in field; can change seed number to rerandomize and get better coverage of checks
    colorvector<-c("goldenrod1", "coral2", "#32bf47", "darkolivegreen1", "lightpink2", "lightyellow", "mediumorchid1", "lightskyblue") # Vector for up to seven checks and the accessions. More will hardly ever be necessary
    acc_categories<-unique(plotinfo$Category) # Get the number of unique entries in the Category column to know how many colors need to picked for the colorvector

    # Plot overview of the field with plot numbers to identify reps. This helps in assessing whether the checks are distributed equally across the field
    cat("Plotte Feld�bersicht mit Plotnummern...\n")
    y<-ggplot(fieldbook,aes(x=PlotCol,PlotRow,fill=Category,label=Plot)) + geom_tile(color="gray") + scale_fill_manual(values=colorvector[1:length(acc_categories)])
    print(y+geom_text(angle=90) + ggtitle(paste0(experiment, "_", year)))
    ggsave(paste0(experiment, "_", year, "_Plotnumbers.tiff"),  width=length(unique(fieldbook$PlotCol)), height=length(unique(fieldbook$PlotRow))*3, units="cm", dpi=100, limitsize=F)
    
    # Same as above but with accession names in case the user wants to see where certain accessions will be located
    cat("Plotte Feld�bersicht mit Akzessionsnamen...\n")
    y<-ggplot(fieldbook,aes(x=PlotCol,PlotRow,fill=Category,label=Line)) + geom_tile(color="gray") + scale_fill_manual(values=colorvector[1:length(acc_categories)])
    print(y+geom_text(angle=90) + ggtitle(paste0(experiment, "_", year)))
    ggsave(paste0(experiment, "_", year, "_Accessionnames.tiff"), width=length(unique(fieldbook$PlotCol)), height=length(unique(fieldbook$PlotRow))*3, units="cm", dpi=100, limitsize=F)

  
    fieldbook$Category<-NULL
    fieldbook$PlotLine<-NULL
    colnames(fieldbook)<-c("Plot",  "Line", "Col","Row", "Rep")
  
    cat("Erstelle Feldbuch...\n")
    write.table(fieldbook, file=paste0(experiment, "_", year, "_fieldbook.txt"), sep="\t", quote = F, row.names=F)
  
    if (middle_rows == "yes"){
      matrix_all<-matrix_all[nrow(matrix_all):1,] #invert rows
      middle_row_matrix = matrix_all
      } else {
      matrix_all<-matrix_all[nrow(matrix_all):1, ] #invert rows
      fullsubvectortor<-1:(floor(ncol(matrix_all)*1.5)) # something might be wrong here
      subvector <- fullsubvectortor[!fullsubvectortor %% 3 == 2]
  
      if (orientation == "vertical"){
        fillermatrix<-matrix(middle_rows, nrow = Reihen*Wiederholungen, ncol = length(fullsubvectortor),byrow = T)
        } else if (orientation == "horizontal"){
        fillermatrix<-matrix(middle_rows, nrow = Reihen, ncol = length(fullsubvectortor),byrow = T)
        }
  
      fillermatrix[,subvector]<-matrix_all[,1:ncol(matrix_all)]
      middle_row_matrix = fillermatrix
      }
  
    # Multiply each matrix column by the number of rows that one plot should consist of
    replicated_col_matrix = middle_row_matrix[, rep(1:ncol(fillermatrix), each=Nr_Plotreihen)]

  
    cat("Erstelle Feld-/Magazinplan...\n")
    write.table(replicated_col_matrix, file=paste0(experiment, "_", year, "_sowingplan.txt"), sep="\t", quote = F, row.names=F)
    cat("Alle Dateien erfolgreich erstellt.\n")
    } # "if checks ok" loop ends
  else {cat("FEHLER: Eine oder mehrere Eingaben sind fehlerhaft. Programm gestoppt. Bitte Eingaben am Beginn des Scripts �berpr�fen und jeden Check ausf�hren.")
  }
  } 


# Wichtig: Diese Zeile nicht vergessen auszuf�hren! Der Vorgang kann je nach Gr�sse der zu erstellenden Bilddateien einen Moment dauern.
field_design(Lines, seeds)


# Alle Dateien sind nun im Arbeitsverzeichnis erstellt. Wenn die Verteilung der Checks nicht gleichm�ssig genug ist, bitte zur�ck zur Randomisierung gehen und die Anweisungen dort befolgen.
