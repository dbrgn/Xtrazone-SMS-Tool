--------------------
Das Xtrazone SMS tool
--------------------

Viele junge Schweizer kennen wohl Xtrazone, ein Internetportal von Swisscom, auf welchem alle Leute die ein xtra-liberty Handyabo haben, 500 Gratis-SMS im Monat versenden k�nnen. Ich habe das Angebot bisher jedoch sehr selten genutzt, da die Handhabung sehr umst�ndlich ist. Zuerst muss man sich durch 3 Seiten durchklicken, bis man dann zum Login kommt, und wenn man mal eingeloggt ist, wird man nach ziemlich kurzer Inaktivit�t schon wieder rausgekickt� Das ist m�hsam. Ein Kollege hat deswegen mal ein Windows-Tool gecodet, welches sich im Systray versteckt, und sich die Logindaten merkt. Da ich jedoch privat haupts�chlich Linux-User bin, und dank SSH auch immer Zugriff auf meinen Linux-Server habe, hab ich mir gedacht dass ein Kommandozeilentool f�r mich viel bessr geeignet w�re�

Ich hab mich also rangesetzt und ein kleines Perlscript geschrieben. Man kann damit sehr bequem �ber die Konsole mit einem Einzeiler ein SMS versenden.


--------------------
Website
--------------------

http://blog.ich-wars-nicht.ch/xtrazone-sms-tool/


--------------------
Voraussetzungen
--------------------

- Perl
- Curl

(Beide Tools k�nnen normalerweise �ber die Paketverwaltung (wie z.B. apt-get) installiert werden.)


--------------------
Installation
--------------------

Script herunterladen/abspeichern und starten. Eventuell m�ssen mit

$ chmod +x sms.pl

die Ausf�hrrechte noch gesetzt werden. WICHTIG: Die Leserechte sollten so gesetzt sein, dass nur der Besitzer die Datei lesen kann (chmod 700 sms.pl). Ansonsten kann jeder der Leserechte hat das Passwort, welches im Plaintext gespeichert wird, auslesen.

Danach m�ssen die Logindaten im Script auf den Zeilen 24 und 25 eingetragen werden.

Um das Script bequemer starten zu k�nnen, empfiehlt es sich, das Ganze nach /usr/local/bin zu kopieren.

# cp sms.pl /usr/local/bin/sms

Danach kann es wie jedes andere Programm auch direkt aufgerufen werden.


--------------------
Benutzung
--------------------

Syntax: $ sms 0791234567 Dies ist meine Nachricht!


--------------------
Hinweise
--------------------

- Ein Telefonbuch ist noch nicht implementiert, kommt wohl noch. Man kann jedoch in der .bashrc mit

export MAX=0791234567

Telefonnummern als Variable exportieren, die dann mit

$ sms $MAX Hallo Max Muster!

benutzt werden k�nnen.

- Dadurch dass das SMS mit nur einem Befehl abgeschickt werden kann, kann man sich z.B. Benachrichtigungs- oder Alarm-Cronjobs mit SMS-Benachrichtigung einrichten.

- Mit zwei kleinen Anpassungen kann man das Ganze auch unter Windows laufen lassen:
> Zeile  36: my $cookiefile = "xtrazone.cookie"; # Temporary cookie file
> Zeile 150: if (system(�del $cookiefile�) != 0)

--------------------
Known Issues
--------------------

- Ich habe bemerkt, dass man im Nachrichtentext keine Klammern verwenden kann (z.B. f�r Smileys). Werde das irgendwann mal noch beheben.
- Sobald die neue XtraZone aufgeschaltet wird, muss man das Script �berarbeiten