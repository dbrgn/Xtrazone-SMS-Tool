Das Xtrazone SMS tool
=====================

Viele junge Schweizer kennen wohl Xtrazone, ein Internetportal von Swisscom, auf welchem alle Leute die ein xtra-liberty Handyabo haben, 500 Gratis-SMS im Monat versenden können. Ich habe das Angebot bisher jedoch sehr selten genutzt, da die Handhabung sehr umständlich ist. Zuerst muss man sich durch 3 Seiten durchklicken, bis man dann zum Login kommt, und wenn man mal eingeloggt ist, wird man nach ziemlich kurzer Inaktivität schon wieder rausgekickt… Das ist mühsam. Ein Kollege hat deswegen mal ein Windows-Tool gecodet, welches sich im Systray versteckt, und sich die Logindaten merkt. Da ich jedoch privat hauptsächlich Linux-User bin, und dank SSH auch immer Zugriff auf meinen Linux-Server habe, hab ich mir gedacht dass ein Kommandozeilentool für mich viel bessr geeignet wäre…

Ich hab mich also rangesetzt und ein kleines Perlscript geschrieben. Man kann damit sehr bequem über die Konsole mit einem Einzeiler ein SMS versenden.

Aktuelle Informationen gibt es auch immer auf der [Homepage](http://blog.ich-wars-nicht.ch/xtrazone-sms-tool/).



Voraussetzungen
---------------

* Perl
* Curl

(Beide Tools können normalerweise über die Paketverwaltung (wie z.B. _apt-get_) installiert werden.)


Installation
------------

Script herunterladen/abspeichern und starten. Eventuell müssen mit

	$ chmod +x sms.pl

die Ausführrechte noch gesetzt werden. __WICHTIG:__ Die Leserechte sollten so gesetzt sein, dass nur der Besitzer die Datei lesen kann (chmod 700 sms.pl). Ansonsten kann jeder der Leserechte hat das Passwort, welches im Plaintext gespeichert wird, auslesen.

Danach müssen die Logindaten im Script auf den Zeilen 24 und 25 eingetragen werden.

Um das Script bequemer starten zu können, empfiehlt es sich, das Ganze nach /usr/local/bin zu kopieren.

	# cp sms.pl /usr/local/bin/sms

Danach kann es wie jedes andere Programm auch direkt aufgerufen werden.


Benutzung
---------

Syntax:

	$ sms 0791234567 Dies ist meine Nachricht!


Lizenz
------

Der Sourcecode dieses Script steht unter der [CreativeCommons by-nc-sa 3.0 Lizenz](http://creativecommons.org/licenses/by-nc-sa/3.0/). Bei Nutzung würe ich mich über ein Feedback freuen.


Hinweise
--------

* Ein Telefonbuch ist noch nicht implementiert, kommt wohl noch. Man kann jedoch in der .bashrc mit

	export MAX=0791234567

Telefonnummern als Variable exportieren, die dann mit

	$ sms $MAX Hallo Max Muster!

benutzt werden können.

* Dadurch dass das SMS mit nur einem Befehl abgeschickt werden kann, kann man sich z.B. Benachrichtigungs- oder Alarm-Cronjobs mit SMS-Benachrichtigung einrichten.

* Mit zwei kleinen Anpassungen kann man das Ganze auch unter Windows laufen lassen:

	Zeile  36: my $cookiefile = "xtrazone.cookie"; # Temporary cookie file
	Zeile 150: if (system("del $cookiefile") != 0)


Known Issues
------------

* Ich habe bemerkt, dass man im Nachrichtentext keine Klammern verwenden kann (z.B. für Smileys). Werde das irgendwann mal noch beheben.
* Sobald die neue XtraZone aufgeschaltet wird, muss man das Script überarbeiten